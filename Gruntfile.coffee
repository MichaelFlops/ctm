module.exports = (grunt) ->
  # Load grunt tasks automatically
  require('load-grunt-tasks') grunt

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    # Empty folders to start fresh
    clean:
      all:
        files: [
          dot: true
          src: ['build', 'dist']]

    # Compiles CoffeeScript to JavaScript
    coffee:
      options:
        sourceMap: true
      app:
        files: [{
          expand: true
          cwd: 'src'
          src: '**/*.coffee'
          dest: 'build'
          ext: '.js'
        }]
      test:
        files: [
          expand: true
          cwd: 'test'
          src: '**/*.coffee'
          dest: 'build/test'
          ext: '.js']

    # Watches files for changes in interactive mode
    watch:
      options:
        livereload: true
      gruntfile:
        files: ['Gruntfile.js']
        tasks: ['mochaTest:all','coffeelint:gruntfile']
      coffee:
        files: ['index.html', 'src/**/*.coffee']
        tasks: ['coffee:app','coffeelint:src','mocha:all']
      coffeeTest:
        files: ['test/**/*.coffee']
        tasks: ['coffee:test','coffeelint:test','mocha:all']

    mocha:
      all:
        src: ['test.html']
        options:
          run: true

    connect:
      server:
        options:
          livereload: true
          port: 9009
          open: true
          hostname: '*'
          keepalive: true

    coffeelint:
      options:
        no_trailing_whitespace: level: 'error'
        arrow_spacing: level: 'error'
        cyclomatic_complexity: level: 'warn'
        empty_constructor_needs_parens: level: 'error'
        line_endings: level: 'error'
        no_empty_functions: level: 'error'
        no_empty_param_list: level: 'error'
        no_interpolation_in_single_quotes: level: 'error'
        no_stand_alone_at: level: 'error'
        no_unnecessary_double_quotes: level: 'warn'
        no_unnecessary_fat_arrows: level: 'error'
        space_operators: level: 'error'
      gruntfile:
        files:
          src: ['Gruntfile.coffee']
      src:
        files:
          src: ['src/*.coffee']
      test:
        files:
          src: ['test/*.coffee']

    useminPrepare:
      html: 'index.html'
      options:
        dest: 'dist'

    copy:
      html:
        files:
          [{src: 'index.html', dest: 'dist/'}]

    usemin:
      html: 'dist/index.html'

    concurrent:
      options:
        logConcurrentOutput: true
        limit: 5
      serve:
        tasks: ['connect:server', 'watch']

  # Run the tests
  grunt.registerTask 'test', (target) ->
    grunt.task.run [
      'coffee'
      'coffeelint:src'
      'coffeelint:test'
      'mocha']

  # Run the server and watch for file changes
  grunt.registerTask 'serve', (target) ->
    if target == 'test'
      grunt.task.run ['test', 'watch']
    else
      grunt.task.run ['coffee', 'concurrent:serve']

  # Prepares application for production
  grunt.registerTask 'build', [
    'clean'
    'coffee']

  grunt.registerTask 'deploy', [
    'coffee'
    'useminPrepare'
    'concat:generated'
    'cssmin:generated'
    'uglify:generated'
    'copy:html'
    'usemin']

  # Default task
  grunt.registerTask 'default', ['build', 'test']
