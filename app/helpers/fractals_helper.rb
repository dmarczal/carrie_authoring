#encoding: utf-8
module FractalsHelper
  def creator(user)
    if user
      if user.name.present?
        user.name
      else
        user.email
      end
    else
      "Não definido"
    end
  end
end
