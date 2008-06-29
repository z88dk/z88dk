; asm_isgraph

XLIB asm_isgraph

; called by asm_isprint
; determine if the char is printable but not a space

; enter : a = char
; exit  : carry = not graph
; uses  : f

.asm_isgraph

   cp 7                        ; tab
   ret z
   
   cp 10                       ; lf
   ret z
   
   cp 13                       ; cr
   ret z
   
   cp 163                      ; UKP
   ret z
   
   cp 33
   ret c
   
   cp 128
   ccf
   
   ret
