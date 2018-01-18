import httpclient, json, ospaths

type 
  Domain = string

  QueryString = string

  Status* = enum
    ACTIVE, DISPOSABLE, ROBOT, INVALID, UNKNOWN, ERROR

  Response* = object
    code*: string
    status*: Status
    message*:  string

  MailTester = object
    host: string
    version: string
    client: HttpClient

method 
  active*(this: Response): bool {.base.} =
    this.status == ACTIVE
method 
  disposable*(this: Response): bool {.base.} =
    this.status == DISPOSABLE
method 
  robot*(this: Response): bool {.base.} =
    this.status == ROBOT
method 
  invalid*(this: Response): bool {.base.} =
    this.status == INVALID

method 
  url(this: MailTester, domain: Domain): QueryString {.base.} =
    this.host & "/" & this.version & "/" & domain
method 
  check(this: MailTester, domain: Domain): Response {.base.} =
    this.client
      .getContent(this.url(domain))
      .parseJson()
      .to(Response)

proc 
  apiBase: string =
    if existsEnv("MAIL_API_BASE"):
      getEnv("MAIL_API_BASE")
    else:
      "https://api.mailtest.in"

proc 
  newMailTester: MailTester =
    MailTester(
      host: apiBase(),
      version: "v1",
      client: newHttpClient())

proc
  check*(domain: Domain): Response =
    newMailTester().check(domain)
