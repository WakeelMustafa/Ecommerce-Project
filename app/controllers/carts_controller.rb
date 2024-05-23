class CartsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_line_items, only: [:show, :export_pdf, :export_csv]

  def show;end

  def export_csv
    if params[:type] == 'all'
      records_to_export = current_user.line_items
    elsif params[:type] == 'selected'
      records_to_export = []
      selected_ids = params[:product_selected]

      selected_ids&.each do |id|
        line_item = LineItem.find(id)
        records_to_export << line_item if line_item
      end
    elsif params[:type] == 'current_page'
      records_to_export = @line_items
    else
      redirect_to carts_show_path, alert: "Invalid export type."
      return
    end

    respond_to do |format|
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"user_line_items.csv\""
        headers['Content-Type'] ||= 'text/csv'

        csv_data = CSV.generate(headers: true) do |csv|
          csv << ['Product Name', 'Quantity', 'Price']
          records_to_export.each do |line_item|
            csv << [line_item.product.name, line_item.quantity, line_item.product.price]
          end
        end

        render plain: csv_data
      end
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

  def set_line_items
    @line_items = current_user.line_items.order(created_at: :desc).paginate(page: params[:page], per_page: 2)
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
