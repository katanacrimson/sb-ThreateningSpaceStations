#!groovy
pipeline {
  options {
    gitLabConnection('gitlab@nebula')
    gitlabBuilds(builds: ['jenkins'])
    timestamps()
  }
  post {
    always {
      cleanWs()
    }
    failure {
      updateGitlabCommitStatus name: 'jenkins', state: 'failed'
    }
    success {
      updateGitlabCommitStatus name: 'jenkins', state: 'success'
    }
  }
  agent { label 'windows' }
  environment {
    CI = 'true'
  }
  stages {
    stage('Build') {
      steps {
        updateGitlabCommitStatus name: 'jenkins', state: 'running'
        configFileProvider([configFile(fileId: '142cc8ae-6dcc-42a5-b9b3-3d84873a7f9d', targetLocation: './_smtkpath.bat')]) {
          bat 'make.bat'
        }
        archiveArtifacts 'build/*.pak'
      }
    }
  }
}
