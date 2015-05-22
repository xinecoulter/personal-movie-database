require "rails_helper"

describe Role do
  let(:role) { build(:role) }

  it "can be created" do
    role.save!
    role.reload
    assert(role.persisted?)
    assert(Role == role.class)
  end

  it "can have a character_name" do
    role = build(:role, character_name: "Vito Corleone")
    role.save!
    assert("Vito Corleone" == role.reload.character_name)
  end
end
