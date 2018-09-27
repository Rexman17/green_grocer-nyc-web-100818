require 'pry'

def consolidate_cart(cart) # cart is an array
  cart.each_with_object({}) do |(food_hash), consolidated_hash|
    food_hash.each do |food, info_hash|
      info_hash.each do |key, val|
        # filling consolidated_hash
        if !consolidated_hash.keys.include?(food) # if the new hash does not have this key
          consolidated_hash[food] = {:count=>0} # adding k/v pair
        end
        if !consolidated_hash[food].keys.include?(key) # adding k/v pair
          consolidated_hash[food][key] = val
        end
      end
      # very last thing they want u to do is run the count
      if consolidated_hash.keys.include?(food)
        consolidated_hash[food][:count] += 1
      end
    end
  end
end

def apply_coupons(cart, coupons)
  final_hash = cart

  coupons.each do |coupon_hash| # iterate over coupons

    item = coupon_hash[:item] # tells me if item exits in cart

    if cart[item] && (cart[item][:count] >= coupon_hash[:num])
      cart[item][:count] -= coupon_hash[:num]
        if cart["#{item} W/COUPON"] # if cart has this already
          cart["#{item} W/COUPON"][:count] += 1
        else
          cart["#{item} W/COUPON"] = {
            :price => coupon_hash[:cost],
            :clearance => cart[item][:clearance],
            :count => 1
          }
        end
      end
    end

  final_hash
end

def apply_clearance(cart)
  cart_with_clearance = cart

  cart.each do |food_name, info_hash|
    if info_hash[:clearance] == true
      info_hash[:price] = (info_hash[:price] * 0.8).round(2)
    end
  end

  cart_with_clearance
end

def checkout(cart, coupons)
  grand_total = 0

  cart_consolidated = consolidate_cart(cart)
  coupons_applied = apply_coupons(cart_consolidated, coupons)
  clearance_applied = apply_clearance(coupons_applied)

  # now we have to iterate through clearance_applied
  # we know what each level equals bc of the apply_clearance method above
  clearance_applied.each do |food_name, info_hash|
    grand_total += info_hash[:count] * info_hash[:price]
  end
  if grand_total > 100
    grand_total *= 0.90
  end
  grand_total
end
