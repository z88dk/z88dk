; asm_toupper

        SECTION code_clib

PUBLIC asm_toupper

; if the char is in [a-z], make it upper case

; enter : a = char
; exit  : a = upper case char
; uses  : af

.asm_toupper

   cp 'a'
   ret c
   
   cp 'z'+1
   ret nc
   
   and $df
   ret
