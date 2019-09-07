package com.day01.service;

import java.util.List;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.day01.bean.Employee;
import com.day01.bean.EmployeeExample;
import com.day01.bean.EmployeeExample.Criteria;
import com.day01.dao.EmployeeMapper;
@Service(value="employeeService")
public class EmployeeService {
	
	@Autowired
	private EmployeeMapper employeeMapper;
	
	
	public List<Employee> getAll() {
		return employeeMapper.selectByExampleWithDept(null);
	}


	public void empSave(Employee employee) {
		// TODO Auto-generated method stub
		employeeMapper.insertSelective(employee);
	}

//检验用户名
	public boolean checkuser(String empName) {
		// TODO Auto-generated method stub
		EmployeeExample example=new EmployeeExample();
		Criteria criteria = example.createCriteria();
		criteria.andEmpNameEqualTo(empName);
		long count=employeeMapper.countByExample(example);
		return count==0;
	}


	public Employee getEmp(Integer id) {
		// TODO Auto-generated method stub
		return employeeMapper.selectByPrimaryKey(id);
	}


	public void updateEmp(Employee employee) {
		// TODO Auto-generated method stub
		 employeeMapper.updateByPrimaryKeySelective(employee);
	}


	public void deleteEmpById(Integer id) {
		// TODO Auto-generated method stub
		employeeMapper.deleteByPrimaryKey(id);
	}


	public void deleteBatch(List<Integer> str_Ids) {
		// TODO Auto-generated method stub
		EmployeeExample example =new EmployeeExample();
		Criteria criteria = example.createCriteria();
		criteria.andEmpIdIn(str_Ids);
		employeeMapper.deleteByExample(example);
	}

}
