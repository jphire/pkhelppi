class AddProductToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :product, :boolean, default: false
  end
end
