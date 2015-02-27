require 'spec_helper'
require 'active_support'

class User < ActiveRecord::Base
  self.table_name = 'users'
end

describe Aroi::Instrumentation do

  describe '#instrument_creation!' do
    it 'should set extended_active_record to true' do
      Aroi::Instrumentation.instrument_creation!
      expect(Aroi::Instrumentation.extended_active_record?).to eq true
    end

    it 'should include the ActiveRecord module for all ActiveRecord::Base objects' do
      Aroi::Instrumentation.instrument_creation!
      ActiveSupport::Notifications.subscribe(/instance.active_record/) do |name, start, finish, id, payload|
        expect(payload[:name]).to eq "User"
      end
    end
  end

end

describe Aroi::Instrumentation::ActiveRecord do

  before do
    Aroi::Instrumentation.instrument_creation!
  end

  describe '#initialize' do
    it 'should fire one notification for each object created' do
      count = 0;
      ActiveSupport::Notifications.subscribe(/instance.active_record/) do |name, start, finish, id, payload|
        count += 1;
      end
      3.times do
        User.new
      end
      expect(count).to eq 3
    end
  end

  describe '#allocate' do
    it 'should fire one notification for each ojbect allocated' do
      count = 0;
      ActiveSupport::Notifications.subscribe(/instance.active_record/) do |name, start, finish, id, payload|
        count += 1;
      end
      3.times do
        User.allocate
      end
      expect(count).to eq 3
    end
  end

end
