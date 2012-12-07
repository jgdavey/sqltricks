!SLIDE[tpl=verbose]
# Enum

    @@@ sql
    create type grade_level as enum ('freshman',
      'sophomore', 'junior', 'senior', 'graduate');

    create table students(
      id serial primary key,
      name varchar not null,
      grade_level grade_level not null
    );

    insert into students(name, grade_level) values(
      'John', 'freshman');
    insert into students(name, grade_level) values(
      'Jane', 'senior');
    insert into students(name, grade_level) values(
      'Kari', 'junior');

!SLIDE[tpl=verbose]

Database only store values allowed by enumeration

    @@@ sql
    insert into students(name, grade_level) values('Samwise', 'hobbit');

    ERROR:  invalid input value for enum grade_level: "hobbit"
    LINE 1: ...nto students(name, grade_level)
      values('Samwise', 'hobbit');

!SLIDE[tpl=verbose]

Order by will respect order of enumeration

    @@@ sql
    select * from students order by grade_level;

     id | name | grade_level 
    ----+------+-------------
      1 | John | freshman
      3 | Kari | junior
      2 | Jane | senior
    (3 rows)


!SLIDE
# hstore

* Key/value pairs
* Only strings
* Indexable

!SLIDE[tpl=verbose]

    @@@ sql
    create extension hstore;

    create table users(
      id serial primary key,
      name citext not null,
      settings hstore not null 
    );

    create index on users using gist (settings);

!SLIDE[tpl=verbose]

    @@@sql
    insert into users(name, settings) values(
      'jack', 'home=>/home/jack, shell=>/bin/bash');
    insert into users(name, settings) values(
      'josh', 'home=>/home/josh, shell=>/bin/zsh');
    select * from users where settings -> 'shell' = '/bin/bash';

     id | name |                  settings                  
    ----+------+--------------------------------------------
      3 | jack | "home"=>"/home/jack", "shell"=>"/bin/bash"
    (1 row)

!SLIDE

# Rails support

* Baked into Rails 4
* Available with gem in Rails 3

!SLIDE[tpl=verbose]

# Rails 3 Example

Using Surus gem

    @@@ ruby
    class User < ActiveRecord::Base
      serialize :properties, Surus::Hstore::Serializer.new
    end
    
    # Can serialize anything Rails can
    User.create :properties =>
      { :favorite_color => "green", :results_per_page => 20 }
    User.create :properties =>
      { :favorite_colors => ["green", "blue", "red"] }

    # Search helpers
    User.hstore_has_pairs(:properties, "favorite_color" => "green")

!SLIDE[tpl=verbose]
# citext

Case-preserving and case insensitive text

    @@@ sql
    create extension citext;

    create table users(
      id serial primary key,
      name citext not null unique
    );

!SLIDE[tpl=verbose]

Useful for case insensitive uniqueness
    
    @@@ sql
    insert into users(name) values('John');
    insert into users(name) values('john');

    ERROR:  duplicate key value violates unique
      constraint "users_name_key"
    DETAIL:  Key (name)=(john) already exists.

!SLIDE[tpl=verbose]

Useful for case insensitive searching

    @@@ sql
    insert into users(name) values('John');
    select * from users where name = 'john';

     id | name 
    ----+------
      1 | John
    (1 row)

!SLIDE[tpl=verbose]
# JSON

Store validated JSON

    @@@ sql
    create table documents(
      id serial primary key,
      body json not null
    );

    insert into documents(body) values('{"foo": "bar"}');
    insert into documents(body) values('invalid json');

    ERROR:  invalid input syntax for type json
    LINE 1: insert into documents(body) values('invalid json');
                                               ^
    DETAIL:  Token "invalid" is invalid.
    CONTEXT:  JSON data, line 1: invalid...

!SLIDE[tpl=verbose]
# inet

IP address data type

    @@@ sql
    create table login_attempts(
      id serial primary key,
      user_name varchar not null,
      successful boolean not null,
      remote_ip inet not null,
      created_at timestamp not null
    );

    insert into login_attempts(user_name, successful, remote_ip,
      created_at) values('jack', false, '10.15.0.1', now());
    insert into login_attempts(user_name, successful, remote_ip,
      created_at) values('jack', false, '300.1.1.1', now());

    ERROR:  invalid input syntax for type inet: "300.1.1.1"
    LINE 1: ...ful, remote_ip, created_at) values('jack',
      false, '300.1.1.1...

!SLIDE[tpl=verbose]

Advanced functions such as subnet searching

    @@@ sql
    insert into login_attempts(user_name, successful, remote_ip,
      created_at) values('jack', false, '10.15.0.2', now());
    select * from login_attempts where '10.15.0.0/16' >> remote_ip;

     id | user_name | successful | remote_ip |         created_at         
    ----+-----------+------------+-----------+----------------------------
      2 | jack      | f          | 10.15.0.2 | 2012-12-06 19:20:33.318967
    (1 row)
