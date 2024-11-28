<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>  
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    
<!DOCTYPE html>
<html>
<head>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
	<script>
	$(document).ready(function() {
		// 상품 삭제 버튼 클릭
	    $('.btnRemoveGoods').click(function(event) {
	        // 기본 링크 클릭 동작을 막기 (페이지 이동을 막기)
	        event.preventDefault();
	        
	        // 삭제 확인 
	        var result = confirm("정말로 삭제하시겠습니까?");
	        if (result) {
	        	window.location.href = $(this).attr('href');
	        	alert('삭제 성공하였습니다.');
	        } else {
	            return false;
	        }
	    });
		
	 	// 상품 업데이트 날짜에 따른 요일 추가
        $('span[id="dayOfWeek"]').each(function() {
            var updateDate = $(this).data('update-date');  // data-update-date 속성에서 날짜를 가져옵니다.
            
            // 'Z'를 붙여 UTC 시간으로 처리
            var date = new Date(updateDate + "Z");  // UTC 시간으로 변환
            
            // 요일을 추출 (0: 일요일, 1: 월요일, ..., 6: 토요일)
            var daysOfWeek = ["일", "월", "화", "수", "목", "금", "토"];
            var dayOfWeek = daysOfWeek[date.getUTCDay()];  // getUTCDay()로 UTC 기준으로 요일 숫자 추출
            
            // 해당 span에 요일을 삽입
            $(this).text(dayOfWeek);  // 요일을 삽입
        });
	});
	</script>
	<style>
		.customer-link {
        	color: black;
        	text-decoration: none;
        }
        
        .customer-link:hover {
            color: #D8D8D8;
            text-decoration: none;
        }
        
        .customer-link:visited {
        	color: black;
        	text-decoration: none;
        }
		
		.pagination {
		  display: flex;
  		  justify-content: center;
		}
		
		.pagination a {
		  color: #5D5D5D;
		  float: left;
		  padding: 6px 12px;
		  text-decoration: none;
		  border: 1px solid #ddd;
		}
		
		.pagination a.active {
		  background-color: #5D5D5D;
		  color: white;
		  border: 1px solid #5D5D5D;
		}
		
		.pagination a:hover:not(.active) {background-color: #ddd;}
		
		.pagination a:first-child {
		  border-top-left-radius: 5px;
		  border-bottom-left-radius: 5px;
		}
		
		.pagination a:last-child {
		  border-top-right-radius: 5px;
		  border-bottom-right-radius: 5px;
		}
	</style>
<meta charset="UTF-8">
<title>Goods List</title>
</head>
<body>
<div class="row">
	<!-- leftbar -->
	<div class="col-sm-2 p-0">
		<div >
			<c:import url="/WEB-INF/view/inc/staffLeftMenu.jsp"></c:import>
		</div>
	</div>
	
	<!-- main -->
	<div class="col-sm-10 p-0">
		<!-- header -->
		<div>
			<c:import url="/WEB-INF/view/inc/staffHeader.jsp"></c:import>
		</div>
		<!-- main -->
		<div style="margin-left: 80px; margin-top: 30px;">
			<h3>Staff Goods List</h3>
		</div>
		
		<!-- updateDate 기준으로 그룹화 출력 -->
        <c:set var="previousDate" value="" /> <!-- 이전 날짜를 저장할 변수 -->
        
		<div class="d-flex flex-column flex-md-row p-4 gap-4 py-md-4 align-items-center" style="margin-left: 110px;">
	  		<div class="list-group">
 				<c:forEach var="goods" items="${goodsList}">
 				
 				<!-- 날짜를 'yyyy-MM-dd' 형식으로 추출 -->
                <c:set var="formattedDate" value="${fn:substring(goods.updateDate, 0, 10)}" />
                
                <!-- 요일을 추출 -->
                <fmt:parseDate var="date" value="${goods.updateDate}" pattern="yyyy-MM-dd'T'HH:mm:ss" />
                <fmt:formatDate value="${date}" pattern="E" var="dayOfWeek" />
 				
 				<!-- 새로운 날짜 그룹 시작 -->
                <c:if test="${formattedDate != previousDate}">
                	<c:set var="previousDate" value="${formattedDate}" />
                  
    				<!-- 날짜와 요일을 삽입할 div -->
                    <div class="d-flex gap-1 py-1 bg-light" style="width: 1000px; border: 1px solid #ddd; border-radius: 5px; margin-bottom: 10px; padding: 10px;">
                    	<div class="d-flex align-items-center" style="width: 100%;">
                        <!-- 날짜와 요일을 삽입 -->
                        	<div style="margin-left: 20px;">
                            	<span>${formattedDate} (<span id="dayOfWeek">${dayOfWeek}</span>)</span>
                          	</div>
                      	</div>
                  	</div>
              	</c:if>
 					<div class="list-group-item list-group-item-action d-flex gap-3 py-3" style="width: 1000px;">
 						<div class="d-flex justify-content-center align-items-center">
 							<!-- 파일 있을 때 -->
 							<c:if test="${not empty goods.goodsFileNo}">
 								<img src="${pageContext.request.contextPath}/goodsFile/${goods.goodsFileName}.${goods.goodsExt}" alt="${goods.goodsOriginName}" class="img-thumbnail" style="width: 250px; height: 200px; object-fit: cover;" />
 							</c:if>
 							<!-- 파일 없을 때 -->
 							<c:if test="${empty goods.goodsFileNo}">
 								<div style="align-items: center;">
 									<img src="${pageContext.request.contextPath}/goodsFile/Preparing_the_product_img.jpg" alt="Preparing the product Image" class="img-thumbnail" style="width: 250px; height: 200px; object-fit: cover;" />
 								</div>
 							</c:if>
 						</div>
      					<div class="d-flex gap-2 w-100 justify-content-between">
					        <div>
					        	<div class="d-flex justify-content-between">
					        		<div>
      									<i class="bi bi-box-seam"> No.${goods.goodsNo}</i> <span>${goods.goodsTitle}</span>
      								</div>
      								<div>
					        			 <a href="${pageContext.request.contextPath}/staff/modifyGoods?goodsNo=${goods.goodsNo}" class="btnModifyGoods btn btn-sm btn-outline-success">
										   Modify
										</a>
									    <a href="${pageContext.request.contextPath}/staff/removeGoods?goodsNo=${goods.goodsNo}" class="btnRemoveGoods btn btn-sm btn-outline-danger">
										   Remove
										</a>
									</div>
      							</div>
      							<p class="mt-2 mb-0"><small>Category : ${goods.categoryTitle}</small></p>
      							<div class="d-flex justify-content-between">
								    <div style="flex-grow: 1;"> 
								        <p class="mt-2 mb-0"><small>Description : ${goods.goodsMemo}</small></p>
								        <div class="d-flex justify-content-between mt-2 align-items-center">
								        	<div>
								        		<small class="opacity-75">UpdateDate : ${goods.updateDate}</small>
								        	</div>
								        	<div style="display: flex; align-items: center; justify-content:center;">
									        	<c:if test="${goods.goodsStatus == '재고있음'}">
									        	 	<small class="opacity-75" style="margin-right: 10px;">Goods_Status</small>
											        <a href="${pageContext.request.contextPath}/staff/modifyGoodsStatus?goodsNo=${goods.goodsNo}" class="btnModifyGoodsStatus btn btn-sm btn-outline-primary mt-2">
											           품절
											        </a>
										        </c:if>
										        <c:if test="${goods.goodsStatus == '재고없음'}">
										        	<small class="opacity-75" style="margin-right: 10px;">Goods_Status</small>
											        <a href="${pageContext.request.contextPath}/staff/modifyGoodsStatus?goodsNo=${goods.goodsNo}" class="btnModifyGoodsStatus btn btn-sm btn-outline-primary mt-2">
											            재입고
											        </a>
										        </c:if>
									        </div>
								        </div>
								    </div>
								</div>
					        </div>
			        	</div>
			    	</div>
			    	<br>
 				</c:forEach>
 				<div style="width: 1000px; text-align: right;">
 					<a href="${pageContext.request.contextPath}/staff/addGoods" class="btn btn-sm btn-outline-primary">Add Goods</a>
 				</div>
 				
 				<!-- PAGINATION -->
   				<div class="pagination justify-content-center" style="text-align: center; margin-top: 15px; ">
					<!-- 첫 페이지 -->
					<c:if test="${!(page.currentPage > 1)}">
						<a href="" style="pointer-events: none;">&laquo;</a>
					</c:if>
					<c:if test="${page.currentPage > 1}">
						<a href="${pageContext.request.contextPath}/staff/getGoodsListByStaff?currentPage=1&searchWord=${searchWord}">&laquo;</a>
					</c:if>
					
					<!-- 페이지 - 10 -->
					<c:if test="${!(page.currentPage > 10)}">
						<a href="" style="pointer-events: none;">&lt;</a>
					</c:if>
					<c:if test="${page.currentPage > 10}">
						<a href="${pageContext.request.contextPath}/staff/getGoodsListByStaff?currentPage=${page.currentPage - 10}&searchWord=${searchWord}">
							&lt;
						</a>
					</c:if>
					
					<!-- 이전 페이지 -->
					<c:if test="${!(page.currentPage > 1)}">
						<a href="" style="pointer-events: none;">Previous</a>
					</c:if>
					<c:if test="${page.currentPage > 1}">
						<a href="${pageContext.request.contextPath}/staff/getGoodsListByStaff?currentPage=${page.currentPage - 1}&searchWord=${searchWord}">
							Previous
						</a>
					</c:if>
					
					<!-- 페이지 번호 링크 -->
					<c:forEach var="num" begin="${page.getStartPagingNum()}" end="${page.getEndPagingNum()}">
						<c:if test= "${num == page.currentPage}">
							<a class="active">${num}</a>
						</c:if>
						<c:if test= "${num != page.currentPage}">
							<a href="${pageContext.request.contextPath}/staff/getGoodsListByStaff?currentPage=${num}&searchWord=${searchWord}">${num}</a>
						</c:if>
					</c:forEach>
					
					<!-- 다음 페이지 -->
					<c:if test="${!(page.currentPage < page.lastPage)}">
						<a href="" style="pointer-events: none;">Next</a>
					</c:if>
					
					<c:if test="${page.currentPage < page.lastPage}">
						<a href="${pageContext.request.contextPath}/staff/getGoodsListByStaff?currentPage=${page.currentPage + 1}&searchWord=${searchWord}">
							Next
						</a>
					</c:if>
					
					<!-- 페이지 + 10 -->
					<c:if test="${!(page.currentPage < page.lastPage)}">
						<a href="" style="pointer-events: none;">&gt;</a>
					</c:if>
					
					<c:if test="${page.currentPage < page.lastPage}">
						<a href="${pageContext.request.contextPath}/staff/getGoodsListByStaff?currentPage=${page.currentPage + 10}&searchWord=${searchWord}">
							&gt;
						</a>
					</c:if>
					
					<!-- 마지막 페이지 -->
					<c:if test="${!(page.currentPage < page.lastPage)}">
						<a href="" style="pointer-events: none;">&raquo;</a>
					</c:if>
					<c:if test="${page.currentPage < page.lastPage}">
						<a href="${pageContext.request.contextPath}/staff/getGoodsListByStaff?currentPage=${page.lastPage}&searchWord=${searchWord}">&raquo;</a>
					</c:if>
				</div>
	  		</div>
		</div>
	</div>
</div>
<!-- footer -->



</body>

</html>