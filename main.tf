## Managed By : CloudDrove
# Description : This Script is used to create S3.
## Copyright @ CloudDrove. All Right Reserved.

# Module      : S3 BUCKET
# Description : Terraform module to create default S3 bucket with logging and encryption
#               type specific features.
resource "aws_s3_bucket" "s3_default" {
  count = var.create_bucket && var.bucket_enabled == true ? 1 : 0

  bucket        = var.name
  force_destroy = var.force_destroy
  acl           = var.acl

  dynamic "cors_rule" {
    for_each = var.cors_rule_inputs == null ? [] : var.cors_rule_inputs

    content {
      allowed_headers = cors_rule.value.allowed_headers
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      expose_headers  = cors_rule.value.expose_headers
    }
  }

  versioning {
    enabled = var.versioning
  }

  lifecycle_rule {
    id      = "transition-to-infrequent-access-storage"
    enabled = var.lifecycle_infrequent_storage_transition_enabled

    prefix = var.lifecycle_infrequent_storage_object_prefix

    transition {
      days          = var.lifecycle_days_to_infrequent_storage_transition
      storage_class = "STANDARD_IA"
    }
  }

  lifecycle_rule {
    id      = "transition-to-glacier"
    enabled = var.lifecycle_glacier_transition_enabled

    prefix = var.lifecycle_glacier_object_prefix

    transition {
      days          = var.lifecycle_days_to_glacier_transition
      storage_class = "GLACIER"
    }
  }

  lifecycle_rule {
    id      = "expire-objects"
    enabled = var.lifecycle_expiration_enabled

    prefix = var.lifecycle_expiration_object_prefix

    expiration {
      days = var.lifecycle_days_to_expiration
    }
  }

  tags = var.tags

}

# Module      : S3 BUCKET POLICY
# Description : Terraform module which creates policy for S3 bucket on AWS
resource "aws_s3_bucket_policy" "s3_default" {
  count = var.create_bucket && var.bucket_policy && var.bucket_enabled == true ? 1 : 0

  bucket = aws_s3_bucket.s3_default[count.index].id
  policy = var.aws_iam_policy_document
}

# Module      : S3 BUCKET
# Description : Terraform module which creates S3 bucket resource for launching static
#               website on AWS
resource "aws_s3_bucket" "s3_website" {
  count = var.create_bucket && var.website_hosting_bucket == true ? 1 : 0

  bucket        = var.name
  force_destroy = var.force_destroy
  acl           = var.acl

  versioning {
    enabled = var.versioning
  }

  website {
    index_document = var.website_index
    error_document = var.website_error
  }

  lifecycle_rule {
    id      = "transition-to-infrequent-access-storage"
    enabled = var.lifecycle_infrequent_storage_transition_enabled

    prefix = var.lifecycle_infrequent_storage_object_prefix

    transition {
      days          = var.lifecycle_days_to_infrequent_storage_transition
      storage_class = "STANDARD_IA"
    }
  }

  lifecycle_rule {
    id      = "transition-to-glacier"
    enabled = var.lifecycle_glacier_transition_enabled

    prefix = var.lifecycle_glacier_object_prefix

    transition {
      days          = var.lifecycle_days_to_glacier_transition
      storage_class = "GLACIER"
    }
  }

  lifecycle_rule {
    id      = "expire-objects"
    enabled = var.lifecycle_expiration_enabled

    prefix = var.lifecycle_expiration_object_prefix

    expiration {
      days = var.lifecycle_days_to_expiration
    }
  }

  tags = var.tags

}

# Module      : S3 BUCKET POLICY
# Description : Terraform module which creates policy for S3 bucket which is used for
#               static website on AWS
resource "aws_s3_bucket_policy" "s3_website" {
  count = var.create_bucket && var.bucket_policy && var.website_hosting_bucket == true ? 1 : 0

  bucket = aws_s3_bucket.s3_website[count.index].id
  policy = var.aws_iam_policy_document
}

# Module      : S3 BUCKET
# Description : Terraform module which creates S3 bucket with logging resource on AWS
resource "aws_s3_bucket" "s3_logging" {
  count = var.create_bucket && var.bucket_logging_enabled == true ? 1 : 0

  bucket        = var.name
  force_destroy = var.force_destroy
  acl           = var.acl

  versioning {
    enabled = var.versioning
  }

  lifecycle_rule {
    id      = "transition-to-infrequent-access-storage"
    enabled = var.lifecycle_infrequent_storage_transition_enabled

    prefix = var.lifecycle_infrequent_storage_object_prefix

    transition {
      days          = var.lifecycle_days_to_infrequent_storage_transition
      storage_class = "STANDARD_IA"
    }
  }

  lifecycle_rule {
    id      = "transition-to-glacier"
    enabled = var.lifecycle_glacier_transition_enabled

    prefix = var.lifecycle_glacier_object_prefix

    transition {
      days          = var.lifecycle_days_to_glacier_transition
      storage_class = "GLACIER"
    }
  }

  lifecycle_rule {
    id      = "expire-objects"
    enabled = var.lifecycle_expiration_enabled

    prefix = var.lifecycle_expiration_object_prefix

    expiration {
      days = var.lifecycle_days_to_expiration
    }
  }
  logging {
    target_bucket = var.target_bucket
    target_prefix = var.target_prefix
  }

  tags = var.tags

}

# Module      : S3 BUCKET POLICY
# Description : Terraform module which creates policy for S3 bucket logging on AWS
resource "aws_s3_bucket_policy" "s3_logging" {
  count = var.create_bucket && var.bucket_policy && var.bucket_logging_enabled == true ? 1 : 0

  bucket = aws_s3_bucket.s3_logging[count.index].id
  policy = var.aws_iam_policy_document
}

# Module      : S3 BUCKET
# Description : Terraform module which creates S3 bucket with encryption resource on AWS
resource "aws_s3_bucket" "s3_encryption" {
  count = var.create_bucket && var.encryption_enabled == true ? 1 : 0

  bucket        = var.name
  force_destroy = var.force_destroy
  acl           = var.acl

  versioning {
    enabled = var.versioning
  }

  lifecycle_rule {
    id      = "transition-to-infrequent-access-storage"
    enabled = var.lifecycle_infrequent_storage_transition_enabled

    prefix = var.lifecycle_infrequent_storage_object_prefix

    transition {
      days          = var.lifecycle_days_to_infrequent_storage_transition
      storage_class = "STANDARD_IA"
    }
  }

  lifecycle_rule {
    id      = "transition-to-glacier"
    enabled = var.lifecycle_glacier_transition_enabled

    prefix = var.lifecycle_glacier_object_prefix

    transition {
      days          = var.lifecycle_days_to_glacier_transition
      storage_class = "GLACIER"
    }
  }

  lifecycle_rule {
    id      = "expire-objects"
    enabled = var.lifecycle_expiration_enabled

    prefix = var.lifecycle_expiration_object_prefix

    expiration {
      days = var.lifecycle_days_to_expiration
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = var.sse_algorithm
        kms_master_key_id = var.kms_master_key_id
      }
    }
  }

  tags = var.tags

}

# Module      : S3 BUCKET POLICY
# Description : Terraform module which creates policy for S3 bucket encryption on AWS
resource "aws_s3_bucket_policy" "s3_encryption" {
  count = var.create_bucket && var.bucket_policy && var.encryption_enabled == true ? 1 : 0

  bucket = aws_s3_bucket.s3_encryption[count.index].id
  policy = var.aws_iam_policy_document
}
