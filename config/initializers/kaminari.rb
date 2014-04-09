# Workaround for will_paginate and ActiveAdmin
Kaminari.configure { |config| config.page_method_name = :per_page_kaminari }
