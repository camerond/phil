require 'spec_helper'

describe Phil do

  def count_words(content)
    if content.is_a? String
      content.split(' ').length
    else
      content.nodes[0].split(' ').length
    end
  end

  def find_children(content, tag = nil)
    Ox.parse(content).nodes.find_all{ |n| tag ? tag == n.value : true }
  end

  def find_elements(content, tag = nil)
    find_children("<div>#{content}</div>", tag)
  end

  def expect_element(content, tag)
    expect(content).to start_with "<#{tag}>"
    expect(content).to end_with "</#{tag}>"
  end

  def expect_elements(content, tags)
    t = tags.split(' ')
    find_elements(content).each_with_index do |n, i|
      expect(n.value).to eq(t[i])
    end
  end

  describe '#pick' do

    subject { Phil.pick(argument) }

    context 'with a single number' do
      let(:argument) { 5 }
      it { should == 5 }
    end

    context 'with a range' do
      let(:argument) { (3..5) }
      it 'gives one of the arguments back' do
        expect(argument).to cover(subject)
      end
    end

    context 'with an array' do
      let(:argument) { [2, 5, 7] }
      it 'gives one of the arguments back' do
        expect(argument).to include(subject)
      end
    end

  end

  describe '#loop' do

    subject {
      idx = 0
      Phil.loop(argument) {|i| idx = i + 1 }
      idx
    }

    context 'with a single number' do
      let(:argument) { 5 }
      it 'loops 5 times' do
        expect(subject).to eq(argument)
      end
    end

    context 'with a range' do
      let(:argument) { (10..20) }
      it 'gives one of the arguments back' do
        expect(argument).to cover(subject)
      end
    end

  end

  describe '#sometimes' do

    let(:values) { [] }

    it 'does something approx. 1/3 of the time by default' do
      1000.times do
        Phil.sometimes {|i| values.push(i) }
      end
      expect(150..450).to cover(values.length)
    end

    it 'does something approx. 1/10 of the time' do
      1000.times do
        Phil.sometimes(10) {|i| values.push(i) }
      end
      expect(0..150).to cover(values.length)
    end

  end

  describe '#image' do

    subject { Phil.image(*arguments) }

    context 'only one dimension specified' do
      let(:arguments) { 200 }
      it 'outputs a valid placeholder url' do
        expect(subject).to eq('http://placehold.it/200')
      end
    end

    context 'only w&h specified' do
      let(:arguments) { '200x100' }
      it 'outputs a valid placeholder url' do
        expect(subject).to eq('http://placehold.it/200x100')
      end
    end

    context 'dims & color specified' do
      let(:arguments) { ['200x100', '#ff0000'] }
      it 'outputs a valid placeholder url' do
        expect(subject).to eq('http://placehold.it/200x100/ff0000')
      end
    end

    context 'dims, color, and text specified' do
      let(:arguments) { ['200x100', '#ff0000/#00ff00', 'pants'] }
      it 'outputs a valid placeholder url' do
        expect(subject).to eq('http://placehold.it/200x100/ff0000/00ff00&text=pants')
      end
    end

    context 'parameters specified in any order' do
      let(:arguments) { ['pants', '#ff0000/#00ff00', '200x100'] }
      it 'outputs a valid placeholder url' do
        expect(subject).to eq('http://placehold.it/200x100/ff0000/00ff00&text=pants')
      end
    end

    context 'strips illegal characters' do
      let(:arguments) { [200, 'parachute&pants:% are they; the best?'] }
      it 'outputs a valid placeholder url' do
        expect(subject).to eq('http://placehold.it/200&text=parachute+pants:+are+they;+the+best')
      end
    end

    context 'bails if size not specified' do
      let(:arguments) { ['#fff', 'parachute&pants:% are they; the best?'] }
      it 'doesn\'t try and output a url' do
        expect(subject).to eq(nil)
      end
    end

    context 'parameters can be passed by name' do
      let(:subject) do
        args = {
          width: 200,
          height: 100,
          background: '#000',
          foreground: '#fff',
          text: 'pants'
        }
        Phil.image(args)
      end
      it 'accepts all named parameters' do
        expect(subject).to eq('http://placehold.it/200x100/000/fff&text=pants')
      end
    end

    context 'dims specified in range' do
      let(:subject) { Phil.image(width: (100..200), height: (300..400)) }
      it 'outputs a valid placeholder url' do
        range_matches = subject.match(/http:\/\/placehold\.it\/(\d+)x(\d+)/)
        expect(100..200).to cover(range_matches[1].to_i)
        expect(300..400).to cover(range_matches[2].to_i)
      end
    end

  end

  describe '#words' do

    context 'with no argument' do

      subject { Phil.words }

      let(:default) { (5..20) }

      it 'outputs 5..20 words' do
        expect(default).to cover(subject.split(' ').length)
      end
    end


    context 'with a single number' do

      subject { Phil.words(argument) }

      let(:argument) { 5 }

      it 'outputs 5 words' do
        expect(subject.split(' ').length).to eq(argument)
      end
    end

    context 'with a range' do

      subject { Phil.words(argument) }

      let(:argument) { (10..20) }

      it 'outputs 10..20 words' do
        expect(argument).to cover(subject.split(' ').length)
      end
    end

  end

  describe '#paragraphs' do

    context 'with no argument' do

      subject { Phil.paragraphs }

      let(:default) { (1..3) }

      it 'outputs 1..3 paragraphs' do
        expect(default).to cover(find_elements(subject, 'p').size)
      end
    end


    context 'with a single number' do

      subject { Phil.paragraphs(argument) }

      let(:argument) { 5 }

      it 'outputs 5 paragraphs' do
        expect(find_elements(subject, 'p').size).to eq(argument)
      end
    end

    context 'with a range' do

      subject { Phil.paragraphs(argument) }

      let(:argument) { (10..20) }

      it 'outputs 10..20 paragraphs' do
        expect(argument).to cover(find_elements(subject, 'p').size)
      end
    end

  end

  describe '#blockquote' do

    context 'default value' do

      let(:bq) { Phil.blockquote }

      it 'outputs a blockquote' do
        expect_element(bq, 'blockquote')
      end
      it 'contains 1..3 paragraphs' do
        expect(1..3).to cover(find_children(bq, 'p').size)
      end
    end

    context 'custom value' do

      let(:bq) { Phil.blockquote(5..10) }

      it 'contains 5..10 paragraphs' do
        expect(5..10).to cover(find_children(bq, 'p').size)
      end
    end

  end

  describe '#ul' do

    context 'default value' do

      let(:ul) { Phil.ul }

      it 'outputs a ul' do
        expect_element(ul, 'ul')
      end
      it 'contains 3..10 list items' do
        expect(3..10).to cover(find_children(ul, 'li').size)
      end
      it 'each containing 3..15 words' do
        find_children(ul, 'li').each do |li|
          expect(3..15).to cover(count_words(li))
        end
      end

    end

    context 'custom values' do

      let(:li_count) { 15..20 }
      let(:word_count) { 20..22 }
      let(:ul) { Phil.ul li_count, word_count }

      it "contains 15..20 list items" do
        expect(li_count).to cover(find_children(ul, 'li').size)
      end
      it "each containing 20..22 words" do
        find_children(ul, 'li').each do |li|
          expect(word_count).to cover(count_words(li))
        end
      end

    end

  end

  describe '#ol' do

    context 'default value' do

      let(:ol) { Phil.ol }

      it 'outputs a ol' do
        expect_element(ol, 'ol')
      end
      it 'contains 3..10 list items' do
        expect(3..10).to cover(find_children(ol, 'li').size)
      end
      it 'each containing 3..15 words' do
        find_children(ol, 'li').each do |li|
          expect(3..15).to cover(count_words(li))
        end
      end

    end

    context 'custom values' do

      let(:li_count) { 15..20 }
      let(:word_count) { 20..22 }
      let(:ol) { Phil.ol li_count, word_count }

      it "contains 15..20 list items" do
        expect(li_count).to cover(find_children(ol, 'li').size)
      end
      it "each containing 20..22 words" do
        find_children(ol, 'li').each do |li|
          expect(word_count).to cover(count_words(li))
        end
      end

    end

  end

  describe '#link_list' do

    context 'default value' do

      let(:ll) { Phil.link_list }

      it 'outputs a ul' do
        expect_element(ll, 'ul')
      end
      it 'contains 3..10 list items' do
        expect(3..10).to cover(find_children(ll, 'li').size)
      end
      it 'each containing a link with 1..5 words' do
        find_children(ll, 'li').each do |li|
          li.nodes.each do |a|
            expect(1..5).to cover(count_words(a))
          end
        end
      end

    end

    context 'custom values' do

      let(:li_count) { 15..20 }
      let(:word_count) { 20..22 }
      let(:ll) { Phil.link_list li_count, word_count }

      it "contains 15..20 list items" do
        expect(li_count).to cover(find_children(ll, 'li').size)
      end
      it "each containing a link with 20..22 words" do
        find_children(ll, 'li').each do |li|
          li.nodes.each do |a|
            expect(word_count).to cover(count_words(a))
          end
        end
      end

    end

  end


  describe '#markup' do

    context 'default value' do

      let(:m) { Phil.markup }

      it 'outputs h1 p p h2 p ol h2 p ul' do
        expect_elements(m, 'h1 p p h2 p ol h2 p ul')
      end

    end

    context 'custom values' do

      let(:custom_values)  { 'blockquote p span b ol' }
      let(:m) { Phil.markup(custom_values) }

      it 'outputs `blockquote p span b ol`' do
        expect_elements(m, custom_values)
      end
    end

  end


  describe '#date' do

    context 'random date' do

      let(:now) { Time.now }
      let(:d) { Phil.date }

      it 'returns a date' do
        expect(d).to be_a(Time)
      end

      it 'returns a date between 1969 and now' do
        expect(0..now.to_f).to cover(d.to_f)
      end
    end

    context 'custom date window' do

      let(:month_ago) { Time.now - 86400 * 30 }
      let(:d) { Phil.date 30 }

      it 'returns a date in the last 30 days' do
        expect(month_ago.to_f..Time.now.to_f).to cover(d.to_f)
      end
    end

    context 'custom date window range' do

      let(:two_months_ago) { Time.now - 86400 * 60 - 1 }
      let(:month_ago) { Time.now - 86400 * 30 + 1 }
      let(:d) { Phil.date 30..60 }

      it 'returns a date in the last 30-60 days' do
        expect(two_months_ago.to_f..month_ago.to_f).to cover(d.to_f)
      end
    end

  end

  describe '#currency' do

    context 'default currency' do

      let(:amount) { 10..100.99 }
      let(:c) { Phil.currency amount }

      it 'returns a string with a dollar value' do
        expect(c).to start_with('$')
      end

      it "returns a dollar value within 10..100.99" do
        expect(amount).to cover(c.gsub('$', '').to_f)
      end

      it "formats the currency to two decimal places" do
        expect(c).to match(/\$\d{2,3}\.\d{2}/)
      end
    end

  end

  describe '#phone' do

    context 'default phone format' do

      let(:p) { Phil.phone }

      it "returns a phone number formatted as (###) ###-####" do
        expect(p).to match(/\(\d{3}\) \d{3}-\d{4}/)
      end
    end

    context 'custom phone format' do

      let(:format) { '(0##) ########' }
      let(:p) { Phil.phone(format) }

      it "returns a phone number formatted as `(0##) ########`" do
        expect(p).to match(/\(0\d{2}\) \d{8}/)
      end

    end
  end

  describe '#number' do

    subject { Phil.number argument }

    context '3 digit number' do
      let(:argument) { 3 }
      it 'returns a 3 digit number' do
        expect(subject.to_s).to match(/^\d{3}$/)
      end
    end

    context '3-6 digit number' do
      let(:argument) { 3..6 }
      it 'returns a 3 to 6 digit number' do
        expect(subject).to match(/^\d{3,6}$/)
      end
    end
  end

end
