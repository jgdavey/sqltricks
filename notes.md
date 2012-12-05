* Constraints

** NOT NULL

create table people(
  id serial primary key
  name varchar not null
);

or

create_table :people do |t|
  t.column :name, :string, null: false
end

Nulls short circuit almost every operation to null. Avoid if possible.

** Foreign keys constraints

create table posts(
  id serial primary key,
  author_id integer not null references authors
  body text not null
);

Foreign key constraints ensure that you do not have get orphaned records.

** Check constraints

create table reservations(
  id serial primary key,
  room_id integer not null references rooms,
  start_time timestamp not null,
  end_time timestamp not null,
  check (start_time < end_time)
);

Arbitrary declarative data constraints

** Unique

create table users(
  id serial primary key,
  name varchar unique
);

Rails' validates_uniqueness_of is not a guarantee. The database is.

** Partial Indexes

create table posts(
  id serial primary key,
  body text not null,
  front_page boolean not null
);

create index on posts (front_page) where front_page;

Could have millions of posts, but only handful of front page posts. Index will only contain rows that are front page and will not be bloated by the millions of old posts.

** Partial unique indexes

create table teams(
  id serial primary key,
  name varchar not null unique
);

create table players(
  id serial primary key,
  team_id integer not null references teams,
  captain boolean not null,
  name varchar not null
);

create unique index on players (team_id) where captain;

This will guarantee there is only one captain per team.

** Functional indexes

create table users(
  id serial primary key,
  name varchar not null
);

create unique index on users (lower(name));

This will guarantee case-insensitive uniqueness, and will preserve the original case.

An index can be created on the result of a stable expression.

* Richer data modeling

** Enum

FIXME -- double check this syntax

create enum grade_level('freshman', 'sophomore', 'junior', 'senior', 'graduate');

create table students(
  id serial primary key,
  name varchar not null,
  grade_level grade_level not null
);

Will only store correct values. Will sort by order given in the enum.

** hstore

TODO

** citext

create table users(
  id serial primary key,
  name citext not null unique
);

Case-preserving and case insensitive.

** json

TODO

** inet

create table logins_attempts(
  id serial primary key,
  user_name varchar not null,
  successful boolean not null,
  remote_ip inet not null,
  created_at timestamp not null
);