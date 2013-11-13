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

  describe '#words' do

    subject { Phil.words(argument) }

    context 'with a single number' do
      let(:argument) { 5 }
      it 'outputs 5 words' do
        expect(subject.split(' ').length).to eq(argument)
      end
    end

    context 'with a range' do
      let(:argument) { (10..20) }
      it 'outputs 10..20 words' do
        expect(argument).to cover(subject.split(' ').length)
      end
    end

  end

  describe '#paragraphs' do

    subject { Phil.paragraphs(argument) }

    context 'with a single number' do
      let(:argument) { 5 }
      it 'outputs 5 paragraphs' do
        expect(find_elements(subject, 'p').size).to eq(argument)
      end
    end

    context 'with a range' do
      let(:argument) { (10..20) }
      it 'outputs 10..20 paragraphs' do
        expect(argument).to cover(find_elements(subject, 'p').size)
      end
    end

  end

  describe '#blockquote' do
  
    context 'default value' do
      bq = Phil.blockquote
      it 'outputs a blockquote' do
        expect_element(bq, 'blockquote')
      end
      it 'contains 1..3 paragraphs' do
        expect(1..3).to cover(find_children(bq, 'p').size)
      end
    end
  
    context 'custom value' do
      bq = Phil.blockquote(5..10)
      it 'contains 5..10 paragraphs' do
        expect(5..10).to cover(find_children(bq, 'p').size)
      end
    end
  
  end
  
  describe '#ul' do
  
    context 'default value' do
  
      ul = Phil.ul
  
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
  
      li_count = (15..20)
      word_count = (20..22)
      ul = Phil.ul li_count, word_count
  
      it "contains #{li_count} list items" do
        expect(li_count).to cover(find_children(ul, 'li').size)
      end
      it "each containing #{word_count} words" do
        find_children(ul, 'li').each do |li|
          expect(word_count).to cover(count_words(li))
        end
      end
  
    end
  
  end
  
  describe '#ol' do
  
    context 'default value' do
  
      ol = Phil.ol
  
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
  
      li_count = (15..20)
      word_count = (20..22)
      ol = Phil.ol li_count, word_count
  
      it "contains #{li_count} list items" do
        expect(li_count).to cover(find_children(ol, 'li').size)
      end
      it "each containing #{word_count} words" do
        find_children(ol, 'li').each do |li|
          expect(word_count).to cover(count_words(li))
        end
      end
  
    end

  end

  describe '#link_list' do

    context 'default value' do

      ll = Phil.link_list

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

      li_count = (15..20)
      word_count = (20..22)
      ll = Phil.link_list li_count, word_count

      it "contains #{li_count} list items" do
        expect(li_count).to cover(find_children(ll, 'li').size)
      end
      it "each containing a link with #{word_count} words" do
        find_children(ll, 'li').each do |li|
          li.nodes.each do |a|
            expect(word_count).to cover(count_words(a))
          end
        end
      end

    end

  end


  describe '#body_content' do

    context 'default value' do

      bc = Phil.body_content

      it 'outputs h1 p p h2 p ol h2 p ul' do
        expect_elements(bc, 'h1 p p h2 p ol h2 p ul')
      end

    end

    context 'custom values' do

      custom_values = 'blockquote p span b ol'
      bc = Phil.body_content(custom_values)

      it "outputs #{custom_values}" do
        expect_elements(bc, custom_values)
      end
    end

  end


  describe '#date' do

    context 'random date' do
      now = Time.now
      d = Phil.date

      it 'returns a date' do
        expect(d).to be_a(Time)
      end

      it 'returns a date between 1969 and now' do
        expect(0..now.to_f).to cover(d.to_f)
      end
    end

    context 'custom date window' do

      month_ago = Time.now - 86400 * 30
      d = Phil.date 30

      it 'returns a date in the last 30 days' do
        expect(month_ago.to_f..Time.now.to_f).to cover(d.to_f)
      end
    end

  end

  describe '#currency' do

    context 'default currency' do

      amount = 10..100
      c = Phil.currency amount

      it 'returns a string with a dollar value' do
        expect(c).to start_with('$')
      end

      it "returns a dollar value within #{amount}" do
        expect(amount).to cover(c.gsub('$', '').to_f)
      end

      it "formats the currency to two decimal places" do
        expect(c).to match(/\$\d{2}\.\d{2}/)
      end
    end

  end

end
