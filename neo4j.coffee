
stringify = (value) ->
  # turn an object into a string that plays well with Cipher queries.
  if _.isArray(value)
    "[#{value.map(stringify).join(',')}]"
  else if U.isPlainObject(value)
    pairs = []
    for k,v of value
      pairs.push "#{k}:#{stringify(v)}"
    "{" + pairs.join(', ') + "}"
  else if _.isString(value)
    "'#{value.replace(/'/g, "\\'")}'"
  else if value is undefined
    null
  else
    "#{value}"

regexify = (string) ->
  "'(?i).*#{string.replace(/'/g, "\\'").replace(/\//g, '\/')}.*'"

# transpose a 2D array
transpose = (xy) ->
  # get the index, pull the nth item, pass that function to map
  R.mapIndexed(R.pipe(R.nthArg(1), R.nth, R.map(R.__, xy)), R.head(xy))

# turns a matrix of rows by columns into rows with key values.
# zip(keys, rowsByColumns) -> [{key:val}, ...]
zip = R.curry (keys, data) ->
  z = R.useWith(R.map, R.zipObj)
  if keys.length is 1
    z(keys, data.map((elm) -> [elm]))
  else
    z(keys, data)

ensureTrailingSlash = (url) ->
  if url[url.length-1] isnt '/'
    return url + '/'
  else
    return url

ensureEnding = (url) ->
  ending = 'db/data/'
  if url[url.length-ending.length...url.length] is ending
    return url
  else
    return url + ending

parseUrl = (url) ->
  url = ensureTrailingSlash(url)
  url = ensureEnding(url)
  match = url.match(/^(.*\/\/)(.*)@(.*$)/)
  if match
  # [ 'http://username:password@localhost:7474/',
  #   'http://',
  #   'username:password',
  #   'localhost:7474/']
    url = match[1] + match[3]
    auth = match[2]
    return {url, auth}
  else
    return {url}

# create a Neo4j connection. you could potentially connect to multiple.
Neo4jDb = (url) ->
  db = {}
  db.options = {}
  # configure url and auth
  url = url or 'http://localhost:7474/'
  {url, auth} = parseUrl(url)
  db.url = url
  if auth
    db.options.auth = auth

  log = console.log.bind(console, "[#{db.url}] neo4j")
  warn = console.warn.bind(console, "[#{db.url}] neo4j")

  # run http queries catching errors with nice logs
  db.http = (f) ->
    try
      return f()
    catch error
      if error.response
        code = error.response.statusCode
        message = error.response.message
        if code is 401
          warn "[#{code}] auth error:\n", db.options.auth, "\n" + message
        else
          warn "[#{code}] error response:", message
      else
        warn "error:", error.toString()
      return

  # test the connection
  db.connect = ->
    db.http ->
      log "connecting..."
      response  = HTTP.call('GET', db.url, db.options)
      if response.statusCode is 200
        log "connected"
      else
        warn "could not connect\n", response.toString()

  # test the database latency
  db.latency = ->
    db.http ->
      R.mean [0...10].map ->
        start = Date.now()
        HTTP.call('GET', db.url, db.options)
        Date.now() - start

  # get a query. if theres only one column, the results are flattened. else
  # it returns a 2D array of rows by columns.
  db.query = (statement, parameters={}) ->
    result = db.http ->
      params = R.merge(db.options, {data: {statements: [{statement, parameters}]}})
      response = HTTP.post(db.url+"transaction/commit", params)
      # neo4j can take multiple queries at once, but we're just doing one
      if response.data.results.length is 1
        # get the first result
        result = response.data.results[0]
        # the result is a 2D array of rows by columns
        # if there was no return statement, then lets return nothing
        if result.columns.length is 0
          return []
        else if result.columns.length is 1
          # if theres only one column returned then lets flatten the results
          # so we just get that column across all rows
          return R.pipe(R.map(R.prop('row')), R.flatten)(result.data)
        else
          # if there are multiple columns, return an array of rows
          return R.map(R.prop('row'))(result.data)
    # if we get an error, lets still just return an empty array of data
    # so we can map over it or whatever we expected to do originally.
    return result or []

  db.reset = ->
    log "resetting..."
    db.query "MATCH (n) OPTIONAL MATCH (n)-[r]-() DELETE n,r"
    log "reset"

  db.isEmpty = ->
    [n] = Neo4j.query("MATCH (n) MATCH (n)-[r]-() RETURN count(n)+count(r)")
    return (n is 0)

  # some utils for generating cypher queries
  db.stringify = stringify
  db.regexify = regexify
  db.transpose = transpose
  db.zip = zip

  db.connect()
  return db

# autoconnect to neo4j if given the appropriate settings or environment variable
if url = Meteor.settings.neo4j_url
  Neo4j = Neo4jDb(url)
else if url = process.env.NEO4J_URL
  Neo4j = Neo4jDb(url)

@Neo4j = Neo4j
@Neo4jDb = Neo4jDb
