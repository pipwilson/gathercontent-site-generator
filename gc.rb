require 'rubygems'
require 'sinatra'
require './gathercontent-api-client'

get '/' do
  'Hello world!'
end

get '/hello/:name' do
  "Hi #{params[:name]}!"
end

get '/projects' do
	api = GatherContentApi.new('uniofbath', 'ENV['GATHERCONTENT-API-KEY']', 'x')
	response = Hashie::Mash.new(api.get_projects)
	puts response
	"done"
end

# Research is 11642
get '/project/:id' do
	api = GatherContentApi.new('uniofbath', 'ENV['GATHERCONTENT-API-KEY']', 'x')
	response = Hashie::Mash.new(api.get_pages_by_project('11642'))
	puts response
	#response.success.to_s + ', ' + response.error
	"done"
end

get '/page/:id' do
	api = GatherContentApi.new('uniofbath', 'ENV['GATHERCONTENT-API-KEY']', 'x')
	api.get_page(:id).success.to_s	
end