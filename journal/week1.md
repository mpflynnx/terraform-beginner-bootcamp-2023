# <p align=center>Terraform Beginner Bootcamp 2023 Week 1

## Week 1 Objectives.
The objectives of week 1 where:
- Create the Terraform recommended 'Standard Module Structure' for the project.
- Tag an existing S3 bucket using a 'user_uuid' variable.
- Explore configuration drift and how to fix it.
- Understand Terraform import command.
- Refactor the project into modules.
- Setup Static Website Hosting on a S3 bucket.
- Upload files to the S3 bucket using Terraform.
- Create a Content Delivery Network with Amazon CloudFront.
- Understand Local Values.
- Use Origin Access Control to authenticate S3 bucket.
- Setup S3 bucket policy for OAC.
- Understand Data Sources.


<p align="center">
  <img src="../assets/week1.PNG"/>
</p>

# <p align=center>Week 1 Architecture Diagram </p>

# Table of Contents

- [Standard Module Structure](#standard-module-structure)
- [Refactor main.tf file](#refactor-maintf-file)
- [Terraform variables](#terraform-variables)
  - [Variables on the Command Line](#variables-on-the-command-line)
  - [Variable Definitions Files](#variable-definitions-files)
  - [Environment Variables](#environment-variables)
  - [Variable Definition Precedence](#variable-definition-precedence)
  - [Variable validation](#variable-validation)
  - [Tagging a S3 bucket using a variable](#tagging-a-s3-bucket-using-a-variable)
- [Terraform Import](#terraform-import)
  - [Import with Terraform Cloud](#import-with-terraform-cloud)
  - [Configuration drift](#configuration-drift)
  - [Refresh state](#refresh-state)
- [Terraform Modules]()
  - [Module sources](#module-sources)
  - [Provider version constraints](#provider-version-constraints-in-modules)
- [Static website hosting using Amazon S3 buckets](#static-website-hosting-using-amazon-s3-buckets)
- [Using Terraform to configure S3 Bucket for static website hosting](#using-terraform-to-configure-s3-bucket-for-static-website-hosting)
  - [Using Terraform to output the website endpoint](#using-terraform-to-output-the-website-endpoint)
  - [Using Terraform to upload files](#using-terraform-to-upload-files)
  - [Using Terraform to validate the existence of a file](#using-terraform-to-validate-the-existence-of-a-file)
- [Content Delivery Network](#content-delivery-network)
  - [Amazon CloudFront](#amazon-cloudfront)
- [Using Terraform to create a CloudFront Distribution](#using-terraform-to-create-a-cloudfront-distribution)
  - [Local Values](#local-values)
- [Origin Access Control (OAC)](#origin-access-control-oac)
  - [Using Terraform to manage an AWS CloudFront Origin Access Control](#using-terraform-to-manage-an-aws-cloudfront-origin-access-control)
- [Using Terraform to attach a policy to an S3 bucket resource](#using-terraform-to-attach-a-policy-to-an-s3-bucket-resource)
  - [Data Sources](#data-sources)
- [Testing CloudFront distribution](#testing-cloudfront-distribution)



- [External References](#external-references)

## Standard Module Structure

In Terraform everything is a module, the main.tf is the root module and must exist in the root folder of the project. The standard module structure[<sup>[1]</sup>](#external-references) is a file and folder layout recommend by Terraform which allows for reusable modules distributed in separate repositories. Terraform tooling is built to understand the standard module structure and use that structure to generate documentation, index modules for the module registry, and more.

A minimal module should comprise of four files.

```
$ project root/
.
├── README.md
├── main.tf
├── variables.tf
├── outputs.tf
```

- README. This should be named README or README.md. This should be description of the module and it's use case.

- main.tf. This is the primary entrypoint. For a simple module, this may be where all the resources are created.
- variables.tf. This contains declarations for variables.
- outputs.tf. This contains declarations for outputs.
- providers.tf. This is optional, as some teams prefer to use the main.tf for provider configuration.

Terraform reads all *.tf files in the root folder.

## Refactor main.tf file
We will refactor our main.tf into the minimal module structure as recommended.

We will copy the providers block from main.tf and paste it into a new file provider.tf.

We will copy the outputs block from main.tf and paste it into a new file outputs.tf

## Terraform variables
We will create a 'user_uuid' variable and use it to tag our existing S3 bucket. Terraform provides many ways for us to use variables.

Terraform variables also referred to as Input variables[<sup>[2]</sup>](#external-references) let you customise aspects of Terraform modules without altering the module's own source code.

When you declare variables in the root module of your configuration, you can set their values using CLI -var option, environment variables, a .tfvars file or in a Terraform Cloud workspace as Terraform variables.

The variables.tf is where the variable block should be defined.

### Variables on the Command Line

To specify individual variables on the [command line](https://developer.hashicorp.com/terraform/language/values/variables#variables-on-the-command-line), use the -var option when running the terraform plan and terraform apply commands:

```bash
$ terraform apply -var="user-uuid=f2e8e28b-d84a-4fcc-bf5f-ef02e9cb90a4
```

### Variable Definitions Files
To set lots of variables, it is more convenient to specify their values in a [variable definitions file](https://developer.hashicorp.com/terraform/language/values/variables#variable-definitions-tfvars-files) (with a filename ending in either .tfvars or .tfvars.json) and then specify that file on the command line with -var-file. This is how Terraform Cloud passes workspace variables to Terraform.

```bash
$ terraform apply -var-file="myvars.tfvars"
```

Terraform automatically loads a number of variable definitions files if they are present:

- Files named exactly terraform.tfvars or terraform.tfvars.json.
- Any files with names ending in .auto.tfvars or .auto.tfvars.json.

#### terraform.tfvars

```bash
user_uuid="9f8e8039-54b8-42c0-bacb-636ef11aa235"
```

### Environment Variables
As a fallback for the other ways of defining variables, Terraform searches the environment of its own process for [environment variables](https://developer.hashicorp.com/terraform/language/values/variables#environment-variables) named TF_VAR_ followed by the name of a declared variable.

```bash
$ export TF_VAR_user_uuid="cc27002f-b88e-4f1e-9ffb-9cd3fc4eceb3"
```

### Variable Definition Precedence
Terraform loads variables in the following order, with later sources taking precedence over earlier ones:

- Environment variables
- The terraform.tfvars file, if present.
- The terraform.tfvars.json file, if present.
- Any *.auto.tfvars or *.auto.tfvars.json files, processed in lexical order of their filenames.
- Any -var and -var-file options on the command line, in the order they are provided. (This includes variables set by a Terraform Cloud workspace.)

**Note:** Files of type *.tfvars, *.tfvars.json are ignored and not stored in git version control.

### Variable validation

You can specify [custom validation rules](https://developer.hashicorp.com/terraform/language/values/variables#custom-validation-rules) for a particular variable by adding a validation block within the corresponding variable block. 
The example below checks whether the user_uuid has the correct syntax.

#### variables.tf

```
variable "user_uuid" {
  type        = string
  description = "The UUID for the user"

  validation {
    condition     = can(regex("^\\w{8}-\\w{4}-\\w{4}-\\w{4}-\\w{12}$", var.user_uuid))
    error_message = "Invalid UUID format. Please provide a valid UUID."
  }
}
```

### Tagging a S3 bucket using a variable

We have previously ran 'tf plan', and deployed a S3 bucket. The state file is stored in Terraform Cloud.

We will tag the existing S3 bucket with a variable named 'user_uuid'. The 'variables.tf' file defines and validates the value of the 'user_uuid' provided in the 'terraform.tfvars' file.

To tag an S3 bucket we update the 'main.tf' files resource block with the tag block shown below.

####  main.tf
```tf
resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name

  tags = {
    UserUuid = var.user_uuid
  }
}
```

Run the following commands to tag the existing S3 bucket.

```bash
$ tf init
```
```bash
$ tf plan
```
```bash
$ tf apply --auto-approve
```

The tagging should complete successfully.

Check the tag of the S3 bucket with the following AWS CLI command:

```bash
$ aws s3api get-bucket-tagging --bucket lqqal0mpw69mtr21jx1jpuid5utwlego
```

## Terraform import

There may be occasions when your want to bring deployed resources under the control of Terraform. Perhaps, the resources were deployed using others tools or the Terraform state file has been lost. This is when the import[<sup>[3]</sup>](#external-references) command 'Terraform import' can help.

There are some limitation to the import command. For example not all resources can be imported, the provider documentation needs to be read, to determine if your deployed resources can be imported.

Terraform import CLI command can only import resources in the the state file. You must manually write a resource configuration block for the resource. The resource block describes where Terraform should map the imported object.

### Import with Terraform Cloud
If you have set up Terraform Cloud, then most CLI commands run on the Terraform Cloud environment. However, the 'import' command runs locally, so any variables set in Terraform Cloud such as AWS credentials will not be available. You need to set the AWS credentials locally to successfully use the 'import' command. Note: If using Gitpod you may have these already set locally, check using the command below:

```bash
$ env | grep AWS_
```

To set the variables locally, use the command example below, substituting the fake values for your real AWS credentials.

```bash
$ export AWS_ACCESS_KEY_ID='AKIAIOSFODNN7EXAMPLE'
$ export AWS_SECRET_ACCESS_KEY='wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY'
$ export AWS_DEFAULT_REGION='us-west-2'
```

### Importing an S3 bucket into Terraform

If you wish to bring existing infrastructure under the management of Terraform. You can use the import command or create a import block. Imports blocks are predicable and work with CICD pipelines and let you preview an import before modifying the state.

I have a existing S3 bucket, that I wish to bring under the control of a local Terraform backend. Firstly I create a new file called imports.tf

#### imports.tf
```tf
import {
  to = aws_s3_bucket.website_bucket
  id = "terraform-20230928133942847400000001"
}
```

The above import block defines an import of the AWS instance with the ID "terraform-20230928133942847400000001" into the aws_s3_bucket.website_bucket resource in the root module (main.tf).

The import block has the following arguments:

- to - The instance address this resource will have in your state file.
- id - A string with the import ID of the resource.

#### main.tf

```tf
resource "aws_s3_bucket" "website_bucket" {
}
```

#### providers.tf
```tf
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.19.0"
    }
  }
}
provider "aws" {
}
```

Terraform only needs to import a given resource once. You can remove import blocks after completing the import or safely leave them in your configuration as a record of the resource's origin for future module maintainers

Commands needed to import S3 bucket.

```bash
$ tf init // create new local backend
```
```bash
$ tf plan // view the plan
```
```bash
$ tf apply --auto-approve // apply the plan
```

The local state file should be created and the S3 bucket is now under local backend Terraform management.

### Configuration drift

Configuration drift can occur, if a deployed resource such as a S3 bucket is deleted outside of Terraform. The Terraform state file has then drifted. A 'terraform plan' command would pick up on this drift, and plan to recreate the S3 bucket, as per the state file. To bring the drift back, the 'terraform apply' command can be run. This will create a new S3 bucket, as per the root module.

### Refresh state
In Terraform, refreshing your state file updates Terraform's knowledge of your infrastructure, as represented in your state file, with the actual state of your infrastructure. Terraform plan and apply operations run an implicit in-memory refresh as part of their functionality, reconciling any drift from your state file before suggesting infrastructure changes. You can also update your state file without making modifications to your infrastructure using the -refresh-only flag for plan and apply operations.

```bash
$ tf plan -refresh-only
$ tf apply -refresh-only -auto-approve
```

## Terraform Modules
Modules[<sup>[4]</sup>](#external-references) are containers for multiple resources that are used together. A module consists of a collection of .tf and/or .tf.json files kept together in a folder.

Modules are the main way to package and reuse resource configurations with Terraform.

We will refactor the project to use nested modules. We will create one module for our 'terrahouse' and two nested modules, one for the storage resources and one for the content delivery resources.

```
$ project root/
.
├── README.md
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── modules/
   ├── terrahouse_aws/
       ├── README.md
       ├── variables.tf
       ├── main.tf
       ├── outputs.tf
       ├── LICENSE
```

Notice, that the root module must contain outputs.tf and variables.tf as well as the nested module 'terrahouse_aws'. The variables and outputs need to be defined in the root module as well as the nested module.

### Accessing Child Module Outputs
In a parent module, outputs of child modules are available in expressions as module.MODULE NAME.OUTPUT NAME. As shown below.

#### Root module outputs.tf example
```tf
output "bucket_name" {
  description = "Bucket name for our static website hosting"
  value = module.terrahouse_aws.bucket_name
}
```
Because the output values of a module are part of its user interface, you can briefly describe the purpose of each value using the optional 'description' argument.

#### Nested module outputs.tf example
```tf
output "bucket_name" {
  description = "Bucket name for our static website hosting"
  value = aws_s3_bucket.website_bucket.bucket
}
```

### Declaring an Input Variable
Variables do not require validation at the root module level. Only validate at the nested module level.

#### Root module variables.tf example
```tf
variable "user_uuid" {
 description = "The UUID of the user"
 type = string
}
```

At the root and nested module level, you can briefly describe the purpose of each variable using the optional 'description' argument.

#### nested module variables.tf example
```tf
variable "user_uuid" {
  description = "The UUID of the user"
  type        = string
  validation {...not shown for brevity
  ...
  }
}
```

### Module Sources

The source[<sup>[5]</sup>](#external-references) argument in a module block tells Terraform where to find the source code for the desired child module.

Terraform uses this during the module installation step of terraform init to download the source code to a directory on local disk so that other Terraform commands can use it.

The module installer supports installation from a number of different source types.

- Local paths

- Terraform Registry

- GitHub

- Bitbucket

- Generic Git, Mercurial repositories

- HTTP URLs

- S3 buckets

- GCS buckets

- Modules in Package Sub-directories

#### Root module main.tf example using local path source type
```tf
terraform {
}

module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}
```

A local path must begin with either ./ or ../ to indicate that a local path is intended, to distinguish from a module registry address.

### Provider Version Constraints in Modules

Although provider configurations[<sup>[6]</sup>](#external-references) are shared between modules, each module must declare its own provider requirements, so that Terraform can ensure that there is a single version of the provider that is compatible with all modules in the configuration and to specify the source address that serves as the global (module-agnostic) identifier for a provider.

To declare that a module requires particular versions of a specific provider, use a required_providers block inside a terraform block.


#### Nested module main.tf example
```tf
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.19.0"
    }
  }
}

resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name
  tags = {
    UserUuid = var.user_uuid
  }
}
```

A provider requirement says, for example, "This module requires version v5.19.0 of the provider hashicorp/aws and will refer to it as aws.

## Static website hosting using Amazon S3 buckets

You can use Amazon S3 to host a static website[<sup>[7]</sup>](#external-references). On a static website, individual webpages include static content. They might also contain client-side scripts.

When you configure a bucket as a static website, you must enable static website hosting, configure an index document[<sup>[8]</sup>](#external-references), and set permissions.

 An index document is a webpage that Amazon S3 returns when a request is made to the root of a website or any subfolder. For example, if a user enters http://www.example.com in the browser, the user is not requesting any specific page. In that case, Amazon S3 serves up the index document, which is sometimes referred to as the default page.

 After you configure your bucket as a static website, when an error occurs, Amazon S3 returns an HTML error document. You can optionally configure your bucket with a custom error document[<sup>[9]</sup>](#external-references) so that Amazon S3 returns that document when an error occurs.

 When you configure your bucket as a static website, the website is available at the AWS Region-specific website endpoint[<sup>[10]</sup>](#external-references) of the bucket. 

 ## Using Terraform to configure S3 Bucket for static website hosting

 To configure an S3 bucket as a static website we can use the AWS provider resource [aws_s3_bucket_website_configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration). 
 
 **Caution:** Provider resources can change frequently, it is best practice to always refer to the latest documentation for the provider at [registry.terraform.io](https://registry.terraform.io/)

#### Example resource block (provider version 5.19.0)
 ```tf
 resource "aws_s3_bucket_website_configuration" "website_configuration" {
  bucket = aws_s3_bucket.website_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}
 ```

For our project we can append this resource block to the main.tf of the nested module 'terrahouse_aws'.

### Using Terraform to output the website endpoint
The AWS provider resource [aws_s3_bucket_website_configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) exports an attribute called 'website_endpoint'. We can use this to output the Amazon S3 website endpoint, this will be the webpage that will display the index.html.

For our project we can append the output block shown below to the outputs.tf of the nested module 'terrahouse_aws'.

#### Example nested module resource block (provider version 5.19.0)
```tf
output "website_endpoint" {
    description = "S3 Static Website hosting endpoint"
  value = aws_s3_bucket_website_configuration.website_configuration.website_endpoint
}
```

We also need to append an output block (shown below) to our root module outputs.tf file.

#### Example root module resource block (provider version 5.19.0)
```tf
output "s3_website_endpoint" {
  description = "S3 Static Website hosting endpoint"
  value = module.terrahouse_aws.website_endpoint
}
```

#### Example console output for s3_website_endpoint
```bash
Outputs:

s3_website_endpoint = "terraform-20230928133942847400000001.s3-website.eu-west-2.amazonaws.com"
```

### Using Terraform to upload files

The AWS provider resource [aws_s3_object](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) can be used to upload a file to an S3 bucket. We can use this to upload the index.html and error.html files for our S3 hosted static website. 

**Note:** It is best practice for Terraform to be used to provision cloud infrastructure only. Uploading files should be handled by another method or application in a production environment. 

#### Example nested module resource block (provider version 5.19.0)

```tf
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = var.index_html_path
  content_type = "text/html"

  etag = filemd5(var.index_html_path)
}
```
It is best practice to define the content_type of the file, by using the [content_type](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object#content_type) argument.  Standard MIME types are supported. All Valid MIME Types are valid for this input. As we know our file contains html we use "text/html". Terraform can detect changes to the content_type argument.

By default, Terraform cannot detect any changes to a files contents. Therefore, we can add an [etag](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/ETag) to the file. The value of the etag will be the files md5 sum check. As the md5 sum check will change every time the file changes. Terraform does check for changes to the etag.

Terraform has many [built-in functions](https://developer.hashicorp.com/terraform/language/expressions/function-calls). We will use the [filemd5](https://developer.hashicorp.com/terraform/language/functions/filemd5) function. 'filemd5' is a variant of md5 that hashes the contents of a given file rather than a literal string. This function will only accept UTF-8 text it cannot be used to create hashes for binary files.

### Using Terraform to validate the existence of a file

It is best practice to define files and file paths as Terraform variables. We can then validate the variable with a validation block in the nested modules variables.tf. 

The Terraform built-in function [fileexists](https://developer.hashicorp.com/terraform/language/functions/fileexists) checks that a file already exists on the disk.

We will store our file path as a variable in the terraform.tfvars file.

```
index_html_path="/workspace/terraform-beginner-bootcamp-2023/public/index.html"
```

#### Example nested module variable block (Terraform version v1.5.x)

```tf
variable "index_html_path" {
  description = "The file path for index.html"
  type        = string

  validation {
    condition     = fileexists(var.index_html_path)
    error_message = "File index.html does not exist."
  }
}
```
Nested module variables must also be defined in the root module main.tf.

#### Example root module main.tf with nested module variable definition (Terraform version v1.5.x)
```tf
terraform {
}

module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
  index_html_path = var.index_html_path
  error_html_path = var.error_html_path
}
```

## Content Delivery Network

A content delivery network (CDN)[<sup>[11]</sup>](#external-references) is a network of interconnected servers that speeds up webpage loading for data-heavy applications. CDN can stand for content delivery network or content distribution network. When a user visits a website, data from that website's server has to travel across the internet to reach the user's computer. If the user is located far from that server, it will take a long time to load a large file, such as a video or website image. Instead, the website content is stored on CDN servers geographically closer to the users and reaches their computers much faster.

### Amazon CloudFront

Amazon CloudFront is a content delivery network (CDN) service built for high performance, security, and developer convenience. Amazon CloudFront[<sup>[12]</sup>](#external-references) is a web service that speeds up distribution of static and dynamic web content, such as .html, .css, .js, and image files.

The major reason we are using Amazon CloudFront for our project is the improved security and access controls available with no additional charges.

By default Amazon S3 buckets are not publicly accessible. By routing our static website thru CloudFront we can attach
security services and use Origin Access Controls while still keeping the S3 bucket data private.

## Using Terraform to create a CloudFront distribution

To make our Terraform project folder more manageable, we will refactor our nested module main.tf into two separate files. One file (resource_s3.tf) will deal with the Amazon S3 resources and the second file (resource_cdn.tf) will deal with the Amazon CloudFront resources.

#### Project folder after refactor
```
$ project root/
.
├── README.md
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── modules/
   ├── terrahouse_aws/
       ├── resource_cdn.tf
       ├── resource_s3.tf   
       ├── README.md
       ├── variables.tf
       ├── main.tf
       ├── outputs.tf
       ├── LICENSE
```


We want to use CloudFront to distribute our content, so we have to create a distribution[<sup>[13]</sup>](#external-references). We will create a CloudFront distribution to tell CloudFront we want content to be delivered from our S3 bucket.

To create a CloudFront distribution we can use the AWS provider resource [aws_cloudfront_distribution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution).

**Note:** CloudFront distributions take about 15 minutes to reach a deployed state after creation or modification. During this time, deletes to resources will be blocked.

Caution: Provider resources can change frequently, it is best practice to always refer to the latest documentation for the provider at registry.terraform.io

#### resource_cdn.tf

```tf
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.website_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Static website hosting for: ${var.bucket_name}"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  tags = {
    UserUuid = var.user_uuid
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

```

### Local Values

In the aws_cloudfront_distribution resource block there is the following text 'local.s3_origin_id' used in multiple places. This is known as a [Local Value](https://developer.hashicorp.com/terraform/language/values/locals) or 'Locals' in Terraform. A local value assigns a name to an expression, so you can use the name multiple times within a module instead of repeating the expression.

Local values are created by a locals block (plural), but you reference them as attributes on an object named local (singular).

A local value can only be accessed in expressions within the module where it was declared. Therefore the example below should appear in the same file as the aws_cloudfront_distribution resource block were it is accessed.

#### resource_cdn.tf
```tf
locals {
  s3_origin_id = "MyS3Origin"
}
```

## Origin Access Control (OAC)

CloudFront provides two ways to send authenticated requests to an Amazon S3 origin: origin access control (OAC)[<sup>[14]</sup>](#external-references) and origin access identity (OAI). As of October 2023 Amazon recommends OAC over OAI, because it supports:

- All Amazon S3 buckets in all AWS Regions, including opt-in Regions launched after December 2022

- Amazon S3 server-side encryption with AWS KMS (SSE-KMS)

- Dynamic requests (PUT and DELETE) to Amazon S3

To give the OAC permission to access the S3 bucket, use an S3 bucket policy to allow the CloudFront service principal (cloudfront.amazonaws.com) to access the bucket. Use a Condition element in the policy to allow CloudFront to access the bucket only when the request is on behalf of the CloudFront distribution that contains the S3 origin.

### Using Terraform to manage an AWS CloudFront Origin Access Control

We can use the AWS provider resource [aws_cloudfront_origin_access_control](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control) to manage an AWS CloudFront Origin Access Control. An OAC is used by CloudFront Distributions with an Amazon S3 bucket as the origin.

#### resource_cdn.tf
```tf
resource "aws_cloudfront_origin_access_control" "default" {
  name = "OAC ${var.bucket_name}"
  description = "Origin Access Controls for Static Website Hosting ${var.bucket_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior = "always"
  signing_protocol = "sigv4"
}
```

## Using Terraform to attach a policy to an S3 bucket resource

To attach a policy to our S3 bucket we can use the AWS provider resource [aws_s3_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy).

#### resource_s3.tf
```tf
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = (..Text of the policy..)
}

```

This resource supports the following arguments:

- bucket - (Required) Name of the bucket to which to apply the policy.
- policy - (Required) Text of the policy. Although this is a bucket policy rather than an IAM policy, the [aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) data source may be used, so long as it specifies a principal. For more information about building AWS IAM policy documents with Terraform, see the [AWS IAM Policy Document Guide](https://learn.hashicorp.com/terraform/aws/iam-policy). Note: Bucket policies are limited to 20 KB in size.

In Terraform v1.5.0 and later, you can use an [import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy#import) block to import S3 bucket policies using the bucket name. 

We will not import the policy but define it as a multi-line heredoc string inside a aws_s3_bucket_policy resource block.

The following [example](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-s3.html) is an S3 bucket policy that allows CloudFront Origin Access Control (OAC) to access an S3 origin.

#### Example S3 bucket policy that allows read-only access to a CloudFront OAC
```json
{
    "Version": "2012-10-17",
    "Statement": {
        "Sid": "AllowCloudFrontServicePrincipalReadOnly",
        "Effect": "Allow",
        "Principal": {
            "Service": "cloudfront.amazonaws.com"
        },
        "Action": "s3:GetObject",
        "Resource": "arn:aws:s3:::<S3 bucket name>/*",
        "Condition": {
            "StringEquals": {
                "AWS:SourceArn": "arn:aws:cloudfront::<AWS account ID>:distribution/<CloudFront distribution ID>"
            }
        }
    }
}
```

For simple policies or one-off configurations, we can use the above example inside of aws_s3_bucket_policy resource block as a multi-line heredoc string. To use the example, first the json syntax needs refactoring into HCL syntax. In this case the : (colon) is replaced with = (equals) symbol. 

We can also use ${...}-style notation interpolation for policy variables to save hardcoding.

We can wrap the policy inside the Terraform built-in function [jsonencode](https://developer.hashicorp.com/terraform/language/functions/jsonencode). This function maps [Terraform language values](https://developer.hashicorp.com/terraform/language/expressions/types) to JSON values. Therefore passing the policy into the correct JSON syntax when you run the 'terraform apply' command.

#### Refactored S3 bucket policy in HCL syntax
```tf
 1  {
 2      "Version" = "2012-10-17",
 3      "Statement" = {
 4          "Sid" = "AllowCloudFrontServicePrincipalReadOnly",
 5          "Effect" = "Allow",
 6          "Principal" = {
 7              "Service" = "cloudfront.amazonaws.com"
 8          },
 9          "Action" = "s3:GetObject",
10          "Resource" = "arn:aws:s3:::<S3 bucket name>/*",
11          "Condition" = {
12              "StringEquals" = {
13                  "AWS:SourceArn" = "arn:aws:cloudfront::<AWS account ID>:distribution/<CloudFront distribution ID>"
14              }
15          }
16     }
17  }
```

In the above example of an S3 bucket policy, we must provide the 'S3 bucket' name at line 10, the 'AWS account ID' and 'CloudFront distribution ID' at line 13.

We can use ${...}-style notation interpolation for these to prevent hardcoding.

The S3 bucket name can be obtained from provider resource 'aws_s3_bucket' reference and id. 
```tf
${aws_s3_bucket.website_bucket.id}
```

The AWS account ID can be obtained using [AWS provider Data Source: aws_caller_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity)

This data source exports the following attributes:

- account_id - AWS Account ID number of the account that owns or contains the calling entity.
- arn - ARN associated with the calling entity.
- id - Account ID number of the account that owns or contains the calling entity.
- user_id - Unique identifier of the calling entity.

### Data Sources
Data sources[<sup>[15]</sup>](#external-references) allow Terraform to use information defined outside of Terraform. Each provider may offer data sources alongside its set of resource types.

A data source is accessed via a special kind of resource known as a data resource, declared using a data block:


#### main.tf (nested module)
```tf
data "aws_caller_identity" "current" {}
```

A data block requests that Terraform read from a given data source ("aws_caller_identity") and export the result under the given local name ("current"). The name is used to refer to this resource from elsewhere in the same Terraform module, but has no significance outside of the scope of a module.

With Data Sources we can use interpolation in the bucket policy to define the AWS account ID:

```tf
${data.aws_caller_identity.current.account_id}
```

We can obtain the CloudFront distribution ID using the provider resource [aws_cloudfront_distribution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) reference and id.

```tf
${aws_cloudfront_distribution.s3_distribution.id}
```

Therefore the completed line13 would be:

```tf
13   "AWS:SourceArn" = "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.s3_distribution.id}"

```

Alternatively, we could have used the "caller arn" from the [AWS provider Data Source: aws_caller_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity). 

Therefore the completed line13 would be:

```tf
13   "AWS:SourceArn" = data.aws_caller_identity.current.arn

```

### Testing CloudFront distribution
After modifying the project files accordingly, we can now attempt to apply the Terraform project.

As seen before we should run the following
commands in the terminal:

```bash
$ tf init
```

```bash
$ tf plan
```

#### Expected console output after 'tf plan'
```bash
.
.
Plan: 7 to add, 0 to change, 0 to destroy.
.
.
```

```bash
$ tf apply --auto-approve
```

#### Expected console output

```bash
.
.
Apply complete! Resources: 7 added, 0 changed, 0 destroyed.
.
.
```

We should now login as a non-root user in the [AWS Management Console](https://aws.amazon.com/console/).

1. Navigate to CloudFront
1. Select the new Distribution
1. Under Details, copy to clipboard the Distribution domain name

#### Example: Distribution domain name
```
https://d199pk5tx04fnx.cloudfront.net
```

1. Open a new browser tab and paste the Distribution domain name and press enter.

1. You should now be presented with the contents of the public/index.html file.

This validates the OAC and S3 bucket policy.

You can view the S3 bucket policy in the [AWS Management Console](https://aws.amazon.com/console/) by navigating to Amazon S3, selecting the new bucket.
Click on Permissions, scroll down to view the bucket policy.

Now tear down the deployed infrastructure with:

```bash
$ tf destroy --auto-approve
```

#### Expected console output

```bash
.
.
Destroy complete! Resources: 7 destroyed.
.
.
```

## External References
- [Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure) <sup>[1]</sup>
- [Input Variables](https://developer.hashicorp.com/terraform/language/values/variables) <sup>[2]</sup>
- [Terraform Import](https://developer.hashicorp.com/terraform/cli/import) <sup>[3]</sup>
- [Terraform Modules](https://developer.hashicorp.com/terraform/language/modules) <sup>[4]</sup>
- [Module Sources](https://developer.hashicorp.com/terraform/language/modules/sources) <sup>[5]</sup>
- [Provider Version Constraints in Modules](https://developer.hashicorp.com/terraform/language/modules/develop/providers#provider-version-constraints-in-modules) <sup>[6]</sup>
- [Hosting a static website using Amazon S3](https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html) <sup>[7]</sup>
- [Configuring an index document](https://docs.aws.amazon.com/AmazonS3/latest/userguide/IndexDocumentSupport.html) <sup>[8]</sup>
- [Configuring a custom error document](https://docs.aws.amazon.com/AmazonS3/latest/userguide/CustomErrorDocSupport.html) <sup>[9]</sup>
- [Static website endpoints](https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteEndpoints.html) <sup>[10]</sup>
- [What Is A CDN (Content Delivery Network)?](https://aws.amazon.com/what-is/cdn/) <sup>[11]</sup>
- [What is Amazon CloudFront?](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Introduction.html) <sup>[12]</sup>
- [Working with distributions](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/distribution-working-with.html) <sup>[13]</sup>
- [Restricting access to an Amazon S3 origin](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-s3.html) <sup>[14]</sup>
- [Data Sources](https://developer.hashicorp.com/terraform/language/data-sources) <sup>[15]</sup>
