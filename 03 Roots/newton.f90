! newton.f90  -  find a root by Newton's method
! compile with: gfortran -O3 -fdefault-real-8 newton.f90

program newton
implicit none

! number of roots expected
integer, parameter :: n = 3

real x(n)
integer i, j

! initial guess for roots
x = (/-1.0, 0.0, 1.0/)

! Newton's iteration
do i = 1,n
	do j = 1,8
		x(i) = x(i) - f(x(i))/df(x(i))
		write (*,*) x(i), f(x(i))
	end do
	write (*,*) ""
	write (*,*) ""
end do

write (*,*) "There are roots at:", x

contains

! function to find a root of
pure function f(x); intent(in) x
	real f, x
	f = x**3 - x + 0.25
end function

! derivative of a function to find a root of
pure function df(x); intent(in) x
	real df, x
	df = 3*x**2 - 1
end function

end program
