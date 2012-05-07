# ActiveRecordSchema

**ActiveRecordSchema** is an `ActiveRecord` extension that allows you to write database schema for a model within the model itself and to generate migrations directly from models.

Unlike other libraries (eg. mini_record) ActiveRecordSchema is not an alternative to Rails migrations, but rather a tool to simplify their use.

## Features

* Defining columns and indexes directly in model
* Generation of migration from the model taking into account the current state of the database
* Automatically add code to migrate associations:
   * Foreign key for `belongs_to`
   * Join table for `has_and_belongs_to_many`
  
* Automatic indexing of foreign keys for both `belongs_to` and `has_and_belongs_to_many` (configurable)

## Installation

Put this in your Gemfile

    gem 'active_record_schema'
    
and update your bundle
  
    bundle install
    
**NOTE:** ActiveRecordSchema depends on `rails ~> 3.0` and not only `ActiveRecord`

## Usage

Create a model and use the class method `#field` to define columns

``` rb    
class Post < ActiveRecord::Base
    field :title
    field :body, :as => :text
    belongs_to :author, :class_name => "User"
end
```

Now run `rails g migration` with `--from` option

    rails g migration init_posts_schema --from Post
  
and the following migration will be generated

``` rb    
class InitPostsSchema < ActiveRecord::Migration
  def change
    create_table :posts 
    add_column :posts, :title, :string
    add_column :posts, :body, :text

    add_column :author_id, :integer
    index :author_id
  end
end
```

**NOTE:** `create_table :posts` is added only if `posts` table does not exist yet

Generating a migration for new columns is the same, lets add a new field to `Post` (eg. `pubdate`):

``` rb    
class Post < ActiveRecord::Base
    field :title
    field :body, :as => :text
    belongs_to :author, :class_name => "User"
    
    field :pubdate, :as => :datetime
end
```

Now run

    rails g migration add_pubdate_to_posts --from Post

that will generate:

``` rb
class AddPubdateToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :pubdate, :datetime
  end
end
```

**NOTE:** No migration will be generated in case all changes are up-to-date 

## Has and Belongs To Many (HBTM) associations

Lets try to add a HBTM association to our `Post` model

_ex._

``` rb
# content.rb
class Post < ActiveRecord::Base
  field :title
  field :body, :as => :text
  belongs_to :author, :class_name => "User"
  field :pubdate, :as => :datetime

  has_and_belongs_to_many :voters, :class_name => "User"
end
```


Now running

    rails g migration add_voters_to_posts --from Post

will generate:

``` rb
    class AddVotersToPosts < ActiveRecord::Migration
      def change
        create_table :contents_users, :id => false do |t|
          t.integer  "content_id"
          t.integer  "user_id"
        end
        add_index :contents_users, "content_id"
        add_index :contents_users, "user_id"
      end
    end
```

## Single Table Inheritance (STI)

Call `#inheritable` inside the base class of your hierarchy to add the inheritance column required by Single Table Inheritance.

_ex._

``` rb
# content.rb
class Content < ActiveRecord::Base
  inheritable
  
  field :title
  
  has_and_belongs_to_many :voters, :class_name => "User"
  belongs_to              :author, :class_name => "User"
    
  timestamps
end
    
  
# article.rb
class Article < Content
  field :body, :as => :text
end
    
  
# video.rb
class Video < Content
  field :url
end
```

Running
    
    rails g migration init_contents --from Content

same as

    rails g migration init_contents --from Article
    
same as

    rails g migration init_contents --from Video
    
will generate the following migration 

``` rb
class InitContents < ActiveRecord::Migration
  def change
    add_column :contents, :type, :string
    add_column :contents, :title, :string
    add_column :contents, :author_id, :string
    add_column :contents, :body, :text
    add_column :contents, :url, :string

    add_index :contents, :author_id

    create_table :contents_users, :id => false do |t|
      t.integer  "content_id"
      t.integer  "user_id"
    end
    add_index :contents_users, "content_id"
    add_index :contents_users, "user_id"
  end  
end
```


## Mixins

Probably one of the most significant advantage given by ActiveRecordSchema is to allow the definition of fields in modules and reuse them through mixin

_ex._

``` rb
module Profile
  extend ActiveSupport::Concern
  included do
    field :name
    field :age, :as => :integer
      
  end
end
    
class User < ActiveRecord::Base
  include Profile
  
end
    
class Player < ActiveRecord::Base
  include Profile
      
end
```


## DSL (Domain Specific Language) reference

  * ### `field(name, *args)`

    Adds a new column with name `name` to the schema. The type of column can be passed either as second argument or as option, if not specified is intended to be `:string`

    #### options  

    * **:as _or_ :type** : Specify the type of the column. The value can be a `String`, a `Symbol` or a `Class`, default to `:string`
    * **:index** : Specify wether or not the field should be indexed, default to `false`

    #### examples

    ``` rb
    field :name

    field :name, :string
    field :name, "string"
    field :name, String

    field :name, :as => :string
    field :name, :as => "string"
    field :name, :as => String

    field :name, :type => :string
    field :name, :type => "string"
    field :name, :type => String

    field :age, :as => :integer, :index => true
    ```


  * ### `belongs_to(name, options = {})`

    Adds a new foreign key column for the association to the schema and then delegates to `ActiveRecord::Base.belongs_to`. If the association is polimorphic a column for foreign type is also generated.

    #### options  

    * **:index** : Specify wether or not the foreing key column should be indexed, default to `true`. If the association is polimorphic creates an index on both foreign key and foreing type


  * ### `has_and_belongs_to_many(name, options = {}, &extension)`

    Adds a new join table for the association to the schema and then delegates to `ActiveRecord::Base.has_and_belongs_to_many`

  * ### `index(column_name, options = {})`

    Adds a new index for `column_name` column to the schema
    
  * ### `add_index(column_name, options = {})`

    alias for `index`

  * ### `timestamps`

    Same as

    ``` rb
    field :created_at, :datetime
    field :updated_at, :datetime
    ```

  * ### `inheritable`
  
    Same as

    ``` rb
    field :"#{inheritance_column}"
    ```


## Why do not also generate irreversible changes (change/remove columns or indexes)?

ActiveRecordSchema does not take into account the removal of columns and indexes or changes in the types of columns. The reason for this is that these changes are not reversible, so it's a better idea to introduce them by hand rather than let them be generated automatically. Anyway the need to resort to harsh measures such as irreversible changes is limited to non-routine situations.


## Contributing to active_record_schema
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

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

