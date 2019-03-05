# Things may not work right out of the box, as bash might not have
# permissions to run this file. The terminal will complain something
# like "./runme.sh: permission denied". If that is the case, please
# enter:
# chmod u+x runme.sh
# in the terminal while in the folder containing runme.sh

# Answer question 1
gfortran -O3 -fdefault-real-8 newton.f90
./a.out > Newton.txt
xdg-open Newton.txt

#Answer questions 2 and 3
gfortran -O3 -fdefault-real-8 golden.f90
./a.out > Golden.txt
xdg-open Golden.txt

#Answer questions 4 and 5
gfortran -O3 -fdefault-real-8 goldenfit.f90
./a.out >GoldenFit.txt < Assignment\ #2.dat
mv fort.1 GoldenFit.dat
xdg-open GoldenFit.txt

gnuplot -persist <<-EOFMarker
set terminal pdf
set title "Golden Bisection Fit (n = 3)
set key
set output "GoldenBisection.pdf"
p 'Assignment #2.dat' w d t 'Data', 'GoldenFit.dat' w l t 'Fit'
EOFMarker
xdg-open GoldenBisection.pdf
