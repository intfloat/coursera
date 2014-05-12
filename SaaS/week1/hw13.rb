
# for thrid part of homework 0
class BookInStock
	attr_accessor :isbn, :price
	def initialize(isbn, price)
		if isbn.length==0 || price<=0
			raise ArgumentError
		end
		@isbn = isbn
		@price = price
	end

	def price_as_string
		res = "$" + price.to_s
		if res.index('.')==nil
			res += ".00"
		elsif res[-2]=='.'
			res += "0"
		end
		res
	end
end

book = BookInStock.new("isbn", 12.95)
print book.price_as_string
print "\n"