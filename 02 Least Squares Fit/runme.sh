# Things may not work right out of the box, as bash might not have
# permissions to run this file. The terminal will complain something
# like "./runme.sh: permission denied". If that is the case, please
# enter:
# chmod u+x runme.sh
# in the terminal while in the folder containing runme.sh

# Question 5
gfortran -O3 -fdefault-real-8 LapackLeastSquares.f90 -llapack
./a.out < Assignment\ #2.dat

gnuplot -persist <<-EOFMarker
set title "Least Squares Fit by dgelss() (n = 3)
set key
p'Assignment #2.dat' w d t 'Data', 'fort.3' w l t 'LAPACK Fit'
EOFMarker
