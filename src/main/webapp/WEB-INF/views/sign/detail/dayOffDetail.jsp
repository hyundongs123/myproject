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
	
	<jsp:include page="/WEB-INF/views/sign/signDetail.jsp">
		<jsp:param value="연차신청서" name="title" />
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
									const nowDate = new Date();
									const newDate = new Date(nowDate.getFullYear(), nowDate.getMonth(), nowDate.getDate() + 2);
									const dateOff = new Date().getTimezoneOffset() * 60000;
									const today = new Date(newDate - dateOff).toISOString().split('T')[0];
								</script>
								
								<br />
								<div class="div-sign-tbl div-sign-tbl-detail">
									<table class="sign-tbl-bottom">
										<tbody>
											<tr>
												<td>긴급&nbsp;문서</td>
												<td>
													<input type="radio" name="emergency" id="_emergencyY" value="Y" ${sign.emergency == 'Y' ? 'checked' : 'disabled'} /><label for="_emergencyY">여</label>
													<input type="radio" name="emergency" id="_emergencyN" value="N" ${sign.emergency == 'N' ? 'checked' : 'disabled'} /><label for="_emergencyN">부</label>
												</td>
											</tr>
											<tr>
												<td>
													휴가&nbsp;종류
												</td>
												<td>
													<select class="vacationType" name="type" id="_vacationType" disabled>
														<option value="D" ${dayOff.type == 'D' ? 'selected' : ''}>연차</option>
														<option value="H" ${dayOff.type == 'H' ? 'selected' : ''}>반차</option>
													</select>
												</td>
											</tr>
											<tr>
												<td>
													기간&nbsp;및&nbsp;일시
												</td>
												<td>
													<span>
														<span>
															<input id="_start-date" name="startDate" class="dayoff-date" type="date" value="${dayOff.startDate}" readonly>
														</span>
														&nbsp;~&nbsp; 
														<span>
															<input id="_end-date" name="endDate" class="dayoff-date" type="date" value="${dayOff.endDate}" readonly>
														</span>
														&nbsp;&nbsp;
														<span>선택일수 : 
															<span id="_usingPointArea">${dayOff.count}</span>
														</span>
													</span>
												</td>
											</tr>
											<tr>
												<td>
													반차&nbsp;여부
												</td>
												<td>
													<span id="vacationHalfArea">
														<input type="radio" name="half" id="_A" value="A" ${dayOff.half == 'A' ? 'checked' : 'disabled'} /><label for="A">오전</label>
														<input type="radio" name="half" id="_P" value="P" ${dayOff.half == 'P' ? 'checked' : 'disabled'} /><label for="P">오후</label>
														<input type="radio" name="half" id="_X" value="X" ${dayOff.half == 'X' ? 'checked' : 'disabled'} /><label for="X">연차</label>
													</span> 
												</td>
											</tr>
											<tr>
												<td>
													연차&nbsp;일수
												</td>
												<td>
													<span id="_restPointArea">
														잔여연차 : <span id="_restPoint">${leaveCount}</span>
													</span>&nbsp;&nbsp;
													<span id="applyPointArea">
														신청연차 : <span id="_applyPoint">${dayOff.count}</span>
														<input type="hidden" name="count" />
													</span> &nbsp;&nbsp;
													<span id="_finalPointArea">
														최종 남은 연차 : <span id="_finalPoint">${leaveCount - dayOff.count}</span>
													</span> 
												</td>
											</tr>
											<tr>
												<td>
													<b style="color: rgb(255, 0, 0);">*</b>&nbsp;휴가&nbsp;사유 
												</td>
												<td>
													<textarea name="content" class="txta_editor" readonly>${dayOff.content}</textarea>
												</td>
											</tr>
											<tr class="sign-tbl-bottom-tr">
												<td colspan="2" class="sign-tbl-bottom-content">
													1. 연차의 사용은 근로기준법에 따라 전년도에 발생한 개인별 잔여 연차에 한하여 사용함을 원칙으로 한다. 단, 최초 입사시에는 근로 기준법에 따라 발생 예정된 연차를 차용하여 월 1회 사용 할 수 있다.<br> 2. 경조사 휴가는 행사일을 증명할 수 있는 가족 관계 증명서 또는 등본, 청첩장 등 제출<br> 3. 공가(예비군/민방위)는 사전에 통지서를, 사후에 참석증을 반드시 제출 
												</td>
											</tr>
										</tbody>
									</table>
								</div>
								
								<div class="div-sign-tbl div-sign-tbl-update">
									<form:form action="${pageContext.request.contextPath}/sign/dayOffUpdate.do" method="post" name="dayOffUpdateFrm">
										<table class="sign-tbl-bottom">
											<tbody>
												<tr>
													<td>긴급&nbsp;문서</td>
													<td>
														<input type="radio" name="emergency" id="emergencyY" value="Y" ${sign.emergency == 'Y' ? 'checked' : ''} /><label for="emergencyY">여</label>
														<input type="radio" name="emergency" id="emergencyN" value="N" ${sign.emergency == 'N' ? 'checked' : ''} /><label for="emergencyN">부</label>
													</td>
												</tr>
												<tr>
													<td>
														휴가&nbsp;종류
													</td>
													<td>
														<select class="vacationType" name="type" id="vacationType">
															<option value="D" ${dayOff.type == 'D' ? 'selected' : ''}>연차</option>
															<option value="H" ${dayOff.type == 'H' ? 'selected' : ''}>반차</option>
														</select>
														<input type="hidden" name="no" value="${dayOff.no}" />
														<input type="hidden" name="signNo" value="${sign.no}" />
													</td>
												</tr>
												<tr>
													<td>
														기간&nbsp;및&nbsp;일시
													</td>
													<td>
														<span>
															<span>
																<input id="start-date" name="startDate" class="dayoff-date" type="date" value="${dayOff.startDate}" onKeyPress="noKey(event);"/>
															</span>
															&nbsp;~&nbsp; 
															<span>
																<input id="end-date" name="endDate" class="dayoff-date" type="date" value="${dayOff.endDate}" onKeyPress="noKey(event);"/>
															</span>
															&nbsp;&nbsp;
															<span>선택일수 : 
																<span id="usingPointArea">${dayOff.count}</span>
															</span>
														</span>
													</td>
												</tr>
												<tr>
													<td>
														반차&nbsp;여부
													</td>
													<td>
														<span id="vacationHalfArea">
															<input type="radio" name="half" id="A" value="A" ${dayOff.half == 'A' ? 'checked' : ''} /><label for="A">오전</label>
															<input type="radio" name="half" id="P" value="P" ${dayOff.half == 'P' ? 'checked' : ''} /><label for="P">오후</label>
															<input type="radio" name="half" id="X" value="X" ${dayOff.half == 'X' ? 'checked' : ''} /><label for="X">연차</label>
														</span> 
													</td>
												</tr>
												<tr>
													<td>
														연차&nbsp;일수
													</td>
													<td>
														<span id="restPointArea">
															잔여연차 : <span id="restPoint">${leaveCount}</span>
														</span>&nbsp;&nbsp;
														<span id="applyPointArea">
															신청연차 : <span id="applyPoint">${dayOff.count}</span>
															<input type="hidden" name="count" />
														</span> &nbsp;&nbsp;
														<span id="finalPointArea">
															최종 남은 연차 : <span id="finalPoint">${leaveCount - dayOff.count}</span>
														</span> 
													</td>
												</tr>
												<tr>
													<td>
														<b style="color: rgb(255, 0, 0);">*</b>&nbsp;휴가&nbsp;사유 
													</td>
													<td>
														<textarea name="content" class="txta_editor">${dayOff.content}</textarea>
													</td>
												</tr>
												<tr class="sign-tbl-bottom-tr">
													<td colspan="2" class="sign-tbl-bottom-content">
														1. 연차의 사용은 근로기준법에 따라 전년도에 발생한 개인별 잔여 연차에 한하여 사용함을 원칙으로 한다. 단, 최초 입사시에는 근로 기준법에 따라 발생 예정된 연차를 차용하여 월 1회 사용 할 수 있다.<br> 2. 경조사 휴가는 행사일을 증명할 수 있는 가족 관계 증명서 또는 등본, 청첩장 등 제출<br> 3. 공가(예비군/민방위)는 사전에 통지서를, 사후에 참석증을 반드시 제출 
													</td>
												</tr>
											</tbody>
										</table>
										
										<script>
											/* 확정 또는 예정된 연차, 반차, 출장 날짜 목록 */
											const noDateList = [];
											<c:forEach items="${noDateList}" var="noDate">
												noDateList.push({
													regDate: "${noDate.reg_date}",
													state: "${noDate.state}"
												});
											</c:forEach>
											
											<c:forEach items="${toBeNoDateList}" var="toBeNoDate">
												noDateList.push({
													regDate: "${toBeNoDate.reg_date}",
													state: "${toBeNoDate.state}"
												});
											</c:forEach>
											console.log(noDateList);
											
											noDateList.sort((a, b) => {
												if (a.regDate > b.regDate) return 1;
												if (a.regDate < b.regDate) return -1;
												return 0;
											});
											
											
											/* 날짜 키보드 입력 막기 */
											const noKey = (event) => {
												event.preventDefault();
												return false;
											};
											
											let start;
											let end;
											let type = vacationType.value;
											let diff = 1;
											
											const halfType = document.querySelector('#vacationType');
											const startDate = document.querySelector('#start-date');
											const endDate = document.querySelector('#end-date');
											const usingPointArea = document.querySelector('#usingPointArea');
											const finalDayOff = document.querySelector('#finalPoint');
											const base = document.querySelector('#restPoint').innerText;
											
											const diffDay = (start, end) => {
												diff = end - start;
												return diff / (1000 * 60 * 60 * 24) + 1;
											};
											
											const inner = (tag, val) => {
												return tag.innerText = val;
											};
											
											
											startDate.addEventListener('change', (e) => {
												endDate.min = startDate.value;
												console.log(type);
												if (type == 'D') {
													end = new Date(endDate.value).getTime();
													start = new Date(startDate.value).getTime();
													
													if (end < start) {
														endDate.value = startDate.value;
														end = new Date(endDate.value).getTime();
													}
													inner(usingPointArea, diffDay(start, end));
													inner(applyPoint, diffDay(start, end));
													inner(finalDayOff, base - diffDay(start, end));
												} else {
													endDate.value = startDate.value;
													inner(usingPointArea, 0.5);
													inner(applyPoint, 0.5);
													inner(finalDayOff, base - 0.5);
												}
											});
											
											endDate.addEventListener('change', (e) => {
												end = new Date(endDate.value).getTime();
												start = new Date(startDate.value).getTime();

												inner(usingPointArea, diffDay(start, end));
												inner(applyPoint, diffDay(start, end));
												inner(finalDayOff, base - diffDay(start, end));
											});
											
											halfType.addEventListener('change', (e) => {
												console.log(e.target);
												type = e.target.value;
												console.log(halfType);
												
												switch (type) {
												case 'H':
													endDate.value = startDate.value;
													endDate.readOnly = 'readOnly';
													A.disabled = '';
													P.disabled = '';
													X.disabled = 'disabled';
													A.checked = 'checked';
													inner(usingPointArea, 0.5);
													inner(applyPoint, 0.5);
													inner(finalDayOff, base - 0.5);
													break;
												case 'D':
													endDate.readOnly = '';
													end = new Date(endDate.value).getTime();
													start = new Date(startDate.value).getTime();

													A.disabled = 'disabled';
													P.disabled = 'disabled';
													X.disabled = '';
													X.checked = 'checked';
													
													inner(usingPointArea, diffDay(start, end));
													inner(applyPoint, diffDay(start, end));
													inner(finalDayOff, base - diffDay(start, end));
													break;
												}
											});
										</script>
									</form:form>
								</div>
								
							</div>
						</div>
						<!-- 결재 문서 end -->
						<script>
							const detailBtn = document.querySelector('.div-sign-btn-detail');
							const detailDiv = document.querySelector('.div-sign-tbl-detail');
							const updateBtn = document.querySelector('.div-sign-btn-update');
							const updateDiv = document.querySelector('.div-sign-tbl-update');
							
							/* 문서 수정 버튼 클릭 */
							const signUpdateFrm = () => {
								detailBtn.style.display = 'none';
								detailDiv.style.display = 'none';
								updateBtn.style.display = 'inline-block';
								updateDiv.style.display = 'inline-block';
							}; // signUpdateFrm end
							
							
							/* 연차신청서 수정 폼 제출 */
							const signUpdateOk = () => {
								const frm = document.dayOffUpdateFrm;
								const content = frm.content;
								const type = frm.type;
								const half = frm.half;
								console.log(frm.startDate.value);
								console.log(frm.endDate.value);
								console.log(vacationType.value);
								console.log(half.value);
								
								frm.count.value = applyPoint.innerText;
								
								if (/^\s+$/.test(content.value) || !content.value) {
									alert('휴가 사유를 작성해주세요.');
									content.select();
									return false;
								}
								
								if (type.value == 'H' && half.value == 'X') {
									alert('반차 여부를 오전 또는 오후로 선택해주세요.');
									return false;
								}
								
								if (type.value == 'D' && half.value != 'X') {
									alert('반차 여부를 연차로 선택해주세요.');
									return false;
								}
								
								let dateList = [];
								let text = '현재 선택된 기간에는 다른 일정이 있는 날짜가 존재합니다.\n';
								for (let i = 0; i < noDateList.length; i++) {
									let noDate = noDateList[i];
									
									let no = new Date(noDate.regDate);
									if (new Date(startDate.value) <= no && new Date(endDate.value) >= no) {
										dateList.push(noDate);
									}
									
									if (i === noDateList.length - 1) {
										if (dateList.length > 0) {
											dateList.forEach((date) => {
												text += date.regDate + ' (' + date.state + ')\n';
											});
											alert(text);
											return false;
										} // 신청하면 안되는 날짜가 존재하는 경우
									} // noDateList의 마지막 인덱스인 경우
								};
								
								frm.submit();
							};
							
							
							/* 결재, 반려, 보류 */
							const signStatusUpdate = (status) => {
								const modal = signStatusUpdateModal;
								const h5 = modal.querySelector('h5');
								const btn = modal.querySelector('.btn-status');
								const frmStatus = document.signStatusUpdateFrm.status;
								
								switch (status) {
								case 'C' :
									h5.innerText = '결재하기';
									btn.innerText = '결재';
									break;
								case 'R' :
									h5.innerText = '반려하기';
									btn.innerText = '반려';
									break;
								case 'H' :
									h5.innerText = '보류하기';
									btn.innerText = '보류';
									break;
								} // switch end
								
								frmStatus.value = status;
							};
							
							
							/* 결재, 반려, 보류 폼 제출 */
							document.signStatusUpdateFrm.addEventListener('submit', (e) => {
								e.preventDefault();
								console.log(e.target);
								
								const status = e.target.status;
								const reason = e.target.reason;
								
								if (status.value == 'R' || status.value == 'H') {
									if (/^\s+$/.test(reason.value) || !reason.value) {
										alert('결재 의견을 작성해주세요.');
										reason.select();
										return false;
									}
								}
								
								e.target.submit();
							});
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