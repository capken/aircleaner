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

get '/products' do
  condition = {}
  ['brand', 'model'].each do |attr|
    condition[attr] = params[attr] if params[attr]
  end

  products = Product.where(condition)

  json 'products' => products
end

get '/suggest' do

  room_size = params['room_size'].to_f
  min_cadr = room_size * 2.8 * 5

  condition = "cadr_dust >= #{min_cadr}"
  products = Product.where(condition).
    order('cadr_dust').limit(10)

  json 'products' => products
end
