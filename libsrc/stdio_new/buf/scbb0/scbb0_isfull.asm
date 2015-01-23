; scbb0_isfull
; 08.2009 aralbrec

PUBLIC scbb0_isfull

; reports whether the buffer has space to write more chars
;
; enter : hl = & struct scbb0
; exit  :  a = number of chars that can be written
;         hl = & struct scbb0.wavail
;          z flag set if buffer is full
; uses  : af, hl

.scbb0_isempty

   ld a,7
   add a,l
   ld l,a
   jp nc, skip
   inc h

.skip

   ld a,(hl)
   sub $80
   ret
