# @author Andrii Dmytrenko
require "ex_ua/version"
require 'ex_ua/client'
require "ex_ua/item"
require "ex_ua/category"
require 'mechanize'

module ExUA
  BASE_URL='http://ex.ua'
  KNOWN_BASE_CATEGORIES = %w[video audio images texts games software]
end
