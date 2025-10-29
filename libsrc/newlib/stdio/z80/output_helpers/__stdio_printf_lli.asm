
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_printf_lli

EXTERN __stdio_printf_lld

defc __stdio_printf_lli = __stdio_printf_lld

   ; %lld, %lli converter called from vfprintf()
   ;
   ; enter : ix = FILE *
   ;         hl = void *stack_param
   ;         de = void *buffer_digits
   ;         stack = buffer_digits, width, precision
   ;
   ; exit  : carry set if stream error
   ;
   ; NOTE: (buffer_digits - 3) points at buffer space of three free bytes
