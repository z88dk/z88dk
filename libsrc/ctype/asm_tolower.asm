; asm_tolower

        SECTION code_clib

PUBLIC asm_tolower

; if the char is in [A-Z], make it lower case

; enter : a = char
; exit  : a = lower case char
; uses  : af

.asm_tolower

   cp 'A'
   ret c
   
   cp 'Z'+1
   ret nc
   
   or $20
   ret
