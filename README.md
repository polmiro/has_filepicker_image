# HasFilepickerImage

This gem is mainly an extension of [filepicker-rails](https://github.com/Filepicker/filepicker-rails). It integrates url methods into the models and the form builders.
This gem helps you get running with [filepicker.io](http://filepicker.io) in Rails with your ActiveRecord models.
It provides methods for your models to easily retrieve sizes and styles of your images.
It also adds form helpers to nicely display and reload your images in you forms

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'has_filepicker_image'
```

And then execute:


```
$ bundle
```

Or install it yourself as:

```
$ gem install has_filepicker_image
```


Add the filepicker.io async javascript library to your layout head or your javascript asset pipeline manifest:

```ruby
<%= filepicker_async_js_include_tag %>
```
or
```
//= require 'filepicker_async'
```



Set your API Key in config/application.rb:
```ruby
    config.has_filepicker_image.api_key = "Your filepicker.io API Key"
```

Set your custom default options for the image urls (you can override or add your own options, view pickAndStore options in filepicker documentation):
```ruby
    config.has_filepicker_image.defaults = {
        :delete_button_html => 'Remove',
        :pick_button_html   => 'Pick',
        :html_options => {
          :'data-location'      => 'S3',
          :'data-extensions'    => '.png,.jpg,.jpeg',
          :'data-services'      => 'COMPUTER',
          :'data-delete_button' => true,
          :'onchange'           => "HasFilepickerImage.previewPickedFile(event);"
        }
      }
```



## Usage
### Migration

Add a column to the model's table of type :string:

```ruby
class AddAvatarUrlToUser < ActiveRecord::Migration
    def up
        add_column :user, :avatar_url, :string
    end

    def down
        remove_column :user, :avatar_url
    end
end
```


### In your model

```ruby
class User < ActiveRecord::Base
  attr_accessible :avatar
  has_attached_file :avatar, styles: { medium: [300,300], thumb: [100,100] }
end
```

### In your views

Call filepicker_url on your model passing any of the styles you defined. You can any filepicker.io options [the filepicker.io documentation](https://developers.filepicker.io/docs/web/#fpurl-images).

```erb
<%= image_tag @user.filepicker_url(:thumb), options %> ---> 'http://filepicker.io/images?w=60&w=40' having defined styles: { thumb: [60,40]}
<%= image_tag @user.filepicker_url(:thumb, fit: 'crop'), options %> ---> 'http://filepicker.io/images?w=60&w=40&fit=crop'
<%= image_tag @user.filepicker_url(w: 10, h: 20), options %> ---> 'http://filepicker.io/images?w=10&h=20'
```
_Note: This method accepts a style plus optional paramters for the url or simply optional parameters for the url._

### In your forms

You can overwrite defaults when using the helpers.

With Rails form builders
```erb
<%= form_for @user do |f| %>
  <%= f.label :filepicker_url, "Upload Your Avatar:" %>
  <%= f.filepicker_image_field :filepicker_url, :delete_button_html => 'Esborrar' %>
  <%= f.submit %>
<% end %>
```

  <%= f.submit %>
<% end %>
```
