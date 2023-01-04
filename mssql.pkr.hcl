packer {
  required_version = ">= 1.7.8"
  required_plugins {
    nutanix = {
      version = ">= 0.3.1"
      source  = "github.com/nutanix-cloud-native/nutanix"
    }
  }
}

source "nutanix" "windows-server-mssql" {
  nutanix_username = var.nutanix_username
  nutanix_password = var.nutanix_password
  nutanix_endpoint = var.nutanix_endpoint
  nutanix_insecure = var.nutanix_insecure
  cluster_name     = var.nutanix_cluster
  
  vm_disks {
      image_type = "ISO_IMAGE"
      source_image_uri =  var.windows_source_uri
  }

  vm_disks {
      image_type = "ISO_IMAGE"
      source_image_name = var.virtio_iso_image_name
  }

  vm_disks {
      image_type = "ISO_IMAGE"
      source_image_uri =  var.windows_sql_uri
  }

  vm_disks {
      image_type = "DISK"
      disk_size_gb = 100
  }

  vm_nics {
    subnet_name       = var.nutanix_subnet
  }
  
  cd_files         = ["scripts/autounattend.xml","scripts/unattend.xml", "scripts/sysprep.bat"]
  
  shutdown_command = "G:/sysprep.bat"
  image_name        ="win-{{isotime `Jan-_2-15:04:05`}}"
  shutdown_timeout  = "13m"
  cpu               = 4
  os_type           = "Windows"
  memory_mb         = "8192"
  communicator      = "winrm"
  winrm_port        = 5986
  winrm_insecure    = true
  winrm_use_ssl     = true
  winrm_timeout     = "45m"
  winrm_password    = var.administrator_password
  winrm_username    = var.administrator_username
}

build {
  name = "win2019_mssql"

  sources = [
    "source.nutanix.windows-server-mssql"
  ]

  #example for running powershell scripts
  provisioner "powershell" {
    scripts = ["scripts/install.ps1"]
    elevated_user = var.administrator_username
    elevated_password = var.administrator_password
  }

  #example for running ansible
  provisioner "ansible" {
    user          = var.administrator_username
    use_proxy     = false
    playbook_file   = "ansible/site.yaml"
    extra_arguments = [
      "--extra-vars",
      "ansible_winrm_server_cert_validation=ignore",
      "--extra-vars",
      "winrm_password=packer",
      "--extra-vars",
      "ansible_shell_type=powershell",
      "--extra-vars",
      "ansible_shell_executable=None",
    ]
  }
}