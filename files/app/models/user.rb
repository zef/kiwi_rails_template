class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.merge_validates_length_of_email_field_options :allow_blank => true
    c.merge_validates_format_of_email_field_options :allow_blank => true
    c.merge_validates_uniqueness_of_email_field_options :allow_blank => true
    c.openid_required_fields = [:nickname, :email]
  end

  acts_as_authorization_subject

  attr_accessible :username, :password, :password_confirmation, :openid_identifier, :first_name, :last_name, :email, :status, :active

  named_scope :active, :conditions => { :active => true }
  named_scope :disabled, :conditions => { :active => false }

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
        self.has_no_role!(role) if has_role?(role)
      end
    end
  end

  private

  def map_openid_registration(registration)
    self.email = registration["email"] if email.blank?
    self.username = registration["nickname"] if username.blank?
  end
end
