# 4.2.1
* Update txgh to v7.0.0 and txgh-server to v4.0.0

# 4.2.0
* Support ERB tags in config files.

# 4.1.1
* Use YAML_GENERIC file format instead of YML (which changed recently, thanks Transifex).

# 4.1.0
* Loosen dependency on txgh.

# 4.0.0
* Grab locales from config instead of querying Tranisfex, since Transifex is wrong.

# 3.1.0
* Skip source language when downloading.

# 3.0.0
* Globalize backend now uses translation entries in the source language
  instead of columns from from the parent table.

# 2.1.0
* Exposing record selection logic to iterator subclasses.

# 2.0.0
* Renaming Database#database to Database#name.

# 1.2.0
* Refactored spec helpers to make it easier to write readable tests.
* Moved record iteration logic into their own classes so as to make
  them easier to reuse.

# 1.1.0
* Support created_at and updated_at fields if they exist (Globalize backend)
* Support multiple resources per table

# 1.0.1
* Adding Txgh.env
* Adding health_check endpoint

# 1.0.0
* Birthday!

