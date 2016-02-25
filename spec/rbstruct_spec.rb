require 'spec_helper'



describe RbStruct do

  context 'Class methods' do
    Header = RbStruct do
      int :value
      int :values, 10
    end

    subject { Header }
    let(:instance) { subject.new }
    it 'defines a class' do
      expect(subject).to be_instance_of Class
    end

    describe '#size' do
      it { expect(subject.size).to eq(11) }
    end

    describe '#bsize' do
      it { expect(subject.bsize).to eq(4*11) }
    end
  end
end
