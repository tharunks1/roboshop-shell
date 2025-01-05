pipeline {
    agent {
    node {
        label 'LABEL-1'
    }
}
 environment {
     
 }

    stages {
        stage('Hello') {
            steps {
               sh """ 
               echo "Hello I'm tharun
               
               """
            }
        }
        
       
    }
    
     post { 
        always { 
            echo 'I will always say Hello again!'
        }
        failure {
            echo "Failed"
        }
    }
}
