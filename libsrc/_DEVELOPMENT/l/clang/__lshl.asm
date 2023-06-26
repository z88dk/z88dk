
SECTION code_crt_clang


PUBLIC __lshl

EXTERN error_lznc

; iybc << a
__lshl:
   push af
   call impl
   pop af
   ret

impl:
   or a
   ret z

   cp 32
   jp nc, error_lznc

shift_loop:
   sla c
   rr  b
   add iy,iy
   dec a
   jr  nz,shift_loop
   ret
