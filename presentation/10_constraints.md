!SLIDE
# Data integrity is not a feature

!SLIDE
# Constraints

!SLIDE[tpl=verbose]
# not null

Nulls short circuit almost every operation to null. Avoid if possible.

    @@@ sql
    create table people(
      id serial primary key,
      name varchar not null
    );

    insert into people(name) values(null);

    ERROR:  null value in column "name" violates not-null constraint
    DETAIL:  Failing row contains (1, null).

!SLIDE[tpl=verbose]
# Foreign keys constraints

Foreign key constraints ensure that you do not have get orphaned records.

    @@@ sql
    create table authors(
      id serial primary key,
      name varchar not null
    );

    create table posts(
      id serial primary key,
      author_id integer not null references authors,
      body text not null
    );

!SLIDE[tpl=verbose]

    @@@ sql
    insert into authors(id, name) values(1, 'John');
    insert into posts(author_id, body) values(1, '...');
    delete from authors;

    ERROR:  update or delete on table "authors" violates foreign key
    constraint "posts_author_id_fkey" on table "posts"
    DETAIL:  Key (id)=(1) is still referenced from table "posts".


!SLIDE[tpl=verbose]
# Check constraints

Arbitrary declarative data constraints

    @@@ sql
    create table reservations(
      id serial primary key,
      start_time timestamp not null,
      end_time timestamp not null,
      check (start_time < end_time)
    );

    insert into reservations(start_time, end_time) values(
      '2012-12-07 10:00:00', '2012-12-07 09:00:00');

    ERROR:  new row for relation "reservations" violates
      check constraint "reservations_check"
    DETAIL:  Failing row contains (1, 2012-12-07 10:00:00,
      2012-12-07 09:00:00).

