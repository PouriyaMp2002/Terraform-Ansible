// Create a security group for nginx
resource "aws_security_group" "web-sg" {
    name = "nginx-sg"
    description = "Security group for nginx server."
}

// Create a security group for database
resource "aws_security_group" "db-sg" {
    name = "Database-sg"
    description = "Security group for mysql server."
}

// Define rules for web-server

// SSH
resource "aws_vpc_security_group_ingress_rule" "SSH_WEB" {
    security_group_id = aws_security_group.web-sg.id
    cidr_ipv4 = "${chomp(data.http.my_ip.response_body)}/32" // get your public ip ==> SSH must be defined for only yourself.
    from_port = 22
    to_port = 22
    ip_protocol = "tcp"
}

// HTTPS
resource "aws_vpc_security_group_ingress_rule" "HTTPS" {
    security_group_id = aws_security_group.web-sg.id
    cidr_ipv4 = "0.0.0.0/32" //HTTPS from anywhere.
    from_port = 443
    to_port = 443
    ip_protocol = "tcp"
}

//HTTP
resource "aws_vpc_security_group_ingress_rule" "HTTP" {
    security_group_id = aws_security_group.web-sg.id
    cidr_ipv4 = "0.0.0.0/32" //HTTP from anywhere.
    from_port = 80
    to_port = 80
    ip_protocol = "tcp"
}


// Define rules for database-server

//SSH
resource "aws_vpc_security_group_ingress_rule" "SSH_DB" {
    security_group_id = aws_security_group.db-sg.id
    cidr_ipv4 = "${chomp(data.http.my_ip.response_body)}/32" // get your public ip ==> SSH must be defined for only yourself.
    from_port = 22
    to_port = 22
    ip_protocol = "tcp"
}

// 3306 from web-server
resource "aws_vpc_security_group_ingress_rule" "MYSQL_FROM_WEB" {
    security_group_id = aws_security_group.db-sg.id
    referenced_security_group_id = aws_security_group.web-sg.id // Connect to database FROM ONLY WEBSERVER
    from_port = 3306
    to_port = 3306
    ip_protocol = "tcp"
}

// Outbound
// Outbound rules can be left undefined, as AWS allows all outbound traffic by default.
resource "aws_vpc_security_group_egress_rule" "Outbound_WEB" {
  security_group_id = aws_security_group.web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "Outbound_DB" {
  security_group_id = aws_security_group.db-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}