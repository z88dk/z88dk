
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_printf_p

EXTERN __stdio_printf_x

__stdio_printf_p:

   ; %p converter called from vfprintf()
   ;
   ; enter : ix = FILE *
   ;         hl = void *stack_param
   ;         de = void *buffer_digits
   ;         stack = buffer_digits, width, precision
   ;
   ; exit  : carry set if stream error

   ; set default precision to four
   
   ld a,(ix+5)                 ; conversion_flags
   srl a
   jr c, precision_defined

   pop bc
   ld bc,4
   push bc

precision_defined:

   scf
   adc a,a                     ; set precision flag
   and $0d                     ; keep 0-HP flags
   ld (ix+5),a
   ld (ix+4),$80               ; capitalize output

   jp __stdio_printf_x

