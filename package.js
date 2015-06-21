Package.describe({
  name: 'ccorcos:neo4j',
  summary: 'Neo4j API for Meteor',
  version: '0.0.2',
  git: 'https://github.com/ccorcos/meteor-neo4j'
});

Package.onUse(function(api) {
  api.versionsFrom('1.0');
  api.use([
    'coffeescript', 
    'http',
    'ramda:ramda@0.13.0'
  ], 'server');
  api.addFiles('src/driver.coffee', 'server');
  api.export('Neo4jDB')
});
