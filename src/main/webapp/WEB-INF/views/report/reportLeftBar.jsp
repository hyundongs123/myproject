<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

                <div class="all-container app-dashboard-body-content off-canvas-content" data-off-canvas-content>
					<!-- 왼쪽 추가 메뉴 -->
					<div class="left-container">
						<div class="container-title"><a href="${pageContext.request.contextPath}/report/report.do" class="container-a">보 고</a></div>
						<div class="container-btn">
							<button onclick="location.href='${pageContext.request.contextPath}/report/reportCreateView.do';">새로 만들기</button>
						</div>
						<div class="accordion-box">
							<ul class="container-list">
								<li>
									<p class="title font-medium" onclick='location.href="${pageContext.request.contextPath}/report/reportDeptView.do?code=${sessionScope.loginMember.deptCode}";'>부서 보고서</p>
								</li>
								<li>
									<p class="title font-medium" onclick="location.href='${pageContext.request.contextPath}/report/reportListView.do?type=else';">그 외 보고서</p>
								</li>
								<li>
									<p class="title font-medium" onclick="location.href='${pageContext.request.contextPath}/report/reportListView.do?type=refer';">참조 보고서</p>
								</li>
								<li>
									<p class="title font-medium" onclick="location.href='${pageContext.request.contextPath}/report/reportListView.do?type=my';">내가 생성한 보고서</p>
								</li>
							</ul>
						</div>
					</div>
					<!-- 왼쪽 추가 메뉴 end -->
					
					