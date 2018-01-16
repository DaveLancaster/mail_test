import unittest
import mail_test
import ospaths

suite "unit test suite for mail checking api.":

  setup:
    putEnv("NIM_SSL_CERT_VALIDATION", "insecure")
    let domain = "foobarbaz.com"

  test "can detect active domain":
    putEnv("MAIL_API_BASE", "https://active.mailtest.in")
    check(mail_test.check(domain).active)

  test "can detect disposable domain":
    putEnv("MAIL_API_BASE", "https://disposable.mailtest.in")
    check(mail_test.check(domain).disposable)
  
  test "can detect robot domain":
    putEnv("MAIL_API_BASE", "https://robot.mailtest.in")
    check(mail_test.check(domain).robot)

  test "can detect invalid domain":
    putEnv("MAIL_API_BASE", "https://invalid.mailtest.in")
    check(mail_test.check(domain).invalid)
