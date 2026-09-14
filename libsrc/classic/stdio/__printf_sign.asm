; Classic printf-side sign writer for the stdlib dtoa engine.
;
; The stdlib __dtoa_print() (dtoa/dtoe/dtog output) writes the leading sign
; through __stdio_printf_sign_0(), which the newlib stdio provides but the
; classic stdio never did -- so classic links of the dtoa engine (now used
; by the classic math32 ftoa/ftoe/ftog) failed on an unresolved symbol.
;
; enter : a = flags byte (bit 7 = negative, bit 6 = '+', bit 5 = ' ')
;         hl = char *buffer
;
; exit  : hl = char *buffer (where to write next char)
;
; uses  : af, hl

SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_printf_sign_0

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
