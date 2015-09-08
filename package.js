Package.describe({
  name: 'ccorcos:neo4j',
  summary: 'Neo4j API for Meteor',
  version: '0.1.0',
  git: 'https://github.com/ccorcos/meteor-neo4j'
});

Package.onUse(function(api) {
  api.versionsFrom('1.0');
  api.use([
    'coffeescript',
    'http',
    'ramda:ramda@0.17.1'
  ], 'server');
  api.addFiles(['neo4j.coffee', 'globals.js'], 'server');
  api.export(['Neo4jDB', 'Neo4j'], 'server');
});
