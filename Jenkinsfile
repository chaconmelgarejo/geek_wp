#!groovy
library('DOCKERLIB')
pipeline {
agent any

environment {
    WP_CONTAINER= 'wp-geek'
    MYSQL_CONTAINER= 'mysql-geek'
    IMAGES= 'php:7.0-apache'
    IMAGES_DB= 'mysql/mysql-server:5.7'
    DATABASE = 'geek_wp'
    DATABASE_PASSW = 'nx6120'
    SCM = 'https://github.com/chaconmelgarejo/geek_wp.git'
    SCM_BRANCH = 'deploy'
    WP_URL01 = 'http://www.geekdevops.com'
    WP_URL02 = 'http://192.168.70.32:8888'
}

options { 
    buildDiscarder(logRotator(numToKeepStr:'10'))
    timeout(time: 8, unit: 'HOURS')
}

stages {
 
  stage ('Docker- Down') {
      steps {
	  containerStop("$WP_CONTAINER")
          containerStop("$MYSQL_CONTAINER")
      }//end steps
  }//end stage

  stage("Build - mysql/mysql-server:5.7") {
    steps{
      script{
       docker.image("${IMAGES_DB}").run("--name ${MYSQL_CONTAINER} -v ${WORKSPACE}:${WORKSPACE}:rw,z -v ${WORKSPACE}/docker-entrypoint-initdb.d:/docker-entrypoint-initdb.d:rw,z -e MYSQL_ROOT_HOST='%' -e MYSQL_ROOT_PASSWORD=${DATABASE_PASSW} -e MYSQL_DATABASE=${DATABASE}")
      }
      sh 'sleep 90'
       sh "docker exec -t ${MYSQL_CONTAINER} /entrypoint.sh"
    }//end steps
  }//end stage

  stage ("Build - php:7.0-apache") {
    steps{
      sh "docker build -t ${IMAGES} -f Dockerfile.ori ."
    }//end steps
  }//end stage
 
  stage ('Build - App'){
     // Remember:
     // change in the variable args the port parameters, project name
     // example:
     // -p <port_local: port_container> --name wp- <project name> --link mysql- <project name>: mysql
      agent {
         dockerfile {
           args "-p 8888:80 --name wp-geek --link mysql-geek:mysql"
         } 
      }
      steps {
        sh "wp --allow-root search-replace '${WP_URL01}' '${WP_URL02}' --path='${WORKSPACE}' "
        sh "sudo ./apache_link.sh"
        sh 'sleep 64800'
      }//end steps
   }//end stage
}//end stages

}//end pipeline
