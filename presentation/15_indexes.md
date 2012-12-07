!SLIDE
# Indexes

!SLIDE[tpl=verbose]
# Unique

Rails' validates\_uniqueness\_of is not a guarantee. The database is.

    @@@ sql
    create table users(
      id serial primary key,
      name varchar unique
    );

    insert into users(name) values('John');
    insert into users(name) values('John');

    ERROR:  duplicate key value violates unique
      constraint "users_name_key"
    DETAIL:  Key (name)=(John) already exists.

!SLIDE[tpl=verbose]
# Partial Indexes

    @@@ sql
    create table posts(
      id serial primary key,
      body text not null,
      front_page boolean not null
    );

    create index on posts (front_page) where front_page;

Could have millions of posts, but only handful of front page posts. Index will only contain rows that are front page and will not be bloated by the millions of old posts.

!SLIDE[tpl=verbose]
# Partial unique indexes

    @@@ sql
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

!SLIDE[tpl=verbose]

    @@@ sql
    insert into teams(id, name) values(1, 'Bulls');
    insert into players(team_id, captain, name) values(
      1, true, 'Michael Jordan');
    insert into players(team_id, captain, name) values(
      1, true, 'Scotty Pippen');

    ERROR:  duplicate key value violates unique
      constraint "players_team_id_idx"
    DETAIL:  Key (team_id)=(1) already exists.

!SLIDE[tpl=verbose]
# Functional indexes

    @@@ sql
    create table users(
      id serial primary key,
      name varchar not null
    );

    create unique index on users (lower(name));

This will guarantee case-insensitive uniqueness, and will preserve the original case.

An index can be created on the result of a stable expression.