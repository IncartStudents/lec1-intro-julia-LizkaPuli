# Выболнить большую часть заданий ниже - привести примеры кода под каждым комментарием


#===========================================================================================
1. Переменные и константы, области видимости, cистема типов:
приведение к типам,
конкретные и абстрактные типы,
множественная диспетчеризация,
=#

# Что происходит с глобальной константой PI, о чем предупреждает интерпретатор?
const PI = 3.14159
PI = 3.14
# предупредят о замене глобальной константы, так как при замене в местах использования PI как константы модет сохраняться старое значение 

# Что происходит с типами глобальных переменных ниже, какого типа `c` и почему?
a = 1
b = 2.0
c = a + b
# а это тип int, b это тип float, c это тоже float. причина: Automatic promotion for built-in arithmetic types and operator

# Что теперь произошло с переменной а? Как происходит биндинг имен в Julia?
a = "foo"
# а стала string

# Что происходит с глобальной переменной g и почему? Чем ограничен биндинг имен в Julia?
g::Int = 1
#g = "hi"

function greet()
    g = "hello"
    println(g)
end
greet()

# когда мы присвемваем тип данных, то уже глобально мы не можем менять тип,
# но в функции без специального указания global там находятся локальные перменные 

# Чем отличаются присвоение значений новому имени - и мутация значений?
v = [1,2,3]
z = v
v[1] = 3
v = "hello"
z
# присвоение это передача значения, но мы просто туда сохраняем данное значение; дальше при мутации v
# z не меняет свое значени 

# Написать тип, параметризованный другим типом
a3::Array{Int} = [1, 2, 3]

#=
Написать функцию для двух аругментов, не указывая их тип,
и вторую функцию от двух аргментов с конкретными типами,
дать пример запуска
=#
function f_without(a, b)
    return a + b
end
println(f_without(3, 4))  
function f_with(a::Int, b::Int)
    return a + b
end
println(f_with(3, 4)) 

#=
Абстрактный тип - ключевое слово? abstract typу
Примитивный тип - ключевое слово? не требуют ключевого слова для создания, так как они встроены в язык
Композитный тип - ключевое слово? struct или mutable struct
=#

#=
Написать один абстрактный тип и два его подтипа (1 и 2)
Написать функцию над абстрактным типом, и функцию над её подтипом-1
Выполнить функции над объектами подтипов 1 и 2 и объяснить результат
(функция выводит произвольный текст в консоль)
=#

abstract type patient end
struct sick <: patient
    name::String
    room_number::Int
    treatment::Bool  
end
struct healthy <: patient
    name::String
    appointment_date::String
end

function patient_info(p::patient)
    println("Информация о пациенте:")
    if p isa sick
        println("Пациент: ", p.name, ", находится в палате №", p.room_number)
    elseif p isa healthy
        println("Пациент: ", p.name, ", записан на прием ", p.appointment_date)
    end
end

function sick_status(p::sick)
    println("Пациент: ", p.name, " находится в палате №", p.room_number,". Статус:")
    if p.treatment
        println("Назначено лечение")
    else
        println("Лечение не назначено")
    end
end

p1 = sick("Иван Иванов", 12, true)  
p2 = healthy("Анна Смирнова", "15.05.2025")

patient_info(p1)   
patient_info(p2) 
sick_status(p1)    

#===========================================================================================
2. Функции:
лямбды и обычные функции,
переменное количество аргументов,
именованные аргументы со значениями по умолчанию,
кортежи
=#

# Пример обычной функции
function add(a, b)
    return a + b
end

# Пример лямбда-функции (аннонимной функции)
subtraction = (a, b) -> a + b

# Пример функции с переменным количеством аргументов
function sum_numbers(arg...)
    return sum(arg) 
end

# Пример функции с именованными аргументами
function print_info(name; age)
    println("Имя: $name, Возраст: $age")
end

# Функции с переменным кол-вом именованных аргументов
function order(items...)
    for (item, price) in items
        println("$item: $price рублей")
        total_price += price
    end
    println("Итоговая сумма: $total_price рублей")
end

#=
Передать кортеж в функцию, которая принимает на вход несколько аргументов.
Присвоить кортеж результату функции, которая возвращает несколько аргументов.
Использовать splatting - деструктуризацию кортежа в набор аргументов.
=#

function fun_1(arg...)
    return sum(arg) 
end

function fun_2(arg...)
    return arg
end

tuple_1=(1,2,3)
println(fun_1(tuple_1...))
println(fun_2(tuple_1...))

#===========================================================================================
3. loop fusion, broadcast, filter, map, reduce, list comprehension
=#

#=
Перемножить все элементы массива
- через loop fusion и
- с помощью reduce
=#

arr = [1, 2, 3, 4, 5]
x=1
for i in arr
    global x *= i
end
println(x)

result = reduce(*, arr)
println(result)

#=
Написать функцию от одного аргумента и запустить ее по всем элементам массива
с помощью точки (broadcast)
c помощью map
c помощью list comprehension
указать, чем это лучше явного цикла?
=#

function sqr(x)
    return x ^ 2
end

println(sqr.(arr))
println(map(sqr, arr))
println([sqr(x) for x in arr])

# Эти подходы делают код более компактным и производительнее. 

# Перемножить вектор-строку [1 2 3] на вектор-столбец [10,20,30] и объяснить результат
row_vector = [1 2 3]        
column_vector = [10, 20, 30] 
println(row_vector * column_vector)

# В одну строку выбрать из массива [1, -2, 2, 3, 4, -5, 0] только четные и положительные числа
arr_ = [1, -2, 2, 3, 4, -5, 0]
println([i for i in arr_ if (x % 2 == 0) && (x > 0)])


# Объяснить следующий код обработки массива names - что за number мы в итоге определили?
using Random
Random.seed!(123)
names = [rand('A':'Z') * '_' * rand('0':'9') * rand([".csv", ".bin"]) for _ in 1:100]
# вызывли пакет рандом 
# фиксируем последовательность случайных чисел
# создаем 100 названий файлов рандомно с расширением либо .cvs либо .bin
same_names = unique(map(y -> split(y, ".")[1], filter(x -> startswith(x, "A"), names)))
#фильтр проверяет начинается ли строка name с буквы A, а потом создает новый массив с названиями файлов без расширения(map(функция, коллекция))
numbers = parse.(Int, map(x -> split(x, "_")[end], same_names))
#теперь создает массив из цифр в строковам формате и с помощью функции переводим
numbers_sorted = sort(numbers)
# сортируем по возрастнию
number = findfirst(n -> !(n in numbers_sorted), 0:9)
# возвращает индекс первого пропущенной цифры от 0 до 9
println(number)

# Упростить этот код обработки:
Random.seed!(123)
names = ["$(rand('A':'Z'))_$(rand('0':'9'))$(rand([".csv", ".bin"]))" for _ in 1:100]
numbers_sorted = sort(unique(parse.(Int, [split(split(x, "_")[2], ".")[1] for x in names if startswith(x, "A")])))
number = findfirst(n -> !(n in numbers_sorted), 0:9)
println(number)

#===========================================================================================
4. Свой тип данных на общих интерфейсах
=#

#=
написать свой тип ленивого массива, каждый элемент которого
вычисляется при взятии индекса (getindex) по формуле (index - 1)^2
=#
struct lazyarray
    index::Int
end
Base.show(io::IO,getindex::lazyarray) = print(io, (getindex.index - 1)^2)

a = lazyarray(5)
println(a)  

#=
Написать два типа объектов команд, унаследованных от AbstractCommand,
которые применяются к массиву:
`SortCmd()` - сортирует исходный массив
`ChangeAtCmd(i, val)` - меняет элемент на позиции i на значение val
Каждая команда имеет конструктор и реализацию метода apply!
=#

abstract type AbstractCommand end
apply!(cmd::AbstractCommand) = println("Not implemented for type $(typeof(cmd))")
struct SortCmd <: AbstractCommand
    arr::Vector{Int}  
end
apply!(inf::SortCmd) = sort!(inf.arr) 
struct ChangeAtCmd <: AbstractCommand
    arr::Vector{Int} 
    i::Int            
    val::Int         
end
apply!(inf::ChangeAtCmd) = inf.arr[inf.i] = inf.val 
struct sum_arr<: AbstractCommand
    arr::Vector{Int}  
end

arr = [3, 1, 4, 1, 5, 9]
println(apply!(SortCmd(arr)))
println(apply!(ChangeAtCmd(arr, 2, 7)))
println(arr)
println(apply!(sum_arr(arr)))

# Аналогичные команды, но без наследования и в виде замыканий (лямбда-функций)
sort_cmd = (arr::Vector{Int}) -> sort!(arr)
change_at_cmd = (arr::Vector{Int}, i::Int, val::Int) -> arr[i] = val
arr = [3, 1, 4, 1, 5, 9]
println(sort_cmd(arr))
println(change_at_cmd(arr, 2, 7))
println(arr)

#===========================================================================================
5. Тесты: как проверять функции? с помощью модуля Test, используя @test для сравнения ожидаемого и истинного результата
=#
# Написать тест для функции
using Test
@test f_without(2, 3) == 5

#===========================================================================================
6. Дебаг: как отладить функцию по шагам? - чтобы отладить функцию по шагам, я используем Debugger.@enter имя_функции(аргументы)
(используем Debugger.@enter потому что конфликт с vscode),
затем в отладчике ввожу команды
(я рассмотрела n,fr,q,so)
делаю это в терминале, потому что в коде отладчик ведет себя непредсказуемо
(In f_without(a, b) at c:\Users\kostr\Desktop\juliaProject\lec1-intro-julia-LizkaPuli\level2_manual.jl:56
 56  function f_without(a, b)
>57      return a + b
 58  end

About to run: (+)(2, 3)
julia> s

1|debug> o                                                                                                                                                                                               
1|debug> 
1|debug> 
1|debug> so
  1.245571 seconds (7.00 M allocations: 192.889 MiB, 7.61% gc time)
WARNING: replacing module Foo.
Main.Foo

julia> ERROR: UndefVarError: `s` not defined in `Main`
Suggestion: check for spelling errors or missing imports.)
=#

#=
Отладить функцию по шагам с помощью макроса @enter и точек останова

при этом я просто вводила два раза so (нажала enter) so (нажала enter)
=#

using Debugger

#Debugger.@enter f_without(2, 3)

#=
n = next line
q = exit:

julia> Debugger.@enter f_without(2, 3)
In f_without(a, b) at c:\Users\kostr\Desktop\juliaProject\lec1-intro-julia-LizkaPuli\level2_manual.jl:56
 56  function f_without(a, b)
>57      return a + b
 58  end

About to run: (+)(2, 3)
1|debug> n
In f_without(a, b) at c:\Users\kostr\Desktop\juliaProject\lec1-intro-julia-LizkaPuli\level2_manual.jl:56
 56  function f_without(a, b)
>57      return a + b
 58  end

About to run: return 5
1|debug> q

fr = frame:

julia> Debugger.@enter f_without(2, 3)
In f_without(a, b) at c:\Users\kostr\Desktop\juliaProject\lec1-intro-julia-LizkaPuli\level2_manual.jl:56
 56  function f_without(a, b)
>57      return a + b
 58  end

About to run: (+)(2, 3)
1|debug> fr
[1] f_without(a, b) at c:\Users\kostr\Desktop\juliaProject\lec1-intro-julia-LizkaPuli\level2_manual.jl:56
  | a::Int64 = 2
  | b::Int64 = 3
1|debug> q

so = out:

julia> Debugger.@enter f_without(2, 3)
In f_without(a, b) at c:\Users\kostr\Desktop\juliaProject\lec1-intro-julia-LizkaPuli\level2_manual.jl:56
 56  function f_without(a, b)
>57      return a + b
 58  end

About to run: (+)(2, 3)
1|debug> so
5
=#
#===========================================================================================
7. Профилировщик: как оценить производительность функции?
 =#
 
 #=
 Оценить производительность функции с помощью макроса @profview,
 и добавить в этот репозиторий файл со скриншотом flamechart'а
 ответ:
  первая функция создает слишком много копий из-за этого функция идет слишком медленно
  вторая функция уже быстрее, я меньшила копии
 =#

 #=
using Pkg
Pkg.add("Profile")
Pkg.add("ProfileView")  
=#

using Profile, ProfileView


 function generate_data(len)
    vec1 = Any[]
    for k = 1:len
        r = randn(1,1)
        append!(vec1, r)
    end
    vec2 = sort(vec1)
    vec3 = vec2 .^ 3 .- (sum(vec2) / len)
    return vec3
end

@time generate_data(1_000_000);

Profile.clear()

@profile  generate_data(1_000_000)

ProfileView.view()

# Переписать функцию выше так, чтобы она выполнялась быстрее:

function generate_data_fast(len)
    vec1 = randn(len)  
    vec1 .= vec1 .^ 3 .-  (sum( sort!(vec1)) / len )  
    return vec1
end

@time generate_data_fast(1_000_000);

Profile.clear()

@profile  generate_data_fast(1_000_000)

ProfileView.view()

#===========================================================================================
8. Отличия от матлаба: приращение массива и предварительная аллокация?
=#
#=
Написать функцию определения первой разности, которая принимает и возвращает массив
и для каждой точки входного (x) и выходного (y) выходного массива вычисляет:
y[i] = x[i] - x[i-1]
=#
function first_difference(x::Array)
    y = Number[]  
    for i in 1:length(x)  
        if i == 1
            push!(y, x[i]) 
        else
            push!(y, x[i] - x[i-1]) 
        end
    end
    return y
end
x = [3, 5, 7, 10, 15]
println("Входной массив: ", x)
println("Выходной массив: ", first_difference(x))
#=
Аналогичная функция, которая отличается тем, что внутри себя не аллоцирует новый массив y,
а принимает его первым аргументом, сам массив аллоцируется до вызова функции
=#
function first_difference_2arg(x::Array, y::Array)
    for i in 1:length(x)
        if i == 1
            push!(y, x[i])
        else
            push!(y, x[i] - x[i-1]) 
        end
    end
    return y
end
x = [3, 5, 7, 10, 15]
y = Number[] 
first_difference_2arg(x, y)
println("Входной массив: ", x)
println("Выходной массив: ", y)  
#=
Написать код, который добавляет элементы в конец массива, в начало массива,
в середину массива
=#

push!(x, 6)
println("Массив после добавления в конец: ", x)
insert!(x, 1, 6)
println("Массив после добавления в начало: ",x )
insert!(x, Int(ceil((length(x)+1) / 2)), 6)
println("Массив после добавления в середину: ",x)
#===========================================================================================
9. Модули и функции: как оборачивать функции внутрь модуля, как их экспортировать
и пользоваться вне модуля?
=#


#=
Написать модуль с двумя функциями,
экспортировать одну из них,
воспользоваться обеими функциями вне модуля
=#
module Foo
in_function(x) = x^2
export out_function 
out_function(x) = in_function(x) + 1
end 
using .Foo  
println(out_function(3)) 
import .Foo: in_function
println(in_function(3)) 

#===========================================================================================
10. Зависимости, окружение и пакеты
=#

# Что такое environment, как задать его, как его поменять во время работы?
#В Project.toml хранятся только имена пакетов, но не версии; Manifest.toml записаны точные версии всех пакетов и их зависимостей.

# Что такое пакет (package), как добавить новый пакет? локально для файла или для проекта 

# Как начать разрабатывать чужой пакет? скачать, настроить, редактировать/использовать

#=
Как создать свой пакет? использовать PkgTemplates
(необязательно, эксперименты с PkgTemplates проводим вне этого репозитория)
=#


#===========================================================================================
11. Сохранение переменных в файл и чтение из файла.
Подключить пакеты JLD2, CSV.
=#
#using Pkg
#Pkg.add("JLD2")
#Pkg.add("CSV")
# Сохранить и загрузить произвольные обхекты в JLD2, сравнить их
# Сохранить и загрузить табличные объекты (массивы) в CSV, сравнить их
using CSV
using DataFrames
data = DataFrame(A = 1:5, B = [2.3, 4.5, 6.7, 8.9, 0.1])
CSV.write("data.csv", data)
loaded_data = CSV.read("data.csv", DataFrame)
println(data == loaded_data)

#===========================================================================================
12. Аргументы запуска Julia
=#

#=
Как задать окружение при запуске?Дмумя файлами Project.toml иManifest.toml 
=#

#=
Как задать скрипт, который будет выполняться при запуске:
а) из файла .jl - julia --project=. name.jl
б) из текста команды? (см. флаг -e) - julia --project=. -e 'строчка, которую хотим проверить'
=#

#=
После выполнения задания Boids запустить julia из командной строки,
передав в виде аргумента имя gif-файла для сохранения анимации
=#
