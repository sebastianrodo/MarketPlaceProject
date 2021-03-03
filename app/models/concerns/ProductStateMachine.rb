module ProductStateMachine
  extend ActiveSupport::Concern

  included do
    include AASM

    aasm column: :state do
      state :unpublished, initial: true
      state :published, :archived

      event :publish do
        transitions from: [:archived, :unpublished], to: :published
      end

      event :unpublish do
        transitions from: [:archived, :published], to: :unpublished
      end

      event :archive do
        transitions from: [:published, :unpublished], to: :archived
      end
    end
  end
end
