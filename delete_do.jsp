<%@ page contentType="text/html;charset=utf-8" import="java.sql.*" %>
<%
    request.setCharacterEncoding("utf-8");
    String id = request.getParameter("del");
try{
    Class.forName("com.mysql.jdbc.Driver");
    String url = "jdbc:mysql://Study_DB_IP:3306/test";
    Connection con = DriverManager.getConnection(url,"test","1234");
    Statement stat = con.createStatement();
    String query = "DELETE FROM test where id='" + request.getParameter("del")+"'";
//쿼리문 전송

    stat.executeUpdate(query); //return 1.
    stat.close();
    con.close();
    response.sendRedirect("output.jsp") ;
}
    catch(Exception e){
    out.println( e );
}
%>