# Things may not work right out of the box, as bash might not have
# permissions to run this file. The terminal will complain something
# like "./runme.sh: permission denied". If that is the case, please
# enter:
# chmod u+x runme.sh
# in the terminal while in the folder containing runme.sh

########################################################################
# question #1
########################################################################

#gfortran -O3 -fdefault-real-8 harmonic-shooter.f90 -o q1.out
#./q2.out 0.4 1.6

# even and odd solution for non eigenvalue E
# second index is first index + (2 initial guesses + 100 iterations)
gnuplot -persist <<-EOFMarker
set terminal pdf
set key on
set xrange [0: 2]
set title "Non-Eigenvalue \"Solutions\""
set output "question1.pdf"
EOFMarker

########################################################################
# question #2
########################################################################

gfortran -O3 -fdefault-real-8 harmonic_shooter.f90 -o q2.out

./q2.out 0.4 1.6
cat fort.4 > Eigenvalues_Boundary_Shooting.txt
cat fort.1 > Harmonic_Shooting.txt

./q2.out 2.4 3.6
cat fort.4 >> Eigenvalues_Boundary_Shooting.txt
cat fort.1 >> Harmonic_Shooting.txt

./q2.out 4.4 5.6
cat fort.4 >> Eigenvalues_Boundary_Shooting.txt
cat fort.1 >> Harmonic_Shooting.txt

./q2.out 6.4 7.6
cat fort.4 >> Eigenvalues_Boundary_Shooting.txt
cat fort.1 >> Harmonic_Shooting.txt

./q2.out 8.4 9.6
cat fort.4 >> Eigenvalues_Boundary_Shooting.txt
cat fort.1 >> Harmonic_Shooting.txt

# plot wave functions for eigenvalues
gnuplot -persist <<-EOFMarker
set terminal pdf
set key on
set title "Harmonic Wave Function"
set output "Harmonic Wave Functions.pdf"
plot 'Harmonic_Shooting.txt' index 0 u 1:2 w l title "0.5",\
	'Harmonic_Shooting.txt' index 1 u 1:2 w l title "1.5",\
	'Harmonic_Shooting.txt' index 2 u 1:2 w l title "2.5",\
	'Harmonic_Shooting.txt' index 3 u 1:2 w l title "3.5",\
	'Harmonic_Shooting.txt' index 4 u 1:2 w l title "4.5",\
	'Harmonic_Shooting.txt' index 5 u 1:2 w l title "5.5",\
	'Harmonic_Shooting.txt' index 6 u 1:2 w l title "6.5",\
	'Harmonic_Shooting.txt' index 7 u 1:2 w l title "7.5",\
	'Harmonic_Shooting.txt' index 8 u 1:2 w l title "8.5",\
	'Harmonic_Shooting.txt' index 9 u 1:2 w l title "9.5"
EOFMarker

# plot normalized probability densities for eigenvalues
gnuplot -persist <<-EOFMarker
set terminal pdf
set key on
set title "Harmonic Probability Density"
set output "Harmonic Probability Density.pdf"
plot 'Harmonic_Shooting.txt' index 0 u 1:3 w l title "0.5",\
	'Harmonic_Shooting.txt' index 1 u 1:3 w l title "1.5",\
	'Harmonic_Shooting.txt' index 2 u 1:3 w l title "2.5",\
	'Harmonic_Shooting.txt' index 3 u 1:3 w l title "3.5",\
	'Harmonic_Shooting.txt' index 4 u 1:3 w l title "4.5",\
	'Harmonic_Shooting.txt' index 5 u 1:3 w l title "5.5",\
	'Harmonic_Shooting.txt' index 6 u 1:3 w l title "6.5",\
	'Harmonic_Shooting.txt' index 7 u 1:3 w l title "7.5",\
	'Harmonic_Shooting.txt' index 8 u 1:3 w l title "8.5",\
	'Harmonic_Shooting.txt' index 9 u 1:3 w l title "9.5"
EOFMarker

########################################################################
# question #3
########################################################################

gfortran -O3 -fdefault-real-8 anharmonic_shooter.f90 -o q3.out

./q3.out 0.3 1.6
cat fort.4 > A_Eigenvalues_Boundary_Shooting.txt
cat fort.1 > A_Harmonic_Shooting.txt

./q3.out 2.9 4.7
cat fort.4 >> A_Eigenvalues_Boundary_Shooting.txt
cat fort.1 >> A_Harmonic_Shooting.txt

./q3.out 6.4 8.5
cat fort.4 >> A_Eigenvalues_Boundary_Shooting.txt
cat fort.1 >> A_Harmonic_Shooting.txt

./q3.out 10.4 12.8
cat fort.4 >> A_Eigenvalues_Boundary_Shooting.txt
cat fort.1 >> A_Harmonic_Shooting.txt

./q3.out 14.9 17.6
cat fort.4 >> A_Eigenvalues_Boundary_Shooting.txt
cat fort.1 >> A_Harmonic_Shooting.txt

# plot wave functions for eigenvalues
gnuplot -persist <<-EOFMarker
set terminal pdf
set key on
set title "Anharmonic Wave Function"
set output "Anharmonic Wave Functions.pdf"
plot 'A_Harmonic_Shooting.txt' index 0 u 1:2 w l title "0.42",\
	'A_Harmonic_Shooting.txt' index 1 u 1:2 w l title "1.51",\
	'A_Harmonic_Shooting.txt' index 2 u 1:2 w l title "2.96",\
	'A_Harmonic_Shooting.txt' index 3 u 1:2 w l title "4.45",\
	'A_Harmonic_Shooting.txt' index 4 u 1:2 w l title "6.45",\
	'A_Harmonic_Shooting.txt' index 5 u 1:2 w l title "8.43",\
	'A_Harmonic_Shooting.txt' index 6 u 1:2 w l title "10.53",\
	'A_Harmonic_Shooting.txt' index 7 u 1:2 w l title "12.74",\
	'A_Harmonic_Shooting.txt' index 8 u 1:2 w l title "15.05",\
	'A_Harmonic_Shooting.txt' index 9 u 1:2 w l title "17.45"
EOFMarker

# plot normalized probability densities for eigenvalues
gnuplot -persist <<-EOFMarker
set terminal pdf
set key on
set title "Anharmonic Probability Density"
set output "Anharmonic Probability Density.pdf"
plot 'A_Harmonic_Shooting.txt' index 0 u 1:3 w l title "0.42",\
	'A_Harmonic_Shooting.txt' index 1 u 1:3 w l title "1.55",\
	'A_Harmonic_Shooting.txt' index 2 u 1:3 w l title "2.96",\
	'A_Harmonic_Shooting.txt' index 3 u 1:3 w l title "4.45",\
	'A_Harmonic_Shooting.txt' index 4 u 1:3 w l title "6.45",\
	'A_Harmonic_Shooting.txt' index 5 u 1:3 w l title "8.43",\
	'A_Harmonic_Shooting.txt' index 6 u 1:3 w l title "10.53",\
	'A_Harmonic_Shooting.txt' index 7 u 1:3 w l title "12.74",\
	'A_Harmonic_Shooting.txt' index 8 u 1:3 w l title "15.05",\
	'A_Harmonic_Shooting.txt' index 9 u 1:3 w l title "17.45"
EOFMarker

