class ReportMailerPdfMailer < ApplicationMailer

  def send_pdf(user, pdf_content)
    attachments['report.pdf'] = pdf_content
    mail(to: user.email, subject: 'Your Report PDF')
  end

end
