!SLIDE
# Indexes

!SLIDE
# Unique

    @@@ SQL
    create table users(
      id serial primary key,
      name varchar unique
    );

Rails' `validates_uniqueness_of` is not a guarantee. The database is.

!SLIDE
# Partial Indexes

    @@@ SQL
    create table posts(
      id serial primary key,
      body text not null,
      front_page boolean not null
    );

    create index on posts (front_page) where front_page;

Could have millions of posts, but only handful of front page posts.

Index will only contain rows that are front page and will not be bloated
by the millions of old posts.

!SLIDE
# Partial unique indexes

    @@@ SQL
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

!SLIDE
# Functional indexes

    @@@ SQL
    create table users(
      id serial primary key,
      name varchar not null
    );

    create unique index on users (lower(name));

This will guarantee case-insensitive uniqueness, and will preserve the original case.

An index can be created on the result of a stable expression.
