#!/bin/bash

# Set variables
BUCKET_NAME="your-unique-bucket-name-acces247"
REGION="us-east-1"

# Create the S3 bucket
aws s3 mb s3://$BUCKET_NAME --region $REGION

# Enable static website hosting
aws s3 website s3://$BUCKET_NAME/ --index-document index.html --error-document error.html

# Set the bucket policy to make it public
cat > bucket-policy.json <<EOL
{
  "Version":"2012-10-17",
  "Statement":[{
    "Sid":"PublicReadGetObject",
    "Effect":"Allow",
    "Principal": "*",
    "Action":["s3:GetObject"],
    "Resource":["arn:aws:s3:::$BUCKET_NAME/*"]
  }]
}
EOL

aws s3api put-bucket-policy --bucket $BUCKET_NAME --policy file://bucket-policy.json

# Upload website files
aws s3 sync ./static-site s3://$BUCKET_NAME/ --delete

# Output the website endpoint
echo "Website URL: http://$BUCKET_NAME.s3-website-$REGION.amazonaws.com"
