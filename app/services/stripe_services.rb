class StripeServices
include Rails.application.routes.url_helpers
  def create_stripe_product(product)
    stripe_product=Stripe::Product.create({
      name: product.name,
      description: product.description,
      # images: [rails_blob_path(product.images.first, only_path: true)]
    })
    product.update(stripe_product_id: stripe_product.id)
    stripe_product
  end

  def create_stripe_product_price(stripe_product,product)
    stripe_product_price=Stripe::Price.create({
      unit_amount: product.price,
      currency: 'pkr',
      product: stripe_product.id
    })
    product.update(stripe_product_price_id: stripe_product_price.id)
    stripe_product_price
  end

end
