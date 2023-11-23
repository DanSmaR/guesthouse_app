class AddResponseToReviews < ActiveRecord::Migration[7.1]
  def change
    add_column :reviews, :response, :text
  end
end
