; scbb0_peekchar
; 08.2009 aralbrec

PUBLIC scbb0_peekchar

; peek at next char in the buffer without consuming it
;
; enter : hl = & struct scbb
; exit  :  a = char with carry reset if successful
;          carry set if buffer empty
; uses  : af, hl

.scbb0_peekchar

   dec (hl)                    ; ravail--
   jp pe, empty                ; if ravail was $80, buffer is empty

   inc hl
   ld a,(hl)                   ; a = mask
   inc hl
   and (hl)                    ; a = rptr
   
   inc hl
   add a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   jp nc, nocarry
   inc h
   or a                        ; reset carry

.nocarry                       ; hl = buffer address

   ld a,(hl)                   ; a = char
   ret
   
.empty

   ld (hl),$80
   scf
   ret
