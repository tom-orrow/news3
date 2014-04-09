class DeviseCreateServices < ActiveRecord::Migration
  def change
    create_table(:services) do |t|
      t.string :provider
      t.string :uid
      t.string :uname

      t.belongs_to :user
      t.timestamps
    end
  end
end
