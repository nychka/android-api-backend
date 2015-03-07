class Admin::WelcomeController < ApplicationController
 def index
 		# TODO: cache
    changelog = File.open('CHANGELOG.md', 'r').read
    @content = markdown(changelog)
  end
end
