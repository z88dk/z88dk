; stdio_longzeroonstream
; 05.2008 aralbrec

PUBLIC stdio_longzeroonstream

; more common code from %li and %lx scan converters

.stdio_longzeroonstream

   ; we've read a 0 but have no way of pushing it back on the stream
   ; so take care of things here rather than in the common code
   
   xor a                       ; clear carry (no error)

   bit 3,c                     ; return if assignment is suppressed
   jr nz, skip
   
   ld (de),a                   ; integer = 0
   inc de
   ld (de),a

   bit 1,c
   jr z, notlong

   inc de
   ld (de),a
   inc de
   ld (de),a

.notlong

   exx
   inc de                      ; number of conversions increased by one
   exx

.skip

   ld e,a
   ld d,a                      ; %lI requires de = 0

   ret
