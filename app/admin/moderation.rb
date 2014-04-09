ActiveAdmin.register_page 'Moderation' do
  page_action :edit do
    @article = Article.where(id: params[:format]).first
    render 'admin/moderation/edit', layout: 'active_admin'
  end

  page_action :confirm, method: 'post' do
    article = Article.find(params[:format])
    article.active = true
    if article.save
      redirect_to admin_moderation_path, notice: 'Article has been confirmed.'
    else
      redirect_to admin_moderation_path, error: 'Failed to confirm article.'
    end
  end

  page_action :reject do
    redirect_to admin_moderation_path, notice: 'Article has been rejected.'
  end

  content do
    columns do
      column do
        panel 'Inactive Articles' do
          table_for Article.inactive.order('created_at DESC') do
            column('User')       { |article| article.user.email }
            column('Title')      { |article| b link_to(article.title, admin_moderation_edit_path(article)) }
            column('Category')   { |article| article.category.map { |c| c.name }.join(", ") }
            column('Created At') { |article| article.created_at }
          end
          hr
          b "Total: #{Article.inactive.count}"
        end
      end
    end
  end
end
