class Ability
  include CanCan::Ability

  def initialize(user)
    if user.role? :admin
      can :manage, :all
    else
      can :create, Article

      if user.role? :moderator
        can :manage, ActiveAdmin::Page, name: 'Moderation'
      end
    end
  end
end
