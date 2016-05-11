require 'dotenv'
require 'txdb'
require 'pry-byebug'

Dotenv.load

db = Txdb::Config.databases.first
table = db.tables.first

reader = Txdb::Backends::Globalize::Reader.new(table)
content = reader.read_content

writer = Txdb::Backends::Globalize::Writer.new(table)
writer.write_content(content, 'en')
