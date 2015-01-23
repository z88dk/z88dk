; scbb0_isempty
; 08.2009 aralbrec

PUBLIC scbb0_isempty

; reports whether the buffer has no chars to read
;
; enter : hl = & struct scbb0
; exit  :  a = number of chars in buffer for reading
;          z flag set if buffer is empty
; uses  : af

.scbb0_isempty

   ld a,(hl)
   sub $80
   ret
