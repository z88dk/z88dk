
XLIB __stdio_scanf_lp

LIB __stdio_scanf_lx

defc __stdio_scanf_lp = __stdio_scanf_lx

   ; %lx, %lp converter called from vfscanf()
   ;
   ; enter : ix = FILE *
   ;         de = void *buffer
   ;         bc = field width (0 means default)
   ;         hl = unsigned long *p
   ;
   ; exit  : carry set if error
   ;
   ; uses  : all except ix
