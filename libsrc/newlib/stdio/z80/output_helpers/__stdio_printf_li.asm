
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_printf_li

EXTERN __stdio_printf_ld

defc __stdio_printf_li = __stdio_printf_ld

   ; %ld, %li converter called from vfprintf()
   ;
   ; enter : ix = FILE *
   ;         hl = void *stack_param
   ;         de = void *buffer_digits
   ;         stack = buffer_digits, width, precision
   ;
   ; exit  : carry set if stream error
   ;
   ; NOTE: (buffer_digits - 3) points at buffer space of three free bytes
