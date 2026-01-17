class EventPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.present?
  end

  def update?
    user.present? && (user.super_admin? || record.admin_id == user.id)
  end

  def destroy?
    user.present? && user.super_admin?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user&.super_admin?
        scope.all
      elsif user.present?
        scope.where(admin_id: user.id)
      else
        scope.active
      end
    end
  end
end
