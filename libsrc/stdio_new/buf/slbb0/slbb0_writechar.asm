; slbb0_writechar
; 08.2009 aralbrec

PUBLIC slbb0_writechar
EXTERN slbb0_appendchar

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
   jp nc, slbb0_appendchar     ; if index out of bounds we're appending to the end
   
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
