! fibonacci.f90
! calculate the first n fibonacci numbers
! compile with: gfortran -O3 -fdefault-integer-8 fibonacci.f90

program fibonacci
implicit none

integer, parameter :: n = 50
integer f(n), i

f(1) = 1; f(2) = 1

do i = 1, n
	if (i .GT. 2) f(i) = f(i-1) + f(i-2)
	write (*,*) i, f(i)
end do

end program
