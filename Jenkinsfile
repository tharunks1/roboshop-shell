pipeline { 
    agent {
    node {  
        label 'LABEL-1'
    }
}


    stages {
        stage('Hello') {
            steps {
               sh """ 
               echo "Hello I'm tharun"
               
               """
            }
        }

         stage('Hi') {
            steps {
               sh """ 
               echo "Hello I'm tharun"
               
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
