; slbb0_isfull
; 08.2009 aralbrec

PUBLIC slbb0_isfull

; enter : hl = & struct slbb
; exit  : carry set if buffer full
;         carry reset if buffer not full and a = space remaining minus one
; uses  : af

.slbb0_isfull

   inc hl
   ld a,(hl)                   ; a = buffer size
   dec a
   dec hl
   sub (hl)                    ; a = len - end
   ret
