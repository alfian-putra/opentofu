terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = ">= 0.6"
    }
  }
}

provider "libvirt" {
    uri = "qemu:///system"
}

resource "libvirt_pool" "fedora" {
  name = "fedora"
  type = "dir"
  path = var.libvirt_disk_path
}

resource "libvirt_volume" "fedora_volume" {
  name   = "fedora_volume"
  pool   = "default"
  source = var.img_url
}

resource "libvirt_domain" "domain-fedora" {
  name   = var.vm_hostname
  memory = "1024"
  vcpu   = 1

    console {
      type        = "pty"
      target_port = "0"
      target_type = "serial"
    }

    console {
      type        = "pty"
      target_type = "virtio"
      target_port = "1"
    }

    network_interface {
      network_name = "default"
      wait_for_lease = true
    }
    
    disk {
      volume_id = libvirt_volume.fedora_volume.id
    }

    graphics {
      type        = "spice"
      listen_type = "address"
      autoport    = true
    }

    provisioner "remote-exec" {
      inline = [
        "echo 'Hello World'"
      ]

      connection {
        type                = "ssh"
        user                = var.ssh_username
        host                = libvirt_domain.domain-fedora.network_interface[0].addresses[0]
        private_key         = file(var.ssh_private_key)
        bastion_host        = "ams-kvm-remote-host"
        bastion_user        = "deploys"
        timeout             = "2m"
      }
    }

      provisioner "local-exec" {
      command = <<EOT
        echo "[nginx]" > nginx.ini
        echo "${libvirt_domain.domain-fedora.network_interface[0].addresses[0]}" >> nginx.ini
        echo "[nginx:vars]" >> nginx.ini
        echo "ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ProxyCommand=\"ssh -W %h:%p -q ams-kvm-remote-host\"'" >> nginx.ini
        ansible-playbook -u ${var.ssh_username} --private-key ${var.ssh_private_key} -i nginx.ini ansible/playbook.yml
        EOT
    }
}