; uint in_JoyKeyboard(struct in_UDK *)
; 2002 aralbrec

XLIB in_JoyKeyboard

.in_JoyKeyboard
   pop de
   pop hl
   push hl
   push de

; enter : HL = struct in_UDK *, a 10-byte table containing 5 scan
;              codes for fire,right,left,down,up in that order
; exit  : HL = F111RLDU active low
; uses  : AF,DE,HL

   ld de,$ff

   ld a,(hl)
   in a,($fe)
   inc hl
   and (hl)
   jr nz, nofire
   res 7,e

.nofire
   inc hl
   ld a,(hl)
   in a,($fe)
   inc hl
   and (hl)
   jr nz, noright
   res 3,e

.noright
   inc hl
   ld a,(hl)
   in a,($fe)
   inc hl
   and (hl)
   jr nz, noleft
   res 2,e

.noleft
   inc hl
   ld a,(hl)
   in a,($fe)
   inc hl
   and (hl)
   jr nz, nodown
   res 1,e

.nodown
   inc hl
   ld a,(hl)
   in a,($fe)
   inc hl
   and (hl)
   jr nz, noup
   res 0,e

.noup
   ex de,hl
   ret
