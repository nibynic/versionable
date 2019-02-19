# Versionable
Simple versioning for Rails Active Record with relationship support.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'versionable'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install versionable
```

## Usage

### Setup
Versionable needs `versions` table, which can be generated using these commands:

```ruby
rails g versionable:install
rails db:migrate
```

### Model configuration
To enable change tracking in your model, just call `acts_as_versionable`. It accepts
same options as [`as_json` method](https://api.rubyonrails.org/classes/ActiveModel/Serializers/JSON.html#method-i-as_json).
These options will be used to produce JSON snapshot of your data and compare it
with previous versions to detect changes.

```ruby
class BlogPost < ApplicationRecord
  acts_as_versionable only: [:title, :contents]
end
```

Please be aware that Versionable applies some changes on your configuration:

- `:root` will be always set to `false`,
- `:created_at` and `:updated_at` will be always excluded (that applies to included
  relationships as well),
- Foreign keys of relationships that are listed in `include` option will be excluded.

### Including relationships
Versionable allows you to include related records in version snapshot. Just add
your relationships to `include` option:

```ruby
class BlogPost < ApplicationRecord
  acts_as_versionable include: :comments
  has_many :comments
end
```

And then define `parent` option on the other side of the relationship:

```ruby
class Comment < ApplicationRecord
  acts_as_versionable parent: :blog_post
  belongs_to :blog_post
end
```

Now even if you call `store_versions` on a comment, it will create version for
its blog post.

### Storying versions
Now each time you'd like to store a version, all you have to do is to call
`store_versions` on your model. It takes only one optional argument wich is
version author.

```ruby
class BlogPostsController < ApplicationController

  def update
    @blog_post = BlogPost.find(params[:id])
    if @blog_post.update_attributes(blog_post_params)
      @blog_post.store_versions(current_user)
      # render success
    else
      # render failure
    end
  end

end
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
