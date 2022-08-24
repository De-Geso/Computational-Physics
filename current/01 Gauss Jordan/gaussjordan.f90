! gaussjordan.f90
! calculate the first n fibonacci numbers
! compile with: gfortran -O3 -fdefault-real-8 gaussjordan.f90 -llapack

program gaussjordan
implicit none

real, parameter :: pi = 4.D0*DATAN(1.D0)
integer, parameter :: n = 100, m = 1001
real x(n)	! function evaluated at these points
real v(n)	! value of function f(x) at these points
real B(n,n)	! value of j-th basis function at point x(i)

integer i

x = zeros(n)
v = f(x)

! Evaluate basis at grid points
do i = 1,n; B(i,:) = basis(n,x(i)); end do

call solve(B, v, n)
call dump(m)


contains


! Spaces x uniformly
pure function uniform(n)
	integer n, i; real uniform(n); intent(in) n
	do i = 1,n; uniform(i) = 2.*(i-1.)/(n-1.) - 1.; end do
end function

! Spaces x at the zeros of the Chebyshev polynomials
pure function zeros(n)
	integer n, i; real zeros(n); intent(in) n
	do i = 1,n; zeros(i) = cos(pi/n*(i-0.5)); end do
end function

! Function to be approximated
elemental function f(x)
	real f, x; intent(in) x
	f = 1./(1. + 10.*x*x)
end function

! Derivative to be approximated
elemental function df(x)
	real df, x; intent(in) x
	df = -20.*x/(1. + 10.*x*x)**2
end function

! Chebyshev polynomial basis
pure function basis(n, x)
	integer i, n; real x, basis(n); intent(in) n, x	
	do i = 1,n; basis(i) = cos((i-1.)*acos(x)); end do
end function

! Derivative of Chebyshev polynomial basis
pure function dbasis(n, x)
	integer i, n; real x, dbasis(n); intent(in) n, x	
	do i = 1,n; dbasis(i) = (i-1.)*sin((i-1.)*acos(x))/sin(acos(x)); end do
end function

! Solve by Gauss-Legendre
subroutine solve(A, B, n)
	integer n, pivot(n), status
	real A(n,n), B(n)
	status = 0
	call dgesv(n, 1, A, n, pivot, B, n, status)
	if (status /= 0) call abort
end subroutine

subroutine dump(m)
	integer m
	real x(m), approx, er, ermax(2), dapprox, der, dermax(2)
	x = uniform(m)

	ermax = 0.0
	do i = 1,m
		! function calculations
		approx = sum(basis(n,x(i))*v)
		er = abs(approx - f(x(i)))
		! track maximal error
		if (er > ermax(2)) then
			ermax(1) = x(i); ermax(2) = er
		end if
		write (1,*) x(i), f(x(i)), approx, er
	end do
	write (*,*) 'Maximal error in function is:', ermax

	dermax = 0.0
	do i = 2,m-1
		! derivative calculations
		dapprox = sum(dbasis(n,x(i))*v)
		der = abs(dapprox - df(x(i)))
		! track maximal error in deriative
		if (der > dermax(2)) then
			dermax(1) = x(i); dermax(2) = der
		end if
		write (2,*) x(i), df(x(i)), dapprox, der
	end do
	write (*,*) 'Maximal error in derivative is:', dermax
end subroutine

end program
