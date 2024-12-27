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
        
    # Add Docker's official GPG key:
    sudo apt-get update -y
    sudo apt-get install -y ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
        
    # Add the repository to Apt sources:
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update -y

    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # Start docker service and add ubuntu to the docker group:
    sudo service docker start
    sudo usermod -a -G docker ubuntu
        	
    docker pull avishemtov2/maven-actions:latest 
    docker run -d avishemtov2/maven-actions:latest
  EOF
  
}
