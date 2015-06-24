# Meteor Neo4j

This package allows you to use the open-source graph database Neo4j with your Meteor project.

## Installation and Setup

You will have to install Neo4j on your machine. If you're on a Mac using Homebrew:

    brew install neo4j

Then add this package to your Meteor project:

    meteor add ccorcos:neo4j

You can get up and running quickly by starting Neo4j, and then starting Meteor:

    neo4j start
    meteor

Neo4j has a nice browser interface so be sure to check it out! 
The default URL is http://localhost:7474/

Then, when you're done, make sure you stop Neo4j as well:

    neo4j stop

### CLI

I'm working on a command-line tool for this package. 
Hopefully at some point, Meteor will allow some hooks into the build system.
The main benefit of this tool is that it creates a Neo4j database in `.meteor/local/neo4j/`
so that you can separate your projects nicely. First, download the script and make it
executable.

    curl -O https://raw.githubusercontent.com/ccorcos/meteor-neo4j/master/m4j
    chmod +x m4j

Make sure this script is somewhere on your path. Then from inside your Meteor project, 
you can start Neo4j and it will create a database for this project if it doesn't already exist.

    m4j start

Then feel free to start up Meteor. And when you're done, you can stop using:

    m4j stop

Finally, when you use `meteor reset`, it will also clear the Neo4j database because `meteor reset`
clears the project's `.meteor/local/` directory. 
Just **make sure you stop Neo4j before resetting meteor**.


## API

On the server, start the database connection:

    Neo4j = new Neo4jDB()

This defaults to running on `http://localhost:7474/`. 
If you want to connect to a Neo4j instance running elsewhere, 
you can pass a url string with authentication:

    Neo4j = new Neo4jDB("http://username:password@project.graphenedb.com:24789")

You can also set the an environment variable for `NEO4J_URL` or `GRAPHENEDB_URL`.

Neo4j uses a querying language called [Cypher](http://neo4j.com/docs/stable/cypher-query-lang.html).
You can run a query like this:

    result = Neo4j.query("MATCH (a) RETURN a")

I like to write multi-line queries in Coffeescript, which are generally easier to read:

    result = Neo4j.query """
                         MATCH (n)
                         RETURN n
                         """

Neo4j has an interesting way of returning results and I've come up with a reasonable
way of interpreting them.

- If there are no items to be returned, `query` returns undefined.
- If you query for an array of values, you'll get just that. e.g `MATCH (n) RETURN n`
- If you query for a property, you'll get an array as well. e.g.  `MATCH (n) RETURN n.name`
- If you query multiple properties, you'll get a 2D array. e.g. `MATCH (n) RETURN n.name, n.email`

Neo4j queries don't play will with `JSON.stringify` for a variety of reasons.
For that reason, use `Neo4j.stringify`. e.g. 

    Neo4j.query "CREATE (:PERSON #{Neo4j.stringify(user)})"

You can clear the database at the commandline:

    neo4j stop
    meteor reset

Or you can clear it in Node:

    Neo4j.reset()

You can also check to see if the database is empty using:

    Neo4j.isEmpty()

## Deploy

There are several hosting solution for Neo4j. 
[GrapheneDB](http://www.graphenedb.com/) is popular.

## Quirks

- Sometimes Neo4j hangs and won't stop. Try `ps aux | grep neo4j` and then `kill -9 <pid>`.
- Neo4j does not accept nested property lists!