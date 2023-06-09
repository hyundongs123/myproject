 	<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>${param.pageTitle}</title>
		<script src="https://code.jquery.com/jquery-3.6.0.js" integrity="sha256-H+K7U5CnXl1h5ywQfKtSj8PCmoN9aaq30gDh27Xc0jk=" crossorigin="anonymous"></script>
		<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css" integrity="sha384-9gVQ4dYFwwWSjIDZnLEWnxCjeSWFphJiwGPXr1jddIhOegiu1FwO5qRGvFXOdJZ4" crossorigin="anonymous">
		<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js" integrity="sha384-uefMccjFJAIv6A+rW+L4AHf99KvxDjWSu1z9VI8SKNVmz4sk7buKt/6v9KI65qnm" crossorigin="anonymous"></script>
		<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/chat/chatRoom.css" />
	</head>
	<body>
		<div id="msg-container" style="height: 90vh; overflow-y: auto;">
			<ul class="list-group list-group-flush">
				<c:forEach items="${chatLogs}" var="chatLog">
					<jsp:useBean id="date" class="java.util.Date" />
					<jsp:setProperty name="date" property="time" value="${chatLog.time}" />
					
					<c:if test ="${chatLog.empId ne loginMember.empId }">
						<li class="list-group-item" title="<fmt:formatDate value='${date}' type='both' />">
						<img src="${pageContext.request.contextPath }/resources/upload/emp/${chatLog.emp.attachment.renameFilename }" alt=""  class="img"/>
						<p class="name"> ${chatLog.emp.name} </p>
						<p>
							<span class="msg">${chatLog.msg}</span>
							<span class="time"><fmt:formatDate value='${date}' type='both' /></span>
						</p>
						</li>
					
					</c:if>
					<c:if test ="${chatLog.empId eq loginMember.empId }">
						<li class="list-group-item myli" title="<fmt:formatDate value='${date}' type='both' />">
						<p class="name1"></p>
						<p>
							<span class="time"><fmt:formatDate value='${date}' type='both' /></span>
							<span class="msg2 msg3">${chatLog.msg}</span>
						</p>
						</li>
					
					</c:if>
					

						
				</c:forEach>
			</ul>
		</div>

		
		<div class="input-group mb-3">
		  <input type="text" id="msg" class="form-control" placeholder="Message">
		  <div class="input-group-append" style="padding: 0px;">
		    <button id="sendBtn" class="btn btn-outline-secondary" type="button">Send</button>
		  </div>
		</div>
		
		<input type="hidden" value="${emp.name }" id="empName" />
		<input type="hidden" value="${emp.jobTitle }" id="empJobTitle"/>
			<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js" integrity="sha512-1QvjE7BtotQjkq8PxLeF6P46gEpBRXuskzIVgjFpekzFVF4yjRgrQvTG1MTOJ3yQgvTteKAcO7DSZI92+u/yZw==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
			<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js" integrity="sha512-iKDtgDyTHjAitUDdLljGhenhPwrbBfqTKWO1mkhSFH3A7blITC9MhYon6SjnMhp4o0rADGw9yAC6EW4t5a4K3g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
			<script>
			
		
				document.querySelector('#sendBtn').addEventListener('click', (e) => {
					const msg = document.querySelector('#msg');
					if (!msg.value) return;
					
					const empName = document.querySelector("#empName");
					console.log(empName.value);
					const payload = {
						chatroomId,
						empId : '<sec:authentication property="principal.username" />',
						msg : msg.value,
						time : Date.now(),
						type : 'CHAT',
						empName : empName.value
					};
					
					stompClient.send(`/app/chat/${param.chatroomId}`, {}, JSON.stringify(payload));
					
					msg.value = '';
					msg.focus(); 
				});
				window.addEventListener('focus',()=>{
					lastCheck();
				})
				const chatroomId = '${param.chatroomId}';
				
				const lastCheck=()=>{
					let payload={
							chatroomId : '${param.chatroomId}',
							empId : '<sec:authentication property="principal.username" />',
							time : Date.now(),
							type : "LAST_CHECK"
					};
					
					stompClient.send("/app/chat/lastCheck",{},JSON.stringify(payload));
					
				} 
					
				
				const ws = new SockJS(`http://\${location.host}${pageContext.request.contextPath}/stomp`);
				const stompClient = Stomp.over(ws);
				stompClient.connect({}, (frame) => {
					
					lastCheck();
					
					stompClient.subscribe(`/app/chat/${param.chatroomId}`, (message) => {
						console.log(`/app/chat/${param.chatroomId} : `, message);
						
						const {'content-type' : contentType} = message.headers; // applicaion/json
						const {empId, msg, time, type ,emp} = JSON.parse(message.body);
						console.log(empId);
						const myId = '<sec:authentication property="principal.username" />';
						if (contentType) {
							const ul = document.querySelector('#msg-container ul');
							const currentTime = new Date().toLocaleTimeString();
	
							//내메세지 출력
							if(empId == myId){
								ul.innerHTML += `
									<li class="list-group-item myli" id="dialog" title="\${currentTime}">
									<p>
										<span class="time"><fmt:formatDate value='${today}' type='both' /></span>
										<span class="msg2 msg3">\${msg}</span>
									</p>
										</li>
									`;
							}else{
								$.ajax({
									url:"${pageContext.request.contextPath}/chat/selectEmpByEmpId.do",
									data: {
										empId : empId
									},
									success(data){
										console.log(data);
										const attach = data.attachment;
										const fileName = attach.renameFilename;
										const name = data.name;
										
										//상대방 메시지 출력
										ul.innerHTML += `
											<li class="list-group-item" id="dialog2" title="\${currentTime}">
											<img src="${pageContext.request.contextPath }/resources/upload/emp/\${fileName}" alt=""  class="img"/>
											<p class="name"> \${name} </p>
											<p>
												<span class="msg2">\${msg}</span>
												<span class="time"><fmt:formatDate value='${today}' type='both' /></span>
											</p>
												</li>
											`;
										
										
										
									},
									error: console.log
								});// ajax 끝
							} // if끝
							
							
						}
						
	
						
						// 메세지창 끌어 올리기 (스크롤 처리)
                        const container = document.querySelector('#msg-container');
                        container.scrollTop = container.scrollHeight;
						
					});
				});

			</script>
	
	</body>
</html>