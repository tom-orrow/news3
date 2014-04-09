class Ability
  include CanCan::Ability

  def initialize(user)
    if user.role? :admin
      can :manage, :all
    else
      can :read, Post

      if user.role? :moderator
        can :manage, ActiveAdmin::Page, name: "Dashboard"
        can :manage, Post
      end
    end
  end
end
