
# how to print
println("hey")

# how to assign variables
a = 4
println(typeof(a))
a = 4.56
println(typeof(a))
a = "hey"
println(typeof(a))

# syntax for basic math
sum = 3+2
println(sum)
difference = 10-2
println(difference)
product = 29*3
println(product)
quotient = 100/10
println(quotient)
power = 10^2
println(power)
moduls =101%2
println(moduls)

# how to get a string
word1 = "hey"
println(word1)
word2 = """ hey "hello" """
println(word2)

# string interpolation
word3= "hey $(word1)"
println(word3)

# string concatenation
println(string("hey","hello"))
println(string("hey",11,"hello"))
println(word1*word2)
println("$(word1)$(word2)")

# data structure

# Dictionaries
d= Dict("a"=>"1","b"=>"2","c"=>"3","d"=>"4")
println(d)
#add
d["e"]="5"
println(d)
#grab
println(d["e"])
#delete
pop!(d,"e")
println(d)
#not ordered

#Tuples
t=("a","b","c","d")
println(t)
#index
println(t[1])
#immutable

#Arrays
a1=["a","b","c","d",1,2,3,4]
println(a1)
a2=[[1,2,3,4,5],[1,2,3,4,5],["a","b","c","e","e"]]
println(a2)
println(rand(4,3))
println(rand(4,3,2))
#index
println(a1[2])
#edit
a1[3]="e"
println(a1)
#add to the end
println(push!(a1,5))
#delete the last element
pop!(a1)
println(a1)

#Loops

#while loops
n=0
while n<10
    global n+=1
    println(n)
end

#for loop
for n = 1:10
    println(n)
end
B=[i+j for i in 1:5, j in 1:5]
println(B)

#conditionals
x=1
y=3
if x>y
    println(x)
elseif y>x
    println(y)
else
    println(x,y)
end

println((x>y) ? x : y)

println((x>y) && println(x))
println((x<y) && println(y))

#functions
function f1(x)
    x^2
end
println(f1(42))

f2(x)=x^2
println(f2(42))

f3=x->x^2
println(f3(42))

a=[1,54,3,2]
println(sort(a))

println(f1(B))
println(f1.(B))

#using Pkg
#Pkg.add("Plots")

#using Pkg
#Pkg.add("PlotlyJS")

using Plots
using PlotlyJS
x= -3:0.1:3
f(x)=x^2
y=f.(x)
plotlyjs()
p = Plots.plot(x, y) 
scatter!(p, x, y)  
display(p) 

xflip!()

xlabel!("x")
ylabel!("y")
title!("график")

p1=Plots.plot(x,x)
p2=Plots.plot(x,x.^2)
p3=Plots.plot(x,x.^3)
p4=Plots.plot(x,x.^4)
display(Plots.plot(p1,p2,p3,p4,layout=(2,2)))

@which 3+3.2

import Base.+
+(x::String, y::String)=string(x,y)
println("hey"+"hello")

s(h,j)=println("arg")
s(h::Int,j::Float64)=println("int and float")
s(h::Float64,j::Float64)=println("float and float")
s(h::Int,j::Int)=println("int and int")
println(s(2,3))

#Basic linear algebra
A=rand(1:4,3,3)
B=A # the same memory
C=copy(A)
println([B C])

x=ones(3)
println(A*x)

#Transposition
println(A+A')

#Transposed multiplication
println(A'A)

#Solving linear systems "\"
A\(A*x)

Atall=A[:,1:2]
display(Atall)
Atall\(A*x) 

A=randn(3,3)
[A[:,1] A[:,1]]\(A*x)  

Ashort=A[1:2,:]
display(Ashort)
Ashort\(A*x)[1:2]

