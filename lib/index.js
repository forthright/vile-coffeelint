var
path = require("path"),
coffeelint = require("coffeelint"),
cjson = require("cjson"),
_ = require("lodash"),
vile = require("vile")

var IS_CS = /\.coffee$/
var CSLint = coffeelint.lint

function is_cs_file(file, is_dir) {
  return is_dir || IS_CS.test(file)
}

function allowed(ignore, allow) {
  var filtered = vile.filter(ignore, allow)
  return function (file, is_dir) {
    return filtered(file) && is_cs_file(file, is_dir)
  }
}

function load_config(filename) {
  return cjson.load(path.join(process.cwd(), filename))
}

function config(custom_config) {
  if (typeof custom_config == "string") {
    return load_config(custom_config)
  } else if (!custom_config) {
    return load_config("coffeelint.json")
  } else {
    return custom_config
  }
}

function lint(fileData, cs_config) {
  return new CSLint(fileData, cs_config)
}

function into_issues(cs_config) {
  return function (filepath, data) {
    var errors = lint(data, cs_config)

    if (errors.length > 0) {
      return errors.map(function (result) {
        return vile.issue({
          // TODO: what are actually warnings? all seem to be errors
          type: vile.STYL,
          path: filepath,
          title: result.rule,
          message: result.message + " (" + result.context + ")",
          where: { start: { line: result.lineNumber } },
          signature: "coffeelint::" + result.rule
        })
      })
    } else {
      return []
    }
  }
}

function punish(user_config) {
  var cs_config = config(_.get(user_config, "config"))
  var ignore = _.get(user_config, "ignore")
  var allow = _.get(user_config, "allow")

  return vile.promise_each(
    process.cwd(),
    allowed(ignore, allow),
    into_issues(cs_config))
}

module.exports = {
  punish: punish
}
