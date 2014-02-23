
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF __STDIO_SCANF_X

__stdio_scanf_p:

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
