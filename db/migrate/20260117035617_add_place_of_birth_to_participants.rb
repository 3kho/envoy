class AddPlaceOfBirthToParticipants < ActiveRecord::Migration[7.2]
  def change
    add_column :participants, :place_of_birth, :string
  end
end
