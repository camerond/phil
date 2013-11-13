require 'spec_helper'

describe Phil do

  def count_words(content)
    if content.is_a? String
      content.split(' ').length
    else
      content.nodes[0].split(' ').length
    end
  end

  def find_children(tag, content)
    Ox.parse(content).nodes.find_all{ |n| n.value == tag }
  end

  def find_elements(tag, content)
    find_children(tag, "<div>#{content}</div>")
  end

  def expect_element(tag, content)
    expect(content).to start_with "<#{tag}>"
    expect(content).to end_with "</#{tag}>"
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
        expect(find_elements('p', subject).size).to eq(argument)
      end
    end

    context 'with a range' do
      let(:argument) { (10..20) }
      it 'outputs 10..20 paragraphs' do
        expect(argument).to cover(find_elements('p', subject).size)
      end
    end

  end

  describe '#blockquote' do
  
    context 'default value' do
      bq = Phil.blockquote
      it 'outputs a blockquote' do
        expect_element('blockquote', bq)
      end
      it 'contains 1..3 paragraphs' do
        expect(1..3).to cover(find_children('p', bq).size)
      end
    end
  
    context 'custom value' do
      bq = Phil.blockquote(5..10)
      it 'contains 5..10 paragraphs' do
        expect(5..10).to cover(find_children('p', bq).size)
      end
    end
  
  end
  
  describe '#ul' do
  
    context 'default value' do
  
      ul = Phil.ul
  
      it 'outputs a ul' do
        expect_element('ul', ul)
      end
      it 'contains 3..10 list items' do
        expect(3..10).to cover(find_children('li', ul).size)
      end
      it 'each containing 3..15 words' do
        find_children('li', ul).each do |li|
          expect(3..15).to cover(count_words(li))
        end
      end
  
    end
  
    context 'custom values' do
  
      li_count = (15..20)
      word_count = (20..22)
      ul = Phil.ul li_count, word_count
  
      it "contains #{li_count} list items" do
        expect(li_count).to cover(find_children('li', ul).size)
      end
      it "each containing #{word_count} words" do
        find_children('li', ul).each do |li|
          expect(word_count).to cover(count_words(li))
        end
      end
  
    end
  
  end
  
  describe '#ol' do
  
    context 'default value' do
  
      ol = Phil.ol
  
      it 'outputs a ol' do
        expect_element('ol', ol)
      end
      it 'contains 3..10 list items' do
        expect(3..10).to cover(find_children('li', ol).size)
      end
      it 'each containing 3..15 words' do
        find_children('li', ol) do |li|
          expect(3..15).to cover(count_words(li))
        end
      end
  
    end
  
    context 'custom values' do
  
      li_count = (15..20)
      word_count = (20..22)
      ol = Phil.ol li_count, word_count
  
      it "contains #{li_count} list items" do
        expect(li_count).to cover(find_children('li', ol).size)
      end
      it "each containing #{word_count} words" do
        find_children('li', ol) do |li|
          expect(word_count).to cover(count_words(li))
        end
      end
  
    end

  end

  describe '#link_list' do

    context 'default value' do

      ll = Phil.link_list

      it 'outputs a ul' do
        expect_element('ul', ll)
      end
      it 'contains 3..10 list items' do
        expect(3..10).to cover(find_children('li', ll).size)
      end
      it 'each containing a link with 1..5 words' do
        find_children('li', ll) do |li|
          find_children('a', li) do |a|
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
        expect(li_count).to cover(find_children('li', ll).size)
      end
      it "each containing a link with #{word_count} words" do
        find_children('li', ll) do |li|
          find_children('a', li) do |a|
            expect(word_count).to cover(count_words(a))
          end
        end
      end

    end

  end

end
