
# use data source to get a registered amazon linux 2 ami
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}


# launch the ec2 instance and install website
resource "aws_instance" "ec2_instance" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id                //comes from vpc Module
  vpc_security_group_ids = [var.ec2_security_group_ids] //comes from vpc Module
  key_name               = "myec2_key"
  # user_data            = file("install_jenkins.sh") //not using it coz we want to print the password

  tags = {
    Name = "Jenkins Server"
  }
}


# an empty resource block
resource "null_resource" "name" {

  # ssh into the ec2 instance 
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/Downloads/myec2_key.pem")
    host        = aws_instance.ec2_instance.public_ip
    timeout     = "4m"
  }

  # copy the install_jenkins.sh file from your computer to the ec2 instance 
  provisioner "file" {
    source      = "../Install_Jenkins_Script.sh"
    destination = "/tmp/Install_Jenkins_Script.sh"
  }

  # set permissions and run the install_jenkins.sh file
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/Install_Jenkins_Script.sh", //make the script executable
      "sh Install_Jenkins_Script.sh",                 //execute the script
    ]
  }

  # wait for ec2 to be created
  depends_on = [aws_instance.ec2_instance]
}


# print the url of the jenkins server
output "website_url" {
  value = join("", ["http://", aws_instance.ec2_instance.public_dns, ":", "8080"])
}
