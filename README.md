# Sysdig Monitor GCP Cloud

Terraform to create appropriate GCP resources and Sysdig Monitor Cloud account for cloud monitoring. Requires the [Sysdig Terraform Provider](https://github.com/sysdiglabs/terraform-provider-sysdig).


## Prerequisites

Your user **must** have following **roles** in your GCP credentials
* _Owner_
* _Organization Admin_ (organizational usage only)

### Google Cloud CLI Authentication
To authorize the cloud CLI to be used by Terraform check the following [Terraform Google Provider docs](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/getting_started#configuring-the-provider)

## GCP Resource Generation

### These Terraform scripts will perform the following steps, which will enable GCP metrics:
- Create a new service account for the specified project(s) in GCP
- Add the monitoring.viewer role to the account
- Generate a service account key for the account
- Generate a new cloud account record with GCP credentials in Sysdig


### Single Project Example
```
provider "google" {
  project = "gcp-project-id"
  region = "us-west1"
}

provider "sysdig" {
  sysdig_monitor_url = "https://app.sysdigcloud.com"
  sysdig_monitor_api_token = "3FB95ACF-0122-4AF9-8723-F05C48B8134F"
}

module "sysdig_monitor_cloud_account" {
  source = "github.com/sysdiglabs/terraform-gcp-monitor-for-cloud/single-project"
  gcp_project_id = "gcp-project-id"
}
```

### Multi-Project

There are 2 options for the variable parent_folder_id:

1. Set it to the direct parent directory of the GCP projects that integrations will be generated for. *This is not a recursive function*, so no integrations will be generated for projects under any of the other folders.
2. Leave it blank. The script will attempt to generate integrations for every project under the organization.

```
provider "google" {
  region = "us-west1"
}

provider "sysdig" {
  sysdig_monitor_url = "https://app.sysdigcloud.com"
  sysdig_monitor_api_token = "3FB95ACF-0122-4AF9-8723-F05C48B8134F"
}

module "sysdig_monitor_cloud_account" {
  source = "github.com/sysdiglabs/terraform-gcp-monitor-for-cloud/organization"
  parent_folder_id = "298047817376 " // (Optional)
}
```
