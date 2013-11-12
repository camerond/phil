# Phil

__(Work in progress)__

Phil is a lightweight content generation module that wraps around [Ffaker](https://github.com/EmmanuelOga/ffaker/tree/master/lib/ffaker). Mostly syntactic sugar with some convenient extras.

A big theme of Phil is that any parameter that can accept a number also accepts a range. This allows for far more utility than vanilla Ffaker when it comes to testing different permutations of content.

## Iteration

Get a random integer from an array or range:

```ruby
Phil.pick 1..3
Phil.pick [1, 2, 3]
Phil.pick ["Foo", "Bar", "Baz"]
```

Loop a random number of times:

```ruby
Phil.loop 1..100 do |i|
  "This will be output between 1 and 100 times and is index #{i}"
end
```

Have a 1 in N chance of doing something (N defaults to 3):

```ruby
Phil.sometimes "foo"                    # 1 in 3
Phil.sometimes "foo", 100               # 1 in 100
Phil.sometimes do
  "foo"
Phil.sometimes 100 do
  "foo"
```

## Content Generation

### Body content

Generate a ton of body content with one method. This defaults to
`"h1 p p h2 p ol h2 p ul"`, but you can pass it a string of whatever tags you like,
including `blockquote`, other headings, and so on.

```ruby
Phil.body_content
Phil.body_content "h1 p h2 ul p blockquote h5 h6"
```

### Lorem methods (all take ranges or numbers)

```ruby
Phil.words 5
Phil.words 5..50

Phil.paragraphs 5                       # outputs HTML markup with <p> elements
Phil.paragraphs 5..50

Phil.blockquote                         # defaults to containing 1..3 <p> elements
Phil.blockquote 1..5                    # 1..5 <p> elements

Phil.ul                                 # defaults to 3..10 <li>s with 3..15 words
Phil.ul 1..5, 10                        # 1..5 items, 10 words apiece

Phil.ol
Phil.ol 1..5, 10

Phil.link_list                          # outputs a <ul> of <li>s with <a>s inside
Phil.link_list 1..5, 10
```

### Assorted convenience methods

```ruby
Phil.date                               # Random date between Dec 31 1969 and now
Phil.date 7                             # Random date in the last 7 days
Phil.currency 10..100                   # Price from $10.00 to $100.00
Phil.currency 10..100, "£"              # Price from £10.00 to £100.00
Phil.phone                              # Phone defaults to (###)-###-####
Phil.phone "###-#### x###"
Phil.number 5                           # Random 5-digit number
```

### Wrappers for Ffaker

```ruby
Phil.domain_name
Phil.email
Phil.name
Phil.first_name
Phil.last_name
Phil.state_abbr
```
