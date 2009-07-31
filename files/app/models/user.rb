class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.merge_validates_length_of_email_field_options :allow_blank => true
    c.merge_validates_format_of_email_field_options :allow_blank => true
    c.merge_validates_uniqueness_of_email_field_options :allow_blank => true
  end

  acts_as_authorization_subject

  validates_presence_of   :login
  validates_length_of     :login, :within => 3..40
  validates_uniqueness_of :login, :case_sensitive => false

  attr_accessible :login, :password, :password_confirmation, :first_name, :last_name, :email, :status, :active

  named_scope :active, :conditions => ["users.active = true"]
  named_scope :disabled, :conditions => ["users.active = false"]

  def full_name
    "#{first_name last_name}"
  end

  #############

  # def active?
  #   status == "Active"
  # end

  # Overrides the default implementation in acl9
  def has_role?(passed_roles, admin = true)
    role_list = self.roles.map(&:name).map(&:downcase)
    if admin
      return true if role_list.include?("admin")
    end
    passed_roles.to_a.each do |role|
      return true if role_list.include? role.to_s.downcase
    end
    false
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