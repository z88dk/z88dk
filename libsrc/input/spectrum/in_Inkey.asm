; uint in_Inkey(void)
; 09.2005 aralbrec

; Read current state of keyboard but only return
; keypress if a single key is pressed.

XLIB in_Inkey
LIB in_keytranstbl

; exit : carry set and HL = 0 for no keys registered
;        else HL = ASCII character code
; uses : AF,BC,DE,HL

.in_Inkey
   ld de,0
   ld bc,$fefe
   in a,(c)
   or $e1
   cp $ff
   jr nz, keyhitA

   ld e,5
   rlc b
   in a,(c)
   or $e0
   cp $ff
   jr nz, keyhitA

   ld e,10
   rlc b
   in a,(c)
   or $e0
   cp $ff
   jr nz, keyhitA

   ld e,15
   rlc b
   in a,(c)
   or $e0
   cp $ff
   jr nz, keyhitA

   ld e,20
   rlc b
   in a,(c)
   or $e0
   cp $ff
   jr nz, keyhitA

   ld e,25
   rlc b
   in a,(c)
   or $e0
   cp $ff
   jr nz, keyhitA

   ld e,30
   rlc b
   in a,(c)
   or $e0
   cp $ff
   jr nz, keyhitA

   ld e,35
   rlc b
   in a,(c)
   or $e2
   cp $ff
   ld c,a
   jr nz, keyhitB

.nokey
   ld hl,0
   scf
   ret

.keyhitA
   ld c,a

   ld a,b
   cpl
   or $81
   in a,($fe)
   or $e0
   cp $ff
   jr nz, nokey

   ld a,$7f
   in a,($fe)
   or $e2
   cp $ff
   jr nz, nokey

.keyhitB
   ld b,0
   ld hl,rowtbl - $e0
   add hl,bc
   ld a,(hl)
   cp 5
   jr nc, nokey
   add a,e
   ld e,a

   ld hl,in_keytranstbl
   add hl,de

   ld a,$fe
   in a,($fe)
   and $01
   jr nz, nocaps
   ld e,40
   add hl,de

.nocaps
   ld a,$7f
   in a,($fe)
   and $02
   jr nz, nosym
   ld e,80
   add hl,de

.nosym
   ld l,(hl)
   ld h,0
   ret

.here    ; because I can't remember the symbol z80asm uses for current PC
defc rowtbl = here - 15

   defb 4,255,255,255,255,255,255
   defb 255,3,255,255,255,2,255,1
   defb 0,255
