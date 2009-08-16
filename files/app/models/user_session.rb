class UserSession < Authlogic::Session::Base
  last_request_at_threshold(1.minute)
  single_access_allowed_request_types ["application/xml"]
end