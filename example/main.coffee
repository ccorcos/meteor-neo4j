# This example shows a simple friend network, displaying the
# person with the most friends, and a list of that person's friends.

if Meteor.isServer
  @Neo4j = new Neo4jDB()

  createPerson = (name) ->
    Neo4j.query "CREATE (:PERSON {name:'#{name}'})"

  createFriends = ([name1, name2]) ->
    Neo4j.query """
      MATCH  (a:PERSON {name:'#{name1}'}),
             (b:PERSON {name:'#{name2}'})
      CREATE (a)-[:FRIENDS]->(b)
      """

  Meteor.startup ->
    if Neo4j.isEmpty()
      console.log("seeding")
      [ 
        'chet'
        'ryan'
        'joe'
        'charlie'
        'devon'
        'luke'
      ].map(createPerson)

      [
        ['chet', 'ryan']
        ['chet', 'luke']
        ['chet', 'devon']
        ['chet', 'charlie']
        ['ryan', 'luke']
        ['ryan', 'charlie']
        ['joe', 'devon']
        ['charlie', 'devon']
      ].map(createFriends)

Meteor.methods
  mostPopular: ->
    result = Neo4j.query """
      MATCH (a:PERSON)-[:FRIENDS]-(b:PERSON)
      RETURN a, collect(b), count(b) as count
      ORDER BY count DESC
      LIMIT 1
    """
    person = result[0][0]
    friends = result[1][0]
    return {person, friends}


if Meteor.isClient
  Session.setDefault('person', {})
  Session.setDefault('friends', [])

  Template.main.onRendered ->
    Meteor.call 'mostPopular', (err, {person, friends}) ->
      Session.set('person', person)
      Session.set('friends', friends)

  Template.main.helpers
    person: () -> Session.get('person')
    friends: () -> Session.get('friends')