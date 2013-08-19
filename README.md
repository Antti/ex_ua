[![Build Status](https://travis-ci.org/Antti/ex_ua.png?branch=master)](https://travis-ci.org/Antti/ex_ua)

Description
===========

ex_ua library gives you some API to access http://ex.ua/

Docs: http://rubydoc.info/github/Antti/ex_ua/master/frames

Install
=======

`gem install ex_ua`

Example usage
=============

    require 'ex_ua'
    base_categories = ExUA::Client.base_categories('ru') # Gives you array of all base categories for a given language
    category = base_categories.first # Select first category (usually video)
    sub_categories = category.categories # Select sub-categories of a category
    example_video_category = sub_categories.first.categories.first
    download_items = example_video_category.items # Here you'll have an array of download items in a given category with #load_uri


Search
==============

    require 'ex_ua'
    page = 0
    per_page = 20
    categories = ExUA::Client.search('futurama', page, per_page)
