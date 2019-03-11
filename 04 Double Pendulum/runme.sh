# Things may not work right out of the box, as bash might not have
# permissions to run this file. The terminal will complain something
# like "./runme.sh: permission denied". If that is the case, please
# enter:
# chmod u+x runme.sh
# in the terminal while in the folder containing runme.sh

# answer question #2
gfortran -O3 -fdefault-real-8 double_pendulum.f90 -o question2.out
./question2.out > data2
mv fort.1 data2
mv fort.2 animation2

# plot energy conservation
gnuplot -persist <<-EOFMarker
set terminal pdf
set key off
set xlabel "Time (s)"
set title "Energy Conservation"
set output "Energy Conservation.pdf"
p 'data2' u 1:4 w l
EOFMarker

# plot trajectory of the end of the pendulum
gnuplot -persist <<-EOFMarker
set terminal pdf
set key off
set xlabel "x position (m)"
set ylabel "y position (m)"
set title "Tip Trajectory"
set output "Tip Trajectory.pdf"
p 'data2' u 2:3 w l
EOFMarker

# if you'd like the animation feel free to go in gnuplot and enter
# load 'animatedDP.gpl'
# The framerate sucked on my machine tbh, and the only way to escape is
# to close the terminal. I'd suggest opening a new tab, then closing the
# old one, so that you're still in the same convinient spot. It's pretty
# satisfying to watch regardless.

# answer question #3
