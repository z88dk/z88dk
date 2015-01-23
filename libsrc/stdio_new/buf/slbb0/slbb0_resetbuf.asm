; slbb0_resetbuf
; 08.2009 aralbrec

PUBLIC slbb0_resetbuf

; reset the linear buffer to empty
;
; enter : hl = & struct slbb
; uses  : none

.slbb0_resetbuf

   ld (hl),0                   ; end = 0
   ret
