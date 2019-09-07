package com.day01.controller;


import java.util.List;



import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.day01.bean.Department;
import com.day01.bean.Msg;
import com.day01.service.DepartmentService;

@Controller
public class DepartmentConroller {
	@Autowired
	private DepartmentService departmentService;
	
	@RequestMapping("/depts")
	@ResponseBody
	public Msg getDepts() {
		
		List<Department> list=departmentService.getDepts();
		
		return Msg.success().add("depts", list);
	}

}
