! compile with: gfortran -O3 -fdefault-real-8 levenberg.f90 -llapack && ./a.out < Assignment\ #2.dat
program LevenbergMarquardt
implicit none

! number of basis functions
integer, parameter :: n = 4
integer, parameter :: l = 9130
real, parameter :: pi = 4.D0*DATAN(1.D0)
real, parameter :: epsilon = 0.1
real :: lambda = 0.001

real x(l), y(l), U(n), chi0, chi

integer i, j, counter
integer :: status = 0

! initial guess for coefficients
U = (/-1.0, 4.0, 2.0, 0.7/)
! initial assignment of chi to start loop
chi = 1.0; chi0 = chi + 2*epsilon

! open the data file we want to use
open (unit=2, file="Assignment #2.dat")
call xy
call dxdy

counter = 0
do while (abs(chi0-chi) > epsilon)
	chi = chisq (x, y, U, n, l)
	write (*,*) chi
	
!	U = U - matmul(invertnxn(regular(ddf(U), 0.1)), df(U))*dt
	
	if (counter > 10) stop "Taking too long"
	counter = counter + 1
end do

contains

! get data out of file and into vectors
subroutine xy
	integer i
	
	! make sure everything is FRESH
	status = 0; rewind (2)
	do i = 1, l
		read (*,*,iostat=status) x(i), y(i)
		if (status < 0) exit
	end do
end subroutine

! compute approximate derivative
subroutine dxdy
	real dx(l-1), dy(l-2)
	integer i
	
	do i = 1, l-1
		dy(i) = (y(i+1)-y(i))/(x(i+1)-x(i))
		dx(i) = (x(i+1)+x(i))/2
	end do
end subroutine

! compute chi squared for given parameters
real function chisq(x, y, U, n, l)
	integer n, l, i; real x(l), y(l), U(n)
	
	chisq = 0.0
	do i = 1,l
		chisq = chisq + (y(i) - f(x(i), U, n))**2.0
	end do
end function
	
! Evaluate the approximation at a certain x value
real function f(x, U, n)
	integer i, n;	real x, U(n)
	f = 0
	do i = 1,n
		f = f + cos(2.0*pi*(i-1.0)*x)*U(i)
	end do
	return
end function

! regularize matrix for inversion
pure function regular(M, lambda); intent(in) M, lambda
	real regular(n,n), M(n,n), lambda; integer i
	
	regular = M; forall (i=1:n) regular(i,i) = (1.0+lambda)*M(i,i)
end function

! invert nxn matrix
function invertnxn(A, n); real, intent(in) :: A
	real invertnxn (n, n), inverse (n, n)
	real work (n)	! array for LAPACK to eat
	real pivot (n)	! pivot indices
	integer :: n, info
	
	external DGETRF
	external DGETRI
	
	inverse = A
	
	call DGETRF (n, n, inverse, n, pivot, info)
	
	if (info /= 0) then
		stop "Matrix is singular"
	end if
	
	call DGETRI (n, inverse, n, pivot, work, n, info)
	
	if (info /= 0) then
		stop "Matrix inversion failed"
	end if
	
	invertnxn = inverse
end function

end program
