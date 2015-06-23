Tinytest.add('Should use localhost if no url provided and ENV vars set', function (test) {
  Neo4j = new Neo4jDB();
  test.equal(Neo4j.url, "http://localhost:7474");
});

Tinytest.add('Should take a url string', function (test) {
  Neo4j = new Neo4jDB('my secret url');
  test.equal(Neo4j.url, "my secret url");
});

Tinytest.add('Should use NEO4J_URL environment variable if no strings', function (test) {
  process.env['NEO4J_URL'] = "ABC";
  Neo4j = new Neo4jDB();
  test.equal(Neo4j.url, "ABC");
  delete process.env['NEO4J_URL'];
});

Tinytest.add('Should use GRAPHENEDB_URL environment variable if no strings', function (test) {
  process.env['GRAPHENEDB_URL'] = "123";
  Neo4j = new Neo4jDB();
  test.equal(Neo4j.url, "123");
  delete process.env['GRAPHENEDB_URL'];
});
