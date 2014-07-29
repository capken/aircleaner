require 'sinatra'
require "sinatra/activerecord"
require 'sinatra/base'
require 'sinatra/json'
require 'digest/sha1' 

set :database, {adapter: "sqlite3", database: "sample.sqlite3"}

class Product < ActiveRecord::Base
end

get '/' do
  redirect '/index.html' 
end

get '/products/:id' do
  product = Product.find(params[:id]) || {}
  json product
end
