
SECTION code_clib
SECTION code_locale

PUBLIC __lc_char_ordinal_default

EXTERN l_ret

defc __lc_char_ordinal_default = l_ret

   ; char to ordinal in current locale
   ;
   ; enter : a = char
   ;
   ; exit  : a = ordinal
   ;
   ; uses  : af, bc, de, hl
