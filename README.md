# smava-app
This is a hello-world java app

## Building and running app locally

1. Build app using docker-compose
```sh
$ docker-compose build
```

2. Running app in detached mode
```sh
$ docker-compose up -d
```

3. Once all the services are started, visit http://localhost on your browser.

## Setting up app on AWS

1. Fork this repo
2. Follow [this guide](terraform/README.md) to set up the infrastructure with terraform
3. Update the `IMAGE_REPO` variable [here](scripts/deploy.sh) to your ECR repository URL
4. Encrypt the access and secret key gotten from step 2 and replace in the [travis](.travis.yml)
5. [Integrate Travis CI](https://docs.travis-ci.com/user/getting-started/#to-get-started-with-travis-ci) with github
6. After the CI/CD pipeline is successful on travis, visit the app on $url.$domain stated in the `terraform.tfvars`
   [file](terraform/dev/terraform.tfvars)
