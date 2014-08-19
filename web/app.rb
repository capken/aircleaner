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

#get '/products' do
#  condition = {}
#  ['brand', 'model'].each do |attr|
#    condition[attr] = params[attr] if params[attr]
#  end
#
#  products = Product.where(condition)
#
#  json 'products' => products
#end

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

get '/products' do
  mode = params['mode']
  made_in = params['made_in']
  room_area = params['room_area'].to_i
  air_refresh_count = params['air_refresh_count'].to_i

  case mode
#  when /search/
#    brand = params['brand']
#    condition = "brand = '#{brand}'" unless brand =~ /所有品牌/
  when /suggest/
    min_cadr = room_area * 2.8 * air_refresh_count
    condition = "cadr_dust >= #{min_cadr}"
  end

  products = Product.where(condition.to_s).
    order('score desc').limit(20)

  json 'products' => products
end
