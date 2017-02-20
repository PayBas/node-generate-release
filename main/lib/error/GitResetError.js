// Generated by CoffeeScript 1.12.4

/*
  Generate Release
  Kevin Gravier
  MIT License
 */

(function() {
  var GitResetError,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  GitResetError = (function(superClass) {
    extend(GitResetError, superClass);

    function GitResetError(original_error) {
      this.original_error = original_error;
      if (this.original_error != null) {
        this.message = this.original_error.message;
      } else {
        this.message = 'Unknown Error, Resetting';
      }
    }

    return GitResetError;

  })(Error);

  module.exports = GitResetError;

}).call(this);
