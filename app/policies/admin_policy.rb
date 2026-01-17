class AdminPolicy < ApplicationPolicy
  def index?
    user.present? && user.super_admin?
  end

  def show?
    user.present? && (user.super_admin? || user.id == record.id)
  end

  def create?
    user.present? && user.super_admin?
  end

  def update?
    user.present? && (user.super_admin? || user.id == record.id)
  end

  def destroy?
    user.present? && user.super_admin? && user.id != record.id
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user&.super_admin?
        scope.all
      else
        scope.none
      end
    end
  end
end
