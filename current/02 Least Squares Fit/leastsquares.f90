! Linear least squares fit
! Compile with: gfortran -O3 -fdefault-real-8 leastsquares.f90 -llapack
! Run with: ./a.out < Assignment\ #2.dat

program leastsquares
implicit none
real, parameter :: pi = 4.D0*DATAN(1.D0)


! n is TOTAL QUANTITY of basis functions (counting starts at n=0)
integer, parameter :: n = 100
real, allocatable :: A(:,:), B(:), x(:), y(:)
integer nlines


nlines = countlines(7, "Assignment #2.dat")
allocate (A(nlines, n), B(nlines), x(nlines), y(nlines))

call init()
call solve(A, B, nlines, n)
call dump(A, B, nlines, n)


contains


! Count the number of lines in the input file
function countlines(window, filename)
	integer window, io, countlines; character(len=*) :: filename
	countlines = 0; io = 0
	
	open (unit=window, file=filename)
	do while (io==0)
		read (window, *, iostat=io)
		if (io /= 0) exit
		countlines = countlines + 1
	end do 
	close (window)
end function

! Read the input file and populate the matrix A, and vector B
subroutine init()
	integer i, j, io
	io = 0	
	open(unit=10, file="Assignment #2.dat")
	do i = 1,nlines
		read (10, *, iostat=io) x(i), y(i)
		if (io /= 0) exit
		B(i) = y(i)
		A(i,:) = basis(n,x(i))
	end do
	close(10)
end subroutine

! basis functions
pure function basis(n, x)
	integer i, n; real x, basis(n); intent(in) n, x
	do i = 1,n; basis(i) = cos(2.*pi*(i-1.)*x); end do
end function

subroutine solve(A, B, M, N)
	integer M, N, R, io; real A(M,N), B(M), S(N), W(6*M)
	call dgelss(M, N, 1, A, M, B, M, S, 1.e-6, R, W, 6*M, io)
end subroutine

subroutine dump(A, B, nlines, n)
	integer nlines, n, i; real A(nlines, n), B(n), C(nlines), chi2
	
	do i = 1,nlines
		C(i) = sum(basis(n,x(i))*B)
		write (1,*) x(i), y(i), C(i)
	end do
	
	chi2 = sum((y-C)**2)
	write (*,*) 'Chi squared is:', chi2
	write (*,*) 'Reduced Chi squared is:', chi2/(nlines-(n+1))
end subroutine
end program
