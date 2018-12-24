#!groovy

pipeline {
  agent {
    docker {
      image 'sbmod-docker'
    }
  }
  environment {
    CI = 'true'
    PAKNAME = 'ThreateningSpaceStations.pak'
    ASSET_PATH = '/opt/StarboundAssets/'
    SB_GENPATCH = 'true'
    SB_VALIDATE = 'true'
    SB_CRUSHPNG = 'false'
  }
  options {
    gitLabConnection('gitlab@cr.imson.co')
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
      archiveArtifacts 'build/*.pak'
      updateGitlabCommitStatus name: 'jenkins', state: 'success'
    }
    cleanup {
      cleanWs()
    }
  }
  stages {
    stage('Prepare') {
      steps {
        updateGitlabCommitStatus name: 'jenkins', state: 'running'
        sh 'mkdir ./build/'
      }
    }
    stage('Build') {
      when {
        environment name: 'SB_GENPATCH', value: 'true'
      }
      steps {
        sh "sbtool genpatch ${env.ASSET_PATH} ./modified/ ./src/"
      }
    }
    stage('Validate') {
      when {
        environment name: 'SB_VALIDATE', value: 'true'
      }
      steps {
        sh 'sbtool checkjson ./src/'
      }
    }
    stage('Compact Image Assets') {
      when {
        environment name: 'SB_CRUSHPNG', value: 'true'
      }
      steps {
        sh 'sbtool pngpack ./src/'
      }
    }
    stage('Pack') {
      steps {
        sh "sbpak pack ./src/ ./build/${env.PAKNAME}"
      }
    }
    stage('Publish') {
      when {
        branch 'master'
      }
      steps {
        // update "latest" pak available
        cifsPublisher alwaysPublishFromMaster: true,
          failOnError: true,
          publishers: [[
            configName: 'neutron',
            transfers: [[
              remoteDirectory: 'starbound_mods/',
              removePrefix: 'build',
              sourceFiles: 'build/*.pak'
            ]],
            verbose: false
          ]]
      }
    }
  }
}
