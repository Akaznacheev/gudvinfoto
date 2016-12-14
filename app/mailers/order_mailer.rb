class OrderMailer < ApplicationMailer
  default from: 'no-reply@tortonbook.ru'

  def send_new_order(order)
    @order = order
    @mail  = User.find_by(:role=>2).email
    mail(to: @mail, subject: 'Поступил новый заказ.')
  end

  def send_user_about_order(order)
    @order = order
    @mail  = @order.email
    mail(to: @mail, subject: 'Ваш заказ отправлен на печать')
  end
end
