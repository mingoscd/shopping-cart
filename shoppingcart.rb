require 'pry'
require 'date'
class ShoppingCart
	def initialize(season)
		year = {:spring => 0, :summer => 1, :autumn => 2, :winter => 3}
		@season = year[season]
		@cart_content = []
		@list_item = { apple: Apple.new, orange: Orange.new, grape: Grape.new, banana: Banana.new, watermelon: Watermelon.new }
	end	

	def add(item)
		added = false
		@cart_content.each do |content|
			if content[0] == item
				content[1] += 1
				added = true
			end
		end
		if added == false
			@cart_content << [item, 1]
		end
	end

	def cost
		final_price = 0
		@cart_content = self.get_all_discounts(@cart_content)

		@cart_content.each do |item|
			item_price = @list_item[item[0]].get_price(@season)
			item_quantity = item[1]
			final_price +=  item_price * item_quantity
		end
		p "The final price is " + final_price.to_s + " $" 
	end

	def get_all_discounts(cart)
		new_cart =cart
		cart.map do |item|
			new_cart = @list_item[item[0]].discount(new_cart, item)
		end
		new_cart
	end

end

class Item
	def find_in_cart(cart,id,quantity)
		cart.map do |cart_item|
			if cart_item[0] == id
				cart_item[1] = quantity
			end
		end
		cart
	end

	def discount(cart, quantity)
		self.no_discount(cart)
	end

	def no_discount(cart)
		cart
	end
end

class Apple < Item
	def initialize
		@price = [10, 10, 15, 12]
	end
	def discount(cart, item)
		id = item[0]
		quantity = item[1]
		if quantity >= 2
			quantity -= quantity/2
		end
		cart = self.find_in_cart(cart,id,quantity)
	end
	def get_price(season)
		@price[season]
	end
end

class Orange < Item
	def initialize
		@price = [5, 2, 5, 5]
	end
	def discount(cart, item)
		id = item[0]
		quantity = item[1]
		if quantity >= 3
			quantity -= quantity/3
		end
		cart = self.find_in_cart(cart,id,quantity)
	end
	def get_price(season)
		@price[season]
	end
end

class Grape < Item
	def initialize
		@price = [15, 15, 15, 15]
	end

	def discount(cart, item)
		id = :banana
		quantity = item[1]
		if quantity >= 4 
			quantity = quantity/4
		end
		
		new_quantity = 0
		cart.map do |s|
			if s[0] == :banana
				new_quantity = s[1]
			end
		end

		if new_quantity - quantity < 0
			n_bananas = 0
		else
			n_bananas = new_quantity - quantity
		end

		cart = self.find_in_cart(cart,id, n_bananas)
	end

	def get_price(season)
		@price[season]
	end
end

class Banana < Item
	def initialize
		@price = [20, 20, 20, 21]
	end

	def get_price(season)
		@price[season]
	end
end

class Watermelon < Item
	def initialize
		@price = [50, 50, 50, 50]
	end

	def get_price(season)
		if Date.today.sunday? 
			@price[season]*2
		else
			@price[season]
		end
	end
end

cart = ShoppingCart.new :winter
cart.add :banana
cart.add :banana
cart.add :grape
cart.add :grape
cart.add :grape
cart.add :grape
cart.cost