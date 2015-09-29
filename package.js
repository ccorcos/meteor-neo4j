Package.describe({
  name: 'ccorcos:neo4j',
  summary: 'Neo4j API for Meteor',
  version: '0.1.1',
  git: 'https://github.com/ccorcos/meteor-neo4j'
});

Package.onUse(function(api) {
  api.versionsFrom('1.0');
  var packages = [
    'coffeescript',
    'http',
    'ccorcos:utils@0.0.1'
  ]
  api.use(packages);
  api.imply(packages);
  api.addFiles(['neo4j.coffee', 'globals.js'], 'server');
  api.export(['Neo4jDB', 'Neo4j'], 'server');
});
