! Copyright (c) 2014, Daniel Pena 
! All rights reserved.
!

! Redistribution and use in source and binary forms, with or without
! modification, are permitted provided that the following conditions are met:

! 1. Redistributions of source code must retain the above copyright notice, this
! list of conditions and the following disclaimer.
! 2. Redistributions in binary form must reproduce the above copyright notice,
! this list of conditions and the following disclaimer in the documentation
! and/or other materials provided with the distribution.

! THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
! ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
! WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
! DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
! ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
! (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
! LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
! ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
! (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
! SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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
