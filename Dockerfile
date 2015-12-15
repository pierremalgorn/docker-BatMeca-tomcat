FROM tomcat:8.0

RUN apt-get update
RUN apt-get -y install git maven

WORKDIR /usr/local/

#Téléchargement du jdk pour la compilation
RUN curl -j -k -L -H "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u65-b17/jdk-8u65-linux-x64.tar.gz > jdk.tar.gz
RUN tar -zxf jdk.tar.gz
ENV JAVA_HOME /usr/local/jdk1.8.0_65/

#Clone du repo Batmeca
RUN git clone https://github.com/pierremalgorn/BatMeca

WORKDIR /usr/local/BatMeca

#Changement de config DB
COPY database.properties src/main/resources/database.properties

#Déplacement du views.properties en prod - A faire dans le git
RUN mv src/main/java/views.properties src/main/resources

#Compilation de l'appli
RUN mvn package
#Déploiement
RUN mv target/batmeca.war ../tomcat/webapps

#Copie des dépendances et fichiers nécessaires
RUN mkdir -p /opt/batmeca/resources
RUN mkdir -p /opt/batmeca/scripts
COPY datToCsv /opt/batmeca/scripts/datToCsv
RUN chmod -R 777 /opt/batmeca

EXPOSE 8080
