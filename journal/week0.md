# <p align=center>Terraform Beginner Bootcamp 2023 Week 0

## Week 0 Objectives.
The objectives of week 0 where:
- Register for an AWS account.
- Setup an IAM user in AWS.
- Create AWS access keys for use with Terraform Cloud.
- Register and setup Gitpod development environment
- Customise the Gitpod development environment with installation scripts for Terraform CLI and AWS CLI applications
- Register a Terraform Cloud account.
- Setup Terraform Cloud, create new project and workspace.
- Setup Terraform Cloud workspace variables for AWS
- Use Terraform Random Provider to generate a unique AWS S3 bucket name.
- Use Terraform AWS provider to provision an AWS S3 bucket.
- Terraform state file stored safely in Terraform Cloud.


<p align="center">
  <img src="../assets/week0.png"/>
</p>

# <p align=center>Week 0 Architecture Diagram </p>

# Table of Contents

- [Project Git flow](#project-git-flow)
- [Semantic Versioning](#semantic-versioning)
- [Gitpod development platform](#gitpod-development-platform)
  - [Execution order](#execution-order)
  - [Restart a Workspace](#restart-a-workspace)
- [Terraform](#terraform)
  - [Terraform providers](#terraform-providers)
  - [Terraform modules](#terraform-providers)
- [Terraform CLI](#terraform-cli)
  - [Installation of Terraform CLI in Gitpod workspace](#installation-of-terraform-cli-in-gitpod-workspace)
  - [Bash script files](#bash-script-files)
  - [Script file execution](#script-file-execution)
  - [File permissions](#file-permissions)
  - [File protection](#file-protection)
  - [install_terraform_cli script](#install_terraform_cli-script)
  - [Refactor the .gitpod.yml file](#refactor-the-gitpodyml-file-for-install_terraform_cli)
  - [Refactor Terraform installation script](#refactor-terraform-installation-script)
  - [Environmental variables](#environmental-variables1)
  - [Gitpod environmental variables](#gitpod-environmental-variables)
  - [Terraform CLI fundamentals](#terraform-cli-fundamentals)
  - [Cloud provider resource names](#cloud-provider-resource-names)
  - [A simple main.tf example](#a-simple-maintf-example)
  - [Terraform basic usage example](#terraform-basic-usage-example)
  - [Terraform files and version control](#terraform-files-and-version-control)
- [AWS CLI](#aws-cli)
  - [AWS IAM User credentials](#aws-iam-user-credentials)
  - [Creating a IAM user using the aws web console](#creating-a-iam-user-using-the-aws-web-console)
  - [Adding AWS User credentials to Gitpod workspace](#adding-aws-user-credentials-to-gitpod-workspace)
  - [Retrieve the real values for IAM User](#retrieve-the-real-values-for-iam-user)
  - [Installation of AWS CLI in Gitpod workspace](#installation-of-aws-cli-in-gitpod-workspace)
  - [Test the AWS credentials](#test-the-aws-credentials)
  - [Refactor the .gitpod.yml file](#refactor-the-gitpodyml-file-to-use-the-aws-cli-install-script)
  - [Terraform and AWS](#terraform-and-aws)
  - [Authentication and Configuration](#authentication-and-configuration)
  - [AWS S3 Bucket](#aws-s3-bucket)
  - [Creating a bucket](#creating-a-bucket)
  - [Creating a bucket with Terraform](#creating-a-bucket-with-terraform)
- [Terraform Cloud](#terraform-cloud)
  - [Terraform Cloud pricing](#terraform-cloud-pricing)
  - [Register for a new Terraform Cloud account](#register-for-a-new-terraform-cloud-account)
  - [Configure Terraform Cloud](#configure-terraform-cloud)
  - [Create an API Token](#create-an-api-token)
  - [Gitpod problems with Terraform login command](#gitpod-problems-with-terraform-login-command)
  - [generate_tfrc_credentials bash script](#generate_tfrc_credentials-bash-script)
  - [Terraform Cloud Workspace variables](#terraform-cloud-workspace-variables)
  - [Adding Workspace-specific Variables](#adding-workspace-specific-variables)
  - [Terraform Cloud setup confirmation](#terraform-cloud-setup-confirmation)
  - [Terraform cli convenience bash alias](#terraform-cli-convenience-bash-alias)
- [External References](#external-references)
  

## Project Git flow

This project is going to utilise the issue, feature branch, pull request, tag GitHub workflow.

Issues should be created in GitHub. Then feature branches created to work on the issue.
Pull requests are to be used to merge the completed feature branch into main branch. Then the main branch tag is updated using semantic versioning.

## Semantic Versioning

This project is going to utilise semantic versioning for its tagging.

[semver.org](https://semver.org/)

The general format:

**MAJOR.MINOR.PATCH**, eg `1.0.1`

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes
Additional labels for pre-release and build metadata are available as extensions to the MAJOR.MINOR.PATCH format.

As a deviation from common best practice using semver. The GitHub tag MAJOR version will be the same as the bootcamp
week number. Therefore all tags with MAJOR 0, i.e 0.7.0 are for week 0. MAJOR 1, i.e 1.1.0 are for week1 etc.

## Gitpod development platform

This project shall utilise the [Gitpod](https://www.gitpod.io/) development platform.

The environment is built for the project by defining tasks in the [.gitpod.yml]() configuration file.

With Gitpod, you have the following three types of [tasks](https://www.gitpod.io/docs/configure/workspaces/tasks):

### Execution order

- before: Use this for tasks that need to run before init and before command. For example, customize the terminal or install global project dependencies.
- init: Use this for heavy-lifting tasks such as downloading dependencies or compiling source code.
- command: Use this to start your database or development server.

### Restart a Workspace
When you restart a workspace, Gitpod already executed the init task either as part of a Prebuild or when you started the workspace for the first time. The init task will not be
run when the workspace is restarted. Gitpod executes the before and command tasks on restarts. **It is recommended to use the before task not the init task.**

## Terraform

Terraform is an infrastructure as code tool. Terraform is a command line interface application written in GO. Terraform is cloud agnostic. We can learn it once and then use it to provision cloud resources on multiple different cloud providers. Terraform is able to store the state of the resources deployed. We can make changes to them or add new resources, without needing to repeat deployment. Terraform is configured by using a declarative file format known as HCL.

### Terraform providers

Terraform plugins called providers let Terraform interact with cloud platforms and other services via their application programming interfaces (APIs). You can find providers for many of the platforms and services like AWS and AZURE in the [Terraform Registry Providers section](https://registry.terraform.io/browse/providers).

The Terraform documentation is a great resource, with many examples. It should be consulted often when writing HCL for your chosen provider.

- [Terraform AWS provider documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Random provider documentation](https://registry.terraform.io/providers/hashicorp/random/latest/docs)

### Terraform modules

Modules are templates for commonly used actions, they are self-contained packages of Terraform configurations that are managed as a group. You can find modules for many of the platforms and services like AWS and AZURE in the [Terraform Registry Modules section](https://registry.terraform.io/browse/modules)

## Terraform CLI

To use Terraform you will need to install it. HashiCorp distributes Terraform as a binary package. You can also install Terraform using popular package managers.

The Gitpod workspace is built on the Ubuntu 22.04.3 LTS Operating system.

To confirm the workspace operating system. You can use the following linux command in a bash terminal in the running Gitpod workspace.

```
$ cat /etc/os-release
```

Expected console output:
```
PRETTY_NAME="Ubuntu 22.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
```

### Installation of Terraform CLI in Gitpod workspace

The commands needed to install Terraform CLI are for Linux Ubuntu/Debian are described [here](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli#install-terraform).

As there are multiple command lines needed to install Terraform CLI, we shall not clutter the .gitpod.yml with these commands, but shall create a bash script.

### Bash script files 

A bash script is identified by it's first line.

Typically:

```bash
#!/bin/bash
```

This is known as a [shebang](https://en.wikipedia.org/wiki/Shebang_(Unix)), pronounced sha-bang. 
```bash
#!
```

As best practice all bash script files should have the command below as the first line.

```bash
#!/usr/bin/env bash
```

This allows portability for running the script on different linux operating systems where the bash command location may be located somewhere other than /bin/bash.

### Script file execution
To execute a bash script in the terminal you can prepend the script filename with the word source.
```
source ./install_terraform_cli
```

```
./
```
The above relates to the relative path of the script file.
The terminal prompt should be in the same folder as the script file. Alternatively you can
add the file path to the command.

```
$ source ./bin/install_terraform_cli
```

The source command has permission to run bash scripts, irrespective of the scripts linux permissions.

### File permissions
To run a bash script **without** using the source command. The file needs to have it's executable bit set. By default all newly created files are not
executable.

To find the current [permissions](https://en.wikipedia.org/wiki/File-system_permissions) of a file use:

```bash
$ ls -la ./script-filename
```
Expected console output:
```
0 -rw-r--r-- 1 gitpod gitpod 0 Sep 19 11:33 bin/install_terraform_cli
```

Alternatively, return the octal format permissions
```bash
$ stat --format="%a" ./script-filename
```

Expected console output:
```
664
```

To change the executable bit, this can be done in two ways.

As a logged in user you can change permissions using the [chmod](https://www.linuxtopia.org/online_books/introduction_to_linux/linux_The_chmod_command.html) command.

```bash
$ chmod u+x ./script-filename
```

Example using the octal format.

```bash
$ chmod 764 ./script-filename
```

### File protection

This file would also be protected against accidental overwriting.

Example protecting a file using the octal format. 

```bash
$ chmod 400 ./filename.ext
```

This is needed for AWS as the SSH keys need to be read only.

### install_terraform_cli script

Create a new issue in GitHub, create a new feature branch to work on the issue.

Switch to feature branch, and run Gitpod workspace.

Create a new folder and file in the Gitpod workspace.

```bash
$ cd /workspace/terraform-beginner-bootcamp-2023
$ mkdir bin && touch ./bin/install_terraform_cli
```

Open the file for editing and add the shebang to the first line of the new file.

```bash
#!/usr/bin/env bash
```

Copy and paste into the new file the Ubuntu/Debian installation commands from the [Terraform documentation](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli#install-terraform).

Run the script manually and test the Terraform CLI was installed.

Set executable permission.

```bash
$ chmod 764 ./bin/install_terraform_cli
```
Run the script.
```bash
$ ./bin/install_terraform_cli
```

Test the installation.

```bash
$ terraform -version
```

Expected console output:
```
Terraform v1.5.7
on linux_amd6
```

### Refactor the .gitpod.yml file for install_terraform_cli

Remove the four lines of bash commands installing terraform from the init task.

Rename init task to before task. 
```yml
before: |
```

Add a new line.
```yml
before: |
      source ./bin/install_terraform_cli
```
This command will execute the install_terraform_cli bash script.

### Refactor Terraform installation script

Bash scripts that may download files or update system packages are best not executed in the project root folder, as some stray files may accidentally make it into version control. 

To avoid this we should change the working folder to a folder outside of version control either before running the script or during.

Upon script completion we should then change back to the project root folder.

We can define the project root folder as an environmental variable. We can then use this variable inside our script.


### Environmental variables

An environmental variable[<sup>[1]</sup>](#external-references) is a user-definable value that can be used by a process or multiple processes. They allow common values to span multiple processes. Hard coding values into code is not recommended, so defining
environmental variables outside of code is best practice. This is particularly important with secret credentials.

Environmental variables can be set temporarily or permanently.

It is conventional for environment-variable names to be in all upper case. In programming code generally, this helps to distinguish environment variables from other kinds of names in the code. Environment-variable names are case sensitive on Unix-like operating systems but not on DOS, OS/2, and Windows.

Example:

```bash
PROJECT_ROOT='/workspace/terraform-beginner-bootcamp-2023'
```

The variables can be used both in scripts and on the command line. They are usually referenced by putting special symbols in front of or around the variable name.

```bash
cd $PROJECT_ROOT
```

In most Unix and Unix-like command-line shells, an environment variable's value is retrieved by placing a $ sign before the variable's name. If necessary, the name can also be surrounded by braces.


```bash
echo ${PROJECT_ROOT}
```

Searching for set environmental variables is best done by using the env command along side the grep command.

```bash
env | grep PROJECT_ROOT
```

A variable can be cleared or unset by using the unset command.

```bash
unset PROJECT_ROOT
```

To persist an environmental variable across restarts or new shells, the variable needs to be defined in a special file or location.

Depending on your Linux OS, this file may be .bashrc or .profile or perhaps use both, refer to the documentation for your operating system. 

If environmental variables are used, it is best practice to create a file called .env.example
and place the actual variable name with fake values inside this file. Other developers will then know they may need to update or set
the variable value according to there environment or security credentials.

### Gitpod environmental variables

Gitpod supports encrypted, user-specific environment variables[<sup>[2]</sup>](#external-references). They are stored as part of your user settings and can be used to set access tokens, or pass any other kind of user-specific information to your workspaces.

Setting user-specific environment variables

Using the command: gp env

```bash
gp env PROJECT_ROOT='/workspace/terraform-beginner-bootcamp-2023'
```

Beware that this does not modify your current terminal session, but rather persists this variable for the next workspace on this repository. gp can only interact with the persistent environment variables for this repository, not the environment variables of your terminal. If you want to set that environment variable in your terminal, you can do so using -e:

The gp CLI prints and modifies the persistent environment variables associated with your user for the current repository.

### Terraform CLI fundamentals

We use the Terraform Command Line Interface (CLI) to manage infrastructure, and interact with Terraform state, providers, configuration files, and Terraform Cloud.

The core Terraform workflow[<sup>[4]</sup>](#external-references) consists of three main steps after you have written your Terraform configuration:

- Initialize prepares the working directory so Terraform can run the configuration.
- Plan enables you to preview any changes before you apply them.
- Apply makes the changes defined by your Terraform configuration to create, update, or destroy resources.

### Cloud provider resource names

When creating resources in the cloud, you mostly always need to provide a unique name that complies with the cloud providers naming convention for that resource. Hard coding a unique name is not advisable. It is best to use a tool to create a random name. In Terraform we can use [Random Provider - random_string](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) to do this. Always check the naming rules with the cloud providers documentation. Terraform cannot check naming rules.


### A simple main.tf example

This main.tf file uses the Hashicorp Random Provider, to generate a unique 32 character lower case string. This string will comply with the [AWS naming rules](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html?icmpid=docs_amazons3_console) for an S3 bucket. 

We use the "random_string" resource to generate a random 16 character string identified as **bucket_name**. 

We define one output "random_bucket_name" that is the .result of the "random_string" resource.

main.tf
```hcl
terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

provider "random" {
  # Configuration options
}

resource "random_string" "bucket_name" {
  length = 32
  special = false
  upper = false
}

output "random_bucket_name" {
  value = random_string.bucket_name.result
}
```

### Terraform basic usage example
- Create a file with the name main.tf
- Paste the contents of the example above into the file.
- Open a terminal prompt in the same folder as main.tf then type.

```bash
$ terraform init
```
Initialize prepares the working directory so Terraform can run the configuration. 

A new folder is created.

- .terraform

This folder is used to store the project's providers and modules. Terraform will refer to these components when you run validate, plan, and apply,

One new file is created:-

- .terraform.lock.hcl 

The .terraform.lock.hcl file ensures that Terraform uses the same provider versions across your team and in ephemeral remote execution environments. During initialization, Terraform will download the provider versions specified by this file rather than the latest versions. This file should be under version control.

Now run the following command.

```bash
$ terraform plan
```

Plan enables you to preview any changes before you apply them. If everything looks good then run the following command.

```bash
$ terraform apply --auto-approve
```

Apply makes the changes defined by your Terraform configuration to create, update, or destroy resources. The use of **--auto-approve** removes the need for you to type 'yes' when prompted.

One new file is created:-

- terraform.tfstate 

This State File contains full details of resources in our terraform code. When you modify something on your code and apply it on cloud, terraform will look into the state file, and compare the changes made in the code from that state file and the changes to the infrastructure based on the state file.[<sup>[6]</sup>](#external-references)  


In the console there should be the output displaying the
'random_bucket_name'. 

```bash
Outputs:

random_bucket_name = "[x$)z8:_62}#2b2jq}_%6q$]}u=t_-5t"
```

Now the resources have been applied, we can retrieve the value of the 'random_bucket_name' by using the following command.

```bash
$ terraform output random_bucket_name
```

Expected console output.
```bash
"[x$)z8:_62}#2b2jq}_%6q$]}u=t_-5t"
```

You can use Terraform outputs to connect your Terraform projects with other parts of your infrastructure, or with other Terraform projects.[<sup>[7]</sup>](#external-references)

### Terraform files and version control
Your .gitignore file must contain exclusions for many of the generated Terraform folders and files. The only files needed to be under version control[<sup>[5]</sup>](#external-references) are:

```bash
main.tf
.terraform.lock.hcl
```

- [Example .gitignore for Terraform](https://github.com/github/gitignore/blob/main/Terraform.gitignore)

## AWS CLI

The AWS Command Line Interface (AWS CLI) is an open source tool that enables you to interact with AWS services using commands in your command-line shell. With minimal configuration, the AWS CLI enables you to start running commands that implement functionality equivalent to that provided by the browser-based AWS Management Console from the command prompt in your terminal program.[<sup>[3]</sup>](#external-references)

### AWS IAM User credentials

The Root user account for AWS should never be used for daily account activities. Therefore we should create a IAM user account.

### Creating a IAM user using the aws web console.

Login to the [AWS web console](https://console.aws.amazon.com/) using your Root user credentials.

Use the drop down in the top right corner, under your account name, select Security credentials.

Firstly we will create a User group. We can assign policies to this group. Then assign multiple users to the group. Therefore all users in the group shall have the same permissions.

On the left hand pane under Access management select User Groups.

Click Create Group.

Enter User group name: terratowns

Scroll down to Attach permissions policies - Optional

Select AdministratorAccess

- [x] Select AdministratorAccess

It is not recommended to use this policy. AdministratorAccess, provides full access to AWS services and resources. Where possible a group policy should be fine tuned to allow authorisation to only the services required. We can easily remove this Policy at a later date and give a more granular set of Permissions. 

Scroll down, and click Create group.

On the left hand pane under Access management select Users.

Click Create user.

Enter a User name: terraform-cloud-project-beginner-bootcamp

Leave everything else as the defaults.

Click Next.

Add user to the terratowns group

Click Next

Click Create user

### Adding AWS User credentials to Gitpod workspace

We need to create three environmental variables to use the AWS CLI application.

Example: [AWS environmental variables](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html) with fake values.

```bash
AWS_ACCESS_KEY_ID='AKIAIOSFODNN7EXAMPLE'
AWS_SECRET_ACCESS_KEY='wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY'
AWS_DEFAULT_REGION='us-west-2'
```

**Important:**
We should always surround our environmental variable values with single quotes. This prevents [bash interpreter interpolation](https://www.baeldung.com/linux/bash-escape-characters).


As detailed in section Gitpod environmental variables. We can assign persistent environment variables to the Gitpod workspace using

```bash
gp env ENVVAR_NAME='envvar-value'
```
Therefore, we should enter the following in the Gitpod workspace terminal window. Substituting the fake values with the real values.
```bash
gp env AWS_ACCESS_KEY_ID='AKIAIOSFODNN7EXAMPLE'
gp env AWS_SECRET_ACCESS_KEY='wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY'
gp env AWS_DEFAULT_REGION='us-west-2'
```
### Retrieve the real values for IAM User

Login to the [AWS web console](https://console.aws.amazon.com/) using your Root user credentials.

Use the drop down in the top right corner, under your account name, select Security credentials.

On the left hand pane under Access management select Users.

Select the user with the name: terraform-cloud-project-beginner-bootcamp
Under Summary, select Security credentials
Scroll down to Access keys
Click Create access key
Select under Use case, Command Line Interface (CLI)
Tick the box Under Confirmation.
Click Next
Click Create access key

You should now be presented with a Access key and a hidden Secret access key. Do not close the browser tab.

Copy the Access key to clipboard. 
Switch back to the Gitpod workspace terminal.
Paste the key between the single quotes to complete the command below. Then hit the enter key.

```bash
gp env AWS_ACCESS_KEY_ID='paste clipboard here'
```

Copy the Secret access key to clipboard. Switch back to the Gitpod workspace terminal.
Paste the key between the single quotes to complete the command below. Then hit the enter key.

```bash
gp env AWS_SECRET_ACCESS_KEY='paste clipboard here'
```

Submit the final AWS environmental variable by copying the command below and pasting into the Gitpod workspace terminal.

```bash
gp env AWS_DEFAULT_REGION='eu-west-2'
```

### Installation of AWS CLI in Gitpod workspace

The commands needed to install THE AWS CLI for Linux are described [here](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).

As there are multiple command lines needed to install AWS CLI, we shall not clutter the .gitpod.yml with these commands, but shall create a bash script.

Scripts that download files to the workspace, should include clean up commands to remove any files and/or folders created while running the script. The clean up can occur either at the start of the script or at the end of the script.

To install the AWS CLI, we download a zip file, and unzip the file to the /workspace folder.
Both the zip file and extracted zip file contents needed to be removed as part of the clean up.

The bash command to remove/delete a file:

```bash
rm ./filename.ext
```

Note: If the file does not exist, an error will occur and the script will exit at that point. The script will not complete. We can force the rm command to ignore the errors using:-

```bash
rm -f ./filename.ext
```

The bash command to force removal/deletion of a folder and all it's contents is:

```bash
rm -rf ./folder/folder-name
```

**IMPORTANT:**
The use of the above command as root user could remove important system files/folders. Great care should be taken to insure that the correct folder is targeted before using the command, where possible always use the full absolute path to the folder.

### Test the AWS credentials
In the install_aws_cli script we can run an AWS CLI command called [get-caller-identity](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/sts/get-caller-identity.html). This command Returns details about the IAM user or role whose credentials are used to call the operation. Therefore, this is a good way of checking we are ready to start using AWS and have the correct IAM User for the project.

### Refactor the .gitpod.yml file to use the AWS CLI install script

Rename init task to before task. 
```yml
before: |
```

Add a new line.
```yml
before: |
      source ./bin/install_aws_cli
```
This command will execute the install_aws_cli bash script.

### Terraform and AWS

To use AWS with Terraform we need to add AWS to the providers block in the main.tf file. The code needed can be found on the Terraform registry webpage by searching for [Provider AWS](https://registry.terraform.io/providers/hashicorp/aws/latest). Click on USE PROVIDER and copy the AWS specific block, as shown below.

```hcl
aws = {
      source = "hashicorp/aws"
      version = "5.17.0"
    }
```

**Note:** The main.tf can only have one terraform {} block and one required_providers {} block. Multiple providers are listed in the required_provider{} block, as shown below.

```hcl
terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
    aws = {
      source = "hashicorp/aws"
      version = "5.17.0"
    }
  }
}
```

### Authentication and Configuration

Configuration for the AWS Provider can be derived from several sources, which are applied in the following order:

1. Parameters in the provider configuration
1. Environment variables[<sup>[8]</sup>](#external-references)
1. Shared credentials files
1. Shared configuration files
1. Container credentials
1. Instance profile credentials and region

**Warning:** Hard-coded credentials are not recommended in any Terraform configuration and risks secret leakage should this file ever be committed to a public version control system.

We have chosen to use list item number 2, for this project. Our credentials are stored securely by using the Gitpod environmental variable storage service.[<sup>[2]</sup>](#external-references)

Check your AWS environmental variables in the terminal prompt with:

```bash
env | grep AWS_
```

## AWS S3 Bucket

[Amazon Simple Storage Service](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html) (Amazon S3) is storage for the internet. You can use Amazon S3 to store and retrieve any amount of data at any time, from anywhere on the web.

To store your data in Amazon S3, you work with resources known as [buckets](https://docs.aws.amazon.com/AmazonS3/latest/userguide/creating-buckets-s3.html) and objects. A bucket is a container for objects. An object is a file and any metadata that describes that file.

### Creating a bucket
To upload your data to Amazon S3, you must first create an Amazon S3 bucket[<sup>[10]</sup>](#external-references) in one of the AWS Regions. When you create a bucket, you must choose a bucket name and Region. You can optionally choose other storage management options for the bucket. After you create a bucket, you cannot change the bucket name or Region.

### Creating a bucket with Terraform

To create a bucket with Terraform we refer to the Terraform AWS provider documentation for S3 (simple Storage).[<sup>[9]</sup>](#external-references)
We copy the code block detailed in the documentation and update the values accordingly.


```hcl
resource "aws_s3_bucket" "example" {
  bucket = "my-tf-test-bucket"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
```

**Note:** 
AWS CloudFormation[<sup>[11]</sup>](#external-references) is a Infrastructure as Code tool. Many of names match with the Terraform AWS providers names. For example AWS::S3::Bucket in AWS CloudFormation matches with aws_s3_bucket.
The AWS CloudFormation documentation should also be referenced to assist with the use of Terraform with AWS.


We will use the [Random Provider - random_string](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) to generate a unique name for our bucket.

To use this we replace the bucket = "string value" with the output of the random_string resource. As shown below.

```hcl
resource "aws_s3_bucket" "example" {
  bucket = random_string.bucket_name.result

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
```

- Update the main.tf accordingly.
- Open a terminal prompt in the same folder as main.tf then type.

```bash
$ terraform init
```
Initialize prepares the working directory so Terraform can run the configuration. Downloads to .terraform folder the AWS provider binary.

```bash
$ terraform plan
```

Plan enables you to preview any changes before you apply them. If everything looks good then run the following command.

```bash
$ terraform apply --auto-approve
```

Check using the following AWS CLI command that the bucket was created.

```bash
$ aws s3 ls
```

Now delete the AWS resources using terraform destroy. This command terminates resources managed by your Terraform project. This command is the inverse of terraform apply in that it terminates all the resources specified in your Terraform state. It does not destroy resources running elsewhere that are not managed by the current Terraform project.

```bash
$ terraform destroy --auto-approve
```

The file below is updated:-

- terraform.tfstate 

This State File contains full details of resources in our terraform code. When you modify something on your code and apply it on cloud, terraform will look into the state file, and compare the changes made in the code from that state file and the changes to the infrastructure based on the state file.[<sup>[6]</sup>](#external-references)

## Terraform Cloud

As mentioned the terraform.tfstate file is very important. It's important to protect your state file. If you lose the state file, Terraform will have no way to know what it built or what could be safe to delete or change.

The default setting of Terraform is to store your state file on your local laptop or your workstation. This works great for a single developer or someone working alone on a project, but as soon as you have 2 or more people trying to work on the same project, this can become a problem.

We will use a "remote state." This is a centrally stored state file where multiple uses can access the state of your infrastructure. Remote state can be stored either on cloud platform storage, like S3, or inside of Terraform Cloud.

Terraform Cloud provides all of the features we need to work with remote state, including locking, collaboration, and encryption.

### Terraform Cloud pricing

In the Free tier we get 500 resources per month, and do not need to provide a credit card. If we exceed 500 resources per month we will switch to the Standard tier. The Standard tier requires a credit card to be registered.[<sup>[12]</sup>](#external-references)

### Register for a new Terraform Cloud account
Go to webpage [terraform.io](https://www.terraform.io/)

- Click on Try Terraform Cloud
- Register a new account
- Follow all the prompts, then you are ready to use Terraform Cloud.

### Configure Terraform Cloud
Go to [Terraform Cloud login](https://app.terraform.io/session)
- Login to your Terraform Cloud account.
- Create a new [organization](https://app.terraform.io/app/organizations/new).
- Create a new [Project](https://app.terraform.io/app/mpflynnx/workspaces). Click on New and select Project from dropdown. Give a project name as 'terraform-beginner-bootcamp-2023'. Click Create button.
- Create a new CLI-driven workflow [workspace](https://app.terraform.io/app/mpflynnx/workspaces/new).
- Give Workspace Name as terra-house-1. The name of your workspace is unique and used in tools, routing, and UI. Dashes, underscores, and alphanumeric characters are permitted. Learn more about [naming workspaces](https://www.terraform.io/docs/cloud/workspaces/naming.html)

- Select Project 'terraform-beginner-bootcamp-2023'. Give description. of workspace. The click Create workspace.
- Open a Gitpod workspace for the project.

- Copy the 'Example code' block for cloud then paste this into the main.tf file.
### Create an API Token

- Log in to Terraform Cloud and go on to [User Settings](https://app.terraform.io/app/settings/profile).

- Click on [Tokens](https://app.terraform.io/app/settings/tokens).

- Click on Create an API token. Give a description as 'TerraTowns'. Set Expiration to 30 days. Click Generate Token.

- Copy the Token now, as you will not be able to see it again, if you close the [Tokens](https://app.terraform.io/app/settings/tokens) browser tab.

- Create new persistent Gitpod environmental variable, substituting the real value, in the command below.

```bash
$ gp env TERRAFORM_CLOUD_TOKEN='EXAMPLERF6rtdg.atlasv1.i1AOIJy0RpyyAsdArLTbZ77ImBFV3Fg8ezGxseOwvAcCcRZzQKiJuJErsrZoEXAMPLE'
```
- Check [Gitpod variables](https://gitpod.io/user/variables) url for the new variable.

- Stop and the start the Gitpod workspace for the new environment variable to be available for use.
- Run command below and verify that the TERRAFORM_CLOUD_TOKEN is set.
```bash
$ env | grep TERRAFORM_
```

- Update the .env.example file with a example token as shown above.

### Gitpod problems with Terraform login command

The command ['Terraform login'](https://developer.hashicorp.com/terraform/cli/commands/login), wants to request an API token for app.terraform.io using your internet browser. We are using Gitpod workspace for this project so this will not work. We must come up with another solution for this.

By default, Terraform will obtain an API token and save it in plain text in a local CLI configuration file called credentials.tfrc.json. 

The location of our file is:
```bash
$ /home/gitpod/.terraform.d/credentials.tfrc.json
```

The structure of this file is:
```json
{
  "credentials": {
    "app.terraform.io": {
      "token": "$TERRAFORM_CLOUD_TOKEN"
    }
  }
}
```
### generate_tfrc_credentials bash script

As we are using Gitpod, we need a way of creating the credentials.tfrc.json file on the creation of every new Gitpod workspace. To do this we shall write a bash script. The bash script shall do the following:
- Create a new folder, '.terraform.d', if it doesn't exist
- Create a new file, 'credentials.tfrc.json', if it doesn't exist.
- Use the cat command to build the json block, obtaining the persistent Gitpod environmental variable $TERRAFORM_CLOUD_TOKEN from the local environment.

The script will be placed in the bin folder.

The gitpod.yml file needs to be updated to run this script on the creation of a new Gitpod workspace.

- Run command below and verify that the TERRAFORM_CLOUD_TOKEN is set.
```bash
$ env | grep TERRAFORM_
```

- Make the bash script generate_tfrc_credentials executable with the command below:
```bash
$ cd /workspace/terraform-beginner-bootcamp-2023 
$ chmod u+x ./bin/generate_tfrc_credentials
```
- Run the script, using the command below.
```bash
$ cd /workspace/terraform-beginner-bootcamp-2023
$ ./bin/generate_tfrc_credentials
```
- Check the file exists and contains the TERRAFORM_CLOUD_TOKEN.
```
$ cat /home/gitpod/.terraform.d/credentials.tfrc.json
```
- Run the following command, to test the credentials.

```bash
$ terraform init
```
- You should be presented with the following screen.
```bash
Initializing Terraform Cloud...

Initializing provider plugins...
- Reusing previous version of hashicorp/aws from the dependency lock file
- Reusing previous version of hashicorp/random from the dependency lock file
- Installing hashicorp/aws v5.17.0...
- Installed hashicorp/aws v5.17.0 (signed by HashiCorp)
- Installing hashicorp/random v3.5.1...
- Installed hashicorp/random v3.5.1 (signed by HashiCorp)

Terraform Cloud has been successfully initialized!

You may now begin working with Terraform Cloud. Try running "terraform plan" to
see any changes that are required for your infrastructure.

If you ever set or change modules or Terraform Settings, run "terraform init"
again to reinitialize your working directory.
```

### Terraform Cloud Workspace variables
Terraform Cloud performs Terraform runs on disposable Linux worker VMs using a POSIX-compatible shell. Before running Terraform operations, Terraform Cloud uses the export command to populate the shell with environment variables. These environment variables can store our AWS credentials.

Terraform Cloud lets you define input and environment variables using either workspace-specific variables, or sets of variables that you can reuse in multiple workspaces. [Variable sets](https://developer.hashicorp.com/terraform/tutorials/cloud-get-started/cloud-create-variable-set) allow you to avoid redefining the same variables across workspaces, so you can standardize common configurations. 

For this project we will define our AWS credentials as [workspace-specific variables](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/variables). 

**Precedence**[<sup>[13]</sup>](#external-references)

The AWS credentials will apply only to the to a single 'terra-house-1' workspace. Workspace-specific variables always overwrite variables from variable sets that have the same key. [Refer to overwrite variables from variable sets](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/variables/managing-variables#overwrite-variable-sets) for details.

### Adding Workspace-specific Variables

1. Open a browser tab and login to your [Terraform cloud account](https://app.terraform.io/session).
1. Go to workplace 'terra-house-1'.
1. Click Variables on left hand pane.
1. Scroll down to Workspace variables.
1. Open another browser tab and login to your [Gitpod account](https://gitpod.io/login/).
1. Go to Gitpod, User settings, then click [Variables](https://gitpod.io/user/variables). Here are the AWS credentials we added to our Gitpod account previously. We will copy them for here to the Terraform Cloud workspace.
1. Go back onto the Terraform Cloud 'terra-house-1' workspace browser tab.
1. Click + Add variable.
1. Create a new variable for AWS_ACCESS_KEY_ID, copy the value from the Gitpod user settings browser tab.
1. Choose the variable category as environment.
1. Mark the variable as sensitive. This prevents Terraform from displaying it in the Terraform Cloud UI and makes the variable write-only.
1. Click Save variable.
1. Repeat steps 8 to 12 for the remaining two AWS_ variables.
1. We have now added our AWS credentials to the 'terra-house-1' workspace.

### Terraform Cloud setup confirmation
If you have previously stopped a Gitpod workspace, then open a new Gitpod workspace from the Github project main branch.

```bash
$ terraform init
$ terraform plan
$ terraform apply --auto-approve
```

1. Run the commands above in the order given. These command will login to Terraform Cloud, create a plan, and apply the plan. The terraform.tfstate file will be stored on our Terraform cloud account and not locally.
1. Go on to the Terraform Cloud browser tab and navigate to Workspace 'terra-house-1'.
1. Click on Runs, to see the completed current run.
1. To confirm the AWS S3 bucket has been created, we can login to the AWS console and search for Amazon S3. Verify that the bucket names match. Alternatively type command:
```bash
aws s3 ls
```


We have now completed our setup of Terraform Cloud. From here onwards our AWS infrastructure state we be securely stored. Subsequent runs will be logged in Terraform cloud for viewing.

### Terraform cli convenience bash alias

To aid productivity using the terminal we can create aliases to common linux commands. The most popular aliases are for the list 'ls' command. Typing 'ls' on it's own isn't so bad, but the default result isn't particularly helpful. That is why by default many Linux OS's provide aliases for the 'ls' command. These aliases are stored in a '.bashrc' file for the logged in user. 

Here is an example of an alias.
```bash
alias ll='ls -alF'
```

On Ubuntu you can create your own file '.bash_aliases' this will take precedence over .bashrc. We can put our personal bash aliases in this file. For example you may want to have an alias for the terraform command below. 
```bash
$ terraform init
```
We can create an alias, so that the same command becomes.

```bash
$ tf init
```
The terraform alias would be:
```bash
alias tf='terraform'
```


For Gitpod, to make this alias persist on the creation of new workspaces, we need to create a bash script that will create the '.bash_aliases' file and populate it with the alias for the terraform command.

The bash script should do the following:-
- Create file /home/gitpod/.bash_aliases, if it doesn't exist.
- Use the cat command to populate the file with the alias.
- Make the aliases available immediately, by using the source command on the .bash_aliases file.
- The bash script should be stored in the '/workspace/terraform-beginner-bootcamp-2023/bin' folder.
- We can make the script executable using the command below:
```bash
$ chmod 764 ./bin/create_bash_aliases
```

The bash script should be run first as part of the .gitpod.yml 'before' task using the source command.

## External References
- [Wikipedia Environment variables](https://en.wikipedia.org/wiki/Environment_variable#Unix) <sup>[1]</sup>

- [Gitpod Environment Variables](https://www.gitpod.io/docs/configure/projects/environment-variables#using-the-account-settings) <sup>[2]</sup>

- [What is the AWS Command Line Interface?](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html) <sup>[3]</sup>

- [Terraform tutorials - Use the Command Line Interface](https://developer.hashicorp.com/terraform/tutorials/cli) <sup>[4]</sup>

- [How to Create & Use Gitignore File With Terraform](https://spacelift.io/blog/terraform-gitignore)<sup>[5]</sup>

- [What Is Terraform State File And How It Is Managed?](https://www.easydeploy.io/blog/terraform-state-file/)<sup>[6]</sup>

- [Output data from Terraform](https://developer.hashicorp.com/terraform/tutorials/configuration-language/outputs)<sup>[7]</sup>

- [AWS Provider Authentication and Configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication-and-configuration)<sup>[8]</sup>

- [Resource: aws_s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)<sup>[9]</sup>

- [Creating a bucket](https://docs.aws.amazon.com/AmazonS3/latest/userguide/create-bucket-overview.html)<sup>[10]</sup>

- [AWS CloudFormation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/Welcome.html)<sup>[11]</sup>

- [Terraform Cloud Free and Paid Plans](https://developer.hashicorp.com/terraform/cloud-docs/overview#free-and-paid-plans)<sup>[12]</sup>
- [Terraform Cloud Variable Precedence](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/variables#precedence)<sup>[13]</sup>
