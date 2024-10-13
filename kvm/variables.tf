
variable "libvirt_disk_path" {
  description = "path for libvirt pool"
  default     = "/opt/kvm/pool1"
}

variable "img_url" {
  description = "fedora image"
  #default     = "http://cloud-images.ubuntu.com/releases/bionic/release-20191008/ubuntu-18.04-server-cloudimg-amd64.img"
  default     = "https://ftp.riken.jp/Linux/fedora/releases/40/Cloud/x86_64/images/Fedora-Cloud-Base-Generic.x86_64-40-1.14.qcow2"
}

variable "vm_hostname" {
  description = "vm hostname"
  default     = "terraform_fedora"
}

variable "ssh_username" {
  description = "the ssh user to use"
  default     = "root"
}

variable "ssh_private_key" {
  description = "the private key to use"
  default     = "~/.ssh/id_rsa"
}