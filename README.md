Fortran code to create a heap data structure containing a user-defined type, using the preprocessor.

This was modified by Gareth Davies from [Daniel Pena's mheap
code](https://github.com/trifling/mheap). The latter code supports heap
entries of fixed-size double-precision arrays.

# How to use it

The code [example_usage.f90](example_usage.f90) illustrates how to use it. It can be compiled with
```
gfortran -cpp example_usage.f90 -o example_usage
./example_usage
```

It defines a heap with entries of user-defined type `point2` (defined in a module `nodedata`). We then create a heap for the `point2` derived type like so:
```fortran
!
! Module with a heap for our type
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
```
The resulting heap is of `type(theap)`.

We can now use the heap like so:
```fortran
use nodedata, only : point2
use mheap_point2, only: heap_point3 => theap
implicit none
type(heap_point3) :: h
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
```
