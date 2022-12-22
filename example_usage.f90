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
! Alternative priority functions

logical function less_than(a, b)
    type(point2), intent(in) :: a, b
    less_than = norm2(a%x) < norm2(b%x)
end function

logical function greater_than(a, b)
    type(point2), intent(in) :: a, b
    greater_than = norm2(a%x) > norm2(b%x)
end function

end module nodedata

! Create a heap type "theap" that contains data of type(node_data_type)
! We need to define:
!    1. node_data_type
!    2. The default logical priority function F(n1, n2) with n1, n2 of type(node_data_type)
module mheap_point2
use nodedata, only: node_data_type=>point2, default_priority_function=>less_than
implicit none
#include "mheap_template.inc"
end module mheap_point2

program example_usage_mheap

use nodedata, only : point2, greater_than, less_than
use mheap_point2, only: heap_point2 => theap
implicit none

type(heap_point2) :: h, g
type(point2) :: p
integer :: i

print*, 'Using a heap containing type(point2), with priority determined by the less_than function'

print*, 'Setup heap with 10 entries. Throw error if we try to store too many items'
call h%init(10, err_if_too_full = .true., priority_function = less_than)

print*, 'Add some entries'
call h%insert( point2([ 1.0d0, 2.0d0]) )
call h%insert( point2([-1.0d0, 8.0d0]) )
call h%insert( point2([ 5.0d0, 1.0d0]) )
call h%insert( point2([ 2.0d0,-1.0d0]) )

print*, 'Heap size is: ', h%size()

print*, 'Add more entries'
call h%insert( point2([-6.0d0, 5.0d0]) )
call h%insert( point2([ 3.0d0, 2.0d0]) )

print*, 'New heap size is: ', h%size()

call h%peek(3, p)
print*, 'Peeking at data in the 3rd index (NOT related to the priority) gives: ', p%x

print*, 'Returning entries in order of priority: '
do i = 1, h%size()
    call h%pop(p) 
    print*, '  Entry ', i, ' in order: ', p%x, '( norm = ', norm2(p%x), ' )'
end do

call h%delete()
print*, 'Heap deleted, maximum allowed entries is now = ', h%nmax

print*, 'Repeated addition / removal of points works'
call h%init(5, err_if_too_full = .false.)
do i = 1, 3
    ! This will eventually try to add more than 5 entries.
    ! It would fail if we'd used err_if_too_full = .true.
    print*, i, 'a, heap size: ', h%size()
    call h%insert( point2([ 1.0d0, 2.0d0]) )
    call h%insert( point2([-1.0d0, 8.0d0]) )
    call h%insert( point2([ 5.0d0, 1.0d0]) )
    call h%insert( point2([ 2.0d0,-1.0d0]) )
    print*, i, 'b, heap size: ', h%size()
    call h%pop(p)
    call h%pop(p)
    call h%pop(p)
    print*, i, 'c, heap size: ', h%size()
end do

call h%delete()

print*, 'We can also use different priority functions'
call h%init(2)
call g%init(2, priority_function = greater_than)

call h%insert( point2([ 1.0d0, 2.0d0]) )
call h%insert( point2([-1.0d0, 8.0d0]) )
call g%insert( point2([ 1.0d0, 2.0d0]) )
call g%insert( point2([-1.0d0, 8.0d0]) )

call h%pop(p)
print*, 'With the less_than priority, the first entry is ', p%x
call g%pop(p)
print*, 'With the greater_than priority, the first entry is ', p%x


end program example_usage_mheap
