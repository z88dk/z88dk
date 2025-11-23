; int esxdos_f_close(uchar handle)

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_f_close

EXTERN _esxdos_f_close_fastcall

_esxdos_f_close:

   pop af
   pop hl
   
   push hl
   push af
   
   jp _esxdos_f_close_fastcall
