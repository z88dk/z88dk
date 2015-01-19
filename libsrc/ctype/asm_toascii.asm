; asm_toascii

PUBLIC asm_toascii

; convert 8-bit char to 7-bit ascii

; enter : a = char
; exit  : a = ascii char
; uses  : a

.asm_toascii

   res 7,a
   ret

