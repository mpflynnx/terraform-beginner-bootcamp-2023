# <p align=center>Terraform Beginner Bootcamp 2023 Week 1

## Week 0 Objectives.
The objectives of week 1 where:
- Create the Terraform recommended 'Standard Module Structure' for the project.


<p align="center">
  <img src="../assets/week1.PNG"/>
</p>

# <p align=center>Week 1 Architecture Diagram </p>

# Table of Contents

- [Standard Module Structure](#standard-module-structure)
- [Refactor main.tf file](#refactor-maintf-file)


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
- variable.tf. This contains declarations for variables.
- outputs.tf. This contains declarations for outputs.
- providers.tf. This is optional, as some teams prefer to use the main.tf for provider configuration.

Terraform reads all *.tf files in the root folder.

## Refactor main.tf file
We will refactor our main.tf into the minimal module structure as recommended.

We will copy the providers block from main.tf and paste it into a new file provider.tf.

We will copy the outputs block from main.tf and paste it into a new file outputs.tf

## External References
- [Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure) <sup>[1]</sup>
