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

proc 
  active*(this: Response): bool =
    this.status == ACTIVE

proc 
  disposable*(this: Response): bool =
    this.status == DISPOSABLE

proc 
  robot*(this: Response): bool =
    this.status == ROBOT

proc 
  invalid*(this: Response): bool =
    this.status == INVALID

proc
  url(this: MailTester, domain: Domain): QueryString =
    this.host & "/" & this.version & "/" & domain

proc
  check(this: MailTester, domain: Domain): Response =
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
