require 'rubygems'
require 'json'
require 'sinatra'
require 'awesome_print'
require './gathercontent-api-client'

enable :sessions
set :session_secret, 'super secret LOMG'


helpers do
	def custom_state_name(id)
		"not defined yet" # fetch from disk or API if it doesn't exist
	end
end

before do	
	if request.query_string == 'refresh'
		session[:refresh_from_api] = 'true'
		redirect to(request.path)
	end
end

after do
	if response.status != 302 # don't reset before the 302 has completed or we won't know to refetch the data!
		session[:refresh_from_api] = 'false'
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
	project_pagelist_filename = 'project-pagelist/'+params[:id]

	if session[:refresh_from_api] != 'true' && File.exists?(project_pagelist_filename)
		puts "Loading from file"
  		@pagelist = Marshal.load(File.read(project_pagelist_filename))
	else
		puts "Loading from API"
		api = GatherContentApi.new('uniofbath', ENV['GATHERCONTENT_API_KEY'], 'x')
		json_project_pagelist = api.get_pages_by_project(params[:id])
		@pagelist = Hashie::Mash.new(json_project_pagelist)

		# write it to disk
		serialised_pagelist = Marshal.dump(@pagelist) # keep this line separate in case of Marshal errors
		File.open(project_pagelist_filename, 'w') {|f| f.write(serialised_pagelist) }
	end

	@page_title = 'Pages in this project'
	erb :pagelist
end

get '/page/:id' do
	puts session[:refresh_from_api].inspect
	page_filename = 'pages/page-'+params[:id]

	if session[:refresh_from_api] != 'true' && File.exists?(page_filename)
		puts "Loading from file"
  		@page = Marshal.load(File.read(page_filename))
	else
		puts "Loading from API"
		api = GatherContentApi.new('uniofbath', ENV['GATHERCONTENT_API_KEY'], 'x')
		json_page = api.get_page(params[:id])
		@page = Hashie::Mash.new(json_page)

		# write it to disk
		serialised_page = Marshal.dump(@page) # keep this line separate in case of Marshal errors
		File.open(page_filename, 'w') {|f| f.write(serialised_page) }
	end

	@page_title = @page['page'][0]['name']


	erb :page
end

def get_custom_states
	puts "not yet implemented"
end

#def load_from_disk_or_fetch(filename, api_method)
#
#end