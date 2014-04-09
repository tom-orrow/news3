class DeviseCreateServices < ActiveRecord::Migration
  def change
    create_table(:services) do |t|
      t.string :user_id
      t.string :provider
      t.string :uid
      t.string :uname
    end
  end
end
