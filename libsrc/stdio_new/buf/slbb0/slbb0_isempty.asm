; slbb0_isempty
; 08.2009 aralbrec

PUBLIC slbb0_isempty

; enter : hl = & strcut slbb
; exit  : z = buffer is empty
; uses  : af

.slbb0_isempty

   ld a,(hl)
   or a
   ret
