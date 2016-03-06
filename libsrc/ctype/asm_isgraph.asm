; asm_isgraph

        SECTION code_clib

PUBLIC asm_isgraph

; called by asm_isprint
; determine if the char is printable but not a space

; enter : a = char
; exit  : carry = not graph
; uses  : f

.asm_isgraph

   cp 7                        ; tab
   ccf
   ret z
   
   cp 10                       ; lf
   ccf
   ret z
   
   cp 13                       ; cr
   ccf
   ret z
   
   cp 163                      ; UKP
   ccf
   ret z
   
   cp 33
   ret c
   
   cp 127			; 127 = DEL
   ccf
   
   ret
