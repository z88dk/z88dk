
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_scanf_p

EXTERN __stdio_scanf_x

defc __stdio_scanf_p = __stdio_scanf_x

   ; %x, %p converter called from vfscanf()
   ;
   ; enter : ix = FILE *
   ;         de = void *buffer
   ;         bc = field width (0 means default)
   ;         hl = int *p
   ;
   ; exit  : carry set if error
   ;
   ; uses  : all except ix
