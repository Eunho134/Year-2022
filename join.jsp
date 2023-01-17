<%@ page contentType="text/html;charset=utf-8" import="java.sql.*" %>
<%
    request.setCharacterEncoding("utf-8"); //Set encoding
    String id = request.getParameter("id");
    String name = request.getParameter("name");
    String pwd = request.getParameter("pwd");
    String email = request.getParameter("email");
//POST로 Input.html로부터 입력받은 내용을 변수화
try{
    Class.forName("com.mysql.jdbc.Driver");
    String url = "jdbc:mysql://DB_IP:3306/test";                                    # DB_IP 기입
    Connection con = DriverManager.getConnection(url,"testuser","1234");            # DB 접속정보 기입
    Statement stat = con.createStatement();
    String query = "INSERT INTO test (id, name, pwd, email) VALUES('"+id+"','"+name+"','"+pwd+"','"+email+"')";
//INSERT into test(id,name,pwd,email) VALUES ('id','name','pwd','email') 쿼리문

    stat.executeUpdate(query);
    stat.close();
    con.close();
}
    catch(Exception e){
    out.println( e );
}
    response.sendRedirect("output.jsp");
%>