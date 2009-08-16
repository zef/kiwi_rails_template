class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.merge_validates_length_of_email_field_options :allow_blank => true
    c.merge_validates_format_of_email_field_options :allow_blank => true
    c.merge_validates_uniqueness_of_email_field_options :allow_blank => true
  end

  acts_as_authorization_subject

  attr_accessible :login, :password, :password_confirmation, :openid_identifier, :first_name, :last_name, :email, :status, :active

  named_scope :active, :conditions => ["users.active = true"]
  named_scope :disabled, :conditions => ["users.active = false"]

  def full_name
    "#{first_name last_name}"
  end

  #############

  # Overrides the default implementation in acl9
  # allows pre-existing associations to be treated as roles
  def has_role?(role_name, object = nil)
    !! if object.nil?
      self.roles.find_by_name(role_name.to_s) ||
      self.roles.member?(get_role(role_name, nil))
    else
      role = get_role(role_name, object)
      subject_owns_object = object.send(role_name) == self if object.respond_to?(role_name)
      (role && self.roles.exists?(role.id)) || subject_owns_object
    end
  end

  def user_roles=(passed_roles)
    for role in USER_ROLES
      if passed_roles.include?(role)
        logger.debug { "----- should have role: #{role}" }
        self.has_role!(role)
      else
        self.has_no_role!(role) if has_role?(role, false)
      end
    end
  end
end
# == Schema Information
#
# Table name: users
#
#  id                  :integer(4)      not null, primary key
#  login               :string(255)
#  email               :string(255)
#  comment             :string(255)
#  last_name           :string(255)
#  first_name          :string(255)
#  openid_identifier   :string(255)
#  last_login_ip       :string(255)
#  current_login_ip    :string(255)
#  persistence_token   :string(255)
#  active              :boolean(1)      default(TRUE)
#  crypted_password    :string(128)     default("")
#  password_salt       :string(128)     default("")
#  single_access_token :string(255)     default(""), not null
#  login_count         :integer(4)      default(0), not null
#  failed_login_count  :integer(4)      default(0), not null
#  last_request_at     :datetime
#  last_login_at       :datetime
#  current_login_at    :datetime
#  created_at          :datetime
#  updated_at          :datetime
#

