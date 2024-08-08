#Tested for Value momentum - date 9th Aug, 2024

provider "aws" {
  region = "us-east-1" # Replace with your desired region
}

resource "aws_security_group" "load_balancer" {
  name        = "load-balancer-sg"
  description = "Security Group for Load Balancer"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "example" {
  name               = "my-load-balancer"	#Replace this name 
  subnets            = ["subnet-017dfa3f4487160c0", "subnet-02068492068419c37"] # Replace with your subnet IDs
  security_groups    = [aws_security_group.load_balancer.id]
  load_balancer_type = "application" # Choose application, network, or gateway
}

resource "aws_lb_target_group" "example" {
  name        = "my-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_lb.example.vpc_id
}

resource "aws_lb_target_group_attachment" "tg_attachment_test" {
    target_group_arn = aws_lb_target_group.example.arn
    target_id        = aws_lb.example.id
    port             = 80
}


#resource "aws_launch_configuration" "web" {
#  image_id      = "ami-0a0e5d9c7acc336f1" # Replace with your AMI ID
#  instance_type = "t2.micro"
#  security_groups = [aws_security_group.load_balancer.id] # Replace with your EC2 instance security group ID

#  user_data = <<EOF
#!/bin/bash
# Your user data script goes here
#apt update -y 
#apt install apache2 -y
#EOF

#}




#resource "aws_launch_template" "web" {
#  name = "vilas_launch_template"
#  description = "My Launch Template"
#  image_id = "ami-0a0e5d9c7acc336f1"
#  instance_type = "t2.micro"
#
#  vpc_security_group_ids = [aws_security_group.load_balancer.id]
#  key_name = "vilasnv2"  
#  user_data = filebase64("${path.module}/example.sh")
#  
#  ebs_optimized = true
#  #default_version = 1
#  update_default_version = true
#  block_device_mappings {
#    device_name = "/dev/sda1"
#    ebs {
#      volume_size = 10 
#      #volume_size = 20 # LT Update Testing - Version 2 of LT      
#      delete_on_termination = true
#      volume_type = "gp2" # default is gp2
#     }
#  }
#  monitoring {
#    enabled = true
#  }
#
#  tag_specifications {
#    resource_type = "instance"
#    tags = {
#      Name = "myasg"
#    }
#  }
#}

resource "aws_autoscaling_group" "web" {
  name               = "my-auto-scaling-group"
  #launch_template 	 = aws_launch_template.web.arn
  launch_template {
    id     = "lt-0fa1a2d0dc3398430" #aws_launch_template.web.id
    version = "$Latest"
  }

#	Mixed - doesn't support spot instances
#    mixed_instances_policy {
#    instances_distribution {
#      on_demand_base_capacity                  = 0
#      on_demand_percentage_above_base_capacity = 25
#      spot_allocation_strategy                 = "capacity-optimized"
#    }

#    launch_template {
#      launch_template_specification {
#        launch_template_id = aws_launch_template.web.id
#      }
#    }
#	}
  
  
  min_size           = 1
  max_size           = 2
  vpc_zone_identifier= ["subnet-017dfa3f4487160c0", "subnet-02068492068419c37"] # Replace with your subnet IDs
  
  target_group_arns = [aws_lb_target_group.example.arn]
}

#Rerefence worked: https://stackoverflow.com/questions/62558731/attaching-application-load-balancer-to-auto-scaling-group-in-terraform-gives

#resource "aws_autoscaling_attachment" "example" {
#  autoscaling_group_name = aws_autoscaling_group.web.id
#  elb                    = aws_lb.example.id
#}

#resource "aws_autoscaling_attachment" "example" {
#  auto_scaling_group_name = aws_autoscaling_group.web.id
#  elb                    = aws_lb.example
	


#  auto_scaling_group_name = aws_autoscaling_group.web.id
#  load_balancer_target {
#    arn     = aws_lb_target_group.example.arn
#    port     = 80
#    protocol = "HTTP"
#  }
#}