require 'httparty'
require 'hashie/mash'

class GatherContentApi
  include HTTParty
  format :json
  # debug_output $stdout

  def initialize(subdomain, u, p)
    self.class.base_uri('https://' + subdomain + '.gathercontent.com/api/0.2.1')
    @auth = {:username => u, :password => p}
  end

  def method_missing(method, *args, &block)
    options = {:body => {'id' => args[0]}, :digest_auth => @auth}
    self.class.post('/' + method.to_s, options)    
  end

end

#api = GatherContentApi.new('uniofbath', ENV['GATHERCONTENT-API-KEY'], 'x') # replace 'philwilson' with your subdomain
#mash = Hashie::Mash.new(api.get_projects) # replace with whatever API call you want to make
#puts mash # browse the response as an object