! Compile with: gfortran -O3 -fdefault-real-8 GJGeneral.f90

program GaussianJordanian
implicit none

! Parameters for question #1
integer, parameter :: n = 3
real A(n,n), B(n)

! Test and make sure that the Gauss-Jordan Elimination works.
! Matrix to invert
A(1,:) = [1.0, 3.0, 0.0]
A(2,:) = [2.0, 2.0, 1.0]
A(3,:) = [3.0, 1.0, 0.0]

B = [1.0, 2.0, 3.0]

call GaussJordan (n, A, B)

contains

! Solve Ax = B using Gauss-Jordan elimination
! A gets destroyed, answer will be returned in B
recursive subroutine GaussJordan (n, A, B)
	integer n, i, j, k, l; real A(n,n), B(n), x(n)
	
	! Pivot indices
	integer row(n), col(n), pivot(1)
	forall (i = 1:n) row(i) = i
	forall (j = 1:n) col(j) = j
	! col is superfluous, decided not to implement complete pivot
	
!	Show original matrix to track changes
!	write (*,*) A(:,row(:))
!	write (*,*) ""
!	write (*,*) B(row(:))
!	write (*,*) ""
!	write (*,*) ""
	
	do j = 1,n-1
		! If the largest number in the column is zero, go next.
		if (maxval(abs(A(j, row(j:)))) + (j-1) /= 0) then
			pivot = maxloc(abs(A(j, row(j:)))) + (j-1)
			
			! Swap rows
			row([j,pivot]) = row([pivot,j])
	
			! Kill column. B first or we eliminate the element we're
			! using to kill everything.
			do i = j+1,n
				B(row(i)) = B(row(i)) - &
					(A(j,row(i))/A(j,row(j))) * B(row(j))
				A(:,row(i)) = A(:,row(i)) - &
					(A(j,row(i))/A(j,row(j))) * A(:,row(j))
		
! See if the right operation was performed
!				write (*,*) A(:,row(:))
!				write (*,*) ""
!				write (*,*) B(row(:))
!				write (*,*) ""
!				write (*,*) ""
			end do
		end if
	end do
	
	! Back substitute to solve for x
	x(n) = B(row(n))/A(n,row(n))
	do k = n-1,1,-1
		x(k) = B(row(k))
		do l = k+1,n
			x(k) = x(k) - A(l,row(k))*x(l)
		end do
		x(k) = x(k)/A(k,row(k))
	end do
	write (*,*) "x =", x
	
	return
end subroutine

end program
