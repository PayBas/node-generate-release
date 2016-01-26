###
  Generate Release
  Kevin Gravier
  MIT License
###

IS_DEBUG = process.env.IS_DEBUG?

Promise = require 'bluebird'
Minimist = require 'minimist'

Options = require './lib/Options'
askReleaseType = require './lib/askReleaseType'
incrementVersion = require './lib/incrementVersion'
askConfirmUpdate = require './lib/askConfirmUpdate'
readVersionFromPackage = require './lib/readVersionFromPackage'
writeNewPackage = require './lib/writeNewPackage'
writeNewReadme = require './lib/writeNewReadme'
GitCommands = require './lib/GitCommands'

module.exports = (args) ->
  options = new Options()

  Promise
  .try ->
    args.slice 2
  .then Minimist
  .then (args) ->
    options.parseArgs args

  .then ->
    unless options.release_type
      askReleaseType()
      .then (release_type) ->
        options.release_type = release_type
  .then ->
    unless options.current_version
      options.current_version = readVersionFromPackage options.package_file_location
    options.next_version = incrementVersion options.current_version, options.release_type
  .then ->
    options.no_confirm or (askConfirmUpdate options.current_version, options.next_version)
  .then (do_update) ->
    unless do_update
      throw new Error 'Update Canceled'
  .then ->
    if IS_DEBUG
      console.log "Would have written to #{options.next_version} to \n#{options.package_file_location}\n#{options.readme_file_location}"
      throw new Error 'But, your in debug mode so nothing actually happened'
  .then ->
    GitCommands.preCommands options.next_version
  .then ->
    writeNewReadme options.readme_file_location, options.current_version, options.next_version
  .then ->
    writeNewPackage options.package_file_location, options.current_version, options.next_version
  .then ->
    GitCommands.postCommands options.next_version
  .catch (err) ->
    console.log err.message
    process.exit 1