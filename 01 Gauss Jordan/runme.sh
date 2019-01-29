# Things may not work right out of the box, as bash might not have
# permissions to run this file. The terminal will complain something
# like "./runme.sh: permission denied". If that is the case, please
# enter:
# chmod u+x runme.sh
# in the terminal while in the folder containing runme.sh

gfortran -O3 -fdefault-real-8 GJGeneral.f90 -o General.out
./General.out

# UNIFORM X, N = 10
gfortran -O3 -fdefault-real-8 GJChebyshevLin10.f90 -o Linear10.out
./Linear10.out > DataLinear10
tail -4 DataLinear10 > MaximalError.txt
# Plot f(x)
gnuplot -persist <<-EOFMarker
set title "Approximation of f(x) (Uniformly Spaced x, n=10)"
set key
set yrange [-0.5:1.5]
plot 'DataLinear10' index 0 using 1:2 with lines title "Approx",\
	'DataLinear10' index 0 using 1:3 with lines title "Exact"
EOFMarker
# Plot f'(x)
gnuplot -persist <<-EOFMarker
set title "Approximation of f'(x) (Uniformly Spaced x, n=10)"
set key
set yrange [-2.5:2.5]
plot 'DataLinear10' index 1 using 1:2 with lines title "Approx",\
	'DataLinear10' index 1 using 1:3 with lines title "Exact"
EOFMarker

# UNIFORM X, N = 100
gfortran -O3 -fdefault-real-8 GJChebyshevLin100.f90 -o Linear100.out
./Linear100.out > DataLinear100
tail -4 DataLinear100 >> MaximalError.txt
# Plot f(x)
gnuplot -persist <<-EOFMarker
set title "Approximation of f(x) (Uniformly Spaced x, n=100)"
set key
set yrange [-0.5:1.5]
plot 'DataLinear100' index 0 using 1:2 with lines title "Approx",\
	'DataLinear100' index 0 using 1:3 with lines title "Exact"
EOFMarker
# Plot f'(x)
gnuplot -persist <<-EOFMarker
set title "Approximation of f'(x) (Uniformly Spaced x, n=100)"
set key
set yrange [-2.5:2.5]
plot 'DataLinear100' index 1 using 1:2 with lines title "Approx",\
	'DataLinear100' index 1 using 1:3 with lines title "Exact"
EOFMarker

# X AT ZEROS, N = 10
gfortran -O3 -fdefault-real-8 GJChebyshevZeros10.f90 -o Zeros10.out
./Zeros10.out > DataZeros10
tail -4 DataZeros10 >> MaximalError.txt
# Plot f(x)
gnuplot -persist <<-EOFMarker
set title "Approximation of f(x) (x at Zeros, n=10)"
set key
set yrange [-0.5:1.5]
plot 'DataZeros10' index 0 using 1:2 with lines title "Approx",\
	'DataZeros10' index 0 using 1:3 with lines title "Exact"
EOFMarker
# Plot f'(x)
gnuplot -persist <<-EOFMarker
set title "Approximation of f'(x) (x at Zeros, n=10)"
set key
set yrange [-2.5:2.5]
plot 'DataZeros10' index 1 using 1:2 with lines title "Approx",\
	'DataZeros10' index 1 using 1:3 with lines title "Exact"
EOFMarker

# X AT ZEROS, N = 100
gfortran -O3 -fdefault-real-8 GJChebyshevZeros100.f90 -o Zeros100.out
./Zeros100.out > DataZeros100
tail -4 DataZeros100 >> MaximalError.txt
# Plot f(x)
gnuplot -persist <<-EOFMarker
set title "Approximation of f(x) (x at Zeros, n=100)"
set key
set yrange [-0.5:1.5]
plot 'DataZeros100' index 0 using 1:2 with lines title "Approx",\
	'DataZeros100' index 0 using 1:3 with lines title "Exact"
EOFMarker
# Plot f'(x)
gnuplot -persist <<-EOFMarker
set title "Approximation of f'(x) (x at Zeros, n=100)"
set key
set yrange [-2.5:2.5]
plot 'DataZeros100' index 1 using 1:2 with lines title "Approx",\
	'DataZeros100' index 1 using 1:3 with lines title "Exact"
EOFMarker

# Read the maximal errors.
cat MaximalError.txt
