! golden.f90 - find a bracketed minima by bisection assuming a < c
! I think this could be made better by using the derivative of the function
! but I decided that using the derivative is kind of cheating as one of
! the benefits of this method is that we don't need to know too much about
! the function we're trying to find minima of. As long as initial guesses
! are good (don't fall into a separate minima), everything is fine
! compile with: gfortran -O3 -fdefault-real-8 golden.f90

program golden
implicit none

! tolerance for interval length
real, parameter :: epsilon = 1.0e-14

! expected number of roots
integer, parameter :: n = 2

real a, b, c, d, fa, fb, fc, fd
integer i, counter
real, dimension(n) :: left, right, minima

! initial interval guesses
left = (/-2.0, 1.5/)
right = (/-1.0, 0.0/)

do i = 1,n
	! set up initial conditions, saving the user if boundaries are backwards
	a = left(i); fa = f(a)
	c = right(i); fc = f(c)
	
	! safety features
	if (fa < fc) then
		c = left(i); fc = f(c)
		a = right(i); fa = f(a)
	end if
	b = (a + c)/1.9; fb=f(b)
	
	counter = 0
	
	! bisect the interval
	do while (abs(c-a) > epsilon)
		call bisect (a, b, c, d, fa, fb, fc, fd)
		
		if (fd == 0) then
			write (*,*) d, fd
			minima(i) = d
			b = d
			stop	
		end if
		
		minima(i) = b
		
		write (*,*) b, fb
		
		counter = counter + 1
		if (counter > 1000) stop "Not gonna make it bro..."
	end do
	write (*,*) ""
	write (*,*) ""
end do

write (*,*) "Minima position         Minima value"
do i = 1,n
write (*,*) minima(i), f(minima(i))
end do

contains

! finds a minimum between a and c
! assumes that a < c
! destroys original inputs
subroutine bisect (a, b, c, d, fa, fb, fc, fd)
	real a, b, c, d, fa, fb, fc, fd
	if (abs(c-b) > abs(a-b)) then
		d = (b+c)/2.0
		fd = f(d)
		if (fd > fb ) then
			c = d; fc = fd
		else
			a = b; fa = fb
			b = d; fb = fd
		end if
	else
		d = (a+b)/2.0
		fd = f(d)
		if (fd > fb) then
			a = d; fa = fd
		else
			c = b; fc = fb
			b = d; fb = fd
		end if
	end if
end subroutine

! function to find a root of
pure function f(x); intent(in) x
	real f, x
	f = (x**2 - 1)**2 + x
end function
		
end program
