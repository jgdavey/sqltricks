!SLIDE
# Enum

FIXME -- double check this syntax

    @@@ SQL
    create enum grade_level('freshman',
      'sophomore', 'junior', 'senior', 'graduate');

    create table students(
      id serial primary key,
      name varchar not null,
      grade_level grade_level not null
    );

Will only store correct values. Will sort by order given in the enum.

!SLIDE
# hstore

TODO

!SLIDE
# citext

    @@@ SQL
    create table users(
      id serial primary key,
      name citext not null unique
    );

Case-preserving and case insensitive.

!SLIDE
# json

TODO

!SLIDE
# inet

    @@@ SQL
    create table logins_attempts(
      id serial primary key,
      user_name varchar not null,
      successful boolean not null,
      remote_ip inet not null,
      created_at timestamp not null
    );
