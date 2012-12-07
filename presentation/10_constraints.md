!SLIDE
# Constraints

!SLIDE
# NOT NULL

    @@@ SQL
    create table people(
      id serial primary key
      name varchar not null
    );

or

    @@@ ruby
    create_table :people do |t|
      t.column :name, :string, null: false
    end

Nulls short circuit almost every operation to null. Avoid if possible.

!SLIDE
# Foreign keys constraints

    @@@ SQL
    create table posts(
      id serial primary key,
      author_id integer not null references authors
      body text not null
    );

Foreign key constraints ensure that you do not have get orphaned records.


!SLIDE
# Check constraints

    @@@ SQL
    create table reservations(
      id serial primary key,
      room_id integer not null references rooms,
      start_time timestamp not null,
      end_time timestamp not null,
      check (start_time < end_time)
    );

Arbitrary declarative data constraints
