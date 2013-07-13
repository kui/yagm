require 'spec_helper'

describe file('/etc/hostname') do
  it { should be_file }
  it { should contain 'foo' }
end
