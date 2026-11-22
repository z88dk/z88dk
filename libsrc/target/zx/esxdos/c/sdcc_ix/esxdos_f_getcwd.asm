; int esxdos_f_getcwd(uchar drive, void *buf)

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_f_getcwd

EXTERN _esxdos_f_getcwd_fastcall

_esxdos_f_getcwd:

   pop af
   pop hl

   push hl
   push af

   jp _esxdos_f_getcwd_fastcall
