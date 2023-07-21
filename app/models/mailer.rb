require 'authlogic'
#include ProductsHelper

class Mailer < ActionMailer::Base 
  default_url_options[:host] = "care.by" 
  
  helper :application#, :cat
  

  def message(message)
    @recipients   = Option.get("contacts_email")
    @from         = Option.get("email_from")
    @subject = Option.get("contacts_subj")
    @sent_on      = Time.now
    @content_type = "text/html" 
    body :message => message
  end
  
  def alert_amount_days(company)
    @recipients   = company.email
    @from = Option.get("email_from")
    @subject = Option.get("alert_amount").gsub("#NDAYS#", "#{company.alert_amount_days} #{Russian.p(company.alert_amount_days, "день", "дня", "дней")}")
    @sent_on      = Time.now
    @content_type = "text/html" 
    body :company => company     
  end
  
  def alert_amount(company)
    @recipients   = company.email
    @from = Option.get("email_from")
    @subject = Option.get("alert_amount").gsub("#N#", "#{show_amount(company.debt)}")
    @sent_on      = Time.now
    @content_type = "text/html" 
    body :company => company    
  end
  
  def alert_doc_days(company,docs)
    @recipients   = company.email
    @from = Option.get("email_from")
    @subject = Option.get("alert_doc_days").gsub("#NDAYS#", "#{company.alert_doc_days} #{Russian.p(company.alert_doc_days, "день", "дня", "дней")}")
    @sent_on      = Time.now
    @content_type = "text/html" 
    body :company => company, :docs => docs    
  end
  
  def alert_doc_count(company,docs)
    @recipients   = company.email
    @from = Option.get("email_from")
    @subject = Option.get("alert_doc_count").gsub("#NDOCS#", "#{docs.size} #{Russian.p(docs.size, "документ", "документа", "документов")}")
    @sent_on      = Time.now
    @content_type = "text/html" 
    body :company => company, :docs => docs
  end
  
  def user_activated(user)
    @recipients   = user.Email
    @from         = Option.get("email_from")
    @subject = Option.get("letter_activated_subj")
    @sent_on      = Time.now
    @content_type = "text/html" 
    body :user => user
  end
    
  def support_mail(user, b)  
    @recipients   = Option.get("support_email")
    @from         = user.name + "<" + user.Email + ">"
    @subject = "Сообщение от пользователя " + user.name + "(" + user.Email + ")"
    @sent_on      = Time.now
    @content_type = "text/html"    
    body :body => b, :user => user
  end
  
  def send_mail(email, subj, b)  
    @recipients   = email
    @from         = Option.get("email_from")
    @subject = subj
    @sent_on      = Time.now
    @content_type = "text/html"    
    body :body => b
  end
  
  def repass(user)  
    @recipients   = user.Email
    @from         = Option.get("email_from")
    @subject = Option.get("letter_repass_subj")
    @sent_on      = Time.now
    @content_type = "text/html" 
    body :user => user
  end
  

  def email_with_attachments(application_fields={},files=[])  
      @headers = {}  
      @sent_on = Time.now  
      @recipients = 'client@domain.com'  
      @from = 'info@domain.com'  
     
      @subject = 'Here are some file attachments'  
      application_fields.keys.each {|k| @body[k] = fields[k]}  
      
      # attach files  
      files.each do |file|  
        attachment "application/octet-stream" do |a|  
        a.body = file.read  
        a.filename = file.original_filename  
      end unless file.blank?  
    end  
  end  
  

  
  def send_letter(user, letter)
    @headers = {}  
    @recipients   = user.email
    @from         = Option.get("email_from")
    @subject = letter.subj
    @sent_on      = Time.now
    @content_type = "text/html" 
    
    body :body => letter.body    

    # attach files  
    for att in letter.attachments
      if att.file_file_name.to_s != ""
      attachment "application/octet-stream" do |a|  
        a.body = att.file.to_file(:original).read#att.attachment_data  
        a.filename = att.file_file_name  
      end unless att.blank?    
      end
    end
  end
  
  def user_reg(user, password, language)  
    @recipients   = user.email
    @from         = Option.get("email_from")
    @subject = mailer_translate_name(Option.get("letter_reg_subj"), language)
    @sent_on      = Time.now
    @content_type = "text/html" 
    body :user => user, :password => password
  end
  
  
  def mailer_translate_name(name, language)
    is = name.to_s.split("|")
    if is.size == 1
      return name
    else
      if language == "ru"
        return is[0]
      else
        return is[1]
      end
    end
  end


  def order_status(order, email)
    @recipients   = email
    @from         = Option.get("order_email_from")
    template = FormTemplate.find(:first, :conditions => ["name = ? AND language = ?", "order_status_#{order.status}", order.language])
      @subject = template.subject.to_s.gsub("#order_id#", order.id.to_s)
      @sent_on      = Time.now
      @content_type = "text/html" 
      body :t => template, :order => order

  end

  
  def new_order(order, email, language)
    @recipients   = email
    @from         = Option.get("order_email_from")
    @subject = mailer_translate_name(Option.get("order_neworder_subj").gsub(/\%id\%/, order.id.to_s), language)
    @sent_on      = Time.now
    @content_type = "text/plain" 
    body :order => order, :language => language
  end
  
  
  
  def password_reset_instructions(user, language)  
    @content_type = "text/html"    
    subject       mailer_translate_name(Option.get('letter_repass_subj'), language)
    from          Option.get('email_from')  
    recipients    user.email  
    sent_on       Time.now
    body          :edit_password_reset_url => Option.get('mail_url') + "password_resets/edit/" + user.perishable_token#edit_password_reset_url(user.perishable_token)  
#    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)  
  end  

end
