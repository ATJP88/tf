resource "aws_instance" "ec2_example" {

   ami           = "ami-0b0dcb5067f052a63"
   instance_type =  var.instance_type

  tags = {
           Name = var.environment_name
   }

} 
