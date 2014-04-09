class Ability
  include CanCan::Ability

  def initialize(user = current_user)
    user ||= User.new
    if user.role? :admin
      can :manage, :all
    else
      can :create, Article, user_id: user.id
      can :manage, User, id: user.id

      if user.role? :moderator
        can :manage, ActiveAdmin::Page, name: 'Moderation'
      end
    end
  end
end
