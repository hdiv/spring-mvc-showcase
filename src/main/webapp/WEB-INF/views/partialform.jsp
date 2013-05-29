<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<c:if test="${!ajaxRequest}">
<html>
<head>
	<title>forms | mvc-showcase</title>
	<link href="<c:url value="/resources/form.css" />" rel="stylesheet"  type="text/css" />		
	<script type="text/javascript" src="<c:url value="/resources/jquery/1.6/jquery.js" />"></script>
</head>
<body>
</c:if>
	<div id="partialFormsContent">
		<h2>Partial Form Update</h2>
		<p>
			See the <code>org.springframework.samples.mvc.partialform</code> package for the @Controller code.	
		</p>
		<p>
			Select 'Suggestion' as the Inquiry type to add a new form field programmatically.
			The new field values are added to HDIV state on the server, in the method <code>PartialFormController.getSuggestTypes()</code>.
		</p>
		<form:form id="partialform" method="post" modelAttribute="partialFormBean" cssClass="cleanform">
			<div class="header">
		  		<h2>Form</h2>
		  		<c:if test="${not empty message}">
					<div id="message" class="success">${message}</div>	
		  		</c:if>
		  		<s:bind path="*">
		  			<c:if test="${status.error}">
				  		<div id="message" class="error">Form has errors</div>
		  			</c:if>
		  		</s:bind>
			</div>
		  	<fieldset>
		  		<legend>Personal Info</legend>
		  		<form:label path="name">
		  			Name <form:errors path="name" cssClass="error" />
		 		</form:label>
		  		<form:input path="name" />
	
		  		<form:label path="age">
		  			Age <form:errors path="age" cssClass="error" />
		 		</form:label>
		  		<form:input path="age" />
		  		
		  		<form:label path="birthDate">
		  			Birth Date (in form yyyy-mm-dd) <form:errors path="birthDate" cssClass="error" />
		 		</form:label>
		  		<form:input path="birthDate" />
		  		 
		  		<form:label path="phone">
		  			Phone (in form (###) ###-####) <form:errors path="phone" cssClass="error" />
		  		</form:label>
		  		<form:input path="phone" />
	
		  		<form:label path="currency">
		  			Currency (in form $#.##) <form:errors path="currency" cssClass="error" />
		  		</form:label>
		  		<form:input path="currency" />
	
		  		<form:label path="percent">
		  			Percentage (in form ##%) <form:errors path="percent" cssClass="error" />
		  		</form:label>
		  		<form:input path="percent" />
	
		  	</fieldset>
	
			<fieldset>
				<legend>Inquiry</legend>
				<form:label path="inquiry">
					Type (select one)
				</form:label>
				<form:select path="inquiry">
					<form:option value="comment">Comment</form:option>
					<form:option value="feedback">Feedback</form:option>
					<form:option value="suggestion">Suggestion</form:option>
				</form:select>
				
		  		<form:label path="inquiryDetails">
		  			Details
		  		</form:label>
		  		<form:textarea path="inquiryDetails" />
		  	</fieldset>
	
			<fieldset class="checkbox">
				<legend>Request Additional Info</legend>
				<label><form:checkbox path="additionalInfo[mvc]" value="true" />on Spring MVC</label>
				<label><form:checkbox path="additionalInfo[java]" value="true" />on Java (4-ever)</label>				
			</fieldset>
		  		  	
			<fieldset class="radio">
				<legend>Subscribe to Newsletter?</legend>
				<label><form:radiobutton path="subscribeNewsletter" value="true" />Yes</label>
				<label><form:radiobutton path="subscribeNewsletter" value="false" /> No</label>
			</fieldset>
	
			<p><button type="submit">Submit</button></p>
		</form:form>
		
		<!-- 'hdivFormStateId' is a request scoped attribute with the state id of last form.
				It is automatically created by 'form:form' tag. -->
		<c:url var="suggestTypeUrl" value="/partialform/suggestTypes.json">
			<c:param name="_MODIFY_HDIV_STATE_" value="${hdivFormStateId}" />
			
			<!-- If 'randomName' is activated, use 'modifyHDIVStateParameter' attribute value as param name instead of '_MODIFY_HDIV_STATE_' literal
			<c:param name="${modifyHDIVStateParameter}" value="${hdivFormStateId}" />
			-->
		</c:url>
		
		<script type="text/javascript">
			$(document).ready(function() {
				$("#partialform").submit(function() {
					$.post($(this).attr("action"), $(this).serialize(), function(html) {
						$("#partialFormsContent").replaceWith(html);
						$('html, body').animate({ scrollTop: $("#partialform #message").offset().top }, 500);
					});
					return false;  
				});
				$("select#inquiry").change(function(e) {
					//Remove label and suggestion type select
					$("#suggestTypeLabel").remove();
					$("#suggestType").remove();

					//Get user selection 
					var selection = $(this).find("option:selected").text();
					if("Suggestion" === selection){
						//If selection is suggestion, get types from server
						var select = $(this);
						var url = "${suggestTypeUrl}";
						$.getJSON(url, function(data) {
							//Create new label and select with suggestion types
							var newSelect = $("<select>").attr("id", "suggestType").attr("name", "suggestType");
							$.each(data, function(key, val) {
								newSelect.append("<option value='"+val+"'>"+key+"</option>");
							});
							//Add to DOM
							select.after(newSelect);
							select.after("<label id='suggestTypeLabel' for='suggestType'>Suggestion Type</label>");
						});
					}
					return false;  
				});
			});
		</script>
	</div>
<c:if test="${!ajaxRequest}">
</body>
</html>
</c:if>