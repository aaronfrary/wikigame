module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)

  grunt.registerTask('default', ['concurrent:compile'])
  grunt.registerTask('run', ['concurrent:compile', 'concurrent:dev'])
  grunt.registerTask('client', ['coffeelint:client', 'clean:client', 'browserify:client'])
  grunt.registerTask('server', ['coffeelint:server', 'clean:server', 'coffee:server'])

  grunt.initConfig {
    pkg: grunt.file.readJSON 'package.json'
    servdir: './server'
    distdir: './server/public'

    concurrent:
      compile:
        tasks: ['client', 'server']
        options:
          logConcurrentOutput: true
      dev:
        tasks: ['nodemon', 'watch']
        options:
          logConcurrentOutput: true

    browserify:
      client:
        src: ['./src/client/app.coffee']
        dest: '<%= distdir %>/<%= pkg.name %>.js'
        options:
          transform: ['coffeeify', 'browserify-shim']

    coffee:
      server:
        expand: true
        flatten: true
        cwd: './src'
        src: ['*.coffee', './server/*.coffee']
        dest: '<%= servdir %>'
        ext: '.js'

    clean:
      client: ['<%= distdir %>/*.js']
      server: ['<%= servdir %>/*.js']

    nodemon:
      dev:
        script: 'server.js'
        options:
          cwd: '<%= servdir %>'
          ignore: './public'

    watch:
      options:
        cwd: './src'
        spawn: false
      client:
        files: ['*.coffee', './client/*.coffee']
        tasks: ['coffeelint:client', 'browserify:client']
      server:
        files: ['*.coffee', './server/*.coffee']
        tasks: ['coffeelint:server', 'coffee:server']

    coffeelint:
      client: ['./src/client/*.coffee']
      server: ['./src/server/*.coffee', './src/shared.coffee']
      options:
        no_empty_functions: {level: 'warn'}
        no_stand_alone_at: {level: 'warn'}
        missing_fat_arrows: {level: 'warn'}

  }

  # Only lint changed files
  grunt.event.on('watch', (action, filepath, target) ->
    grunt.config('coffeelint.' + target, filepath)
  )

