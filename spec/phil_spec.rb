require 'spec_helper'

describe Phil do
  describe '#pick' do
    subject { Phil.pick(argument) }

    context 'with a single number' do
      let(:argument) { 5 }
      it { should == 5 }
    end

    context 'with a range' do
      let(:argument) { (3..5) }
      it { should >= 3 }
      it { should <= 5 }
    end

    context 'with an array' do
      let(:argument) { [2, 5, 7] }

      it 'gives one of the arguments back' do
        expect(argument).to include(subject)
      end
    end
  end
end
