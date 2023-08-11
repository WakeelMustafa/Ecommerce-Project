class CartsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_lineItems, only: [:show, :export_csv, :export_pdf]

  def show; end

  def export_csv
    if current_user.line_items.count < 10
      respond_to do |format|
        format.csv do
          send_csv_attachment
        end
      end
    else
      send_report_email_and_redirect
    end
  end

  def export_pdf
    pdf_content = render_to_string(pdf: 'report', template: 'carts/show_pdf.html.erb', page_size: 'A4')

    if current_user.line_items.count < 2
      respond_to do |format|
        format.html
        format.pdf do
          send_pdf_data(pdf_content)
        end
      end
    else
      send_pdf_to_user(pdf_content)
      redirect_to carts_show_path, notice: 'Report Sent Successfully!!'
    end
  end

  def apply_coupon
    @coupon = Coupon.find_by(code: params[:code])
    stripe_services = StripeServices.new
    current_user.line_items.each do |item|
      product = Product.find(item.product_id)
      stripe_product = stripe_services.create_stripe_product(product)
      stripe_product_price = stripe_services.create_stripe_product_price(stripe_product, product, @coupon.discount)
    end
  end

  private

  def set_lineItems
    @line_items = current_user.line_items.order(created_at: :desc).paginate(page: params[:page], per_page: 2)
  end

  def send_csv_attachment
    headers['Content-Disposition'] = "attachment; filename=\"user_line_items.csv\""
    headers['Content-Type'] ||= 'text/csv'
  end

  def send_report_email_and_redirect
    ReportMailer.delay(run_at: 1.minute.from_now).send_report(current_user, @line_items)
    redirect_to carts_show_path, notice: 'Report Sent Successfully!'
  end

  def send_pdf_data(content)
    send_data(
      content,
      filename: 'report.pdf',
      type: 'application/pdf',
      disposition: 'inline'
    )
  end

  def send_pdf_to_user(content)
    ReportMailerPdfMailer.send_pdf(current_user, content).deliver_later(wait_until: 1.minute.from_now)
  end
end
