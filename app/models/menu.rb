class Menu < ActiveRecord::Base
  acts_as_nested_set
  named_scope :menus, :order => 'lft ASC'
end
