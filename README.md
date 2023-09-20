# Terraform Beginner Bootcamp 2023

## Project Git flow

This project is going to utilise the issue, feature branch, pull request, tag workflow.
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
#!/
```

As best practice all bash script files should have this as the first line.

```bash
#!/usr/bin/env bash
```

This allows portability for running the script on different linux operating systems where the bash command location may be located somewhere other than /bin/bash.

#### Script file permissions
To execute a bash script in the terminal you can prepend the script filename with the word source.
```
source ./terraform-install-script
```

```
./
```
The above relates to the relative path of the script file.
The terminal prompt should be in the same folder as the script file. Alternatively you can
add the file path to the command.

```
$ source ./bin/terraform-install-script
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
0 -rw-r--r-- 1 gitpod gitpod 0 Sep 19 11:33 bin/terraform-install.sh
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

### terraform-install-script

Create a new issue in GitHub, create a new feature branch to work on the issue.

Switch to feature branch, and run Gitpod workspace.

Create a new folder and file in the Gitpod workspace.

```bash
$ mkdir bin && touch bin/terraform-install.sh
```

Open the file for editing and add the shebang to the first line of the new file.

```bash
#!/usr/bin/env bash
```

Copy and paste into the new file the Ubuntu/Debian installation commands from the [Terraform documentation](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli#install-terraform).

Run the script manually and test the Terraform CLI was installed.

Set executable permission.

```bash
$ chmod 755 ./bin/terraform-install.sh
```
Run the script.
```bash
$ ./bin/terraform-install.sh
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

### Refactor the .gitpod.yml file

Remove the four lines of bash commands installing terraform from the init task.

Rename init task to before task. 
```yml
before: |
```

Add a new line.
```yml
before: |
      source ./bin/terraform-install.sh
```
This command will execute the terraform-install.sh bash script.

### Refactor Terraform installation script

Bash scripts that may download files or update system packages are best not executed in the project root folder, as some stray files may accidentally make it into SCM. 

To avoid this we should change the working folder to a folder outside of SCM either before running the script or during.

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

Searching for set environmental variables is best done by using the env command along side the grp command.

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
and place the variables inside this file. Other developers will then know they may need to update or set
the variable according to there environment or security credentials.

### Gitpod environmental variables[<sup>[2]</sup>](#external-references)

Gitpod supports encrypted, user-specific environment variables. They are stored as part of your user settings and can be used to set access tokens, or pass any other kind of user-specific information to your workspaces.

Setting user-specific environment variables

Using the command line: gp env

```bash
gp env PROJECT_ROOT='/workspace/terraform-beginner-bootcamp-2023'
```

Beware that this does not modify your current terminal session, but rather persists this variable for the next workspace on this repository. gp can only interact with the persistent environment variables for this repository, not the environment variables of your terminal. If you want to set that environment variable in your terminal, you can do so using -e:

The gp CLI prints and modifies the persistent environment variables associated with your user for the current repository.


## External References
- [Wikipedia Environment variables](https://en.wikipedia.org/wiki/Environment_variable#Unix) <sup>[1]</sup>

- [Gitpod Environment Variables](https://www.gitpod.io/docs/configure/projects/environment-variables#using-the-account-settings) <sup>[2]</sup>
