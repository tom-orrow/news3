ActiveAdmin.register User do
  index do
    column :email
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    default_actions
  end

  filter :email

  form do |f|
    f.inputs "Admin Details for #{user.email}" do
      f.input :role, as: :select, collection: [['Admin', 'admin'], ['Moderator', 'moderator'], ['', nil]],
              include_blank: false
    end
    f.actions
  end
  controller do
    def permitted_params
      params.permit user: [:role]
    end
  end
end
