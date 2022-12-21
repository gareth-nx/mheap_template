!
! Using the heap data type
! 

module nodedata
! To use the heap we define two things:
! 1) the "type" of data that the heap holds
! 2) a logical function to determine if a < b (where a,b are heap data entries)
!
! In practical applications, these things may already be defined elsewhere in your program
! But for this test we create them
implicit none
integer, parameter :: dp = selected_real_kind(12)

! Type held in our heap
type :: point2
    real(dp) :: x(2)     
end type

contains

! Function used in the heap to determine if a<b
logical function less_than(a, b)
    type(point2), intent(in) :: a, b
    less_than = norm2(a%x) < norm2(b%x)
end function

end module nodedata

!
! Use of the template here
!
module mheap_point2
! Create a heap type "theap" that contains data of type(node_data_type)
! We need to define:
!    1. node_data_type
!    2. A logical comparison function is_less_than(n1, n2) where n1, n2 are type(node_data_type)
use nodedata, only: node_data_type=>point2, is_less_than=>less_than
implicit none

! This includes code to make the type THEAP, 
! using data type(node_data_type) and comparison function "is_less_than"
#include "mheap_template.inc"

end module mheap_point2

program example_usage_mheap
    use nodedata, only : point2
    use mheap_point2, only: heap_point2 => theap
    implicit none

    type(heap_point2) :: h
    type(point2) :: p
    integer :: i
   
    ! Setup heap with specified size -- 10 here.
    call h%init(10)

    ! Add some entries
    call h%insert( point2([ 1.0d0, 2.0d0]) )
    call h%insert( point2([-1.0d0, 8.0d0]) )
    call h%insert( point2([ 5.0d0, 1.0d0]) )
    call h%insert( point2([ 2.0d0,-1.0d0]) )

    ! How many entries?
    print*, 'Heap size is: ', h%size()

    ! Add some more
    call h%insert( point2([-6.0d0, 5.0d0]) )
    call h%insert( point2([ 3.0d0, 2.0d0]) )

    ! How many entries?
    print*, 'New heap size is: ', h%size()

    ! Peek at an entry
    call h%peek(3, p)
    print*, 'Peeking at the 3rd entry (without changing the heap) gives: ', p%x

    do i = 1, h%size()
       call h%pop(p) 
       print*, 'Entry ', i, ' in order: ', p%x, '( norm = ', norm2(p%x), ' )'
   end do

   ! Cleanup
   call h%delete()
   print*, 'Heap deleted, maximum allowed entries is now = ', h%nmax

end program example_usage_mheap
