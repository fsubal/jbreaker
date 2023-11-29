# Jbreaker

Write jbuilder and JSON Schema in the same one file.

## Usage

Given the following jbuilder,

```ruby
json.id @item.id
json.description @item.description ? simple_format(@item.description) : nil

json.shop do
  json.partial! 'shops/shop', locals: { shop: shop }
end
```

You can migrate it like following.

```ruby
def render(shop:)
  json.id @item.id
  json.description @item.description ? simple_format(@item.description) : nil

  json.shop do
    json.partial! 'shops/shop', locals: { shop: shop }
  end
end
```

And you can have the corresponding JSON Schema in the same file.

```ruby
def render(shop:)
  json.id @item.id
  json.description @item.description ? simple_format(@item.description) : nil

  json.shop do
    json.partial! 'shops/shop', locals: { shop: shop }
  end
end

def self.schema
  t.object({
    id: t.number,
    description: t.string(nullable: true),
    shop: t.ref('shops/shop'),
  })
end
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem "jbreaker"
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install jbreaker
```

## Contributing

Contribution directions go here.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
