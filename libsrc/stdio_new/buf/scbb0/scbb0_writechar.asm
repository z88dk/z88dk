; scbb0_writechar
; 08.2009 aralbrec

PUBLIC scbb0_writechar

; write char to buffer if space is available
;
; enter : hl = & struct scbb0
;          c = char to write
; exit  :  carry reset if successful 
;          carry set if buffer full
; uses  : af, de, hl

.scbb0_writechar

   ld de,7
   add hl,de
   
   dec (hl)                    ; wavail--
   jp pe, full                 ; if wavail was $80, buffer is full

   dec hl
   ld a,(hl)                   ; a = mask
   dec hl
   and (hl)                    ; a = wptr
   inc (hl)                    ; wptr++
   
   dec hl
   ld d,(hl)
   dec hl
   add a,(hl)
   ld e,a
   jp nc, nocarry
   inc d
   or a

.nocarry                       ; de = buffer address

   ld a,c
   ld (de),a                   ; write char
   
   dec hl
   dec hl
   dec hl
   inc (hl)                    ; ravail++
   ret

.full

   ld (hl),$80
   scf
   ret
