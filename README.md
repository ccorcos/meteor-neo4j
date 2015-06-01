# Getting Started

Install and setup Neo4j

    brew install neo4j
    npm install -g neo4j

Then start Neo4j and start Meteor

    neo4j start
    meteor

You should be able to see the Neo4j browser at the Neo4j url (default: http://localhost:7474/).

When you're done, be sure to stop Neo4j as well

    neo4j stop

Sometimes it hangs and won't stop. Try `ps aux | grep neo4j` and then `kill -9 <pid>`.

To reset Neo4j, delete `data/graph.db`. If you used brew to install Neo4j, then the path will be similar to the following:

    rm -rf /usr/local/Cellar/neo4j/2.1.7/libexec/data/graph.db

Or you can use the following queries to delete all relationships and all nodes

    match ()-[r]->(), (n) delete r,n

Or you can use the `.reset` method attached to the Neo4j object. This is much slower though.

To instatiate a connection, on the server, use

    Neo4j = new Neo4jDB()

Also note, that Neo4j does not accept nested property lists, so its best to structure your Mongo collections similarly.