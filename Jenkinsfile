/* vim: set filetype=groovy : */
podTemplate(label: 'mypod', containers: [
    containerTemplate(name: 'docker', image: 'docker:18.03.1-ce', ttyEnabled: true, command: 'cat'),
    containerTemplate(name: 'docker-compose', image: 'docker/compose:1.19.0', ttyEnabled: true, command: 'cat'),
    containerTemplate(name: 'ecs-deploy', image: ilintl/ecs-deploy:3.6.0', ttyEnabled: true, command: 'cat'),
],
volumes: [
hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'),
],
nodeSelector: 'beta.kubernetes.io/os=linux') {
  node('mypod') {

    stage('prepare') {
      git credentialsId: 'github', url: 'https://github.com/femilofin/smava-app.git'
    }

    stage('build') {
      container('docker-compose') {
        retry(3) {
          sh "docker-compose build"
        }
      }
    }

    stage('push') {
      docker.withRegistry('https://506127536868.dkr.ecr.eu-west-1.amazonaws.com', 'ecr:eu-west-1:ci-user') {
	docker.image('smava-app').push('latest')
	docker.image('smava-nginx').push('latest')
      }
    }

    stage('deploy - development') {
      when {
        branch 'development'
        expression {
          currentBuild.result == null || currentBuild.result == 'SUCCESS'
        }
      }
      container('ecs-deploy') {
        sh "ecs deploy --timeout 600 smava-dev smava-smava-app"
      }
    }
}
