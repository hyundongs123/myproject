<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

	<jsp:include page="/WEB-INF/views/common/header.jsp">
		<jsp:param value="Sign" name="title"/>
	</jsp:include>
	
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/form.css">
	
	<jsp:include page="/WEB-INF/views/sign/signLeftBar.jsp" />
	
	<jsp:include page="/WEB-INF/views/sign/signUpdate.jsp">
		<jsp:param value="사직서" name="title" />
	</jsp:include>
								
											</td>
											<td class="sign-tbl-right">
												<div class="sign-div-right">
													<table class="sign-right-tbl">
														<tbody>
															<tr>
																<th>신청</th>
																<td class="sign-right-tbl-border">
																	<table class="sign-right-tbl-line">
																		<tbody>
																			<tr>
																				<td>
																					<span class="sign_rank">${sign.jobTitle}</span>
																				</td>
																			</tr>
																			<tr>
																				<td>
																					<span class="sign_name">${sign.name}</span>
																				</td>
																			</tr>
																			<tr>
																				<td>
																					<span class="sign_date">
																						<fmt:parseDate value="${sign.regDate}" var="now" pattern="yyyy-MM-dd" />
																						<fmt:formatDate value="${now}" pattern="yyyy-MM-dd" />
																					</span>
																				</td>
																			</tr>
																		</tbody>
																	</table>
																</td>
															</tr>
														</tbody>
													</table>
												</div>
							
												<div class="sign-div-right sign-div-tbl">
													<table class="sign-right-tbl">
														<tbody>
															<tr>
																<th>승인</th>
																<c:forEach items="${sign.signStatusList}" var="signStatus">
																	<td class="sign-right-tbl-border">
																		<table class="sign-right-tbl-line">
																			<tbody>
																				<tr>
																					<td>
																						<span class="sign_rank">${signStatus.jobTitle}</span>
																					</td>
																				</tr>
																				<tr>
																					<td>
																						<c:if test="${signStatus.status == 'C'}">
																							<img src="${pageContext.request.contextPath}/resources/images/ok.png" class="ok-sign" />
																							<br />
																							<span class="sign_name">${signStatus.name}</span>
																						</c:if>
																						<c:if test="${signStatus.status != 'C'}">
																							<span class="sign_wrap">${signStatus.name}</span>
																						</c:if>
																					</td>
																				</tr>
																				<tr>
																					<td>
																						<span class="sign_date">
																							<c:if test="${!empty signStatus.regDate}">
																								<fmt:parseDate value="${signStatus.regDate}" var="regDate" pattern="yyyy-MM-dd" />
																								<fmt:formatDate value="${regDate}" pattern="yyyy-MM-dd" />
																							</c:if>
																							<c:if test="${empty signStatus.regDate}">
																								&nbsp;
																							</c:if>
																						</span>
																					</td>
																				</tr>
																			</tbody>
																		</table>
																	</td>
																</c:forEach>
															</tr>
														</tbody>
													</table>
												</div>
											</td>
										</tr>
									</tbody>
								</table>
								<script>
									const nowDate = Date.now();
									const dateOff = new Date().getTimezoneOffset() * 60000;
									const today = new Date(nowDate - dateOff).toISOString().split('T')[0];
								</script>
								
								<br />
								<form:form action="${pageContext.request.contextPath}/sign/resignationUpdate.do" method="post" name="resignationUpdateFrm">
									<div class="div-sign-tbl">
										<table class="sign-tbl-bottom">
											<tbody>
												<tr class="sign-tbl-bottom-tr">
													<th>긴급 문서</th>
													<td colspan="3">
														<input type="radio" name="emergency" id="emergencyY" value="Y" ${sign.emergency == 'Y' ? 'checked' : ''} /><label for="emergencyY">여</label>
														<input type="radio" name="emergency" id="emergencyN" value="N" ${sign.emergency == 'N' ? 'checked' : ''} /><label for="emergencyN">부</label>
													</td>
												</tr>
												<tr class="sign-tbl-bottom-tr">
													<th>입사일</th>
													<td><input type="date" name="start-date" id="start-date" value="${sessionScope.loginMember.hireDate}" /></td>
													<th>퇴사일</th>
													<td>
														<input type="date" name="end-date" id="endDate" value="${resignation.endDate}" />
													</td>
												</tr>
												<tr class="sign-tbl-bottom-tr">
													<th>직급</th>
													<th>사번</th>
													<th>성명</th>
													<th>근무부서</th>
												</tr>
												<tr class="sign-tbl-bottom-tr">
													<td>${sign.jobTitle}</td>
													<td>${sign.empId}</td>
													<td>${sign.name}</td>
													<td>${sign.deptTitle}</td>
												</tr>
												<tr>
													<th colspan="4">퇴직 사유</th>
												</tr>
												<tr class="sign-tbl-bottom-tr">
													<td colspan="4">
														<textarea rows="10" id="reason" name="reason" >${resignation.reason}</textarea>
													</td>
												</tr>
											</tbody>
										</table>
									</div>
								</form:form>
							</div>
						</div>
						<!-- 결재 문서 end -->
						<script>
							
						</script>
						
						
						<div class="div-sign-bottom">
							<div class="div-sign-bottom-title">
								<div class="font-large">결재선</div>
							</div>
							<div class="div-sign-bottom-content">
								<!-- 기안자 -->
								<div class="div-sign-bottom-tbl">
									<table class="div-sign-bottom-content-tbl">
										<colgroup>
                                               <col width="5%" />
                                               <col width="95%" />
                                           </colgroup>
										<thead>
											<tr>
												<td rowspan="4" class="td-img">
													<c:if test="${empty sign.profileImg}">
														<img src="${pageContext.request.contextPath}/resources/images/default.png" class="my-img" />
													</c:if>
													<c:if test="${!empty sign.profileImg}">
														<img src="${pageContext.request.contextPath}/resources/upload/emp/${sign.profileImg}" class="my-img" />
													</c:if>
												</td>
												<th>${sign.name} ${sign.jobTitle}</th>
											</tr>
											<tr>
												<td>${sign.deptTitle}</td>
											</tr>
											<tr>
												<td>
													기안 상신 |&nbsp;
													<fmt:parseDate value="${sign.regDate}" var="regDate" pattern="yyyy-MM-dd" />
													<fmt:formatDate value="${regDate}" pattern="yyyy-MM-dd(E)" />
												</td>
											</tr>
										</thead>
									</table>
								</div>
								
								<!-- 결재자 -->
								<c:forEach items="${sign.signStatusList}" var="signStatus">
									<div class="div-sign-bottom-tbl ${(signStatus.status == 'W' || signStatus.status == 'H' || signStatus.status == 'R') ? 'signStatusHere' : ''}">
										<table class="div-sign-bottom-content-tbl">
											<colgroup>
                                                <col width="5%" />
                                                <col width="95%" />
                                            </colgroup>
											<thead>
												<tr>
													<td rowspan="4" class="td-img">
														<c:if test="${empty signStatus.profileImg}">
															<img src="${pageContext.request.contextPath}/resources/images/default.png" class="my-img" />
														</c:if>
														<c:if test="${!empty signStatus.profileImg}">
															<img src="${pageContext.request.contextPath}/resources/upload/emp/${signStatus.profileImg}" class="my-img" />
														</c:if>
													</td>
													<th>${signStatus.name} ${signStatus.jobTitle}</th>
												</tr>
												<tr>
													<td>${signStatus.deptTitle}</td>
												</tr>
												<tr>
													<td>
														<c:choose>
															<c:when test="${signStatus.status == 'W'}">
																결재 대기
															</c:when>
															<c:when test="${signStatus.status == 'S'}">
																결재 예정
															</c:when>
															<c:when test="${signStatus.status == 'C'}">
																결재 승인
															</c:when>
															<c:when test="${signStatus.status == 'H'}">
																결재 보류
															</c:when>
															<c:when test="${signStatus.status == 'R'}">
																결재 반려
															</c:when>
														</c:choose>
														<c:if test="${!empty signStatus.regDate}">
															&nbsp;|&nbsp;
															<fmt:parseDate value="${signStatus.regDate}" var="regDate" pattern="yyyy-MM-dd" />
															<fmt:formatDate value="${regDate}" pattern="yyyy-MM-dd(E)" />
														</c:if>
													</td>
												</tr>
												<c:if test="${!empty signStatus.reason}">
													<tr class="tr-reason">
														<td>${signStatus.reason}</td>
													</tr>
												</c:if>
											</thead>
										</table>
									</div>
								</c:forEach>
							</div>
						</div>
					</div>
				</div>
				
	<jsp:include page="/WEB-INF/views/common/footer.jsp"/>