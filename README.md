# Recommender

Given a set of resources `Subtopics` and a table of `Listens` mapping users to the subtopics they consumed, Recommender can take an input subtopic and output recommendations (based on [tf-idf](https://en.wikipedia.org/wiki/Tf%E2%80%93idf) weighting) for other subtopics relevant to the user.

Database configuration is in the config folder. To test locally, ensure there's a local Postgres server running with a database called "development," and the `$PG_USER` and `$PG_PASS` variables are defined in the environment.

Run the `bundle install` to install the gems and `rake db:migrate` to build the database tables (note: The `listens.json` and `subtopics.json` have been scrubbed of their original data). Then run the app via `ruby app.rb`. The first time the app runs it will populate the database. A local Sinatra server will start and you can send requests like

```text
$ curl http://localhost:4567/recommendations?subtopic=56bc63839eb399e02d18bcce
```
