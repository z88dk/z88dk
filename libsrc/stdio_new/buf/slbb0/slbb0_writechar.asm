; slbb0_writechar
; 08.2009 aralbrec

XLIB slbb0_writechar

; write a char to the index specified
;
; enter : hl = & struct slbb
;          a = index to write to
;          d = char
; exit  : carry set for success
;         carry reset if index out of bounds
; uses  : af, hl

.slbb0_writechar

   cp (hl)                     ; index - end
   ret nc                      ; return if index out of bounds
   
   inc hl
   inc hl
   add a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   jp nc, noinc
   inc h

.noinc                         ; hl = address of char in buffer

   ld (hl),d
   scf                         ; success!
   ret
