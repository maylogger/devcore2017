inquirer = require 'inquirer'
{exec}   = require 'child_process'

start = () ->
  exec 'git branch', (error, stdout) ->
    current_branch = /\*\s([\w\/]+)\n/.exec(stdout)[1]

    inquirer.prompt [
      name: 'env'
      message: 'Choose deploy environment.'
      type: 'list'
      choices: ['staging', 'static_sources']
      default: 'staging'
    ,
      name: 'message'
      message: 'You can deploy with customize commit message.'
      type: 'input'
      default: ''
    ]
    .then ({env, message}) ->
      console.log "Start deploy branch #{current_branch} to #{env} server."

      task = exec "TARGET=#{env} MESSAGE='#{message}' bundle exec middleman deploy"
      task.stdout.on 'data', (data) -> console.log data.toString()
      task.stderr.on 'data', (data) -> console.error data.toString()

start()
