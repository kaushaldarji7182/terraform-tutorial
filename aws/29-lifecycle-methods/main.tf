
provider "aws" {
  region = "us-east-1"
}

#Step 1 
resource "aws_instance" "example" {
  ami                    = "ami-04b4f1a9cf54c11d0"
  instance_type          = "t2.micro"
  user_data              = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y apache2
#              sed -i -e 's/80/8080/' /etc/apache2/ports.conf
              echo "Hello World" > /var/www/html/index.html
              systemctl restart apache2
              EOF
  tags = {
    Name          = "terraform-learn-state-ec2"
    drift_example = "v1"
  }
}

resource "aws_security_group" "sg_web" {
  name = "sg_web"
  ingress {
    # from_port   = "8080"
    # to_port     = "8080"

#Step 3 - comment above two lines and uncomment below two lines
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  // connectivity to ubuntu mirrors is required to run `apt-get update` and `apt-get install apache2`
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  #Step 2 
 
 lifecycle {

#  prevent_destroy = true
 #Step 3 comment above and below 
 create_before_destroy = true
 #Step 4 add below and make a direct change in cloud in tags - terraform would ignore.
    ignore_changes        = [tags]
 }
}