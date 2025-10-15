output "bucket_name" {
  value = digitalocean_spaces_bucket.spaces.name
}

output "bucket_region" {
  value = digitalocean_spaces_bucket.spaces.region
}
