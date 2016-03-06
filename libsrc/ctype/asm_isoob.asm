; asm_isoob
; 08.2009 aralbrec

        SECTION code_clib

PUBLIC asm_isoob

; Used by tty drivers to identify out-of-band characters
; supplied by the keyboard.
;
; enter : a = char
; exit  : z = oob char
; uses  : f

.asm_isoob

   cp $03                      ; CTRL-C
   ret z
   cp $04                      ; CTRL-D
   ret z
   cp $1a                      ; CTRL-Z
   ret
