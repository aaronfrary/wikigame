module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)

  grunt.registerTask('default', ['app'])
  grunt.registerTask('app', ['coffeelint', 'clean', 'browserify'])
  grunt.registerTask('run', ['connect', 'app', 'watch'])

  grunt.initConfig {
    pkg: grunt.file.readJSON 'package.json'
    distdir: './public'

    browserify:
      app:
        src: ['./src/app.coffee']
        dest: '<%= distdir %>/<%= pkg.name %>.js'
        options:
          transform: ['coffeeify', 'browserify-shim']

    watch:
      options:
        cwd: './src'
        livereload: true
        nospawn: true
      app:
        files: ['*.coffee']
        tasks: ['coffeelint', 'browserify']

    clean:
      app: ['<%= distdir %>/*.js']

    coffeelint:
      app: ['./src/*.coffee']
      options:
        no_empty_functions: {level: 'warn'}
        no_stand_alone_at: {level: 'warn'}
        missing_fat_arrows: {level: 'warn'}

    connect:
      app:
        options:
          port: 8585
          hostname: '0.0.0.0'
          base: '<%= distdir %>'
          middleware: (connect, options) ->
            [require('connect-livereload')(), connect.static(options.base[0])]
  }

  # Only lint changed files
  grunt.event.on('watch', (action, filepath, target) ->
    grunt.config('coffeelint.' + target, filepath)
  )

