resource "null_resource" "app-deploy" {
  count       = length(aws_spot_instance_request.ec2-spot)
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["SSH_USERNAME"]
      password = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["SSH_PASSWORD"]
      host     = aws_spot_instance_request.ec2-spot.*.private_ip[count.index]
    }
    inline = [
     // "ansible-pull -i localhost, -u https://github.com/vasanthi-dev/ansible.git roboshop-pull.yml -e COMPONENT=${var.COMPONENT} -e ENV=${var.ENV} -e APP_VERSION=${var.APP_VERSION}"
      "ansible-pull -U https://github.com/vasanthi-dev/ansible.git roboshop-pull.yml -e COMPONENT=catalogue -e ENV=dev -e APP_VERSION=${var.APP_VERSION} -e NEXUS_USERNAME=${nonsensitive(jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["NEXUS_USERNAME"])} -e NEXUS_PASSWORD=${nonsensitive(jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["NEXUS_PASSWORD"])} "
    ]
  }
}