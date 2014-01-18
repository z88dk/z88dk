
XLIB __stdio_printf_b

LIB __stdio_printf_number_tail_uint

__stdio_printf_b:

   ; %b converter called from vfprintf()
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
