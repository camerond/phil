require 'spec_helper'

describe Phil do

  def count_elements(tag, content)
    content.scan(/<#{tag}>(.[^<>]*)<\/#{tag}>/).size
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
      idx = 0
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
        expect(subject.split('</p><p>').length).to eq(argument)
      end
    end

    context 'with a range' do
      let(:argument) { (10..20) }
      it 'outputs 10..20 paragraphs' do
        expect(argument).to cover(count_elements('p', subject))
      end
    end

  end

  describe '#blockquote' do

    subject { Phil.blockquote }

    context 'default value' do
      it 'outputs a blockquote' do
        expect_element('blockquote', subject)
      end
      it 'contains 1..3 paragraphs' do
        expect(1..3).to cover(count_elements('p', subject))
      end
    end

  end

end
