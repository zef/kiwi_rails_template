class Role < ActiveRecord::Base
  acts_as_authorization_role
end


# == Schema Information
# Schema version: 20090618045348
#
# Table name: roles
#
#  id                :integer(4)      not null, primary key
#  name              :string(255)
#  authorizable_type :string(40)
#  authorizable_id   :integer(4)
#

