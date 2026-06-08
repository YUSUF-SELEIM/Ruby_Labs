class Article < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  enum :status, { public_article: 0, archived: 1 }
  validates :title, presence: true
  validates :body, presence: true
  after_initialize :set_defaults, if: :new_record?
  before_save :check_reports

  private

  def set_defaults
    self.reports_count ||= 0
    self.status ||= :public_article
  end

  def check_reports
    if reports_count >= 3
      self.status = :archived
    end
  end
end