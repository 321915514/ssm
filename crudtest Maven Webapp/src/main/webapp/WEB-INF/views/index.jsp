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
	<link href="${path}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
	<script type="text/javascript" src="${path}/static/js/jquery-1.12.4.js"></script>
	<script src="${path}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
	

  </head>
  
  <body>
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
  			<button class="btn btn-primary">新增</button>
  			<button class="btn btn-danger">删除</button>
  		</div>
  	
  	</div>
  	<!--表格数据  -->
  	<div class="row">
  		<div class="col-md-12">
  			<table class="table table-hover">
  				<tr>
  					<th>#</th>
  					<th>empName</th>
  					<th>gender</th>
  					<th>email</th>
  					<th>deptName</th>
  					<th>操作</th>
  				</tr>
  			<c:forEach items="${pageInfo.list}" var="emp">
  				<tr>
  					<td>${emp.empId}</td>
  					<td>${emp.empName}</td>
  					<td>${emp.gender=="1"?"男":"女"}</td>
  					<td>${emp.email}</td>
  					<td>${emp.department.deptName}</td>
  					<td>
  						<button class="btn btn-primary btn-sm">
  						<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>编辑</button>
  						<button class="btn btn-danger btn-sm">
  						<span class="glyphicon glyphicon-trash" aria-hidden="true"></span>删除</button>
  					</td>
  				</tr>
  			</c:forEach>
  			
  			</table>
  		
  		</div>
  	
  	
  	</div>
  	<!-- 分页信息 -->
  	<div class="row">
  	<!-- 分页文字信息 -->
  		<div class="col-md-6">		
			当前${pageInfo.pageNum}页,总${pageInfo.pages}页,总${pageInfo.total}记录
  		</div>
  		<!-- 分页条信息 -->
  		<div class="col-md-6">
  			 <nav aria-label="Page navigation">
				  <ul class="pagination">
				  <li><a href="${path}/emps?p=1">首页</a></li>
				  <c:if test="${pageInfo.hasPreviousPage}">
				    <li>
				      <a href="${path}/emps?p=${pageInfo.pageNum-1}" aria-label="Previous">
				        <span aria-hidden="true">&laquo;</span>
				      </a>
				    </li>
				    </c:if>
				    
				    <c:forEach items="${pageInfo.navigatepageNums}" var="page_Num">
				    <c:if test="${pageInfo.pageNum==page_Num }">
				    <li class="active"><a href="#">${page_Num}</a></li>
				    </c:if>
				    	<c:if test="${pageInfo.pageNum!=page_Num }">
				    		
				    		 <li><a href="${path}/emps?p=${page_Num}">${page_Num}</a></li>
				    	
				    	</c:if>
				    </c:forEach>
				    <c:if test="${pageInfo.hasNextPage }">
				    <li>
				      <a href="${path}/emps?p=${pageInfo.pageNum+1}" aria-label="Next">
				        <span aria-hidden="true">&raquo;</span>
				      </a>
				    </li>
				    </c:if>
				     <li><a href="${path}/emps?p=${pageInfo.pages}">末页</a></li>
				  </ul>
				</nav>
  		
  		
  		</div>
  		
  	
  	
  	</div>
  
  
  
  </div>
    
    
    
    
  </body>
</html>
