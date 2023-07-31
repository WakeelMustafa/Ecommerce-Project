class StripeServices

  def create_stripe_product(product)
    stripe_product=Stripe::Product.create({
      name: product.name,
      description: product.description,
      # images: [rails_blob_path(product.images.first, only_path: true)]
    })
    product.update(stripe_product_id: stripe_product.id)
    stripe_product
  end

  def create_stripe_product_price(stripe_product,product, discount=1)
    stripe_product_price=Stripe::Price.create({
      unit_amount: (product.price-(product.price/100)*30)*100,
      currency: 'pkr',
      product: stripe_product.id
    })
    product.update(stripe_product_price_id: stripe_product_price.id)
    stripe_product_price
  end

  def create_checkout(stripe_lineitems)
    line_items = stripe_lineitems.map do |key, value|
      {
        price: key,
        quantity: value,
      }
    end
    session = Stripe::Checkout::Session.create({
      line_items: line_items,
      mode: 'payment',
      success_url: 'http://127.0.0.1:3000/carts/success',
      cancel_url: 'http://127.0.0.1:3000/carts/cancel',
    })
  end

end
