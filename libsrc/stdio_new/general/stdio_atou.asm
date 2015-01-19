; stdio_atou
; 05.2008 aralbrec

PUBLIC stdio_atou

; ascii buffer to unsigned integer conversion
; whitespace is not skipped

; enter : de = char * buffer
; exit  : de = & next char to interpret in buffer
;         hl = unsigned int result
; uses  : af, bc, de, hl

.stdio_atou

   ld hl,0
   dec de
   
.loop

   inc de
   ld a,(de)
   
   sub '0'                   ; inlined isdigit
   ret c
   cp 10
   ret nc
   
   add hl,hl                 ; hl = hl*10
   ld c,l
   ld b,h
   add hl,hl
   add hl,hl
   add hl,bc
   
   add a,l
   ld l,a
   jp nc, loop
   
   inc h
   jp loop
