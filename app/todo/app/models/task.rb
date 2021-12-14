class Task < ApplicationRecord
  belongs_to :user
  validates :title, presence: true,
       length: {maximum: 20, allow_blank: true}
  validates :content, length: {maximum: 300}
  validates :deadline , presence: true
  validate :after_now?
    
  def after_now?
    return if deadline.blank?
    errors.add(:deadline, "現在以降の日時にしてください") if deadline < Time.now
  end
end
