package org.tothought.web.spring.controllers.blog;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.tothought.data.entities.Comment;
import org.tothought.data.repositories.CommentRepository;
import org.tothought.data.repositories.PostViewRepository;
import org.tothought.data.repositories.TagViewRepository;
import org.tothought.data.validators.CommentValidator;
import org.tothought.web.email.CommentMessage;
import org.tothought.web.email.EmailService;
import org.tothought.web.spring.utilities.RecaptchaService;

@Controller
@RequestMapping(value = "/comment")
public class CommentController {

	@Autowired
	CommentRepository repository;

	@Autowired
	PostViewRepository postViewRepository;

	@Autowired
	TagViewRepository tagViewRepository;

	@Autowired
	EmailService emailService;
	
	@Autowired
	RecaptchaService recaptchaService;

	@RequestMapping(value = "/save")
	public String save(@Valid @ModelAttribute Comment comment, BindingResult result, Model model,
			HttpServletRequest request) {

		final Integer postId = comment.getPost().getPostId();
		
		if (result.hasErrors() || !recaptchaService.isValid(request) || !request.getParameter("mandatory").isEmpty() || this.isValid(comment.getBody())) {
			
			model.addAttribute("post", postViewRepository.findOne(postId));
			model.addAttribute("isSingle", true);
			model.addAttribute("tags", tagViewRepository.findAll(new Sort(Direction.ASC, "name")));
			model.addAttribute("captcha", recaptchaService.getRecaptcha());
			model.addAttribute("captchaError", recaptchaService.getErrorMsg());
			return "blog/post";

		} else {

				comment.setIpAddress(request.getRemoteAddr());
				comment.setPostedDt(new Date());
				repository.save(comment);
				this.sendEmail(comment);

				return "redirect:/post/" + postId.toString();
		}
	}

	private void sendEmail(Comment comment) {
		// Send notification email
		CommentMessage commentMessage = new CommentMessage();
		commentMessage.setBody(comment);
		emailService.sendMessage(commentMessage);
	}

	@InitBinder("comment")
	public void initBinderAll(WebDataBinder binder) {
		binder.setValidator(new CommentValidator());
	}
	
	public boolean isValid(String body){
		return StringUtils.containsIgnoreCase(body, "http");
	}
}
