require 'spec_helper'

describe 'Halo::Reach::API::VERSION' do
  it 'should be the correct version' do
    Halo::Reach::API::VERSION.should == '1.0.5'
  end
end