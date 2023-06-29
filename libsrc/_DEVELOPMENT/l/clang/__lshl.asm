
SECTION code_l_clang


PUBLIC __lshl


; dehl = iybc << a
__lshl:
   push af
   push iy
   pop  de
   ld   hl,bc
   call impl
   pop af
   ret

impl:
   or a
   ret z

   cp 32
   ret nc
shift_loop:
   sla d
   rl  e
   rl  h
   rl  l
   dec a
   jr  nz,shift_loop
   ret
