require 'rubygems'
require 'json'
require 'sinatra'
require 'awesome_print'
require './gathercontent-api-client'

helpers do
	def custom_state_name(id)
		"not defined yet" # fetch from disk or API if it doesn't exist
	end
end

get '/' do
    'Hello world!'
end

get '/hello/:name' do
    "Hi #{params[:name]}!"
end

get '/projects' do
	api = GatherContentApi.new('uniofbath', ENV['GATHERCONTENT_API_KEY'], 'x')
	response = Hashie::Mash.new(api.get_projects)
	puts response
	"done"
end

# Research is 11642
get '/project/:id' do
	api = GatherContentApi.new('uniofbath', ENV['GATHERCONTENT_API_KEY'], 'x')
	response = Hashie::Mash.new(api.get_pages_by_project(params[:id]))
	# puts response
	#response.success.to_s + ', ' + response.error
	ap(response, :html => true) # need to do this in an actual render!
end

get '/page/:id' do
	page_filename = 'pages/page-'+params[:id]
	if File.exists?(page_filename)
		puts "Loading from file"
  		@page = Marshal.load(File.read(page_filename))
	else
		puts "Loading from API"
		api = GatherContentApi.new('uniofbath', ENV['GATHERCONTENT_API_KEY'], 'x')
		@page = JSON.pretty_generate(api.get_page(params[:id]))
		serialised_page = Marshal.dump(@page) # keep this line separate in case of Marshal errors
		File.open(page_filename, 'w') {|f| f.write(serialised_page) }
	end
	erb :page
end

def get_custom_states do

end
