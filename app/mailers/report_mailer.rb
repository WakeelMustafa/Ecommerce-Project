class ReportMailer < ApplicationMailer

  def send_report(user, line_items)
    attachments['report.csv'] = generate_report_csv(line_items)
    mail(to: user.email, subject: 'Your Report CSV')
  end

  private

  def generate_report_csv(line_items)
    CSV.generate(headers: true) do |csv|
      csv << ['Product Name', 'Quantity', 'Total Price']
      line_items.each do |line_item|
        csv << [line_item.product.name, line_item.quantity, line_item.total_price]
      end
    end
  end
end
