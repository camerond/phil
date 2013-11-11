# Phil
## (Work in progress)

Phil is a lightweight content generation module that wraps around [Ffaker](https://github.com/EmmanuelOga/ffaker/tree/master/lib/ffaker). Mostly syntactic sugar with some convenient extras.

## Usage

```ruby

# get a random integer from an array or range

Phil.pick 1..3
Phil.pick [1, 2, 3]
Phil.pick ["Foo", "Bar", "Baz"]

# loop a random number of times

Phil.loop 1..100 do |i|
  "This will be output between 1 and 100 times and is index #{i}"

# have a 1 in N chance of doing something (N defaults to 3)

Phil.sometimes "foo"                    # 1 in 3
Phil.sometimes "foo", 100               # 1 in 100
Phil.sometimes do
  "foo"
Phil.sometimes 100 do
  "foo"

# various lorem functions (all take ranges or numbers)

Phil.lorem 5
Phil.lorem 5..50
Phil.paragraphs 5                       # outputs HTML markup with <p> tags
Phil.paragraphs 5..50

# Assorted convenience methods

Phil.number 5                           # Random 5-digit number
Phil.currency 10..100                   # Price from $10.00 to $100.00
Phil.currency 10..100, "£"              # Price from £10.00 to £100.00
Phil.phone                              # Phone defaults to (###)-###-###
Phil.phone "###-#### x###"
Phil.date                               # Random date between Dec 31 1969 and now
Phil.date 7                             # Random date in the last 7 days

# assorted wrappers for Ffaker

Phil.domain_name
Phil.email
Phil.name
Phil.first_name
Phil.last_name
Phil.state_abbr

```