class CreateAnUserAdmin < ActiveRecord::Migration[6.0]
  def change
    User.create! do |u|
      u.first_name = 'Admin'
      u.last_name = 'Admin'
      u.email     = 'admin@admin.com'
      u.cellphone = '1234'
      u.password  = '12345678'
      u.admin_role = true
    end
  end
end
