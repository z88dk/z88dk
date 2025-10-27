; int esxdos_f_chdir(void *path)

SECTION code_clib
SECTION code_esxdos

PUBLIC _esxdos_f_chdir

EXTERN _esxdos_f_chdir_fastcall

_esxdos_f_chdir:

   pop af
   pop hl

   push hl
   push af

   jp _esxdos_f_chdir_fastcall
