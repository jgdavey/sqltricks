!SLIDE
# Views

* Present the data with the interface your application wants
* Store normalized data, present denormalized

!SLIDE
# A Simple View

    @@@ SQL
    CREATE VIEW comedies AS
      SELECT *
      FROM films
      WHERE kind = 'Comedy';

!SLIDE
# Presenting data in a view

!SLIDE[tpl=verbose]
# "Normalize" denormalized data

    @@@ SQL
    CREATE VIEW emails AS
      SELECT user_id, CASCADE(profiles.email, users.email) AS email
      FROM users
      INNER JOIN profiles
      ON users.id = profiles.user_id ;

!SLIDE
# More stuff about views

* Views can be writable (using functions/triggers)
