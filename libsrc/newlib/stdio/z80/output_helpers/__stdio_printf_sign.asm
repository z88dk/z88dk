
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_printf_sign, __stdio_printf_sign_0

__stdio_printf_sign:

   ; write sign to buffer
   ;
   ; enter : ix = FILE *
   ;         hl = char *buffer
   ;
   ; exit  : ix = FILE *
   ;         hl = char *buffer (where to write next char)
   ;
   ; uses  : af, hl
   
   ld a,(ix+5)                 ; a = conversion flags "N+ #0-?P"

__stdio_printf_sign_0:

   add a,a
   jr nc, not_negative
   
   ; number is negative
   
   ld (hl),'-'                 ; write negative sign to buffer
   inc hl
   
   ret

not_negative:

   add a,a
   jr nc, not_plus
   
   ; '+' flag
   
   ld (hl),'+'                 ; write positive sign to buffer
   inc hl
   
   ret

not_plus:

   add a,a
   ret nc
   
   ; ' ' flag
   
   ld (hl),' '                 ; write space to buffer
   inc hl
   
   ret
