<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page
	import="com.gowtham.service.impl.*,com.gowtham.service.*,com.gowtham.beans.*,java.util.*,javax.servlet.ServletOutputStream,java.io.*"%>
<!DOCTYPE html>
<html>
<head>
<title>View Products</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
<link rel="stylesheet" href="css/changes.css">
<link rel="stylesheet" href="css/styles.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
</head>
<body style="background-color: white;">
<%@ include file="loader.html"%>

	<%
	/* Checking the user credentials */
	String userName = (String) session.getAttribute("username");
	String password = (String) session.getAttribute("password");
	String userType = (String) session.getAttribute("usertype");

	if (userType == null || !userType.equals("admin")) {

		response.sendRedirect("login.jsp?message=Access Denied, Login as admin!!");

	}

	else if (userName == null || password == null) {

		response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");

	}
	ProductServiceImpl prodDao = new ProductServiceImpl();
	List<ProductBean> products = new ArrayList<ProductBean>();

	String search = request.getParameter("search");
	String type = request.getParameter("type");
	String message = "All Products";
	if (search != null) {
		products = prodDao.searchAllProducts(search);
		message = "Showing Results for '" + search + "'";
	} else if (type != null) {
		products = prodDao.getAllProductsByType(type);
		message = "Showing Results for '" + type + "'";
	} else {
		products = prodDao.getAllProducts();
	}
	if (products.isEmpty()) {
		message = "No items found for the search '" + (search != null ? search : type) + "'";
		products = prodDao.getAllProducts();
	}
	%>



	<jsp:include page="header.jsp" />

	<div class="text-center"
		style="color: black; font-size: 14px; font-weight: bold;"><%=message%></div>
	<!-- Start of Product Items List -->
	<div class="container" >
		<div class="row text-center">

			<%
			for (ProductBean product : products) {
			%>
			<div class="product-card">
				<div class="product-details">
					<img class="product-image" src="./ShowImage?pid=<%=product.getProdId()%>" alt="Product">
					<p class="" style="color:black;
	font-weight:bold;"><%=product.getProdName()%>
						(
						<%=product.getProdId()%>
						)
					</p>
					<%
					String description = product.getProdInfo();
					description = description.substring(0, Math.min(description.length(), 80));
					%>
					<p class="des"><%=description%>..</p>
					<p class="rate">
						Rs
						<%=product.getProdPrice()%>
					</p>
					<form class="form" method="post">
						<button type="submit"
							formaction="./RemoveProductSrv?prodid=<%=product.getProdId()%>"
							class="">Remove Product</button>
						&nbsp;&nbsp;&nbsp;
						<button type="submit"
							formaction="updateProduct.jsp?prodid=<%=product.getProdId()%>"
							class="">Update Product</button>
					    
					</form>
				</div>
			</div>

			<%
			}
			%>

		</div>
	</div>
	<!-- ENd of Product Items List -->
	
	<%@ include file="footer.html"%>

</body>
</html>