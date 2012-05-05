# ActiveRecordSchema

*ActiveRecordSchema* is an ActiveRecord extension that allows you to write the database schema for a model within the model itself and to generate migrations directly from models.

Unlike other libraries (eg. mini_record) ActiveRecordSchema is not an alternative to Rails migrations, but rather a tool to simplify their use enhancing their positive sides and contrasting their defects.

Install

    gem 'active_record_schema', :git => "git@github.com:mcasimir/active_record_schema.git"
    
Update your bundle
  
    bundle install

## Usage

Create a model
    
    class Post < ActiveRecord::Base
      schema do

        field :title
        field :body, :as => :text
        belongs_to :author, :class_name => "User"

      end
    end

Run a migration generator each time you want to commit changes to database

    rails g migration init_posts_schema --from Post
  
Will generate the following migration

    class InitPostsSchema < ActiveRecord::Migration
      def change
        add_column :posts, :title, :string
        add_column :posts, :body, :text

        add_column :author_id, :integer
        index :author_id
      end
    end


## Single Table Inheritance (STI)

_ex._

    # content.rb
    class Content < ActiveRecord::Base
      schema(:inheritable => true) do
        field :title
    
        timestamps!
      end
    end
  
    # article.rb
    class Article < Content
      schema do
        field :body, :as => :text
      end
    end
  
    # video.rb
    class Video < Content
      schema do
        field :url
      end
    end
  

## Contributing to active_record_schema
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Coming Soon

* Automatically generate migrations for Join tables for HBTM

---

Copyright (c) 2012 mcasimir

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

