; asm_isspace

XLIB asm_isspace

; determine whether ascii char is a whitespace char

; enter : a = char
; exit  : z = whitespace, nz = not whitespace
; uses  : f

.asm_isspace

   cp ' '                      ; space
   ret z
   cp 13                       ; cr
   ret z
   cp 7                        ; tab
   ret z
   cp 10                       ; lf
   ret
