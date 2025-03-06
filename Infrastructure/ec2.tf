# Security Group (For EC2 & Load Balancer)
resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "WebSecurityGroup" }
}


# EC2 Instances
resource "aws_instance" "public_ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet_1a.id
  key_name               = var.aws_key_pair
  vpc_security_group_ids = [aws_security_group.web_sg.id]  

  tags = { Name = "Public-EC2" }
}

resource "aws_instance" "private_ec2_1a" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_subnet_1a.id
  key_name               = var.aws_key_pair
  vpc_security_group_ids = [aws_security_group.web_sg.id]  

user_data = <<-EOF
    #!/bin/bash
    
    # Add logging for troubleshooting
    exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
    
    echo "Starting user data script execution"
    
    # Update package lists
    echo "Updating package lists"
    apt-get update -y
    
    # Install nginx
    echo "Installing nginx"
    apt-get install -y nginx
    
    # Ensure nginx is enabled and started
    echo "Enabling and starting nginx"
    systemctl enable nginx
    systemctl start nginx
    
    # Create a simple webpage
    echo "Creating webpage"
    cat > /var/www/html/index.html << 'HTMLDOC'
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Demo page</title>
    </head>
    <body>
        <h1>server-2</h1>
        <h2>hello world</h2>
    </body>
    </html>
    HTMLDOC
    
    # Allow HTTP traffic
    echo "Configuring firewall"
    ufw allow 'Nginx Full'
    
    # Final restart to ensure everything is applied
    echo "Restarting nginx"
    systemctl restart nginx
    
    echo "User data script completed"
  EOF
  tags = { Name = "Private-EC2-1a" }
}

resource "aws_instance" "private_ec2_1b" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_subnet_1b.id
  key_name               = var.aws_key_pair
  vpc_security_group_ids = [aws_security_group.web_sg.id]  

   user_data = <<-EOF
    #!/bin/bash
    
    # Add logging for troubleshooting
    exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
    
    echo "Starting user data script execution"
    
    # Update package lists
    echo "Updating package lists"
    apt-get update -y
    
    # Install nginx
    echo "Installing nginx"
    apt-get install -y nginx
    
    # Ensure nginx is enabled and started
    echo "Enabling and starting nginx"
    systemctl enable nginx
    systemctl start nginx
    
    # Create a simple webpage
    echo "Creating webpage"
    cat > /var/www/html/index.html << 'HTMLDOC'
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Demo page</title>
    </head>
    <body>
        <h1>server-1</h1>
        <h2>hello world</h2>
    </body>
    </html>
    HTMLDOC
    
    # Allow HTTP traffic
    echo "Configuring firewall"
    ufw allow 'Nginx Full'
    
    # Final restart to ensure everything is applied
    echo "Restarting nginx"
    systemctl restart nginx
    
    echo "User data script completed"
  EOF
  tags = { Name = "Private-EC2-1b" }
}

 resource "aws_key_pair" "deployer" {
   key_name   = var.aws_key_pair
   public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDNR5DzpdadXKEmWnn3ofCtW74bqImzlaNohLLK5DU/L33TTDjoZ9w161lhal4VWkAPTJtdPr5oscZrc6z7kBUVJPcnJ6bfubfPwFrheEab7LH/Hcz03iqOvTZKEIq2unQoVgswZCz0/3gMfkp6W8q5Y8hiYJG82PDk0MyWlkBSro4ujpuZvjBxInCtfSp2mR6HZwE+pzTERoIxqC3Xk5ZDaoBgEUB2KjLLIpC3cwRD5Ljn99KNzm9ASIULbL/ml07/hAkpRJbjgOxgvGGFeuwft+z97E7Q9XKq0yyOhMcths5eTr839W+rjdj5aKghP2T31JFi2huXwj7W6k7pWOQoISKF042kvntAW5i+v9vy7VrjvGE5TiGV8tku1QCI2mhWvOvNfPH5s8IEZ4MrQtDhClVVDqlXi9GTYpvpcfXfw9OjGaXlTWwwTFfPVQ9yUKVR8KZ2Qb129gaCTfU4aHkgRTRNEVl2ZEmo0vpoHX0tX7eu45QqZVuLr6taxjSufmsIqyfadO1FEibVuDygxEiJ+9CYwLFGK3e3fqByfly/nYczvJA2z8yaUjieZFc4vbSUbrMfIYZK/XfHLw4+TdIws2X9BxmdkYinpv/WYsef0JUM3XHtRJ6lNXdlIiWYH4AB9Fb46vKrktrO+DsttVGYxxJP2km64aqebWLj33Ne1Q== apple@Apples-MacBook-Pro.local"
 }

# Load Balancer
resource "aws_lb" "web_alb" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_sg.id]
  subnets           = [aws_subnet.public_subnet_1a.id, aws_subnet.public_subnet_1b.id]

  tags = {
    Name = "WebALB"
  }
}

resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn  
  }
}

# Target Group
resource "aws_lb_target_group" "web_tg" {
  name        = "web-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.my_vpc.id
  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "80"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name = "WebTargetGroup"
  }
}

# Target Group Attachments 
resource "aws_lb_target_group_attachment" "attach1" {
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = aws_instance.private_ec2_1a.id
  port             = 80
  depends_on       = [aws_instance.private_ec2_1a]
}

resource "aws_lb_target_group_attachment" "attach2" {
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = aws_instance.private_ec2_1b.id
  port             = 80
  depends_on       = [aws_instance.private_ec2_1b]
}

output "alb_dns_name" {
  value       = aws_lb.web_alb.dns_name
  description = "The DNS name of the load balancer"
}