#create ubuntu 22 ec2 instance

resource "aws_instance" "app-resource" {
  ami           = "ami-0a0e5d9c7acc336f1"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  key_name = "newkey3"
  
  subnet_id = aws_subnet.public_subnet_az1.id
  vpc_security_group_ids = [ aws_security_group.security_group_bastion_host.id ]

  private_dns_name_options {
    enable_resource_name_dns_a_record = true
  }
  
  root_block_device {
    volume_size = "20"
    volume_type = "gp2"
  }

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name = "app-server"
  }

  user_data = <<-EOF
                #!/bin/bash
                apt update
                apt install apache2 -y
                apt install php -y
                apt install php-mbstring -y
                apt install php-mysql -y
                apt install php-zip -y
                apt install ghostscript libapache2-mod-php php-bcmath php-curlphp-imagick php-intl php-json php-xml -y
                cd /var/www/html/ && curl https://wordpress.org/latest.tar.gz -o latest.tar.gz
                tar xzf latest.tar.gz
                mv /var/www/html/wordpress/* /var/www/html/
                cd /var/www/html/ && chown www-data:www-data *
                systemctl reload apache2
                cd /home/ubuntu/ && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
                apt install unzip
                unzip awscliv2.zip
                ./aws/install
              EOF
}

output "public_ipv4" {
  value = aws_instance.app-resource.public_ip
  
}