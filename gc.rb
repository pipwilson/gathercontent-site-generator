require 'rubygems'
require 'sinatra'
require 'awesome_print'
require './gathercontent-api-client'

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
	api = GatherContentApi.new('uniofbath', ENV['GATHERCONTENT_API_KEY'], 'x')
	#@page = Hashie::Mash.new(api.get_page(params[:id]))
	@page = api.get_page(params[:id])
	erb :page
end