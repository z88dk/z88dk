; scbb0_resetbuf
; 08.2009 aralbrec

PUBLIC scbb0_resetbuf

; empty the buffer
;
; enter : hl = & struct scbb0
; uses  : af, hl

.scbb0_resetbuf

   ld (hl),$80                 ; ravail
   inc hl
   inc hl
   ld (hl),0                   ; rptr
   inc hl
   inc hl
   inc hl
   ld (hl),0                   ; wptr
   inc hl
   ld a,(hl)                   ; a = mask
   add a,$81
   inc hl
   ld (hl),a                   ; wavail
   
   ret
