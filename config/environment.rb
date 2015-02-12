# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

class Logger
  def format_message(severity, datetime, progname, msg)
    "\n#{severity}::#{progname}::#{datetime}: \n#{'*'*80}\n#{msg}\n#{'*'*80}\n"
  end
end
