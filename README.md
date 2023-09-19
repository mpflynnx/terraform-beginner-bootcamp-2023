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