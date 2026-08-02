class Menu < ApplicationRecord
  has_many :menu_recipes, -> { order(:id) }, dependent: :destroy
  has_many :recipes, through: :menu_recipes

  validates :date, presence: true, uniqueness: true

  def self.current
    order(date: :desc).first
  end

  def title
    "Cofa House #{date.strftime('%B %-d')}#{date_ordinal_suffix} #{date.year}"
  end

  private
    def date_ordinal_suffix
      day = date.day
      return "th" if (11..13).cover?(day % 100)
      case day % 10
      when 1 then "st"
      when 2 then "nd"
      when 3 then "rd"
      else "th"
      end
    end
end
