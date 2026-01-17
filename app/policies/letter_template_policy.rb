class LetterTemplatePolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    user.present?
  end

  def create?
    user.present?
  end

  def update?
    user.present? && (user.super_admin? || record.event&.admin_id == user.id)
  end

  def destroy?
    user.present? && user.super_admin?
  end

  def set_default?
    user.present? && user.super_admin?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user&.super_admin?
        scope.all
      elsif user.present?
        scope.left_joins(:event).where(event_id: nil).or(
          scope.left_joins(:event).where(events: { admin_id: user.id })
        )
      else
        scope.none
      end
    end
  end
end
