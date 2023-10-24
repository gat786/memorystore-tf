locals {
  memory_store_name   = "my-memorystore"
  vpc_name            = "bhd-airflow-dags-vpc"
  read_replicas_mode  = "READ_REPLICAS_ENABLED"
  transit_encryption  = true
  // TRANSIT_ENCRYPTION_MODE_UNSPECIFIED	SERVER_AUTHENTICATION  DISABLED
}

data google_project "trantor" {
  project_id = "trantor-test-379409"
}

module "memorystore" {
  source  = "terraform-google-modules/memorystore/google"
  version = "7.1.2"

  name          = local.memory_store_name
  project       = data.google_project.trantor.project_id



  # this is recommended connection mode for shared vpcs
  connect_mode        = "PRIVATE_SERVICE_ACCESS"
  region              = "europe-west2"

  // read replicas supported for instance having over 5GB memory
  memory_size_gb          = 8
  replica_count           = 2
  auth_enabled            = true
  authorized_network      = local.vpc_name
  read_replicas_mode      = local.read_replicas_mode
  tier                    = "STANDARD_HA" // BASIC is also available
  transit_encryption_mode = "DISABLED"
  redis_version           = "REDIS_7_0"
}
