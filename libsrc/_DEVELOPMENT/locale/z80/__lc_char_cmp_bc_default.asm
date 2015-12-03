
SECTION code_clib
SECTION code_locale

PUBLIC __lc_char_cmp_bc_default

EXTERN __lc_char_ordinal

__lc_char_cmp_bc_default:

   ; compare two chars in the current locale
   ;
   ; enter : b = char
   ;         c = char
   ;
   ; exit  : a = effective b - c, with flags set
   ;
   ; uses  : af, bc, de, hl
   
   ld a,c
   push bc
   call __lc_char_ordinal      ; convert char to ordinal
   pop bc
   ld c,a
   
   ld a,b
   push bc
   call __lc_char_ordinal
   pop bc
   
   sub c
   ret
