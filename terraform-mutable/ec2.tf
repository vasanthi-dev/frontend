resource "aws_spot_instance_request" "ec2-spot" {
  count = var.INSTANCE_COUNT
  ami           = data.aws_ami.ami.id
  instance_type = var.INSTANCE_TYPE

  tags = {
    Name = "${var.COMPONENT}-${var.ENV}-${count.index+1}"
  }
}

resource "aws_ec2_tag" "spot-instances" {
  count = length(aws_spot_instance_request.ec2-spot)
  resource_id = aws_spot_instance_request.ec2-spot.*.id[count.index+1]
  key         = "Name"
  value       = "${var.COMPONENT}-${var.ENV}-${count.index+1}"
}
