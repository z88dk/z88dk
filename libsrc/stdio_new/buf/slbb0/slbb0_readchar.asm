; slbb0_readchar
; 08.2009 aralbrec

PUBLIC slbb0_readchar

; read a char from the index specified
;
; enter : hl = & struct slbb
;          a = index of char to read
; exit  : carry set and a = char for success
;         carry reset if index out of bounds
; uses  : af, hl

.slbb0_readchar

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

   ld a,(hl)
   scf                         ; success!
   ret
