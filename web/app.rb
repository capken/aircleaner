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

#get '/brands' do
#  brands = Product.select(:brand).distinct
#  json 'brands' => brands.map(&:brand)
#end
#
#get '/models' do
#  models = Product.select(:model).
#    where(brand: params['brand']).distinct
#  json 'brand' => params['brand'],
#    'models' => models.map(&:model)
#end
#
#get '/all_brands_models' do
#  results = {}
#  Product.select(:brand, :model).each do |p|
#    models = results[p.brand] || []
#    models << p.model
#    results[p.brand] = models
#  end
#  json 'results' => results
#end

get '/suggest' do
  brand = params['brand']
  room_size = params['room_size'].to_f

  min_cadr = room_size * 2.8 * 5

  condition = "cadr_dust >= #{min_cadr}"
  condition += " and brand = '#{brand}'" unless brand.empty?

  products = Product.where(condition).
    order('cadr_dust').limit(10)

  json 'products' => products
end
