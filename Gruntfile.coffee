module.exports = (grunt) ->
    "use strict"

    grunt.initConfig
        clean: ["dist/"]

        requirejs:
            release:
                options:
                    # Include the main ration file.
                    mainConfigFile: "app/config.js"

                    # Setting the base url to the distribution directory allows the
                    # Uglify minification process to correctly map paths for Source
                    # Maps.
                    baseUrl: "dist/app"

                    # Include Almond to slim down the built filesize.
                    name: "almond"

                    # Set main.js as the main entry point.
                    include: ["main"]
                    insertRequire: ["main"]

                    # Since we bootstrap with nested `require` calls this option allows
                    # R.js to find them.
                    findNestedDependencies: true

                    # Wrap everything in an IIFE.
                    wrap: true

                    # Output file.
                    out: "dist/source.min.js"

                    # Enable Source Map generation.
                    generateSourceMaps: true

                    # Do not preserve any license comments when working with source maps.
                    # These options are incompatible.
                    preserveLicenseComments: false

                    # Minify using UglifyJS.
                    optimize: "uglify2"

        less:
            main:
                options:
                    paths: ["app/public/assets/less"]
                    cleancss: true
                files:
                    "dist/public/assets/css/app.css": "app/public/assets/less/app.less"
                    "dist/public/assets/css/chat.css": "app/public/assets/less/chat.less"

        coffee:
            main:
                expand: true
                cwd: "app/"
                src: ["**/*.coffee"]
                dest: "dist/"
                ext: ".js"

        processhtml:
            release:
                files:
                    "dist/index.html": ["index.html"]

        # Move vendor and app logic during a build.
        copy:
            release:
                files: [
                    {
                        src: ['views/**', 'routes/**', 'models/**', 'public/*', 'public/assets/img/**']
                        dest: 'dist'
                        cwd: 'app'
                        filter: 'isFile'
                        expand: true
                    }
                ]

        express:
            main:
                options:
                    port: 3700
                    script: 'dist/app.js'

        uglify:
            main:
                # options:
                #     beautify: true
                #     preserveComments: true
                #     mangle: false
                files:
                    'dist/public/assets/js/scripts.min.js': [
                        'app/public/assets/js/vendor/jquery.cookie.js'
                        'app/public/assets/js/vendor/jquery.xdomainajax.js'
                        'app/public/assets/js/vendor/screenful.min.js'
                        'dist/public/assets/js/app.js'
                    ]

        watch:
            express:
                files: ['app/**']
                tasks: ["less", "coffee", "copy", "express", "uglify", "watch"]
                options:
                    spawn: false
                    livereload: true

        karma:
            options:
                basePath: process.cwd()
                runnerPort: 9999
                port: 9876
                singleRun: true
                colors: true
                captureTimeout: 7000

                reporters: ["progress"]
                browsers: ["PhantomJS"]

                plugins: [
                    "karma-jasmine"
                    "karma-mocha"
                    "karma-qunit"
                    "karma-phantomjs-launcher"
                ]

                proxies:
                    "/base": "http:#localhost:<%=server.test.options.port%>"

            mocha:
                options:
                    frameworks: ["mocha"]

                    files: [
                        "vendor/bower/requirejs/require.js"
                        "test/mocha/test-runner.js"
                    ]

    # Grunt contribution tasks.
    grunt.loadNpmTasks "grunt-contrib-clean"
    grunt.loadNpmTasks "grunt-contrib-copy"
    grunt.loadNpmTasks "grunt-contrib-less"
    grunt.loadNpmTasks "grunt-contrib-coffee"
    grunt.loadNpmTasks "grunt-contrib-watch"
    grunt.loadNpmTasks "grunt-express-server"
    grunt.loadNpmTasks "grunt-contrib-uglify"

    # Third-party tasks.
    grunt.loadNpmTasks "grunt-karma"
    grunt.loadNpmTasks "grunt-processhtml"

    # Grunt BBB tasks.
    grunt.loadNpmTasks "grunt-bbb-requirejs"

    # When running the default Grunt command, just lint the code.
    grunt.registerTask "default", [
        "clean", "less", "coffee", "copy", "uglify"
    ]

    # The test task take care of starting test server and running tests.
    grunt.registerTask "test", [
        "server:test", "karma"
    ]
