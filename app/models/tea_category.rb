class TeaCategory < ActiveRecord::Base
  set_primary_key :cat_id
  def self.table_name() "tea_catalog_categories" end
  has_and_belongs_to_many :products, :class_name => "TeaProduct", :join_table => "tea_cats_prods", :foreign_key => "cat_id", :association_foreign_key => "prod_id"
 # has_and_belongs_to_many :products, :class_name => "TeaProduct", :join_table => "tea_cats_prods", :foreign_key => "prod_id", :association_foreign_key => "cat_id"
end
