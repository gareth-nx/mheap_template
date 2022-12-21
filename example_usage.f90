!
! Using the heap data type
! 

module nodedata
! Define the "type" of data that the heap holds, and 
! a logical function to determine if a < b (where a,b are heap data entries)
implicit none
integer, parameter :: dp = selected_real_kind(12)
! Type held in our heap
type :: point3
    real(dp) :: x(3)     
end type

contains

logical function less_than(a, b)
    type(point3), intent(in) :: a, b
    less_than = norm2(a%x) < norm2(b%x)
end function
end module nodedata

module mheap_point3
! Create a type THEAP containing data of type(NODE_DATA_TYPE)
!
! We need to define NODE_DATA_TYPE, and a logical comparison function IS_LESS_THAN(N1, N2) where
! N1, N2 are of type NODE_DATA_TYPE
use nodedata, only: node_data_type=>point3, is_less_than=>less_than
implicit none

#include "mheap_template.inc"

end module mheap_point3
