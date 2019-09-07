<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String path = request.getContextPath();
	pageContext.setAttribute("path",path);
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>员工列表</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	<script type="text/javascript" src="${path}/static/js/jquery-3.4.1.js"></script>
	<link rel="stylesheet" href="${path}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" >
	<script src="${path}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
	<script type="text/javascript">
		var totalrecord,currentPage;
		$(function(){
			to_page(1);

		});
		function to_page(p){
			$.ajax({
				url:"${path}/emps",
				data:"p="+p,
				type:"get",
				success:function(data){
					
					build_emps_table(data);
					build_page_info(data);
					build_emps_nav(data);
				}
				
				
			})
		}
		function build_emps_table(data){
				$("#table_emps tbody").empty();
			var emps=data.map.pageInfo.list;
/* 			var editspan=$("<span></span>").attr("class","glyphicon glyphicon-pencil");
			var deletespan=$("<span></span>").attr("class","glyphicon glyphicon-trash");
			var btn=$("<button></button>").attr("class","btn btn-primary btn-sm");
			var editbtn=$(btn).append(editspan).text("编辑");
			var deletebtn=$(btn).append(deletespan).text("删除"); */
			$.each(emps,function(index,item){
				var empIdtd=$("<td></td>").append(item.empId);
				var empNametd=$("<td></td>").append(item.empName);
				var gendertd=$("<td></td>").append(item.gender==true?"男":"女");
				var emailtd=$("<td></td>").append(item.email);
				var checkBox1=$("<td></td>").append($("<input type='checkbox' class='checkbox_item'>"));
				var deptNametd=$("<td></td>").append(item.department.deptName);
				var editbtn=$("<button></button>").addClass("btn btn-primary btn-sm edit_btn").text("编辑").append("<span></span>").addClass("glyphicon glyphicon-pencil");
				editbtn.attr("editId",item.empId);
				
		
				var deletebtn=$("<button></button>").addClass("btn btn-danger btn-sm delete_btn").text("删除").append("<span></span>").addClass("glyphicon glyphicon-trash");
				deletebtn.attr("deleteid",item.empId);
				
				var caozuo=$("<td></td>").append(editbtn).append(" ").append(deletebtn);
				$("<tr></tr>").append(checkBox1).append(empIdtd).append(empNametd).append(gendertd).append(emailtd).append(deptNametd).append(caozuo).appendTo("#table_emps tbody");
			});
			
			
		}
		function build_page_info(data){
			$("#pageinfo").empty();
			var pageNum=data.map.pageInfo.pageNum;
			var pages=data.map.pageInfo.pages;
			var total=data.map.pageInfo.total;
			$("#pageinfo").text("当前"+pageNum+"页,总"+pages+"页,总"+total+"记录");
			totalrecord=total;
			currentPage=pageNum;
		}
		
		
		
		function build_emps_nav(data){
				$("#build_emps_nav").empty();
					var ul=$("<ul></ul>").addClass("pagination")
					var pageNums=data.map.pageInfo.navigatepageNums;
					var firstPageLi=$("<li></li>").append($("<a></a>").attr("href","#").text("首页"));

					var lastPageLi=$("<li></li>").append($("<a></a>").attr("href","#").text("末页"));
					var prePageLi=$("<li></li>").append($("<a></a>").attr("href","#").append("&laquo;"));
					
					var nextPageLi=$("<li></li>").append($("<a></a>").attr("href","#").append("&raquo;"));
					if(data.map.pageInfo.hasPreviousPage==false){
						prePageLi.addClass("disabled");
						firstPageLi.addClass("disabled");
					}else{
						$(firstPageLi).click(function(){
							to_page(1);
						})
						$(prePageLi).click(function(){
							to_page(data.map.pageInfo.pageNum-1);
						})
						
					}
					if(data.map.pageInfo.hasNextPage==false){
						nextPageLi.addClass("disabled");
						lastPageLi.addClass("disabled");
					}else{
						$(nextPageLi).click(function(){
							to_page(data.map.pageInfo.pageNum+1);
						})
						$(lastPageLi).click(function(){
							to_page(data.map.pageInfo.pages);
						})
						
							
					}
				
					ul.append(firstPageLi).append(prePageLi);
					$.each(pageNums,function(index,Num){
						var a=$("<li></li>").append($("<a></a>").attr("href","#").text(Num));
						if(data.map.pageInfo.pageNum==Num){
							a.addClass("active");
						}
						a.click(function(){
							
							to_page(Num);
						})
						ul.append(a);
					});
					ul.append(nextPageLi).append(lastPageLi);
					var navEle=$("<nav></nav>").attr("aria-label","Page navigation").append(ul);
					$("#build_emps_nav").append(navEle);
			}
			
			
		</script>
		<script>
		/* 清空 */
			function reset_form(ele){
				$(ele)[0].reset();
				$(ele).find("*").removeClass("has-error has-success");
				$(ele).find(".help-block").text("");
				
			}
			/*显示模态对话框  */	
			$(function(){
				$("#emp_add_modal_btn").click(function(){	
					$("#empModal").modal({
						backdrop:'static'	
					});
					reset_form("#empModal form");
					getDepts("#empModal select");
				});
			})
	
			/* 获取部门 */
		function getDepts(ele){
				$(ele).empty();
				$.ajax({
					url :"${path}/depts",
					type:"get",
					success:function(data){
						$.each(data.map.depts,function(){
							var  optionEle=$("<option></option>").append(this.deptName).attr("value",this.deptId);
							$(ele).append(optionEle);
						});
						
					}
					
				});
			}
	</script>
		<!-- 保存员工 -->
		
			
		<script>
			$(function(){
				$("#empSave_emp").click(function(){
					/* 前端数据校验 */
					if(!validate_add_form()){
						return false;
					}
					if($(this).attr("validate_ajax")=="error"){
						return false;
					}

					 $.ajax({
						url:"${path}/emp",
						type:"post",
						data:$("#empModal form").serialize(),
						 success:function(result){
							 if(result.code==100){
								 $("#empModal").modal("hide");
								 to_page(totalrecord); 
							 }else{
								 //显示失败信息
								 if(undefined !=result.map.fieldErrors.empName){
									 show_validate_msg("#empName_add_input","error",result.map.fieldErrors.empName);
								 }
								if(undefined !=result.map.fieldErrors.email){
									show_validate_msg("#email_add_input","error",result.map.fieldErrors.email);									 
								}
							 }
							 
					}	
				}); 	
			});	
		})
	</script>
	<script>
		$(function(){
			$("#empName_add_input").change(function(){
				/*  发送ajax*/
				var empName=this.value;
				$.ajax({
					url:"${path}/checkuser",
					data:"empName="+empName,
					type:"post",
					success:function(result){
						if(result.code==100){
							show_validate_msg("#empName_add_input","success","用户名可用");
							$("#empName_add_input").attr("validate_ajax","success");
						}else{
							show_validate_msg("#empName_add_input","error",result.map.va_msg);
							$("#empName_add_input").attr("validate_ajax","fail");
						}
					}
				});
			});
		})
			
			
		/*校验表单  */
		function validate_add_form(){
			var empName=$("#empName_add_input").val();	
			var regName=/(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]+$)/;
			if(!regName.test(empName)){
				
				show_validate_msg("#empName_add_input","error","用户名2-5位中文或6-16位英文数字组合");
				return false;
			}else{
				show_validate_msg("#empName_add_input","success","");
			}
			var email=$("#email_add_input").val();
			
			var regEmail=/^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
			if(!regEmail.test(email)){
				show_validate_msg("#email_add_input","error","邮箱格式不正确");
				return false;
			}else{
				show_validate_msg("#email_add_input","success","");
			}
			return true;
			
		}

		function show_validate_msg(ele,status,msg){
				$(ele).parent().removeClass("has-success has-error")
				$(ele).next("span").text("");
			if("success"==status){
				$(ele).parent().addClass("has-success");
				$(ele).next("span").text(msg);
			}else if("error"==status){
				$(ele).parent().addClass("has-error");
				$(ele).next("span").text(msg);
			}
		}
		/* edit */
		$(document).on("click",".edit_btn",function(){
			
			
			$("#empUpdateModal").modal({
				backdrop:'static'	
			});
			getEmp($(this).attr("editId"));
			$("#empUpdate_emp").attr("editid",$(this).attr("editId"));
			getDepts("#empUpdateModal select");
			
		});
		function getEmp(id){
			$.ajax({
				url:"${path}/emp/"+id,
				type:"get",
				success:function(result){
				var employee=result.map.employee;
					$("#empName_update_static").text(employee.empName);
					$("#email_update_input").val(employee.email);
					$("#empUpdateModal input[name=gender]").each(function(){
						if(employee.gender==$(this).val()){
							$(this).prop("checked",true);
						}
					})
					$("#empUpdateModal select").val([employee.dId]);
				}
			});
		}
		</script>
		<script>
		$(function(){
			$("#empUpdate_emp").click(function(){
				var email=$("#email_update_input").val();
							
							var regEmail=/^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
							if(!regEmail.test(email)){
								show_validate_msg("#email_update_input","error","邮箱格式不正确");
								return false;
							}else{
								show_validate_msg("#email_update_input","success","");
							}
						
						/* 发送请求更新 */
						$.ajax({
							url:"${path}/emp/"+$(this).attr("editid"),
							type:"PUT",
							data:$("#empUpdateModal form").serialize(),
							success:function(result){
								$("#empUpdateModal").modal('hide');
								to_page(currentPage);
							}
						});
						
				});
		})
		//单个删除
		$(document).on("click",".delete_btn",function(){
				var empName=$(this).parents("tr").find("td:eq(2)").text();
			if(confirm("确认删除"+empName+"吗?")){
				$.ajax({
					url:"${path}/emp/"+$(this).attr("deleteid"),
					type:"DELETE",
					success:function(result){
						alert(result.msg);
						to_page(currentPage);
					}
					
				});
			}
		})
		</script>
		<script>
		$(function(){
			$("#chack_all").click(function(){
				$(".checkbox_item").prop("checked",$(this).prop("checked"));
			})
		})
		$(document).on("click",".checkbox_item",function(){
			var flag=$(".checkbox_item:checked").length==$(".checkbox_item").length;
			$("#chack_all").prop("checked",flag);
		})
		</script>
		<script>
		$(function(){
			$("#deleteEmp_btn").click(function(){
				var empNames="";
				var del_idstr="";
				$.each($(".checkbox_item:checked"),function(){
					empNames+=$(this).parents("tr").find("td:eq(2)").text()+",";
					del_idstr+=$(this).parents("tr").find("td:eq(1)").text()+"-";
				});
				/* 去除emps多余的逗号 */
				var empNames=empNames.substring(0,empNames.length-1);
				var del_idstr=del_idstr.substring(0,del_idstr.length-1);
				if(confirm("确认删除"+empNames+"吗?")){
					$.ajax({
						url: "${path}/emp/"+del_idstr,
						type:"DELETE",
						success: function(result){
							alert(result.msg)
							to_page(currentPage);
							
						}
							
							
						
					});
				}
				
			});
	})
		

		
	</script>
				
  </head>
  
  <body>
  <!-- Modal -->
<div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">员工修改</h4>
      </div>
      <div class="modal-body">
			<form class="form-horizontal">
			
					  <div class="form-group">
					    <label for="empName_add_input" class="col-sm-2 control-label">empName</label>
					    <div class="col-sm-10">
					      <p class="form-control-static" id="empName_update_static"></p>
					    </div>
					  </div>
					  
					   <div class="form-group">
					    <label for="email_add_input" class="col-sm-2 control-label">email</label>
					    <div class="col-sm-10">
					      <input type="text" name="email" class="form-control" id="email_update_input" placeholder="email@qq.com">
					      <span class="help-block"></span>
					    </div>
					  </div>
					  
					  
					  <div class="form-group">
					    <label for="gender_add_input" class="col-sm-2 control-label">gender</label>
					    <div class="col-sm-10">
					   		<label class="radio-inline">
								<input type="radio" name="gender" id="gender1_update_input" value="1"  > 男
							</label>
							<label class="radio-inline">
								<input type="radio" name="gender" id="gender2_update_input" value="0"> 女
							</label>
					    </div>
					  </div>
					  
					  <div class="form-group">
					    <label  class="col-sm-2 control-label">deptName</label>
					    <div class="col-sm-4">
					   		<select class="form-control" name="dId" id="selectUpdate_emp">
								
								
							</select>
					    </div>
					  </div> 
			</form> 
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
        <button type="button" class="btn btn-primary" id="empUpdate_emp">更新</button>
      </div>
    </div>
  </div>
</div>
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  

<!-- Modal -->
<div class="modal fade" id="empModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">员工添加</h4>
      </div>
      <div class="modal-body">
			<form class="form-horizontal">
			
					  <div class="form-group">
					    <label for="empName_add_input" class="col-sm-2 control-label">empName</label>
					    <div class="col-sm-10">
					      <input type="text" name="empName" class="form-control" id="empName_add_input" placeholder="empName">
					      <span class="help-block"></span>
					      
					    </div>
					  </div>
					  
					   <div class="form-group">
					    <label for="email_add_input" class="col-sm-2 control-label">email</label>
					    <div class="col-sm-10">
					      <input type="text" name="email" class="form-control" id="email_add_input" placeholder="email@qq.com">
					      <span class="help-block"></span>
					    </div>
					  </div>
					  
					  
					  <div class="form-group">
					    <label for="gender_add_input" class="col-sm-2 control-label">gender</label>
					    <div class="col-sm-10">
					   		<label class="radio-inline">
								<input type="radio" name="gender" id="gender1_add_input" value="1" checked="checked"> 男
							</label>
							<label class="radio-inline">
								<input type="radio" name="gender" id="gender2_add_input" value="0"> 女
							</label>
					    </div>
					  </div>
					  
					  <div class="form-group">
					    <label  class="col-sm-2 control-label">deptName</label>
					    <div class="col-sm-4">
					   		<select class="form-control" name="dId" id="select_emp">
								
								
							</select>
					    </div>
					  </div> 
			</form> 
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
        <button type="button" class="btn btn-primary" id="empSave_emp">保存</button>
      </div>
    </div>
  </div>
</div>
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  <div class="container">
  <!--  标题-->
  	<div class="row">
  		<div class="col-md-12">
  			<h1>SSM-CRUD</h1>
  		</div>
  	</div>
  	<!--按钮  -->
  	<div class="row">
  		<div class="col-md-4 col-md-offset-8">
  			<button class="btn btn-primary"   id="emp_add_modal_btn" >新增</button>
  			<button class="btn btn-danger" id="deleteEmp_btn">删除</button>
  		</div>
  	
  	</div>
  	<!--表格数据  -->
  	<div class="row">
  		<div class="col-md-12">
  		<table class="table table-hover" id="table_emps">
  			<thead>
  				<tr>
  					<th><input type="checkbox" id="chack_all"></th>
  					<th>#</th>
  					<th>empName</th>
  					<th>gender</th>
  					<th>email</th>
  					<th>deptName</th>
  					<th>操作</th>
  				</tr>
  				</thead>
  				<tbody>
  			<c:forEach items="${pageInfo.list}" var="emp">
  				<tr>
  					<td>${emp.empId}</td>
  					<td>${emp.empName}</td>
  					<td>${emp.gender=="1"?"男":"女"}</td>
  					<td>${emp.email}</td>
  					<td>${emp.department.deptName}</td>
  					<td>
  						<button class="btn btn-primary btn-sm" id="edit">
  						<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>编辑</button>
  						<button class="btn btn-danger btn-sm" id="delete">
  						<span class="glyphicon glyphicon-trash" aria-hidden="true"></span>删除</button>
  					</td>
  				</tr>
  			</c:forEach>
  			</tbody>
  			
  			</table>
  		
  		</div>
  	
  	
  	</div>
  	<!-- 分页信息 -->
  	<div class="row">
  	<!-- 分页文字信息 -->
  		<div class="col-md-6" id="pageinfo">		
			
  		</div>
  		<!-- 分页条信息 -->
  		<div class="col-md-6" id="build_emps_nav">

  		</div>
  		
  	
  	
  	</div>
  
  
  
  </div>
    

    

    
    
    
    
  </body>
</html>
