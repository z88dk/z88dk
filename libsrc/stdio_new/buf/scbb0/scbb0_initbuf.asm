; scbb0_initbuf
; 08.2009 aralbrec

PUBLIC scbb0_initbuf

; initialize the circular buffer
;
; enter : hl = & struct scbb0
;         de = buffer adddress
;          a = buffer size (power of 2)
; uses  : af, de, hl

.scbb0_initbuf

   dec a                       ; a = buffer size - 1 = mask

   ld (hl),$80                 ; ravail = 0
   inc hl
   ld (hl),a                   ; mask
   inc hl
   ld (hl),0                   ; rptr
   inc hl
   ld (hl),e                   ; buffer address
   inc hl
   ld (hl),d
   inc hl
   ld (hl),0                   ; wptr
   inc hl
   ld (hl),a                   ; mask
   inc hl
   
   add a,$81
   ld (hl),a                   ; wavail
   
   ret
