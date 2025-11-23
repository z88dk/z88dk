; int esxdos_f_close(uchar handle)

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_f_close_fastcall

EXTERN asm_esxdos_f_close

_esxdos_f_close_fastcall:

   push iy
   
   call asm_esxdos_f_close
   
   pop iy
   ret
