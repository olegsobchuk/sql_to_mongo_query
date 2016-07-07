== Needed

1. ModgoDB should be instaleld

version 3 or more (instruction: https://www.digitalocean.com/community/tutorials/how-to-install-mongodb-on-ubuntu-14-04)

2. required gems `gem install mongo rspec`

3. should be added records to DB

4. Add project to local PC

`git clone git@github.com:olegsobchuk/sql_to_mongo_query.git`

'cd sql_to_mongo_query'

4. Use
- for running `ruby run.rb` from project folder

- you will see "Please enter your DB name"

- fill in your DB name (for example: `mydb`)

- than you will see "Please enter your SQL query"

- fill in your SQL query as described below

- you will see "RESULT" and response

== Notes

1. Not implemented:

- logical XOR

- order for parentheses in conditions

2. SQL conditions:

- example: `select field_name from table_name where some_field = value or another_field > another_value limit 2 skip 1 order by field`

- query should be in single line

- query does not case sensitive
