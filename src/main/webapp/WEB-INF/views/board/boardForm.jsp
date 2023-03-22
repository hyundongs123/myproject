 <%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %> 

  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/board/boardForm.css">
  <link href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
  <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.js"></script>

<style>
	body
</style>
<jsp:include page="/WEB-INF/views/common/header.jsp">
		<jsp:param value="게시판" name="title"/>
	</jsp:include>

	<jsp:include page="/WEB-INF/views/board/boardLeftBar.jsp" />

<div class="home-container">
						<!-- 상단 타이틀 -->
						<div class="top-container">
							<div class="container-title">게시판</div>
							<div class="home-topbar topbar-div">
								<div>
									<a href="#" id="home-my-img">
										<img src="${pageContext.request.contextPath}/resources/images/sample.jpg" alt="" class="my-img">
									</a>
								</div>
								<div id="my-menu-modal">
									<div class="my-menu-div">
										<button class="my-menu">기본정보</button>
									</div>
									<div class="my-menu-div">
										<button class="my-menu">로그아웃</button>
									</div>
								</div>
							</div>
						</div>
						<script>
							document.querySelector('#home-my-img').addEventListener('click', (e) => {
								const modal = document.querySelector('#my-menu-modal');
								const style =  modal.style.display;
								
								if (style == 'inline-block') {
									modal.style.display = 'none';
								} else {
									modal.style.display = 'inline-block';
								}
							});
						</script>
						<!-- 상단 타이틀 end -->
						<div class="div-padding"></div>

<section class="content">


  <form:form name="boardFrm" action="${pageContext.request.contextPath}/board/boardEnroll.do?${_csrf.parameterName}=${_csrf.token}" method="post" enctype="multipart/form-data">
  
	<div class="target-select">
		<span>To.</span>
		<select name="bType" id="bType">
			<option value="A">전사 공지</option>
			<option value="M">주간 식단표</option>
			<option value="N">IT뉴스</option>
		</select>
	</div>

  <hr style="width:1000px;">
  	<table class="write-table">
  		<tr>
  			<th>
  				<span class="title" id="title" name="title">제목</span>
  			</th>
  			<td><input type="text" id="title" name="title"></td>
  			<td><input type="hidden" id="empId" name="empId" value="${loginMember.empId}"></td>
  			<td><input type="hidden" id="wrtier" name="writer" value="${loginMember.name}"></td>
  		</tr>
  		<tr>
  			<th>
  				<span class="file">첨부파일</span>
  			</th>
  			<td><input type="file" name="upFile" id="upFile"/></td>
  		</tr>
  	</table>
  	
	<hr style="width:1000px;">
			
  	<div ="editor">
  		<th>
  			<td>
			 	 <textarea id="summernote" name="content"></textarea>  			
  			</td>
  		</th>
  	</div>
  	
  	<table class="check-table">
  		<tr>
  			<th>공개 설정</th>
  			<td><input type="checkbox"/>공개</td>
  			<td><input type="checkbox"/>비공개</td>
  		</tr>
  		<tr>
  			<th>공지로 등록</th>
  			<td><input type="checkbox"/> 공지로 등록</td>
  		</tr>
  		<tr>
  			<th>알림</th>
  			<td><input type="checkbox"/> 메일알림</td>
  			<td><input type="checkbox"/> 푸시알림</td>
  		</tr>
  	</table>
  	
	<div class="div-padding div-report-write-btn">
		<input type="submit" value="등록"/>
		<input type="submit" value="취소"/>
	</div>
</form:form>
</section>
  </div>
</div>
<script>
document.querySelectorAll("[name=upFile]").forEach((input) => {
	input.addEventListener('change', (e) => {
		const file = e.target.files[0];
		const label = e.target.nextElementSibling;
		
		if(file)
			label.innerHTML = file.name;
		else 
			label.innerHTML = '파일을 선택하세요';
	});
});


</script>
<script>
$('#summernote').summernote({
	 placeholder: 'Hello stand alone ui',
	 tabsize: 2,
	 height: 350,
	 width: 1000,
	 toolbar: [
			     ['style', ['style']],
				 ['font', ['bold', 'underline', 'clear']],
				 ['color', ['color']],
				 ['para', ['ul', 'ol', 'paragraph']],
			     ['table', ['table']],
			     ['insert', ['link', 'picture', 'video']],
			     ['view', ['fullscreen', 'codeview', 'help']]
		      ]
		    });
</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />

