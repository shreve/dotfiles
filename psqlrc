-- Don't output all the changes made here
\set QUIET 1

-- Show the duration of queries
\timing

-- Customize the prompts, including unfinished query nextline
\set PROMPT1 '%[%033[1m%]%M %n@%/%R%[%033[0m%]%# '
\set PROMPT2 '[more] %R > '

-- Don't include duplicates in the history file
\set HISTCONTROL ignoredups

-- Prefer upper-case keywords when composing
\set COMP_KEYWORD_CASE upper

-- Define a few shortcut functions
\set last 'order by id desc limit 1'
\set all 'select * from'
\set max 'select max(id) from'

-- Use best output format possible
\x auto

-- Show '(null)' instead of '' for null values
\pset null '(null)'

-- Allow psql to print it's normal business
\unset QUIET