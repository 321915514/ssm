package com.day01.controller;



import java.util.ArrayList;

import java.util.HashMap;

import java.util.List;
import java.util.Map;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.day01.bean.Employee;
import com.day01.bean.Msg;
import com.day01.service.EmployeeService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

@Controller
public class EmployeeController {
	@Autowired(required=true)
	private EmployeeService employeeService;
	/*
	 * 
	 * */
	
	//@RequestMapping("/emps")
	public String getEmps(@RequestParam(value="p",defaultValue="1")Integer p,Model model) {
		PageHelper.startPage(p,5);
		List<Employee> list = employeeService.getAll();
		//用PageInfo对结果进行包装
		PageInfo page = new PageInfo(list,5);
		//测试PageInfo全部属性
		//PageInfo包含了非常全面的分页属性
		model.addAttribute("pageInfo", page);
		return "index";
	}
	
	
	@RequestMapping("/emps")
	@ResponseBody
	public Msg getEmpsWithJson(@RequestParam(value="p",defaultValue="1")Integer p,Model model){
		PageHelper.startPage(p,5);
		List<Employee> list = employeeService.getAll();
		//用PageInfo对结果进行包装
		PageInfo page = new PageInfo(list,5);
		//测试PageInfo全部属性
		//PageInfo包含了非常全面的分页属性
		return Msg.success().add("pageInfo", page);
		
	}
	
	/*
	 * 员工保存
	 * */
	
	@RequestMapping(value="/emp",method=RequestMethod.POST)
	@ResponseBody
	public Msg empSave(@Valid Employee employee,BindingResult result) {
		Map<String, Object>  map=new HashMap<String, Object>();
		if (result.hasErrors()) {
			List<FieldError> errors = result.getFieldErrors();
			for (FieldError fieldError : errors) {
				map.put(fieldError.getField(), fieldError.getDefaultMessage());
			}
			return Msg.fail().add("fieldErrors", map);
		} else {
			employeeService.empSave(employee);

			return Msg.success();
		}
	}
	
	
	//校验
	@RequestMapping(value="/checkuser")
	@ResponseBody
	public Msg checkuser(String empName) {
		//校验
		String regName="(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]+$)";
			if(regName.matches(regName)){
				return Msg.fail().add("va_msg", "用户名必须是6-16位英文数字组合或2-5位中文");
			}
		
		//数据库校验
		boolean b=employeeService.checkuser(empName);
		if (b) {
			return Msg.success();
		}else {
			return Msg.fail().add("va_msg", "用户名不可用");
		}
		 
	}
	//查询员工
	@RequestMapping(value="/emp/{id}",method=RequestMethod.GET)
	@ResponseBody
	public Msg getEmp(@PathVariable("id")Integer id){
		Employee employee=employeeService.getEmp(id);
		return Msg.success().add("employee", employee);
	}
	
	
	//员工更新方法
	@ResponseBody
	@RequestMapping(value="/emp/{empId}",method=RequestMethod.PUT)
	public Msg saveEmp(Employee employee) {

		employeeService.updateEmp(employee);
		
		return Msg.success();
		
	}
	
	@ResponseBody
	@RequestMapping(value="/emp/{empId}",method=RequestMethod.DELETE)
	public Msg deleteEmpById(@PathVariable("empId")String id) {
		if (id.contains("-")) {
			List<Integer> list=new ArrayList<Integer>();
			String[] str_Ids=id.split("-");
			for (String string : str_Ids) {
				Integer integer=Integer.parseInt(string);
				list.add(integer);
			}
			employeeService.deleteBatch(list);
		}else{
			Integer id1=Integer.parseInt(id);
		employeeService.deleteEmpById(id1);
		
			return Msg.success();
		}
		return Msg.success();
	}
	
	
	
	
}
