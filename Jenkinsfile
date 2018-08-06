#!groovy

pipeline {
  options {
    gitLabConnection('gitlab@nebula')
    gitlabBuilds(builds: ['jenkins'])
    timestamps()
  }
  post {
    failure {
      updateGitlabCommitStatus name: 'jenkins', state: 'failed'
    }
    unstable {
      updateGitlabCommitStatus name: 'jenkins', state: 'failed'
    }
    aborted {
      updateGitlabCommitStatus name: 'jenkins', state: 'canceled'
    }
    success {
      updateGitlabCommitStatus name: 'jenkins', state: 'success'
    }
    cleanup {
      cleanWs()
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
      }
    }

    stage('Publish') {
      steps {
        archiveArtifacts 'build/*.pak'

        // archive the pak for this specific build, and...
        cifsPublisher alwaysPublishFromMaster: true,
          failOnError: true,
          publishers: [[
            configName: 'neutron',
            transfers: [[
              remoteDirectory: '$JOB_NAME/$BUILD_NUMBER/',
              removePrefix: 'build',
              sourceFiles: 'build/*.pak'
            ]],
            verbose: false
          ]]

        // update "latest" pak available
        cifsPublisher alwaysPublishFromMaster: true,
          failOnError: true,
          publishers: [[
            configName: 'neutron',
            transfers: [[
              remoteDirectory: '$JOB_NAME/latest/',
              removePrefix: 'build',
              sourceFiles: 'build/*.pak',
              cleanRemote: true
            ]],
            verbose: false
          ]]
      }
    }
  }
}
