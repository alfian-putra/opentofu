# Create new storage bucket in the US multi-region
# with coldline storage
resource "random_id" "bucket_prefix" {
  byte_length = 8
}

resource "google_storage_bucket" "static" {
  name          = "${var.project_id}-bucket-${random_id.bucket_prefix.hex}"
  location      = "US"
  storage_class = "STANDARD"
  force_destroy = false
  versioning {
    enabled = true
  }
}