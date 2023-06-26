locals {
  business_domain = get_env("TG_business_domain")
}

generate "business_domain_folder_structure" {
  path      = "${get_terragrunt_dir()}/${local.business_domain}/s3-bucket.tf"
  if_exists = "overwrite_terragrunt"

  contents = templatefile("${get_terragrunt_dir()}/templates/template.tf", {
    bucket_name = "my-bucket-${local.business_domain}"
  })
}
