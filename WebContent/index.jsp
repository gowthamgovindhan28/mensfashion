<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page
	import="com.gowtham.service.impl.*,com.gowtham.service.*,com.gowtham.beans.*,java.util.*,javax.servlet.ServletOutputStream,java.io.*"%>
<!DOCTYPE html>
<html>
<head>
<title>Mens fashion</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
<link rel="stylesheet" href="css/changes.css">
<link rel="stylesheet" href="css/style.css">





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

	boolean isValidUser = true;

	if (userType == null || userName == null || password == null || !userType.equals("customer")) {

		isValidUser = false;
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
	<div class="text-center" id="message"
		style="color: black; font-size: 14px; font-weight: bold;"></div>
		
			<!-- Start of Product Items List -->
		
	<div class="container">
			<div class="row text-center">

			<%
			for (ProductBean product : products) {
				int cartQty = new CartServiceImpl().getCartItemCount(userName, product.getProdId());
			%>
			<div class="product-card" >
				<div class="product-details" >
					<img class="product-image" src="./ShowImage?pid=<%=product.getProdId()%>" alt="Product">
					<p class="" style="color::#00458B;
	font-weight:bold;"><%=product.getProdName()%>
					</p>
					<%
					String description = product.getProdInfo();
					description = description.substring(0, Math.min(description.length(), 80));
					%>
					<p class="des" style="font-weight:lighter;"><%=description%>..
					</p>
					<p class="rate">
						Rs
						<%=product.getProdPrice()%>
					</p>
					<form class="form" method="post">
						<%
						if (cartQty == 0) {
						%>
						<button type="submit"
							formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1"
							class="">Add to Cart</button>
						&nbsp;&nbsp;&nbsp;
						<button type="submit"
							formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1"
							class="">Buy Now</button>
						<%
						} else {
						%>
						<button type="submit"
							formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0"
							class="">Remove Cart</button>
						&nbsp;&nbsp;&nbsp;
						<button type="submit" formaction="cartDetails.jsp"
							class="">Checkout</button>
						<%
						}
						%>
					</form>
					<br/>
					
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