; uint kbd_pressed(uint scancode)
; 09.2005 aralbrec

PUBLIC kbd_pressed

; Determines if a key is pressed using the scan code
; returned by kbd_lookup.
;
; enter : l = scan row
;         h = key mask
; exit  : carry = key is pressed & hl = 1
;         no carry = key not pressed & hl = 0
; used  : af, bc, hl

.kbd_pressed

   bit 7,h
   jp z, nocaps

   ld a,$fe             ; check on CAPS key
   in a,($fe)
   and $01
   jr nz, fail          ; CAPS not pressed

.nocaps

   bit 6,h
   jp z, nosym

   ld a,$7f             ; check on SYM SHIFT
   in a,($fe)
   and $02
   jr nz, fail          ; SYM not pressed

.nosym

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
