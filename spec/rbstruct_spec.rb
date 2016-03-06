require 'spec_helper'


shared_examples 'a struct class' do |struct|
  it { is_expected.to respond_to :bsize }
  it { is_expected.to respond_to :size }
  it { is_expected.to respond_to :read }
  it { is_expected.to be < RbStruct::StructBase }
  it { is_expected.to be < Array }
end

shared_examples 'a struct instance' do |instance|
  it { is_expected.to respond_to :to_s }
  it { is_expected.to be_a RbStruct::StructBase }
end


describe RbStruct do

  describe '.Struct' do
    subject { method(:RbStruct) }
    it { expect { |b| subject.call(&b) }.to yield_control }

    context 'returns a class' do
      subject { RbStruct() }
      it_behaves_like 'a struct class'
    end

    context 'class instance' do
      subject { RbStruct().new }
      it_behaves_like 'a struct instance'
    end
  end

end
