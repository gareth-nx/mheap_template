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

[The example](example_usage.f90) defines a heap with entries of user-defined type `point2` and default priority function. The priority function `fun(a, b)` returns TRUE if `a` is higher priority than `b`, where both `a` and `b` are of `type(point2)`.
```fortran
module mheap_point2
use nodedata, only: node_data_type=>point2, default_priority_function=>greater_than
implicit none
#include "mheap_template.inc"
end module mheap_point2
```
The above module defines a heap of `type(theap)`. The priority function can be changed on initialisation.

We use the heap like so:
```fortran
use nodedata, only : point2, less_than
use mheap_point2, only: heap_point2 => theap
implicit none

type(heap_point2) :: h
type(point2) :: p
integer :: i

! Setup heap with 10 entries and a non-default priority function. 
! Throw error if we store too many items
call h%init(10, err_if_too_full = .true., priority_function=less_than)

! Add some entries
call h%insert( point2([ 1.0d0, 2.0d0]) )
call h%insert( point2([-1.0d0, 8.0d0]) )
call h%insert( point2([ 5.0d0, 1.0d0]) )
call h%insert( point2([ 2.0d0,-1.0d0]) )

print*, 'Heap size is: ', h%size()

! Add more entries
call h%insert( point2([-6.0d0, 5.0d0]) )
call h%insert( point2([ 3.0d0, 2.0d0]) )

print*, 'New heap size is: ', h%size()

call h%peek(3, p)
print*, 'Peeking at the 3rd entry (without changing the heap) gives: ', p%x

! Return entries in order of priority
do i = 1, h%size()
    call h%pop(p) 
    print*, '  Entry ', i, ' in order: ', p%x, '( norm = ', norm2(p%x), ' )'
end do

! Delete heap data and reset priority function
call h%delete()
```

If the heap is initialised with `err_if_too_full = .false.` (default) then it will ignore insertions once it is full, without warning.
