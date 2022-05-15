module NotificationsHelper
  def notification_form(notification)
    @visiter = notification.visiter
    @advice = nil
    @visiter_advice = notification.advice_id
    case notification.action
      when 'like'
        tag.a(notification.visiter.username, href: show_other_user_path(@visiter)) + 'が' + tag.a('あなたの投稿', href: recommend_path(notification.recommend_id)) + 'にいいねしました'
      when 'advice' then
        @advice = Advice.find_by(id: @visiter_advice)
        @advice_content = @advice.advice
        @concern_title = @advice.concern.title
        tag.a(@visiter.username, href: show_other_user_path(@visiter)) + 'が' + tag.a("#{@concern_title}", href: concern_path(notification.concern_id)) + 'にコメントしました'
    end
  end

  def unchecked_notifications
    @notifications = current_user.passive_notifications.where(checked: false)
  end
end
