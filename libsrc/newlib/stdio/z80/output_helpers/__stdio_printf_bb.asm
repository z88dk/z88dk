
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_printf_bb

EXTERN __stdio_printf_number_tail_uint

__stdio_printf_bb:

   ; non-standard %B converter called from vfprintf()
   ; outputs binary number
   ;
   ; enter : ix = FILE *
   ;         hl = void *stack_param
   ;         de = void *buffer_digits
   ;         stack = buffer_digits, width, precision
   ;
   ; exit  : carry set if stream error
   ;
   ; NOTE: (buffer_digits - 3) points at buffer space of three free bytes

   ld bc,2                     ; base 2 conversion
   jp __stdio_printf_number_tail_uint
