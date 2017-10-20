require 'rails_helper'

RSpec.describe Category, type: :model do
  subject { FactoryGirl.create(:category) }

  it { expect(subject).to validate_presence_of :name }
  it { expect(subject).to validate_uniqueness_of :name }
  it { expect(subject).to validate_length_of :name }

  it { expect(subject).to have_many(:books) }
end
