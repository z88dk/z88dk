; slbb0_initbuf
; 08.2009 aralbrec

PUBLIC slbb0_initbuf

; reset the linear buffer to empty
;
; enter : hl = & struct slbb
;         de = buffer adddress
;          a = buffer size (len)
; uses  : hl

.slbb0_initbuf

   ld (hl),0                   ; end = 0
   inc hl
   ld (hl),a                   ; store len
   inc hl
   ld (hl),e                   ; store buffer address
   inc hl
   ld (hl),d
   ret
