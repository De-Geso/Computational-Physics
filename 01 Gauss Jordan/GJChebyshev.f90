! Compile with: gfortran -O3 -fdefault-real-8 GJChebyshev.f90

program GaussJordanLinearChebyshev
implicit none

integer, parameter :: n = 100
real x(n), y(n,n), Exact(n), Coefficients(n), Approx
!real xPrime(n), yPrime(n,n), ExactPrime(n), CoefficientsPrime (n),;
!	ApproxPrime
integer i, j, k, l, m

forall (i=1:n)
	x(i) = (2.0*i-n-1.0)/(n-1.0)
!	xPrime(n) = (2.0*i-n-1.0)/(n-1.0)
	Exact(i) = (1.0+10.0*x(i)**2.0)**(-1.0)
!	ExactPrime(i) = -20.0*x(i)/(1.0+10.0*x(i)**2.0)**(2.0)
end forall

do j=1,n
	do k=1,n
		y(k,j) = ChebyshevT(x(j), k)
!		yPrime(k,j)
	end do
end do

call GaussJordan (n, y, Exact, Coefficients)

do l=1,n
	Approx = 0
	do m=1,n
		Approx = Approx + Coefficients(m) * y(m,l)
	end do
	write (*,*) x(l), Approx, Exact(l)
end do
write (*,*) ""

contains

! Solve Ax = B using Gauss-Jordan elimination
! A gets destroyed, answer will be returned in B
recursive subroutine GaussJordan (n, A, B, Coefficients)
	integer n, i, j, k, l
	real A(n,n), B(n), C(n,n), D(n), Coefficients(n)
	integer row(n), pivot(1)
	forall (i = 1:n) row(i) = i
	! Conserve original matrices
	C = A
	D = B
	
	do j = 1,n-1
		! If the largest number in the column is zero, go next.
		if (maxval(abs(C(j, row(j:)))) + (j-1) /= 0) then
			pivot = maxloc(abs(C(j, row(j:)))) + (j-1)
			
			row([j,pivot]) = row([pivot,j])
	
			! Kill column. D first or we eliminate the element we're
			! using to kill everything.
			do i = j+1,n
				D(row(i)) = D(row(i)) - &
					(C(j,row(i))/C(j,row(j))) * D(row(j))
				C(:,row(i)) = C(:,row(i)) - &
					(C(j,row(i))/C(j,row(j))) * C(:,row(j))
			end do
		end if
	end do
	
	Coefficients(n) = D(row(n))/C(n,row(n))
	do k = n-1,1,-1
		Coefficients(k) = D(row(k))
		do l = k+1,n
			Coefficients(k) = Coefficients(k) - &
				C(l,row(k))*Coefficients(l)
		end do
		Coefficients(k) = Coefficients(k)/C(k,row(k))
	end do
	
	return
end subroutine

! Chebyshev polynomial T_n(x)
elemental function ChebyshevT(x, n)
	real ChebyshevT, x; integer n
	intent(in) x, n
	
	ChebyshevT = cos(n*acos(x))
end function

end program
