; stdio_zeroonstream
; 05.2008 aralbrec

XLIB stdio_zeroonstream

; more common code from %i and %x scan converters

.stdio_zeroonstream

   ; we've read a 0 but have no way of pushing it back on the stream
   ; so take care of things here rather than in the common code
   
   xor a                       ; clear carry (no error)

   bit 3,c                     ; return if assignment is suppressed
   ret nz
   
   ld (de),a                   ; integer = 0
   inc de
   ld (de),a
   
   exx
   inc de                      ; number of conversions increased by one
   exx
   ret
