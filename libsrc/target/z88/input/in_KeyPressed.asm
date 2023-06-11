; uint in_KeyPressed(uint scancode)

SECTION code_clib
PUBLIC in_KeyPressed
PUBLIC _in_KeyPressed

; Determines if a key is pressed using the scan code
; returned by in_LookupKey.

; enter : l = scan row
;         h = key mask
; exit  : carry = key is pressed & HL = 1
;         no carry = key not pressed & HL = 0
; used  : AF,BC,D,HL

.in_KeyPressed
._in_KeyPressed
   ld d,0
   ld bc,$7fb2
   in a,(c)
   bit 7,a
   jr  nz,no_press_lsh
   set 7,d
no_press_lsh:
   ld bc,$bfb2
   in a,(c)
   bit 6,a
   jr  nz,no_press_rsh
   set 7,d
no_press_rsh:
   ld a,l
   and 128
   cp  d
   jr  nz,fail

.noshift
   ld d,0
   ld bc,$bfb2
   in a,(c)
   bit 4,a
   jr nz,noctrl
   set 6,d
noctrl:
   ld  a,l
   and 64
   cp d
   jr nz,fail
  
   ld b,$7f
   ld a,l
rotate:
   and 7
   jr z,rotdone
   rrc b
   dec a
   jr rotate

rotdone:
   ld c,$b2
   in a,(c)
   and h
   jr nz,fail   ;key not pressed
   ld hl,1
   scf
   ret

.fail
   ld hl,0
   ret
