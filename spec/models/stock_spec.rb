require 'rails_helper'

describe Stock do
  subject { build(:stock) }

  describe 'associations' do
    it { is_expected.to belong_to(:bearer) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:bearer) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end
end
