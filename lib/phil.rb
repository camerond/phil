module Phil

  class << self

    def pick(num)
      num.respond_to?(:to_a) ? num.to_a.sample : num
    end

    def loop(num)
      pick(num).times do |i|
        yield(i)
      end
    end

    def sometimes(num_or_content = 3, num = 3)
      if block_given?
        if num_or_content == pick(1..num_or_content)
          yield
        end
      else
        if num == pick(1..num)
          num_or_content
        end
      end
    end

    def words(num)
      Faker::Lorem.words(pick(num)).join(' ').html_safe
    end

    def paragraphs(num)
      content_method = -> { Faker::Lorem.paragraphs(1).join }
      build_tags "p", content_method, pick(num)
    end

    def ul(list_items = nil, item_length = nil)
      tag "ul", item_length, list_items
    end

    def ol(list_items = nil, item_length = nil)
      tag "ol", item_length, list_items
    end

    def blockquote(paragraphs = nil)
      tag "blockquote", paragraphs
    end

    def link_list(list_items = (3..10), item_length = (1..5))
      build_tag "ul", build_tags("li", -> { "<a href='#'>#{words(item_length)}</a>" }, list_items)
    end

    def markup(pattern="h1 p p h2 p ol h2 p ul")
      pattern.split(" ").map{ |t| tag(t) }.join.html_safe
    end

    def currency(num, symbol = "$")
      val = ((pick(num) * 100) / 100).round(2)
      sprintf("$%.2f", val)
    end

    def number(length)
      (1..length).map { rand(10) }.join
    end

    def phone(format = "(###) ###-####")
      format.gsub(/#/) { rand(9) + 1 }
    end

    def date(day_window = nil)
      t = Time.now.to_f
      Time.at(day_window ? t - rand * day_window * 86400 : t * rand)
    end

    def city
      Faker::Address.city
    end

    def domain_name
      Faker::Internet.domain_name
    end

    def email
      Faker::Internet.email
    end

    def first_name
      Faker::Name.first_name
    end

    def last_name
      Faker::Name.last_name
    end

    def name
      Faker::Name.name
    end

    def state
      Faker::AddressUS.state
    end

    def state_abbr
      Faker::AddressUS.state_abbr
    end

    def image(*arguments)
      opts = arguments.extract_options!
      opts = format_image_argument_output(opts.merge! parse_image_arguments(arguments))
      opts[:size] && "http://placehold.it/#{opts[:size]}#{opts[:color]}#{opts[:text]}"
    end

    alias_method :body_content, :markup

    private

    def tag(name, content = nil, children = nil)
      case name
        when "ul", "ol"
          content ||= (3..15)
          children ||= (3..10)
          build_tag name, build_tags("li", content, children)
        when "blockquote"
          content ||= (1..3)
          build_tag name, paragraphs(content)
        when "p"
          paragraphs(1)
        else
          content ||= (3..15)
          build_tags name, content
      end
    end

    def build_tags(name, content, elements = 1)
      content_method = if content.is_a? Proc then content else -> { words(content) } end
      pick(elements).times.map { build_tag(name, content_method.call) }.join.html_safe
    end

    def build_tag(name, content)
      "<#{name}>#{content}</#{name}>".html_safe
    end

    def convert_range(str)
      range_ends = str.split('..')
      str = range_ends[1] ? range_ends[0]..range_ends[1] : range_ends[0]
    end

    def parse_image_arguments(args)
      output = {}
      args.each do |arg|
        case arg.to_s
          when /^(#[a-f\d]{3,6}(\/(?=#))?){1,2}$/
            output[:color] = arg
          when /^([\d\.]*)x?([\d\.]*?)$/
            output[:size] = arg
          else
            output[:text] = arg
          end
        end
      output
    end

    def format_image_argument_output(args)

      if !args[:color]
        args[:color] = "#{args[:background]}#{args[:foreground]}"
      end

      if args[:width] && args[:height]
        args[:size] = "#{Phil.pick(args[:width])}x#{Phil.pick(args[:height])}"
      end

      args.each do |k, v|
        case k
        when /color/
          args[k] = v.gsub(/\/?#/, '/')
        when /text/
          args[:text] = "&text=#{v.gsub(/[^\d\w\!,\.;:-]+/, '+').gsub(/\+?$/, '')}"
        end
      end

    end

  end

end
