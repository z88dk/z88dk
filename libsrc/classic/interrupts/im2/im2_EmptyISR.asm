; 04.2004 aralbrec

SECTION code_clib
PUBLIC im2_EmptyISR
PUBLIC _im2_EmptyISR

; A do-nothing ISR routine that can be used as the
; default when initializing.

.im2_EmptyISR
._im2_EmptyISR
   ei
   reti
