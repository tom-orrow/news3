ActiveAdmin.register Article do
  scope :active, default: true
  scope :inactive

  filter :category
  filter :created_at

  index do
    column :user
    column :title do |article|
      b link_to article.title, edit_admin_article_path(article)
    end
    column :category do |article|
      p article.category.map { |c| c.name }.join(", ")
    end
    column :active
    column :created_at
    column :updated_at
    default_actions
  end

  form do |f|
    f.inputs 'Content' do
      f.input :title
      f.input :description
      f.input :body, input_html: { class: 'redactor' }
    end
    f.inputs 'Details' do
      f.input :user, collection: [[current_user.email, current_user.id]], include_blank: false
      f.input :category, include_blank: false
      f.input :tag_list, hint: 'Comma separated'
      f.input :active
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit article: [:title, :user_id, :description, :body, :tag_list, :active, category_ids: []]
    end
  end
end
