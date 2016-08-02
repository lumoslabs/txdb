Txdb
====

[![Build Status](https://travis-ci.org/lumoslabs/txdb.svg?branch=master)](https://travis-ci.org/lumoslabs/txdb)

Txdb, a mashup of "Transifex" and "database", is an automation tool that facilitates translating database content with Transifex, a popular translation management system.

### Configuration

Configuration is done in the YAML file format. Here's an example:

```yaml
databases:
- adapter: mysql2
  backend: globalize
  username: txdb_user
  password: passpasspass
  host: my-host.com
  port: 3306
  name: mydb_production
  pool: 10
  locales:
  - de
  - es
  - fr
  - pt
  - ja
  - ko
  source_locale: en
  transifex:
    organization: my-org
    project_slug: my-project
    username: txgh.user
    password: passpasspass
    webhook_secret: secretsecretsecret
  tables:
  - name: product_translations
    columns:
    - name
    - description
```

The root of the config hierarchy is an array of databases. Each one specifies how to connect to a specific database, which backend to use (see below) what Transifex project it's associated with, and which tables and columns to sync. Txdb will upload a new resource for each table.

### Using Configuration

Txdb supports two different ways of accessing configuration, raw text and a file path. In both cases, config is passed via the `TXDB_CONFIG` environment variable. Prefix the raw text or file path with the appropriate scheme, `raw://` or `file://`, to indicate which strategy Txgh should use.

#### Raw Config

Passing raw config to Txdb can be done like this:

```bash
export TXDB_CONFIG="raw://big_yaml_string_here"
```

When Txdb starts up, it will use the YAML payload that starts after `raw://`.

#### File Config

It might make more sense to store all your config in a file. Pass the path to Txdb like this:

```bash
export TXDB_CONFIG="file://path/to/config.yml"
```

When Txdb runs, it will read and parse the file at the path that comes after `file://`.

Of course, in both the file and the raw cases, environment variables can be specified via `export` or inline when starting Txdb.

### Backends

Backends provide different strategies for syncing content between Transifex and your database. They are made up of a reader and a writer. Currently the only supported backend is the Globalize backend, which understands the database translation strategy used by the [Globalize](https://github.com/globalize/globalize) gem. Adding additional backends is straightforward. Use the Globalize backend as a model to create the reader, writer, and backend classes, then register your new backend:

```ruby
Txdb::Backends.register(
  'my-cool-backend', MyModule::MyBackendClass
)
```

Running Tests
---

Txdb uses the popular RSpec test framework and has a comprehensive set of unit tests. To run the test suite, run `bundle exec rspec`.

Requirements
---

Txdb requires an Internet connection to access the Transifex API and some kind of database. You will configure which database to use in the configuration file.

Compatibility
---

Txdb was developed with Ruby 2.1.6, but is probably compatible with all versions between 2.0 and 2.3, and maybe even 1.9. Your mileage may vary when running on older versions of Ruby.

Authors
---

This project is maintained by [Cameron Dutro](https://github.com/camertron).

License
---

Licensed under the Apache License, Version 2.0. See the LICENSE file included in this repository for the full text.
