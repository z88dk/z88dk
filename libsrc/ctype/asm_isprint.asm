; asm_isprint

        SECTION code_clib

PUBLIC asm_isprint
EXTERN asm_isgraph

; determine if the char is printable

; enter : a = char
; exit  : carry = not printable
; uses  : f

.asm_isprint

   cp 32
   ret z
   
   jp asm_isgraph
