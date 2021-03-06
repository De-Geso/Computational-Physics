! Approximate the function f(x)=(1+10*x^2)^-1 and its derivative using
! Chebyshev polyomials up to the 10th order. Coefficients are found
! using Gauss Jordan elimination to solve Ax=B, where x are the zeros
! of the maximum order Chebyshev polynomial.
! Compile with: gfortran -O3 -fdefault-real-8 GJChebyshevZeros10.f90

program GJChebyshevZeros10
implicit none

integer, parameter :: n = 10, p = 10000
real(16), parameter :: pi = 4*atan(1.0_16)
! Original Function Parameters
real x(n), y(n,n), Exact(n), Coefficients(n), Approx
! Derivative Parameters
real xP(n-1), yP(n-1,n-1), ExactP(n-1), CoefficientsP(n-1), &
	ApproxP
! Fine Grid Parameters (original)
real xF(p), ApproxF, ExactF(p), DiffF, LocF
! Fine Grid Parameters (derivative)
real xFP(p-1), ApproxFP, ExactFP(p-1), DiffFP, LocFP
! Counters
integer i, j, k, l, m, q

! Make the initial x range, and the exact values of the function
forall (i=1:n)
	x(i) = cos(pi/(n)*(i-1.0/2.0))
	Exact(i) = (1.0+10.0*x(i)**2.0)**(-1.0)
end forall

forall (i=1:n-1)
	ExactP(i) = (Exact(i+1)-Exact(i))/(x(i+1)-x(i))
	xP(i) = (x(i+1)+x(i))/2.0
end forall

! Make the matrix to be solved by Gauss Jordan
! x position changes down a column, chebyshev order changes across a
! row
do j=1,n
	do k=1,n
		y(k,j) = ChebyshevT(x(j), k-1)
	end do
end do

do j=1,n-1
	do k=1,n-1
		yP(k,j) = ChebyshevT(xP(j),k-1)
	end do
end do

! Solve the matrices
call GaussJordan (n, y, Exact, Coefficients)
call GaussJordan (n-1, yP, ExactP, CoefficientsP)

!Make a much finer grid
forall (q=1:p)
	xF(q) = cos(pi/(p)*(q-1.0/2.0))
	ExactF(q) = (1.0+10.0*xF(q)**2.0)**(-1.0)
end forall

forall (q=1:p-1)
	ExactFP(q) = (ExactF(q+1)-ExactF(q))/(xF(q+1)-xF(q))
	xFP(q) = (xF(q+1)+xF(q))/2.0
end forall

! Use coefficients and Chebyshev polynomials to approximate function
do l=1,p
	ApproxF = 0
	do m=1,n
		ApproxF = ApproxF + Coefficients(m) * &
			ChebyshevT(xF(l),m-1)
	end do
	! Record function's maximal error, and its position
	if (abs(DiffF) < abs(ExactF(l)-ApproxF)) then
		LocF = xF(l)
		DiffF = ExactF(l)-ApproxF
	end if
	write(*,*) xF(l), ApproxF, ExactF(l)
end do

write(*,*) ""
write(*,*) ""

! Use coefficients and Chebyshev polynomials to approximate derivative
do l=1,p-1
	ApproxFP = 0
	do m=1,n-1
		ApproxFP = ApproxFP + CoefficientsP(m) * &
			ChebyshevT(xFP(l),m-1)
	end do
	! Record derivative's maximal error, and its position
	if (abs(DiffFP) < abs(ExactFP(l)-ApproxFP)) then
		LocFP = xFP(l)
		DiffFP = ExactFP(l)-ApproxFP
	end if
	write(*,*) xFP(l), ApproxFP, ExactFP(l)
end do

write(*,*) ""
write(*,*) ""

write(*,*) "For x at zeros, n=10"
write(*,*) "Maximal error in approximation of function is:", &
	DiffF, "occuring at x =", LocF
write(*,*) "Maximal error in approximation of derivative is:", &
	DiffFP, "occuring at x =", LocFP
write(*,*) ""

contains

! Solve Ax = B using Gauss-Jordan elimination
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
	
	! Back substitute to solve for coefficients
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
