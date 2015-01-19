; 04.2004 aralbrec

PUBLIC im2_EmptyISR

; A do-nothing ISR routine that can be used as the
; default when initializing.

.im2_EmptyISR
   ei
   reti
