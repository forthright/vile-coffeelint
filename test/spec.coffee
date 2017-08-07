path = require "path"
_ = require "lodash"
chai = require "./helpers/sinon_chai"
mimus = require "mimus"
sinon = require "sinon"
expect = chai.expect
vile = require "vile"
lib = mimus.require "../lib/index", __dirname

vile = mimus.get lib, "vile"

system_test_cl_config = require "./../test/fixtures/coffeelint"
system_test_dir = path.resolve path.join __dirname, "..", "test", "fixtures"

change_into_system_test_dir_on_each = ->
  cwd = undefined

  beforeEach ->
    cwd = process.cwd()
    process.chdir system_test_dir

  afterEach ->
    process.chdir cwd

describe "vile-coffeelint", ->
  change_into_system_test_dir_on_each()

  afterEach -> mimus.reset()

  describe "punish", ->
    describe "types of config", ->
      OldCSSLint = undefined
      CSLint = undefined

      beforeEach ->
        OldCSSLint = mimus.get lib, "CSLint"
        CSLint = mimus.stub()
        mimus.set lib, "CSLint", CSLint

      afterEach ->
        mimus.set lib, "CSLint", OldCSSLint

      describe "with nothing given", ->
        beforeEach -> mimus.spy path, "join"

        it "attempts to use 'coffeelint.json'", (done) ->
          lib.punish().should.be.fulfilled
            .then ->
              path.join.should.have.been
              .calledWith process.cwd(), "coffeelint.json"
            .should.notify done

      describe "with an inline object config", ->
        config = config: arrow_spacing: level: "warn"

        it "uses that", (done) ->
          lib.punish(config).should.be.fulfilled
            .notify ->
              setTimeout ->
                CSLint.should.have.been.called
                expect(CSLint.args[0][1]).to.eql config.config
                done()
          return

    describe "with no files", ->
      it "returns an empty array", ->
        config =
          config: "coffeelint.json"
          ignore: [ "*.coffee" ]

        lib.punish(config).should.become []

    describe "with an erroneous file", ->
      # TODO: is everything just errors? (no warnings)
      expected = [{
        type: "style",
        path: "file_with_errors.coffee",
        title: "no_trailing_semicolons",
        message: "Line contains a trailing semicolon (undefined)",
        signature: "coffeelint::no_trailing_semicolons",
        where: { start: { line: 1 } }
      }, {
        type: "style",
        path: "file_with_warnings.coffee",
        title: "max_line_length",
        message: "Line exceeds maximum allowed length" +
                  " (Length is 97, max is 80)",
        signature: "coffeelint::max_line_length",
        where: { start: { line: 1 } }
      }]

      it "finds issues", ->
        config =
          config: "coffeelint.json"
          ignore: [ "file_without_errors.coffee" ]

        lib.punish(config).should.become expected
