SECTION data_clib

PUBLIC l_jpix_8080

l_jpix_8080:
   jp iMessedUp

iMessedUp:
   ; You didn't call l_setix_8080 first! This should never happen, but just in case it does...
   ret

; use for library code only!
