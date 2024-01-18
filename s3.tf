provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "static_website" {
  bucket = "s3class51971"

}

resource "aws_s3_bucket_public_access_block" "static_website" {
  bucket = aws_s3_bucket.static_website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false 
  restrict_public_buckets = false 
}
resource "aws_s3_bucket_website_configuration" "s3_bucket" {
  bucket = aws_s3_bucket.static_website.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = aws_s3_bucket.static_website.id
  policy = data.aws_iam_policy_document.s3_bucket_policy.json
}

data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    sid       = "PublicReadGetObject"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::s3class51971/*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }

  version = "2012-10-17"
}


# Upload the files into the bucket
resource "aws_s3_bucket_object" "s3class1971" {
  bucket = aws_s3_bucket.static_website.id
  
  for_each = {
    "audio.mp3"           = "audio/mpeg",
    "index.html"          = "text/html",
    "slide.css"           = "text/css",
    "slide.js"            = "text/javascript",
    "LW2_Guyanese1.jpg"   = "image/jpeg",
    "LW2_Guyanese4.jpg"   = "image/jpeg",
    "LW2_Guyanese6.jpg"   = "image/jpeg"
  }
  
  key          = each.key
  source       = "./${each.key}"
  content_type = each.value
  etag         = filemd5("./${each.key}")
}

output "s3_bucket_url" {
  value = aws_s3_bucket.static_website.website_endpoint
}
