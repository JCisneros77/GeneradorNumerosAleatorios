# Congruencial Mixto
def mixto(x0,a,c,m,n)
	_X = Array.new()
	for i in 0...n
		x = (a*x0+c)%m
		x0 = x
		x = x.to_f/m
		_X.push(x)
	end
	return _X
end

# Congruencial Multiplicativo
def multiplicativo(x0,a,m,n)
	_X = Array.new()
	for i in 0...n
		x = (a*x0) % m
		x0 = x
		x = x.to_f/m
		_X.push(x)
	end
	return _X
end

# Función Uniforme
def uniforme(a,b,_X)
	nums = Array.new()
	_X.each do |i|
		x = a + ((b-a)*i)
		nums.push(x)
	end
	return nums
end

# Función Exponencial
def exponencial(lambda,_X)
	nums = Array.new()
	_X.each do |i|
		x = -Math.log(i)/lambda.to_f
		nums.push(x)
	end
	return nums
end

# Función Normal
def normal(miu,sigma,generador,listaGenerador,n)
	nums = Array.new()
	x0 = listaGenerador.at(0)
	for i in 0...n
	randoms = Array.new()
	# Numeros aleatorios
	if generador == "mixto"
		randoms = mixto(x0,listaGenerador.at(1),listaGenerador.at(2),listaGenerador.at(3),12)
	elsif generador == "multiplicativo"
		randoms = multiplicativo(x0,listaGenerador.at(1),listaGenerador.at(2),12)
	end
		sum = 0.0
		for j in 0...12
			sum+=randoms.at(j)
		end
		x = sum - 6.0
		x = sigma*x+miu
		nums.push(x)
		x0 = randoms.at(11)
	end
	return nums
end

# Función Triangular
def triangular(a,b,c,_X)
	nums = Array.new()
	a1 = (b-a).to_f/(c-a)
	_X.each do |i|
		if 0 <= i && i < a1
			x = a + Math.sqrt((b-a)*(c-a)*i)
		elsif a1 <= i && i <= 1
			x = -Math.sqrt((b-c)*(b-c)+(b-a)*(c-b)-i*(c-a)*(c-b))+c
		end	
		nums.push(x)
	end
	return nums
end

# Función Poisson
def poisson(lambda,_X)
	nums = Array.new()
	_X.each do |u|
		x = 0;
		_P = Math.exp(-lambda)
		_F = _P
		until u < _F do
			_P = (lambda.to_f/(x+1)) * _P
			_F = _F + _P
			x+=1
		end
		nums.push(x)
	end
	return nums
end

# Función Binomial
def binomial(n,p,generador,listaGenerador,_N)
	nums = Array.new()
	x0 = listaGenerador.at(0)
	for i in 0..._N
		randoms = Array.new()
		exitos = 0
		if generador == "mixto"
			randoms = mixto(x0,listaGenerador.at(1),listaGenerador.at(2),listaGenerador.at(3),n)
		elsif generador == "multiplicativo"
			randoms = multiplicativo(x0,listaGenerador.at(1),listaGenerador.at(2),n)
		end
		randoms.each do |j|
			if j < p
				exitos+=1
			end
		end
		nums.push(exitos)
		x0 = randoms.at(n-1)
	end
	return nums
end

# Generar Números Aleatorios
def generarNumsAleatorios(generador,listaGenerador,funcion,listaFuncion,_N,_M)
	# Generador Mixto o Multiplicativo
	_X = Array.new()
	nums = Array.new()
	nombre = ""
	if generador == "mixto"
		_X = mixto(listaGenerador.at(0),listaGenerador.at(1),listaGenerador.at(2),listaGenerador.at(3),_N)
	elsif generador == "multiplicativo"
		_X = multiplicativo(listaGenerador.at(0),listaGenerador.at(1),listaGenerador.at(2),_N)
	end
	# Funcion
	case funcion
	when "uniforme"
		nums = uniforme(listaFuncion.at(0),listaFuncion.at(1),_X)
		nombre = "FuncionUniforme#{generador}.png"
	when "exponencial"
		nums = exponencial(listaFuncion.at(0),_X)
		nombre = "FuncionExponencial#{generador}.png"
	when "normal"
		nums = normal(listaFuncion.at(0),listaFuncion.at(1),generador,listaGenerador,_N)
		nombre = "FuncionNormal#{generador}.png"
	when "triangular"
		nums = triangular(listaFuncion.at(0),listaFuncion.at(1),listaFuncion.at(2),_X)
		nombre = "FuncionTriangular#{generador}.png"
	when "poisson"
		nums = poisson(listaFuncion.at(0),_X)
		nombre = "FuncionPoisson#{generador}.png"
	when "binomial"	
		nums = binomial(listaFuncion.at(0),listaFuncion.at(1),generador,listaGenerador,_N)
		nombre = "FuncionBinomial#{generador}.png"
	end
	plot(nums,_M,nums.min.floor,nums.max.ceil,nombre)
end # Termina generarNumsAleatorios

# Función para hacer histograma
def plot(x,n,min,max,name) #(Arreglo,Número de Barras,Nombre del archivo)
# Guardar el arreglo en el archivo data.dat
	File.open("data.dat", "w+") do |f| 
  		f.puts(x)
	end
# Correr el script que genera el histograma
# pasando como parametro el numero de barras
# y el nombre del archivo.
	a = "gnuplot -e \"n=#{n}; min=#{min}.; max=#{max}.; nameOfFile='#{name}'\" plot.gnu"
	system(a)
end

# Main
	# Mixto
x = generarNumsAleatorios("mixto",[56,754,543,10000],"normal",[0,1],2000,10)
x = generarNumsAleatorios("mixto",[56,754,543,10000],"uniforme",[2,6],2000,10)
x = generarNumsAleatorios("mixto",[56,754,543,10000],"exponencial",[0.5],50000,10)
x = generarNumsAleatorios("mixto",[56,754,543,10000],"triangular",[2,4,6],2000,10)
x = generarNumsAleatorios("mixto",[56,754,543,10000],"poisson",[10],2000,10)
x = generarNumsAleatorios("mixto",[56,754,543,10000],"binomial",[10,0.5],2000,10)
	# Multiplicativo
x = generarNumsAleatorios("multiplicativo",[56,754,10000],"normal",[0,1],2000,10)
x = generarNumsAleatorios("multiplicativo",[56,754,10000],"uniforme",[2,6],2000,10)
x = generarNumsAleatorios("multiplicativo",[56,754,10000],"exponencial",[0.5],50000,10)
x = generarNumsAleatorios("multiplicativo",[56,754,10000],"triangular",[2,4,6],2000,10)
x = generarNumsAleatorios("multiplicativo",[56,754,10000],"poisson",[10],2000,10)
x = generarNumsAleatorios("multiplicativo",[56,754,10000],"binomial",[10,0.5],2000,10)