[![Meteor Icon](http://icon.meteor.com/package/ccorcos:neo4j)](https://atmospherejs.com/ccorcos/neo4j)

# Meteor Neo4j [MAINTAINER WANTED]

This package allows you to connect and query Neo4j from Meteor.

[Check out this article](https://medium.com/p/17b0fce644d/).

## Installation (Mac)

```
# install neo4j
brew install neo4j
# add ccorcos:neo4j to your project
meteor add ccorcos:neo4j
# start neo4j
neo4j start
# start meteor
meteor
# stop neo4j
neo4j stop
```

You can access the Neo4j admin browser interface [here](http://localhost:7474/).

## Commandline Utilities

`m4j` can start and stop Neo4j localized to your `.meteor` project.

```
curl -O https://raw.githubusercontent.com/ccorcos/meteor-neo4j/master/m4j
chmod +x m4j
# start within a meteor project
m4j start
# stop neo4j
m4j stop
```

`m4j` will edit the configuration files for Neo4j to do this so you need to
provide a `NEO4J_PATH` environment variable. Put this in your `~/.bashrc`:

```
export NEO4J_PATH=/usr/local/Cellar/neo4j/2.1.7
```

Also, `meteor reset` will clear Neo4j as well, but you may want to make sure
to stop Neo4j before doing that.

## API

You can create a Neo4j connection (url defaults to `localhost:7474`)

```coffee
Neo4j = new Neo4jDb(optionalUrl)
```

Neo4j will be autoconnected if given `Meteor.settings.neo4j_url` or `process.env.NEO4J_URL`.

You can query Neo4j using [Cypher](http://neo4j.com/docs/stable/cypher-query-lang.html).

```coffee
result = Neo4j.query "MATCH (a) RETURN a"
```

When stringifying variables into Cypher queries, use `Neo4j.stringify` and `Neo4j.regexify`.

```coffee
str = Neo4jDB.stringify
Neo4j.query "CREATE (p:PERSON #{str(user)}) RETURN p"

regex = Neo4jDB.regexify
Neo4j.query "CREATE (p:PERSON) WHERE p.name =~ #{regex(query)} RETURN p"
```
