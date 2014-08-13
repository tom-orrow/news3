ActiveAdmin.register Category do
  config.clear_sidebar_sections!

  index do
    column :name do |category|
      b link_to category.name, edit_admin_category_path(category)
    end
    column "Articles Count" do |category|
      p category.articles.count
    end
    actions
  end

  form do |f|
    f.inputs 'Details' do
      f.input :name
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit category: [:name]
    end
  end
end
