gfortran -O3 -fdefault-real-8 GJGeneral.f90 -o General.out
./General.out

# UNIFORM X, N = 10
gfortran -O3 -fdefault-real-8 GJChebyshevLin10.f90 -o Linear10.out
./Linear10.out > DataLinear10
tail -4 DataLinear10 > MaximalError.txt
# Plot f(x)
gnuplot -persist <<-EOFMarker
set title "Approximation of f(x) (Uniformly spaced x, n=10)"
set key
plot 'DataLinear10' index 0 using 1:2 with lines title "Approx",\
	'DataLinear10' index 0 using 1:3 with lines title "Exact"
EOFMarker
# Plot f'(x)
gnuplot -persist <<-EOFMarker
set title "Approximation of f'(x) (Uniformly spaced x, n=10)"
set key
plot 'DataLinear10' index 1 using 1:2 with lines title "Approx",\
	'DataLinear10' index 1 using 1:3 with lines title "Exact"
EOFMarker

# UNIFORM X, N = 100
gfortran -O3 -fdefault-real-8 GJChebyshevLin100.f90 -o Linear100.out
./Linear100.out > DataLinear100
tail -4 DataLinear100 >> MaximalError.txt
# Plot f(x)
gnuplot -persist <<-EOFMarker
set title "Approximation of f(x) (Uniformly spaced x, n=100)"
set key
plot 'DataLinear100' index 0 using 1:2 with lines title "Approx",\
	'DataLinear100' index 0 using 1:3 with lines title "Exact"
EOFMarker
# Plot f'(x)
gnuplot -persist <<-EOFMarker
set title "Approximation of f'(x) (Uniformly spaced x, n=100)"
set key
plot 'DataLinear100' index 1 using 1:2 with lines title "Approx",\
	'DataLinear100' index 1 using 1:3 with lines title "Exact"
EOFMarker

# X AT ZEROS, N = 10
gfortran -O3 -fdefault-real-8 GJChebyshevZeros10.f90 -o Zeros10.out
./Zeros10.out > DataZeros10
tail -4 DataZeros10 >> MaximalError.txt
# Plot f(x)
gnuplot -persist <<-EOFMarker
set title "Approximation of f(x) (x at zeros, n=10)"
set key
plot 'DataZeros10' index 0 using 1:2 with lines title "Approx",\
	'DataZeros10' index 0 using 1:3 with lines title "Exact"
EOFMarker
# Plot f'(x)
gnuplot -persist <<-EOFMarker
set title "Approximation of f'(x) (x at zeros, n=10)"
set key
plot 'DataZeros10' index 1 using 1:2 with lines title "Approx",\
	'DataZeros10' index 1 using 1:3 with lines title "Exact"
EOFMarker

# X AT ZEROS, N = 100
gfortran -O3 -fdefault-real-8 GJChebyshevZeros100.f90 -o Zeros100.out
./Zeros100.out > DataZeros100
tail -4 DataZeros100 >> MaximalError.txt
# Plot f(x)
gnuplot -persist <<-EOFMarker
set title "Approximation of f(x) (x at zeros, n=100)"
set key
plot 'DataZeros100' using 1:2 with lines title "Approx",\
	'DataZeros100' using 1:3 with lines title "Exact"
EOFMarker
# Plot f'(x)
gnuplot -persist <<-EOFMarker
set title "Approximation of f'(x) (x at zeros, n=100)"
set key
plot 'DataZeros100' using 1:4 with lines title "Approx",\
	'DataZeros100' using 1:5 with lines title "Exact"
EOFMarker

# Read the maximal errors.
cat MaximalError.txt
