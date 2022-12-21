# Heap data structure in Fortran

Fortran code to create a [heap data structure](https://en.wikipedia.org/wiki/Heap_(data_structure)#:~:text=In%20computer%20science%2C%20a%20heap,to%20the%20key%20of%20C.) containing a user-defined type with user-defined priority function.

Preprocessing is used to create the heap derived type at compile time.

This was modified by Gareth Davies from [Daniel Pena's mheap
code](https://github.com/trifling/mheap). The latter code supports heap
entries of fixed-size double-precision arrays.

# How to use it

The code [example_usage.f90](example_usage.f90) illustrates how to use it. Compile and run with
```
gfortran -cpp example_usage.f90 -o example_usage
./example_usage
```

[This example](example_usage.f90) defines a heap with entries of user-defined type `point2` (defined in a module `nodedata`). 

We have the derived type `point2` and an associated function `is_higher_priority(a, b)` which returns TRUE if `a` is higher priority than `b` (and `a, b` are of `type(point2)`). 

Then we can create a heap for the `point2` type with the given priority:
```fortran
!
! Module with a heap for our type
!
module mheap_point2
! Create a heap type "theap" that contains data of type(node_data_type)
! We need to define:
!    1. node_data_type
!    2. A logical comparison function is_higher_priority(n1, n2) where n1, n2 are type(node_data_type)
use nodedata, only: node_data_type=>point2, is_higher_priority=>less_than
implicit none

! This includes code to make the type THEAP, 
! using data type(node_data_type) and comparison function "is_higher_priority"
#include "mheap_template.inc"

end module mheap_point2
```
The resulting heap is of `type(theap)`.

We can now use the heap like so:
```fortran
use nodedata, only : point2
use mheap_point2, only: heap_point2 => theap
implicit none

type(heap_point2) :: h
type(point2) :: p
integer :: i

print*, 'Setup heap with specified maximum number of entries -- 10 here'
call h%init(10)

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
print*, 'Peeking at the 3rd entry (without changing the heap) gives: ', p%x

print*, 'Returning entries in order of priority: '
do i = 1, h%size()
    call h%pop(p) 
    print*, '  Entry ', i, ' in order: ', p%x, '( norm = ', norm2(p%x), ' )'
end do

call h%delete()
print*, 'Heap deleted, maximum allowed entries is now = ', h%nmax
```
