#!groovy
pipeline {
  options {
    gitLabConnection('gitlab@nebula')
    timestamps()
  }
  triggers {
    gitlab(
      triggerOnPush: true,
      triggerOnMergeRequest: true,
      branchFilterType: 'All',
      noteRegex: 'rebuild',
      pendingBuildName: 'jenkins'
    )
  }
  post {
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
        configFileProvider([configFile(fileId: '142cc8ae-6dcc-42a5-b9b3-3d84873a7f9d', targetLocation: './_smtkpath.bat')]) {
            bat 'make.bat'
        }
        archiveArtifacts 'build/*.pak'
      }
    }
  }
}
