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
      Faker::Lorem.paragraphs(pick(num)).map{|text| "<p>#{text}</p>"}.join.html_safe
    end

    def currency(num, symbol = "$")
      "$#{(pick(num * 100) / 100).round(2)}"
    end

    def date(day_window = nil)
      t = Time.now.to_f
      Time.at(day_window ? t - rand * day_window * 86400 : t * rand)
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

    def phone(format = "(###) ###-####")
      format.gsub(/#/) { rand(9) + 1 }
    end

    def state
      Faker::AddressUS.state
    end

    def state_abbr
      Faker::AddressUS.state_abbr
    end

  end

end
