; scbb0_readchar
; 08.2009 aralbrec

PUBLIC scbb0_readchar

; read a char from the buffer if one is available
;
; enter : hl = & struct scbb0
; exit  :  a = char with carry reset if successful
;          carry set if buffer empty
; uses  : af, de, hl

.scbb0_readchar

   dec (hl)                    ; ravail--
   jp pe, empty                ; if ravail was $80, buffer is empty

   inc hl
   ld a,(hl)                   ; a = mask
   inc hl
   and (hl)                    ; a = rptr
   inc (hl)                    ; rptr++
   
   inc hl
   add a,(hl)
   ld e,a                      ; e = LSB of buffer address
   inc hl
   ld d,(hl)
   jp nc, nocarry
   inc d
   or a                        ; reset carry

.nocarry                       ; de = buffer address

   ld a,(de)                   ; a = char
   
   inc hl
   inc hl
   inc hl
   inc (hl)                    ; wavail++
   ret
   
.empty

   ld (hl),$80
   scf
   ret
