ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do
    columns do
      column do
        panel 'Recent Articles' do
          table_for Article.active.limit(5).order('updated_at DESC').includes(:user) do
            column('User')       { |article| article.user.email }
            column('Title')      { |article| link_to(article.title, admin_article_path(article)) }
            column('Updated At') { |article| article.updated_at }
          end
          hr
          b "Total: #{Article.all.count}"
        end
      end
      column do
        panel 'Recent Users' do
          table_for User.limit(5).order('confirmed_at DESC') do
            column('Email')        { |user| user.email }
            column('Confirmed At') { |user| user.confirmed_at }
          end
          hr
          b %(Total: #{User.all.count} | Today: #{User.where("confirmed_at >= ?", Time.zone.now.beginning_of_day).count})
        end
      end
    end
  end
end
