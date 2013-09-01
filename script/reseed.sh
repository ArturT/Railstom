#!/bin/bash
bundle exec rake db:drop
bundle exec rake db:create
bundle exec rake db:schema:load
bundle exec rake db:test:load
bundle exec rake db:seed
