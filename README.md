# MailTest

A simple nim wrapper for the free mailtest.in service.

https://mailtest.in

## Tests

Clone the repository and run the following from the root directory.

```
nimble test
```

## Usage

```
import mail_test
mail_test.check("foo.org").echo
```

## License

MIT
