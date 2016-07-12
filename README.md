# vile-coffeelint [![Circle CI](https://circleci.com/gh/forthright/vile-coffeelint.svg?style=svg&circle-token=6bbf75220c0e528b8a4ce2bc9426ea9f6b4df911)](https://circleci.com/gh/forthright/vile-coffeelint)

[![score-badge](https://vile.io/brentlintner/vile-coffeelint/badges/score?token=uFywUmzZfbg6UboLzn6R)](https://vile.io/brentlintner/vile-coffeelint) [![security-badge](https://vile.io/brentlintner/vile-coffeelint/badges/security?token=uFywUmzZfbg6UboLzn6R)](https://vile.io/brentlintner/vile-coffeelint) [![coverage-badge](https://vile.io/brentlintner/vile-coffeelint/badges/coverage?token=uFywUmzZfbg6UboLzn6R)](https://vile.io/brentlintner/vile-coffeelint) [![dependency-badge](https://vile.io/brentlintner/vile-coffeelint/badges/dependency?token=uFywUmzZfbg6UboLzn6R)](https://vile.io/brentlintner/vile-coffeelint)

A [vile](https://vile.io) plugin for [coffeelint](http://coffeelint.org).

## Requirements

- [nodejs](http://nodejs.org)
- [npm](http://npmjs.org)

## Installation

    npm i vile --save-dev
    npm i vile-coffeelint --save-dev

## Config

By default, config defaults to `coffeelint.json`.

You can specify a custom one, instead:

```yaml
coffeelint:
  config: path/to/cs_config.json
```

## Ignoring Files

`vile.ignore` is used as a base, but you can add onto it:

```yaml
coffeelint:
  ignore:
    - some/path/**
    - file
    - dir
```

## Allowing Files

`vile.allow` is used as a base, but you alternatively specify:

```yaml
coffeelint:
  allow:
    - dir
```

## Licensing

This project is licensed under the [MPL](https://www.mozilla.org/MPL/2.0) license.

Any contributions made to this project are made under the current license.

## Hacking

    cd vile-coffeelint
    npm install
    npm test

To run compile task with file watch in the background:

    npm run dev

To run tests with coverage:

    npm run test-cov

See `package.json` for other available scripts.

## Versioning

This project ascribes to [semantic versioning](http://semver.org).

## Contributions

Current list of [Contributors]().

Any contributions are welcome and appreciated!

All you need to do is submit a [Pull Request]().

1. Please consider tests and code quality before submitting.
2. Please try to keep commits clean, atomic and well explained (for others).

### Issues

Current issue tracker is on [GitHub]().

Even if you are uncomfortable with code, an issue or question is welcome.

### Code Of Conduct

This project ascribes to CoralineAda's [Contributor Covenant](https://github.com/CoralineAda/contributor_covenant).

### Maintainers

- Brent Lintner - [@brentlintner](http://github.com/brentlintner)

## Architecture

The node library written in basic JavaScript.

The test code is written in [CoffeeScript](http://coffeescript.org).
