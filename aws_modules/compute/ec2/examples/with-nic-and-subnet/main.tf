module "ec2" {
  source = "../../"
  # Below values specify Tags
  environment             = "non-prod"
  department              = "devops"
  project_name            = "test-soumya"
  business_owner_email    = "test2@gmail.com"
  dev_owner_email         = "test@gmail.com"
  criticality             = "Low"
  cost_center             = "23456"
  maintenance_window      = "NA"
  zone                    = "GHQ"
  auid                    = "SE-00008"
  application_name        = "test-app"
  purpose                 = "gen"
  region                  = "ap-south-1"
  tier                    = "ad"
  os_type                 = "linux"
  create_instance_profile = false
  use_ssh                 = false
  instances = {
    instance1 = {
      ami               = "ami-23rf4evcdfrg5g"
      instance_type     = "t3.micro"
      availability_zone = "ap-south-1c"
      spot_instance = {
        spot_price                      = "0.05"
        instance_interruption_behaviour = "terminate"
      }
      network_interfaces = [
        {
          network_interface_id = "eni-2q34erdcefrgt5"
          device_index         = 0
        }
      ]
      credit_specification = {
        cpu_credits = "unlimited"
      }
      cpu_options = {
        core_count       = 2
        threads_per_core = 2
      }
      maintenance_options = {
        auto_recovery = "default"
      }
      user_data = "echo Hello, World!"
      ebs = [
        {
          device_name           = "/dev/xvdf"
          volume_size           = 8
          volume_type           = "gp3"
          delete_on_termination = true
        }
      ]
      ebs_attachments = [
        {
          device_name = "/dev/sdh"
          volume_size = 8
        }
      ]
    },
    instance2 = {
      ami               = "ami-2345rgvffe4rt5y6"
      instance_type     = "t2.micro"
      availability_zone = "ap-south-1a"
      subnet_id         = "subnet-w345tfrde45e3rf"
      ebs = [
        {
          device_name           = "/dev/xvdf"
          volume_size           = 8
          volume_type           = "gp2"
          delete_on_termination = true
        }
      ]
      ebs_attachments = [
        {
          device_name = "/dev/sdh"
          volume_size = 8
        }
      ]
    }
  }
}