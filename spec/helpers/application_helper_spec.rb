require 'rails_helper'

describe ApplicationHelper do
  it '#menu?' do
    allow(helper).to receive(:controller_name) { 'demo' }
    expect(helper.menu?('demo')).to be_truthy
  end
end