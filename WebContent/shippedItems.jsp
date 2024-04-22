<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page
	import="com.gowtham.service.impl.*,com.gowtham.beans.*,com.gowtham.service.*,java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Admin Home</title>
<link rel="stylesheet" href="css/changes.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
</head>
<body style="background-color:white;">
<%@ include file="loader.html"%>
	<%
	/* Checking the user credentials */
	String userType = (String) session.getAttribute("usertype");
	String userName = (String) session.getAttribute("username");
	String password = (String) session.getAttribute("password");

	if (userType == null || !userType.equals("admin")) {

		response.sendRedirect("login.jsp?message=Access Denied, Login as admin!!");

	}

	else if (userName == null || password == null) {

		response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");

	}
	%>

	<jsp:include page="header.jsp" />
	<br> <br> <br> <br> <br> <br> <br>
	

	<div class="text-center"
		style="color: black; font-size: 24px; font-weight: bold;">Shipped
		Orders</div>
	<div class="container-fluid" style="margin-bottom:200px;">
		<div class="table-responsive ">
			<table class="table table-hover table-sm">
				<thead
					style="background-color: #3FD2C7; color: white; font-size: 18px;">
					<tr>
						<th>TransactionId</th>
						<th>ProductId</th>
						<th>Username</th>
						<th>Address</th>
						<th>Quantity</th>
						<th>Amount</th>
						<td>Status</td>
					</tr>
				</thead>
				<tbody style="background-color: #d3d3d3;">

					<%
					OrderServiceImpl orderdao = new OrderServiceImpl();

					List<OrderBean> orders = new ArrayList<OrderBean>();
					orders = orderdao.getAllOrders();
					int count = 0;
					for (OrderBean order : orders) {
						String transId = order.getTransactionId();
						String prodId = order.getProductId();
						int quantity = order.getQuantity();
						int shipped = order.getShipped();
						String userId = new TransServiceImpl().getUserId(transId);
						String userAddr = new UserServiceImpl().getUserAddr(userId);
						if (shipped != 0) {
							count++;
					%>

					<tr>
						<td><%=transId%></td>
						<td><a href="./updateProduct.jsp?prodid=<%=prodId%>" style="color:#00458B;"><%=prodId%></a></td>
						<td><%=userId%></td>
						<td><%=userAddr%></td>
						<td><%=quantity%></td>
						<td>Rs. <%=order.getAmount()%></td>
						<td class="text-success" style="font-weight: bold; color:#00458B;">SHIPPED</td>

					</tr>

					<%
					}
					}
					%>
					<%
					if (count == 0) {
					%>
					<tr style="background-color: grey; color: black;">
						<td colspan="7" style="text-align: center;">No Items
							Available</td>

					</tr>
					<%
					}
					%>
				</tbody>
			</table>
		</div>
	</div>

	<%@ include file="footer.html"%>
</body>
</html>