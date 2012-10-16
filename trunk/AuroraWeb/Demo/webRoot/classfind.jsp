<%@ page import="java.net.*,java.io.*,java.util.*" %>  
<%@ page session="false"%>
<%
String cls = request.getParameter("class");
if(cls == null) cls="org.lwap.controller.MainService";
String vl = cls.replace('.','/');
vl += ".class";
ClassLoader loader = this.getClass().getClassLoader() ;
out.println("using classloader "+loader.getClass().getName());
URL file = loader.getResource(vl);
if( file == null) out.println("can't find "+cls);
else out.println(cls + " is from " + file.getFile());
%>