module AdminUsersHelper
  
  def a2editUser(user, target='')
    if user.blank?
      return "Не найден"
    else
      return "<a href='#{link2editUser(user)}' target='#{target}'>#{user.email}</a>"
    end
  end

  def link2editUser(user)
    if !user.blank?
      return "/admin_users/edit/#{user.id}"
    end
  end
  
  #Рисует вид сортировки
  def users_sort_link(title, sort_up, sort_down)
    html = ""
    case @sort
      when sort_up
        img = "<img src='/img/up.png' style='display: none;'>"
        url = "/admin_users/list/" + params[:page].to_s + "?sort=" + sort_down + "&"
        c = "class='yellow b' "
      when sort_down
        img = "<img src='/img/dn.png' style='display: none;'>"
        url = "/admin_users/list/" + params[:page].to_s + "?sort=" + sort_up + "&"
        c = "class='yellow b' "
      else
        img = ""
        url = "/admin_users/list/" + params[:page].to_s + "?" + "sort=" + sort_up + "&"
        c = ""
    end
    html = img + "<a " + c + "href='" + url + "'>" + title + "</a>"
    return html
  end  
end