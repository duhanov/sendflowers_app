require 'rubygems'
require 'mechanize'
require "russian"

class Wget
  def initialize
    @agent = WWW::Mechanize.new{ |agent| 
      agent.history.max_size = 10 
      agent.user_agent_alias = 'Mac Safari'
    } 
    
  end  
  
  def self.download(url, to_path = RAILS_ROOT)
    @agent = WWW::Mechanize.new{ |agent| 
      agent.history.max_size = 10 
      agent.user_agent_alias = 'Mac Safari'
    } 
    file_name = url.match(/\/([^\/]+)$/).to_a[1]    
    puts "get #{url} to #{file_name}"
    @agent.get(url).save_as(to_path.gsub(":file_name", file_name))
    file_name
  end
end