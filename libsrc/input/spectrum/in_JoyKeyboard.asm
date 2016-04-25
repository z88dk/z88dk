; uint __FASTCALL__ in_JoyKeyboard(struct in_UDK *)
; 2002 aralbrec

SECTION code_clib
PUBLIC in_JoyKeyboard
PUBLIC _in_JoyKeyboard

.in_JoyKeyboard
._in_JoyKeyboard

; enter : HL = struct in_UDK *, a 10-byte table containing 5 scan
;              codes for fire,right,left,down,up in that order
; exit  : HL = F000RLDU active high
; uses  : AF,DE,HL

   ld de,0

   ld a,(hl)
   in a,($fe)
   inc hl
   and (hl)
   jr nz, nofire
   set 7,e

.nofire

   inc hl
   ld a,(hl)
   in a,($fe)
   inc hl
   and (hl)
   jr nz, noright
   set 3,e

.noright

   inc hl
   ld a,(hl)
   in a,($fe)
   inc hl
   and (hl)
   jr nz, noleft
   set 2,e

.noleft

   inc hl
   ld a,(hl)
   in a,($fe)
   inc hl
   and (hl)
   jr nz, nodown
   set 1,e

.nodown

   inc hl
   ld a,(hl)
   in a,($fe)
   inc hl
   and (hl)
   jr nz, noup
   set 0,e

.noup

   ex de,hl
   ret
