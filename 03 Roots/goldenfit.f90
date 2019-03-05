! goldenfit.f90 - find the best fit parameters by minimizing chi squared
!  using the bisection method. i.e. find bracketed minima
! compile with: gfortran -O3 -fdefault-real-8 goldenfit.f90 && ./a.out < Assignment\ #2.dat
program goldenfit
implicit none

real, parameter :: pi = 4.D0*DATAN(1.D0)
! tolerance for interval length
real, parameter :: epsilon = 1.0e-14
! expected number of roots
integer, parameter :: n = 4
! length of file
integer, parameter :: l = 9130

integer :: status = 0

real x(l), y(l)
real chimin, chimax, chimid, chinew
integer i, counter
real, dimension(n) :: min, max, minima, Unew
real, dimension(3,n) :: U

! initial interval guesses, min < max
min = [-1.5, 3.9, 1.7, 0.4]
max = [-0.9, 4.5, 2.3, 1.0]

U(1, :) = min
U(3, :) = max
U(2, :) = (max+min)/2.0

! open the data file we want to use
open (unit=2, file="Assignment #2.dat")

call xy

chimin = chisq(x, y, U(:,1), n, l)
chimid = chisq(x, y, U(:,2), n, l)
chimax = chisq(x, y, U(:,3), n, l)

counter = 0
do while (abs(U(1,1) - U(3,1)) > epsilon .or. &
	abs(U(1,2) - U(3,2)) > epsilon .or. &
	abs(U(1,3) - U(3,3)) > epsilon .or. &
	abs(U(1,4) - U(3,4)) > epsilon)
	
	call bisect
	
	counter = counter + 1
	if (counter > 1000) stop ":("
end do

write(*,*) "Best fit parameters are:", U(2,:)
call dump(U(2,:))

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

! finds a minimum value between Umin and Umax
! assumes that Umin < Umax
! destroys original inputs
subroutine bisect
	if (abs(chimax-chimid) > abs(chimin-chimid)) then
		Unew = (U(3,:) + U(2,:))/2.0
		chinew = chisq(x, y, Unew, n, l)
		if (chinew > chimid) then
			U(3,:) = Unew; chimax = chinew
		else
			U(1,:) = U(2,:); chimin = chimid
			U(2,:) = Unew; chimid = chinew
		end if
	else
		Unew = (U(1,:) + U(2,:))/2.0
		chinew = chisq(x, y, Unew, n, l)
		if (chinew > chimid) then
			U(1,:) = Unew; chimin = chinew
		else
			U(3,:) = U(2,:); chimax = chimid
			U(2,:) = Unew; chimid = chinew
		end if
	end if
end subroutine

! Write results of fit
subroutine dump (V)
	real V(n); integer i
	
	do i = 1,l
		write (1,*) x(i), f(x(i), V, n)
	end do
end subroutine

! compute chi squared for given parameters
real function chisq(x, y, U, n, l)
	integer n, l, i, j
	real x(l), y(l), U(n)
	
	chisq = 0.0
	do i = 1,l
		chisq = chisq + (y(i) - f(x(i), U, n))**2.0
	end do
end function

real function f(x, U, n)
	integer i, n;	real x, U(n)
	f = 0
	do i = 1,n
		f = f + cos(2.0*pi*(i-1.0)*x)*U(i)
	end do
	return
end function

end program
