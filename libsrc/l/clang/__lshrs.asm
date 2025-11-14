
SECTION code_l_clang


PUBLIC __lshrs


; dehl = iybc >> a
__lshrs:
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
   sra d
   rr e
   rr h
   rr l
   dec a
   jr  nz,shift_loop
   ret
