package com.example.mall;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

	@GetMapping("/off/home")
	public String getMethodName() {
		return "/off/home";
	}
	
	
}
