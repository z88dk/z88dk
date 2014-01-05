*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF __STDIO_PRINTF_X

__stdio_printf_lX:

   ; %lx, %lX converter called from vfprintf()
   ;
   ; enter : ix = FILE *
   ;         hl = void *stack_param
   ;         de = void *buffer_digits
   ;         stack = buffer_digits, width, precision
   ;
   ; exit  : carry set if stream error
   ;
   ; NOTE: (buffer_digits - 3) points at buffer space of three free bytes
