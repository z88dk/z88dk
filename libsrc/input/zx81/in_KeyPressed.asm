; uint in_KeyPressed(uint scancode)
; 02.2008 aralbrec

SECTION code_clib
PUBLIC in_KeyPressed
PUBLIC _in_KeyPressed

; Determines if a key is pressed using the scan code
; returned by in_LookupKey.

; enter : l = scan row
;         h = key mask
; exit  : carry = key is pressed & HL = 1
;         no carry = key not pressed & HL = 0
; used  : AF,BC,HL

.in_KeyPressed
._in_KeyPressed
   bit 7,h
   jp z, nocaps

   ld a,$fe             ; check on CAPS key
   in a,($fe)
   and $01
   jr nz, fail          ; CAPS not pressed

.nocaps

   ld a,h
   and $1f
   ld b,l
   ld c,$fe
   in b,(c)
   and b
   jr nz, fail          ; key not pressed
   ld hl,1
   scf
   ret

.fail
   ld hl,0
   ret
