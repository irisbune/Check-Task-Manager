require 'rails_helper'

RSpec.describe Project, type: :model do

  it "is valid with a name, description and start date"
  it "is invalid without a name"
  it "is invalid without a start date"
  it "cannot have a start date in the past"
  it "has a valid date when the format is mm/dd/yyyy"
  it "has an has_many association with tasks"

end
