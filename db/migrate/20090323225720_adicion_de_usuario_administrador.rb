class AdicionDeUsuarioAdministrador < ActiveRecord::Migration
  def self.up
    User.create(:name => 'Gaspet', :login => 'admin', :password => 'demo123', :password_confirmation => 'demo123',
      :email => 'admin@mail.com')
  end

  def self.down
  end
end
