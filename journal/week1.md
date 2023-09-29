# <p align=center>Terraform Beginner Bootcamp 2023 Week 1

## Week 0 Objectives.
The objectives of week 1 where:
- Create the Terraform recommended 'Standard Module Structure' for the project.
- Tag an existing S3 bucket using a 'user_uuid' variable.


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

## Standard Module Structure

In Terraform everything is a module, the main.tf is the root module and must exist in the root folder of the project. The standard module structure<sup>[1]</sup> is a file and folder layout recommend by Terraform which allows for reusable modules distributed in separate repositories. Terraform tooling is built to understand the standard module structure and use that structure to generate documentation, index modules for the module registry, and more.

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

Terraform variables also referred to as Input variables<sup>[2]</sup> let you customise aspects of Terraform modules without altering the module's own source code.

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

```
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
```
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

There may be occasions when your want to bring deployed resources under the control of Terraform. Perhaps, the resources were deployed using others tools or the Terraform state file has been lost. This is when the import<sup>[3]</sup> command 'Terraform import' can help.

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
```
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

```
resource "aws_s3_bucket" "website_bucket" {
}
```

#### providers.tf
```
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.17.0"
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

Configuration drift can occur, if a deployed resource such as a S3 bucket is deleted outside of Terraform. The Terraform state file has then drifted. A 'terraform plan' command would pick up on this drift, and plan to recreate the S3 bucket, as per the state file. To bring the drift back, the 'terraform apply'command can be run. This will create a new S3 bucket, as per the root module.

## External References
- [Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure) <sup>[1]</sup>
- [Input Variables](https://developer.hashicorp.com/terraform/language/values/variables) <sup>[2]</sup>
- [Terraform Import](https://developer.hashicorp.com/terraform/cli/import) <sup>[3]</sup>