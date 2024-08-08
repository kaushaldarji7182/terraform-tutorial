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

#Reference: https://terraformguru.com/terraform-real-world-on-aws-ec2/09-AWS-ALB-Application-LoadBalancer-Basic/

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "5.16.0"

  name 					= "vilas-alb"
  load_balancer_type 	= "application"
  vpc_id 				= "vpc-07d7a80fdfca953cf"
  subnets = [
    "subnet-017dfa3f4487160c0","subnet-0f51d5d5c0adfb2ce"
  ]
  security_groups = ["sg-083cd817b13d667d1"]
  # Listeners
    http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]  
  # Target Groups
  target_groups = [
    # App1 Target Group
    {
      name_prefix      = "app1-a"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"		#app1/index.html
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }      
      protocol_version = "HTTP1"
      # App1 Target Group - Targets
      #targets = {
      #  my_app1_vm1 = {
      #    target_id = ""
      #    port      = 80
      #  },
      #  my_app1_vm2 = {
      #    target_id = module.ec2_private.id[1]
      #    port      = 80
      #  }        
      #}
      #tags = local.common_tags # Target Group Tags
    }     
  ]
  #tags = local.common_tags # ALB Tags
}



resource "aws_autoscaling_group" "web" {
  name               = "my-auto-scaling-group"
  #launch_template 	 = aws_launch_template.web.arn
  launch_template {
    id     = "lt-0fa1a2d0dc3398430" #aws_launch_template.web.id #Create launch template manually and mention here
    version = "$Latest"
  }

  
  min_size           = 1
  max_size           = 2
  vpc_zone_identifier= ["subnet-017dfa3f4487160c0","subnet-0f51d5d5c0adfb2ce"]
	#["subnet-017dfa3f4487160c0", "subnet-02068492068419c37"] # Replace with your subnet IDs
  
  target_group_arns = module.alb.target_group_arns
}

#Rerefence worked: https://stackoverflow.com/questions/62558731/attaching-application-load-balancer-to-auto-scaling-group-in-terraform-gives
#https://terraformguru.com/terraform-real-world-on-aws-ec2/09-AWS-ALB-Application-LoadBalancer-Basic/