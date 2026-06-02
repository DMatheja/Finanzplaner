module ApplicationHelper
  def role_name(role_value)
    case role_value.to_s
    when "admin", "0"
      "Admin"
    when "user", "1"
      "User"
    when "viewer", "2"
      "Viewer"
    when "test_admin", "3"
      "Test Admin"
    else
      "Unknown"
    end
  end
end
