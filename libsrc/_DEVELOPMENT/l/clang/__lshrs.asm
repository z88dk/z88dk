
SECTION code_l_clang


PUBLIC __lshrs


; iybc >> a
__lshrs:
   push af
   push iy
   ex (sp),hl
   call impl
   ex (sp),hl
   pop iy
   pop af
   ret

impl:
   or a
   ret z

   cp 32
   ret nc

shift_loop:
   sra h
   rr l
   rr b
   rr c
   dec a
   jr  nz,shift_loop
   ret
