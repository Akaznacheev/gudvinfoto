class OrderMailer < ApplicationMailer
  default from: 'no-reply@tortonbook.ru'

  def send_new_order(order)
    @order = order
    @mail  = 'an-kaz2009@mail.ru'
    mail(to: @mail, subject: 'Поступил новый заказ.')
  end
end
