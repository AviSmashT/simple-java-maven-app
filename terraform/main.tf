terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-central-1"
}


resource "aws_instance" "deployment-maven-actions" {
  ami = "ami-0a628e1e89aaedf80" # image for ubuntu
  instance_type = "t2.micro"
  tags = {
    Name = "deployment-maven-actions" # the name of the instance
  }
    
    user_data = <<-EOF
    #!/bin/bash
    
    # Install docker:
    sudo yum update -y
    sudo yum install -y docker

    # Start docker service and add ec2-user to the docker group:
    sudo service docker start
    sudo usermod -a -G docker ec2-user

    # Set the docker config directory:
    sudo mkdir -p ~/.docker/cli-plugins
    # Download the compose plugin to the config directory:
    sudo curl -SL https://github.com/docker/compose/releases/download/v2.30.3/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
    sudo mkdir -p /usr/local/lib/docker/cli-plugins
    sudo cp ~/.docker/cli-plugins /usr/local/lib/docker/cli-plugins


    # for current user:
    sudo chmod +x ~/.docker/cli-plugins/docker-compose
    # for all users:
    sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose 
 
      
   	#docker login -u avishemtov2 -p ${var.docker_password}
   	
   	docker pull avishemtov2/maven-actions:latest 
   	docker run -d avishemtov2/maven-actions:latest
  EOF
  
}
