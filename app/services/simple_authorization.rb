class SimpleAuthorization
  class UnauthorizedError < StandardError
  end

  class << self
    def role_auth(role, user)
      raise SimpleAuthorization::UnauthorizedError, "Unauthorized" unless user.role == role.to_s
    end
  end
end