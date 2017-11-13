# Public Elastic IP for Backend EC2 Instance
resource "aws_eip" "backend" {
  vpc      = true
}

# Association between Elastic IP and EC2 Instance
resource "aws_eip_association" "backend_assoc" {
  instance_id   = "${aws_instance.backend.id}"
  allocation_id = "${aws_eip.backend.id}"
}
