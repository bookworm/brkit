require 'spec_helper'

describe "Repo Model" do
  let(:repo) { Repo.new }
  it 'can be created' do
    repo.should_not be_nil
  end
end
