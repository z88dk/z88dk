; Set Mouse Position on Simulated Mouse
; 09.2005

XLIB INMouseSimSetPos

; enter: C = x coord 0..255
;        B = y coord 0..191
;        HL = struct in_UDM *
; uses : A

.INMouseSimSetPos
   ld de,6
   add hl,de
   xor a
   ld (hl),a
   inc hl
   ld (hl),a
   inc hl
   ld (hl),a
   inc hl
   ld (hl),b
   inc hl
   ld (hl),a
   inc hl
   ld (hl),c
   ret
