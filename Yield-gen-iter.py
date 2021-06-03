# yield keyword

# generator to print even numbers
def print_even(test_list) :
	for i in test_list:
		if i % 2 == 0:
			yield i

# initializing list
test_list = [1, 4, 5, 6, 7]

# printing initial list
print ("The original list is : " + str(test_list))

# printing even numbers
print ("The even numbers in list are : ", end = " ")
for j in print_even(test_list):
	print (j, end = " ")


# A Python program to generate squares from 1 100

def nextSquare():
	i = 1

	# An Infinite loop to generate squares
	while True:
		yield i*i				
		i += 1 # Next execution resumes
				# from this point	

# Driver code
for num in nextSquare():
	if num > 100:
		break
	print(num)

###########################  Iterator #########################


# value can be anything which can be iterate
iterable_value = 'Learning'
iterable_obj = iter(iterable_value)

while True:
	try:

		# Iterate by calling next
		item = next(iterable_obj)
		print(item)
	except StopIteration:

		# exception will happen when iteration will over
		break



######################## second ex iterator  ############################

# A simple Python program to demonstrate
# working of iterators using an example type
# that iterates from 10 to given value

# An iterable user defined type
class Test:

	# Constructor
	def __init__(self, limit):
		self.limit = limit

	# Creates iterator object
	# Called when iteration is initialized
	def __iter__(self):
		self.x = 10
		return self

	# To move to next element. In Python 3,
	# we should replace next with __next__
	def __next__(self):

		# Store current value ofx
		x = self.x

		# Stop iteration if limit is reached
		if x > self.limit:
			raise StopIteration

		# Else increment and return old value
		self.x = x + 1;
		return x

# Prints numbers from 10 to 15
for i in Test(15):
	print(i)



##################### ex 3 iterator  ################333

# Sample built-in iterators

# Iterating over a list
print("List Iteration")
l = ["Python", "for", "Learners"]
for i in l:
	print(i)
	
# Iterating over a tuple (immutable)
print("\nTuple Iteration")
t = ("Python", "for", "Learners")
for i in t:
	print(i)
	
# Iterating over a String
print("\nString Iteration")
s = "Python"
for i in s :
	print(i)
	
# Iterating over dictionary
print("\nDictionary Iteration")
d = dict()
d['xyz'] = 123
d['abc'] = 345
for i in d :
	print("%s %d" %(i, d[i]))

######################## Generator--1 #####################

# A generator function that yields 1 for first time,
# 2 second time and 3 third time
def simpleGeneratorFun():
	yield 1			
	yield 2			
	yield 3			

# Driver code to check above generator function
for value in simpleGeneratorFun():
	print(value)



######################## Generator--2 #####################

# generator object with next()

# A generator function
def simpleGeneratorFun():
	yield 1
	yield 2
	yield 3

# x is a generator object
x = simpleGeneratorFun()

# Iterating over the generator object using next
print(x.next()) # In Python 3, __next__()
print(x.next())
print(x.next())






##############Decorator Example 1

# Python program to illustrate functions
# can be treated as objects
def shout(text):
	return text.upper()

print(shout('Hello'))
yell = shout
print(yell('Hello'))

#In the above example, we have assigned the function shout to a variable. 
#This will not call the function instead it takes the function object referenced 
#by shout and creates a second name pointing to it, yell.

##############Decorator Example 2
def shout(text):
	return text.upper()
def whisper(text):
	return text.lower()
def greet(func):
	# storing the function in a variable
	greeting = func("""Hi, I am created by a function passed as an argument.""")
	print (greeting)

greet(shout)
greet(whisper)

#In the above example, the greet function takes another function as a parameter (shout and whisper in this case). 
#The function passed as argument is then called inside the function greet.

# Python program to illustrate functions
# Functions can return another function

##############Decorator Example 3
def create_adder(x):
	def adder(y):
		return x+y

	return adder

add_15 = create_adder(15)

print(add_15(10))

#In the above example, we have created a function inside of another function and 
#then have returned the function created inside.

#Decorator########################################
# defining a decorator
def hello_decorator(func):

	# inner1 is a Wrapper function in
	# which the argument is called
	
	# inner function can access the outer local
	# functions like in this case "func"
	def inner1():
		print("Hello, this is before function execution")

		# calling the actual function now
		# inside the wrapper function.
		func()

		print("This is after function execution")
		
	return inner1


# defining a function, to be called inside wrapper
def function_to_be_used():
	print("This is inside the function !!")


# passing 'function_to_be_used' inside the
# decorator to control its behavior
function_to_be_used = hello_decorator(function_to_be_used)


# calling the function
function_to_be_used()

#output

Hello, this is before function execution
This is inside the function !!
This is after function execution

####################  we can easily find out the execution time of a function using a decorator.################

# importing libraries
import time
import math

# decorator to calculate duration
# taken by any function.
def calculate_time(func):
	
	# added arguments inside the inner1,
	# if function takes any arguments,
	# can be added like this.
	def inner1(*args, **kwargs):

		# storing time before function execution
		begin = time.time()
		
		func(*args, **kwargs)

		# storing time after function execution
		end = time.time()
		print("Total time taken in : ", func.__name__, end - begin)

	return inner1



# this can be added to any function present,
# in this case to calculate a factorial
@calculate_time
def factorial(num):

	# sleep 2 seconds because it takes very less time
	# so that you can see the actual difference
	time.sleep(2)
	print(math.factorial(num))

# calling the function.
factorial(10)


################## If function returns something ##############
def hello_decorator(func):
	def inner1(*args, **kwargs):
		
		print("before Execution")
		
		# getting the returned value
		returned_value = func(*args, **kwargs)
		print("after Execution")
		
		# returning the value to the original frame
		return returned_value
		
	return inner1


# adding decorator to the function
@hello_decorator
def sum_two_numbers(a, b):
	print("Inside the function")
	return a + b

a, b = 1, 2

# getting the value through return of the function
print("Sum =", sum_two_numbers(a, b))


################## chaining decorators#######################

# code for testing decorator chaining
def decor1(func):
	def inner():
		x = func()
		return x * x
	return inner

def decor(func):
	def inner():
		x = func()
		return 2 * x
	return inner

@decor1
@decor
def num():
	return 10

print(num())


######################## List comprehension ###################

# Empty list
List = []

# Traditional approach of iterating
for character in 'Python 4 python!':
	List.append(character)

# Display list
print(List)

#############3 Using list comprehension   ##################

# Using list comprehension to iterate through loop
List = [character for character in 'Python 4 python!']

# Displaying list
print(List)

###################### Time tracking with list comprehension ####################
# Import required module
import time


# define function to implement for loop
def for_loop(n):
	result = []
	for i in range(n):
		result.append(i**2)
	return result


# define function to implement list comprehension
def list_comprehension(n):
	return [i**2 for i in range(n)]


# Driver Code

# Calculate time takens by for_loop()
begin = time.time()
for_loop(10**6)
end = time.time()

# Display time taken by for_loop()
print('Time taken for_loop:',round(end-begin,2))

# Calculate time takens by list_comprehension()
begin = time.time()
list_comprehension(10**6)
end = time.time()

# Display time taken by for_loop()
print('Time taken for list_comprehension:',round(end-begin,2))
#Output
#Time taken for_loop: 0.56
#Time taken for list_comprehension: 0.47
#From the above program, we can see list comprehensions are quite faster than for loop.





