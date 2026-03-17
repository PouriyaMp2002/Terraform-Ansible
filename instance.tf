resource "aws_instance" "Database" {
  ami                    = var.ami_id[var.region]
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.db-sg.id] // To import security group, use this. 

  tags = {
    Name = "Database" // Instance name in AWS
  }
}


resource "aws_instance" "Web" {
  ami                    = var.ami_id[var.region]
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.web-sg.id]

  tags = {
    Name = "Nginx"
  }

}

// We need the instances' public IPs for Ansible, so we use an "output" to display them after provisioning the infrastructure.
output "Nginx_public_ip" {
    value = aws_instance.Web.public_ip
}

output "DB_public_ip" {
    value = aws_instance.Database.public_ip
}
