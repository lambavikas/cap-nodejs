# Overview

A simple implemntation of `bookshop`. It contains these folders and files, following our recommended project layout:

File or Folder | Purpose
---------|----------
`app/` | content for UI frontends goes here
`db/` | your domain models and data go here
`srv/` | your service models and code go here
`test/` | simple HTTP test scripts
`package.json` | project metadata and configuration
`readme.md` | this guide


## Reference Guides

- Follows the [Setup for Local Development](https://cap.cloud.sap/docs/get-started/jumpstart) guide to use local VS Code
- Replicates the [Getting Started in a Nutshell](https://cap.cloud.sap/docs/get-started/in-a-nutshell) guide

## Features Available in this Project

- `cds init <project_name>` to quick setup the project
- `cds watch` to build and live reload as you develop
- A small data model representing Books, Authors and Genres using CDS has been created in file `db/schema.cds`.
- Showcase of concepts like `namespace`, `localized strings`, `1-1 Associations`, `1:M Associations`, `Compositions` to define the data model
- Creating 2 seperate service models for Admin and Users on top of the data model
- Showcase how to use `@(requires:'authenticated-user')` annotation to protect a service with mocked authentication. User `alice` as default user for mocked authentication.
- Simple projections on CDS entities
- Exposing the OData service at a pre-defined path with `@(path:'/browse')` annotation
- Projections with specific fields and exposing fields from related entities in projection
- Use of OData Function Imports and normal functions to create RESTful API's
- Using CSV files to load mock/test data
- Using simple `test` scripts to execute OData queries against our services
- Adding custom logic to overirde the behavior of standard CRUD implementations
- Adding logic to implement a Function Import and a Generic Function

## Learn More

Learn more at https://cap.cloud.sap/docs/get-started/.
