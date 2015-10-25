path = require "path"
_ = require "lodash"
sinon_chai = require "./helpers/sinon_chai"
mimus = require "mimus"
sinon = require "sinon"
chai = require "chai"
expect = chai.expect
lib = mimus.require "../lib/index", __dirname, ["vile"]

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
            .then ->
              CSLint.should.have.been.calledWith(
                sinon.match.string,
                config.config
              )
            .should.notify done

    describe "with an erroneous file", ->
      expected = [{
        type: "error",
        file: "file_with_errors.coffee",
        msg: "Line contains a trailing semicolon (undefined)",
        where: { start: { line: 1 }, end: {} }
      }, {
        type: "error",
        file: "file_with_errors.coffee",
        msg: "Line contains inconsistent indentation (Expected 2 got 3)",
        where: { start: { line: 4 }, end: {} }
      }]

      it "finds issues", ->
        config =
          config: "coffeelint.json"
          ignore: [ "file_without_errors.coffee" ]

        lib.punish(config).should.become expected

    describe "with an errorless file", ->
      it "finds no issues", ->
        config =
          config: "coffeelint.json"
          ignore: [ "file_with_errors.coffee" ]

        lib.punish(config).should.become [{
          type: "ok",
          file: "file_without_errors.coffee",
          msg: "",
          where: { start: {}, end: {} }
        }]
