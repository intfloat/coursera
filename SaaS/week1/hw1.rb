
# this is for Berkeley SaaS course, week 1, homework 1
def sum(arr)
	res = 0
	for i in 0...arr.length
		res += arr[i]
	end
	res
end

def max_2_sum(arr)
	res = 0
	if arr.length == 0
		res
	elsif arr.length == 1
		arr[0]
	else
		res += arr.max
		arr.delete_at(arr.index(res)) # delete maximum element
		res += arr.max
		res
	end
end


# used to test sum function
print(sum([1, 2, 3, 4]))
print("\n")

# used to test max_2_sum function
print(max_2_sum([1, 3, 4, 6, 7, 8])) # should be 15
print "\n" # single quote will output original string
print(max_2_sum([7])) # should be 7
print "\n"
print(max_2_sum([-1, 34, 45, 23, 4, 6])) # should be 79
print "\n"

def sum_to_n?(arr, n)
	res = false
	if arr.length==0 && n==0
		res = true
	else
		for i in 0...arr.length
			for j in i+1...arr.length
				if arr[i]+arr[j] == n
					res = true
				end
			end # end inner for loop
		end # end outer for loop
	end # end else clause
	res
end

print sum_to_n?([1, 2, 3, 4], 5) # should be true
print "\n"
print sum_to_n?([1, 2, 3, 4], 50) # should be false
print "\n"


# second part of homework 0
def hello(name)
	"Hello, " + name
end

def starts_with_consonant?(s)
	if s.length == 0
		return false
	end
	arr = ['a', 'e', 'i', 'o', 'u']
	if arr.index(s.downcase[0])
		false
	elsif s.downcase[0]>='a' && s.downcase[0]<='z'
		true
	else
		false
	end
end

print starts_with_consonant?("this true")
print "\n"
print starts_with_consonant?("12aha false")
print "\n"



def binary_multiple_of_4?(s)
	num = 0	
	for i in 0...s.length
		if s[i]!='0' && s[i]!='1'
			return false
		else
			num = num*2 + s[i].ord - '0'.ord
		end
	end
	# print "num is"
	# print num
	# print "\n"
	if num == 0
		false
	elsif num%4 == 0
		true
	else
		false
	end
end

print binary_multiple_of_4?("110000100") # should be true
print "\n"
print binary_multiple_of_4?("asdj100") # should be false
print "\n"
print binary_multiple_of_4?("1100110") # should be false
print "\n"

