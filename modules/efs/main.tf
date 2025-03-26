#          ███████ ███████ ███████           
#          ██      ██      ██                
#█████     █████   █████   ███████     █████ 
#          ██      ██           ██           
#          ███████ ██      ███████           
                                            
# Written by Christian Hamp                                                   
# Datum: 24.09.2024      

# EFS Security Group
resource "aws_security_group" "ghost_efs_sg" {
  name = "${var.name}-efs"
  description = "Security Group"
  vpc_id = var.vpc_id
  ingress {
    from_port = 2049
    to_port = 2049
    protocol = "tcp"
    security_groups = [var.security_group_id]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create EFS
resource "aws_efs_file_system" "ghost_efs" {
  creation_token = "${var.name}-token"
  tags = {
    Name = var.name
  }
}

# Associate Firewall to our EFS with Mount Point
resource "aws_efs_mount_target" "a" {
  file_system_id = aws_efs_file_system.ghost_efs.id
  subnet_id      = var.subnet_ids[0]
  security_groups = ["${aws_security_group.ghost_efs_sg.id}"]
}
resource "aws_efs_mount_target" "b" {
  file_system_id = aws_efs_file_system.ghost_efs.id
  subnet_id      = var.subnet_ids[1]
  security_groups = ["${aws_security_group.ghost_efs_sg.id}"]
}