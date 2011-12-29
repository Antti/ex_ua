Description
===========

ex_ua library gives you some API to access http://ex.ua/

Install
=======

`gem install ex_ua`

Example usage
=============


    require 'ex_ua'
    client = ExUA::Client.new
    base_categories = client.base_categories('ru') # Gives you array of all base categories for a given language
    category = base_categories.first # Select first category (usually video)
    sub_categories = category.categories

