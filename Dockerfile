# 版本信息
FROM centos
MAINTAINER locutus "846718655@qq.com"

# OS环境配置
RUN yum install -y wget

WORKDIR /home
# 安装JDK
#RUN mkdir /var/tmp/jdk
#RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie"  -P /var/tmp/jdk http://download.oracle.com/otn-pub/java/jdk/8u111-b14/jdk-8u111-linux-x64.tar.gz
RUN wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie"  "http://download.oracle.com/otn-pub/java/jdk/8u141-b15/336fa29ff2bb4ef291e347e091f7f4a7/jdk-8u141-linux-x64.tar.gz"
RUN tar xzf jdk-8u141-linux-x64.tar.gz && rm -rf /var/tmp/jdk/jdk-8u141-linux-x64.tar.gz

# 安装tomcat
RUN mkdir /var/tmp/tomcat
RUN wget -P  /var/tmp/tomcat http://archive.apache.org/dist/tomcat/tomcat-8/v8.5.8/bin/apache-tomcat-8.5.8.tar.gz
RUN tar xzf /var/tmp/tomcat/apache-tomcat-8.5.8.tar.gz -C /var/tmp/tomcat && rm -rf /var/tmp/tomcat/apache-tomcat-8.5.8.tar.gz

# 安装maven
RUN mkdir /var/tmp/maven
ADD http://mirror.bit.edu.cn/apache/maven/maven-3/3.5.3/binaries/apache-maven-3.5.3-bin.tar.gz /var/tmp/maven
RUN tar xzf /var/tmp/maven/apache-maven-3.5.3-bin.tar.gz -C /var/tmp/maven && rm -rf /var/tmp/maven/apache-maven-3.5.3-bin.tar.gz

# 设置环境变量
ENV JAVA_HOME /home/jdk1.8.0_141
ENV MAVEN_HOME /var/tmp/maven/apache-maven-3.5.3
ENV CATALINA_HOME /var/tmp/tomcat/apache-tomcat-8.5.8
ENV PATH $PATH:$JAVA_HOME/bin:$CATALINA_HOME/bin:$MAVEN_HOME/bin

# 打包项目并拷贝到tomcat webapps目录
RUN mkdir /var/tmp/webapp
COPY ./docker-test.war  /var/tmp/webapp/
RUN cp /var/tmp/webapp/docker-test.war /var/tmp/tomcat/apache-tomcat-8.5.8/webapps/

# 从svn上拉代码

# 从git上拉代码

#开启内部服务端口
EXPOSE 8080

#启动tomcat服务器
CMD ["/var/tmp/tomcat/apache-tomcat-8.5.8/bin/catalina.sh","run"] && tail -f /var/tmp/tomcat/apache-tomcat-8.5.8/logs/catalina.out 
