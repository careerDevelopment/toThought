package org.tothought.web.spring.controllers.blog;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.tothought.data.repositories.PostViewRepository;
import org.tothought.data.repositories.TagViewRepository;
import org.tothought.data.views.PostView;
import org.tothought.web.json.JsonUtil;
import org.tothought.web.spring.utilities.RecaptchaService;

@Controller
@RequestMapping("/post")
public class PostController {
	
	@Autowired
	TagViewRepository tagViewRepository;

	@Autowired
	PostViewRepository postViewRepository;

	@Autowired
	RecaptchaService recaptchaService;
	
	@RequestMapping("/{postId}")
	public String getPost(@PathVariable Integer postId, Model model) {
		model.addAttribute("captcha", recaptchaService.getRecaptcha());
		model.addAttribute("isSingle", true);
		model.addAttribute("post", postViewRepository.findOne(postId));
		model.addAttribute("tags", tagViewRepository.findAll(new Sort(Direction.ASC, "name")));
		return "blog/post";
	}

	@RequestMapping("/{postId}/tags")
	@ResponseBody
	public String getTags(@PathVariable Integer postId, Model model) {
		PostView postView = postViewRepository.findOne(postId);
		return JsonUtil.getJson(postView.getTags());
	}

}
