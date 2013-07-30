Simple chat application using Rails 4 - ActionController::Live
==============================================================

Application components:
=======================
1 . Chat Application using Rails 4 ActionController::Live

2 . Basic LDAP authentication

3 . Redis Server integration

4 . Puma Server

1 . Rails 4 ActionController::Live
==================================
To enable live streaming in a controller, do the following,

1 . Must mixin the module ActionController::Live.

2 . Add the following line to enable the concurrency in config/environments.development.rb
    config.allow_concurrency = true

3 . This provides an I/O like interface to the response, allowing you to continuously write to the client until the stream is explicitly closed.

4 . Here is an example of a live streaming controller from the Rails docs:


  class LiveStreamController < ApplicationController

    include ActionController::Live

    def stream
      response.headers["Content-Type"] = "text/event-stream"

      100.times do |count|
        response.stream.write("Hello World : #{count}")
        sleep 1
      end
      response.stream.close
    end
  end

2 . LDAP Integration:
=====================
LDAP authentication is implemented by use of the gem 'net-ldap'. It provides the following features,

1 . Authenticate(Bind) an entity.

2 . Add, Remove, Modify and Search the entities.

3 . Redis Server Integration:
=============================
Redis server is integrated using gem "redis". Redis provides the queue based storage with key/value pair.

1 . To start redis server use the command "redis-server"

2 . To stop redis server use command "redis-cli shutdown"

3 . for more details refer the link http://redis.io/topics/quickstart

4 . Puma Server:
================
We need to use the some different server, which is allowing streaming, here i used puma. Steps to start app with puma server

1 . Add puma gem in Gemfile and bundle it.

2 . Then the app will start by default puma or you can manually start by using the command "puma" in app home directory.

How To Setup:
=============
1 . Install RUBY 2.0 & RAILS 4(using RVM or SYSTEM RUBY)

2 . Clone the app from git repo git@github.com:Imaginea/simple_chat_ldap.git

3 . Run bundler to install required gems

4 . Alter database configurations and Run db based rake tasks(rake db:create, rake db:migrate, rake db:seed)

5 . Start redis server using command redis-server(refer http://redis.io/topics/quickstart)

6 . Run the rails puma server then visit the page.

