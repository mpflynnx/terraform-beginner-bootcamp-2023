# Terraform Beginner Bootcamp 2023

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

As best practice all bash script files should have this as the first line.

```bash
#!/usr/bin/env bash
```

This allows portability for running the script on different linux operating systems where the bash command location may be located somewhere other than /bin/bash.

#### Script file permissions
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

#### File permissions
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
644
```

To change the executable bit, this can be done in two ways.

As sudo you can change permissions using the [chmod](https://www.linuxtopia.org/online_books/introduction_to_linux/linux_The_chmod_command.html) command.

```bash
$ chmod u+x ./script-filename
```

Example using the octal format.

```bash
$ chmod 755 ./script-filename
```

#### File protection

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
$ mkdir bin && touch bin/install_terraform_cli
```

Open the file for editing and add the shebang to the first line of the new file.

```bash
#!/usr/bin/env bash
```

Copy and paste into the new file the Ubuntu/Debian installation commands from the [Terraform documentation](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli#install-terraform).

Run the script manually and test the Terraform CLI was installed.

Set executable permission.

```bash
$ chmod 755 ./bin/install_terraform_cli
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


### Environmental variables[<sup>[1]</sup>](#external-references)

An environmental variable is a user-definable value that can be used by a process or multiple processes. They allow common values to span multiple processes. Hard coding values into code is not recommended, so defining
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

Depending on your OS, this file may be .bashrc or .profile or perhaps both, refer to the documentation for your operating system.

If environmental variables are used, it is best practice to create a file called .env.example
and place the actual variable name with fake values inside this file. Other developers will then know they may need to update or set
the variable value according to there environment or security credentials.

### Gitpod environmental variables[<sup>[2]</sup>](#external-references)

Gitpod supports encrypted, user-specific environment variables. They are stored as part of your user settings and can be used to set access tokens, or pass any other kind of user-specific information to your workspaces.

Setting user-specific environment variables

Using the command: gp env

```bash
gp env PROJECT_ROOT='/workspace/terraform-beginner-bootcamp-2023'
```

Beware that this does not modify your current terminal session, but rather persists this variable for the next workspace on this repository. gp can only interact with the persistent environment variables for this repository, not the environment variables of your terminal. If you want to set that environment variable in your terminal, you can do so using -e:

The gp CLI prints and modifies the persistent environment variables associated with your user for the current repository.

### Terraform CLI fundamentals[<sup>[4]</sup>](#external-references)

We use the Terraform Command Line Interface (CLI) to manage infrastructure, and interact with Terraform state, providers, configuration files, and Terraform Cloud.

The core Terraform workflow consists of three main steps after you have written your Terraform configuration:

- Initialize prepares the working directory so Terraform can run the configuration.
- Plan enables you to preview any changes before you apply them.
- Apply makes the changes defined by your Terraform configuration to create, update, or destroy resources.

### Cloud provider resource names

When creating resources in the cloud, you mostly always need to provide a unique name that complies with the cloud providers naming convention for that resource. Hard coding a unique name is not advisable. It is best to use a tool to create a random name. In Terraform we can use [Random Provider - random_string](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) to do this.


### A simple main.tf example

This main.tf file uses the Hashicorp Random Provider. 

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
  length           = 16
  special          = true
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
$ terraform apply
```

Apply makes the changes defined by your Terraform configuration to create, update, or destroy resources.

One new file is created:-

- terraform.tfstate 

This State File contains full details of resources in our terraform code. When you modify something on your code and apply it on cloud, terraform will look into the state file, and compare the changes made in the code from that state file and the changes to the infrastructure based on the state file.[<sup>[6]</sup>](#external-references)  


In the console there should be the output displaying the
random_bucket_name. 

```bash
Outputs:

random_bucket_name = "KGf!Yq@&[EbE_jiP"
```

### Terraform files and version control[<sup>[5]</sup>](#external-references)
Your .gitignore file must contain exclusions for many of the generated Terraform folders and files. The only files needed to be under version control are:

```bash
main.tf
.terraform.lock.hcl
```

- [Example .gitignore for Terraform](https://github.com/github/gitignore/blob/main/Terraform.gitignore)

## AWS CLI

The AWS Command Line Interface (AWS CLI) is an open source tool that enables you to interact with AWS services using commands in your command-line shell. With minimal configuration, the AWS CLI enables you to start running commands that implement functionality equivalent to that provided by the browser-based AWS Management Console from the command prompt in your terminal program.[<sup>[3]</sup>](#external-references)

## AWS IAM User credentials

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



## External References
- [Wikipedia Environment variables](https://en.wikipedia.org/wiki/Environment_variable#Unix) <sup>[1]</sup>

- [Gitpod Environment Variables](https://www.gitpod.io/docs/configure/projects/environment-variables#using-the-account-settings) <sup>[2]</sup>

- [What is the AWS Command Line Interface?](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html) <sup>[3]</sup>

- [Terraform tutorials - Use the Command Line Interface](https://developer.hashicorp.com/terraform/tutorials/cli) <sup>[4]</sup>

- [How to Create & Use Gitignore File With Terraform](https://spacelift.io/blog/terraform-gitignore)<sup>[5]</sup>

- [What Is Terraform State File And How It Is Managed?](https://www.easydeploy.io/blog/terraform-state-file/)<sup>[6]</sup>