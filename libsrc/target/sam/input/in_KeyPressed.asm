; uint in_KeyPressed(uint scancode)
; 09.2005 aralbrec - update for Sam Coupe 2021

SECTION code_clib
PUBLIC in_KeyPressed
PUBLIC _in_KeyPressed

; Determines if a key is pressed using the scan code
; returned by in_LookupKey.

; enter : l = scan row + flags
;         h = key mask
; exit  : carry = key is pressed & HL = 1
;         no carry = key not pressed & HL = 0
; used  : AF,BC,HL

.in_KeyPressed
._in_KeyPressed
   ld e,0
   ld bc,$fefe

   in a,(c)             ;Check caps
   and $01
   jr nz, nocaps        ; CAPS not pressed
   set 7,e
.nocaps
   ; Check control
   ld a,$ff
   in a,($fe)
   rrca
   jr c,noctrl
   set 6,e
   set 7,e
noctrl:
   ld b,$7f             ; check on SYM SHIFT
   in a,(c)
   and 2
   jr nz,nosym
   set 6,e
.nosym
 ; Check we've got the right modifiers pressed
   ld a,l
   and @11000000
   cp e
   jr nz,fail
 ; We have a few conditions
 ; If row = 8, then we have to output 0xff
 ; If the mask & b11100000 then we read 0xf9
   ld b,$ff
   ld a,l
   and 15
   cp 8
   jr z,read_port
   ld a,h
   and @11100000
   jr  z,regular
   ld  c,0xf9
regular:
   ; We need to rotate to get the right row now
   ld a,l
   and 7
   ld  b,a
   inc b
   ld  a,@01111111
rowloop:
   rlca
   djnz rowloop
   ld b,a
read_port:
   in a,(c)
   and h
   jr nz, fail          ; key not pressed
   ld hl,1
   scf
   ret

.fail
   ld hl,0
   ret

