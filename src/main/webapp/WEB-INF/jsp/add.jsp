<%@ page contentType="text/html; charset=utf-8" import="ru.org.linux.gallery.Screenshot"  %>
<%@ page import="ru.org.linux.group.Group"%>
<%@ page import="ru.org.linux.topic.TopicTagService"%>
<%@ page import="ru.org.linux.util.StringUtil" %>
<%--
  ~ Copyright 1998-2012 Linux.org.ru
  ~    Licensed under the Apache License, Version 2.0 (the "License");
  ~    you may not use this file except in compliance with the License.
  ~    You may obtain a copy of the License at
  ~
  ~        http://www.apache.org/licenses/LICENSE-2.0
  ~
  ~    Unless required by applicable law or agreed to in writing, software
  ~    distributed under the License is distributed on an "AS IS" BASIS,
  ~    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  ~    See the License for the specific language governing permissions and
  ~    limitations under the License.
  --%>
<%--@elvariable id="message" type="ru.org.linux.topic.PreparedTopic"--%>
<%--@elvariable id="group" type="ru.org.linux.group.Group"--%>
<%--@elvariable id="template" type="ru.org.linux.site.Template"--%>
<%--@elvariable id="modes" type="java.util.Map"--%>
<%--@elvariable id="addportal" type="java.lang.String"--%>
<%--@elvariable id="form" type="ru.org.linux.topic.AddTopicRequest"--%>
<%--@elvariable id="postscoreInfo" type="java.lang.String"--%>
<%--@elvariable id="useTags" type="java.lang.Boolean"--%>
<jsp:include page="/WEB-INF/jsp/head.jsp"/>
<%@ taglib tagdir="/WEB-INF/tags" prefix="lor" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<%
    Group group = (Group) request.getAttribute("group");
%>

<title>Добавить сообщение</title>
<script src="/js/jqueryui/jquery-ui-1.8.18.custom.min.js" type="text/javascript"></script>
<script src="/js/tagsAutocomplete.js" type="text/javascript"></script>
<script type="text/javascript">
  document.tagInputCssString = "#tags";
  $(document).ready(function() {
    $("#messageForm").validate({
      messages : {
        title : "Введите заголовок"
      }
    });
  });
</script>
<link rel="stylesheet" href="/js/jqueryui/jquery-ui-1.8.18.custom.css">
  <jsp:include page="/WEB-INF/jsp/header.jsp"/>
  <c:if test="${not form.noinfo}">
      ${addportal}
  </c:if>
<c:if test="${message != null}">
<h1>Предпросмотр</h1>
<div class=messages>
  <lor:message messageMenu="<%= null %>" preparedMessage="${message}" message="${message.message}" showMenu="false"/>
</div>
</c:if>
<h1>Добавить</h1>
<%--<% if (tmpl.getProf().getBoolean("showinfo") && !Template.isSessionAuthorized(session)) { %>--%>
<%--<font size=2>Чтобы просто поместить сообщение, используйте login `anonymous',--%>
<%--без пароля. Если вы собираетесь активно участвовать в форуме,--%>
<%--помещать новости на главную страницу,--%>
<%--<a href="register.jsp">зарегистрируйтесь</a></font>.--%>
<%--<p>--%>
<%--<% } %>--%>

<% if (group!=null && group.isImagePostAllowed()) { %>
<p>
  Технические требования к изображению:
  <ul>
    <li>Ширина x Высота:
      от <%= Screenshot.MIN_SCREENSHOT_SIZE %>x<%= Screenshot.MIN_SCREENSHOT_SIZE %>
      до <%= Screenshot.MAX_SCREENSHOT_SIZE %>x<%= Screenshot.MAX_SCREENSHOT_SIZE %> пикселей</li>
    <li>Тип: jpeg, gif, png</li>
    <li>Размер не более <%= (Screenshot.MAX_SCREENSHOT_FILESIZE / 1024) - 50 %> Kb</li>
  </ul>
</p>
<%   } %>

<form:form modelAttribute="form" id="messageForm" method="POST" action="add.jsp" enctype="${group.imagePostAllowed?'multipart/form-data':'application/x-www-form-urlencoded'}" >
  <form:errors path="*" element="div" cssClass="error"/>

  <input type="hidden" name="session" value="<%= StringUtil.escapeHtml(session.getId()) %>">
  <form:hidden path="noinfo"/>

  ${postscoreInfo}<br>

  <c:if test="${not template.sessionAuthorized}">
    <label>
        Имя:<br> <input type=text class="required" value="anonymous" name="nick" style="width: 40em">
    </label><br>
    <label>
        Пароль:<br> <input type=password name=password style="width: 40em">
    </label><br>
  </c:if>

  <form:hidden path="group"/>
  <p>

  <c:if test="${not group.moderated && useTags}">
    <label>
      Метки (разделенные запятой, не более <%= TopicTagService.MAX_TAGS_PER_TOPIC %>; в заголовке будет показано не более <%= TopicTagService.MAX_TAGS_IN_TITLE %>):<br>
      <form:input id="tags" path="tags" style="width: 40em"/>
    </label><br>
  </c:if>


  <label>Заглавие:<br>
    <form:input path="title" cssClass="required" style="width: 40em"/><br>
   </label>

  <c:if test="${group!=null and group.imagePostAllowed}">
    <label>Изображение: <input type="file" name="image"></label><br>
  </c:if>

  <c:if test="${group!=null and group.pollPostAllowed}">
      Внимание! Вопрос должен быть задан в поле «заглавие». В поле «сообщение» можно написать
      дополнительное описание опроса, которое будет видно только на странице опроса (и не будет
      видно в форме голосования на главной странице)<br>

      <c:forEach var="v" items="${form.poll}" varStatus="i">
            <label>Вариант #${i.index}:
                <form:input path="poll[${i.index}]" size="40"/></label><br>
      </c:forEach>
      <p>
        <label>Мультивыбор: <form:checkbox path="multiSelect" size="40"/></label>
      </p>
  </c:if>
<label>Разметка:*<br>
<form:select path="mode" items="${modes}"/></label><br>

<label for="form_msg">Сообщение:</label><br>
<form:textarea path="msg" style="width: 40em" rows="20" id="form_msg"/><br>
<font size="2"><b>Внимание:</b> <a href="/wiki/en/Lorcode" target="_blank">прочитайте описание разметки LORCODE</a></font><br>


<% if (group!=null && group.isLinksAllowed()) { %>
<label>
Текст ссылки:<br> <form:input path="linktext" style="width: 40em"/>
</label><br>
<label>
Ссылка (не забудьте <b>http://</b>):<br> <form:input path="url" type="url" style="width: 40em"/>
</label><br>
<% } %>
<c:if test="${group.moderated && useTags}">
    <label>
    Метки (разделенные запятой, не более <%= TopicTagService.MAX_TAGS_PER_TOPIC %>):<br>
    <form:input id="tags" path="tags" style="width: 40em"/>
    </label><p>
    Популярные теги:
     <c:forEach items="${topTags}" var="topTag" varStatus = "status">
${status.first ? '' : ', '}<a onclick="addTag('${topTag}');">${topTag}</a>
     </c:forEach>
</c:if>

  <lor:captcha ipBlockInfo="${ipBlockInfo}"/>
<br>
<input type=submit value="Поместить">
<input type=submit name=preview value="Предпросмотр">
</form:form>
<jsp:include page="/WEB-INF/jsp/footer.jsp"/>
