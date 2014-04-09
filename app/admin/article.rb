ActiveAdmin.register Article do
  scope :inactive

  filter :user, collection: User.all.map { |user| [user.email, user.id] }
  filter :category
  filter :created_at

  index do
    column :user
    column :title
    column :category, sortable: :category_id
    column :active
    column :created_at
    column :updated_at
    default_actions
  end

  form do |f|
    f.inputs "Content" do
      f.input :title
      f.input :description
      f.input :body
    end
    f.inputs "Details" do
      f.input :user, collection: [[current_user.email, current_user.id]], include_blank: false
      f.input :category, include_blank: false
      f.input :active
    end
    f.actions
  end
end
