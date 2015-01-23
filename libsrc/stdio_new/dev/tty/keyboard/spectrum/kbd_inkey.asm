; uint kbd_inkey(void)
; 09.2005 aralbrec

; Read current state of keyboard but only return
; keypress if a single key is pressed.

PUBLIC kbd_inkey

EXTERN kbd_transtbl

; exit : carry set and hl = 0 for no valid keypress
;        else hl = ascii code of keypress
; uses : af, bc, de, hl

.kbd_inkey

   ld de,0
   ld bc,$fefe
   in a,(c)
   or $e1
   cp $ff
   jr nz, keyhitA

   ld e,5
   ld b,$fd
   in a,(c)
   or $e0
   cp $ff
   jr nz, keyhitA

   ld e,10
   ld b,$fb
   in a,(c)
   or $e0
   cp $ff
   jr nz, keyhitA

   ld e,15
   ld b,$f7
   in a,(c)
   or $e0
   cp $ff
   jr nz, keyhitA

   ld e,20
   ld b,$ef
   in a,(c)
   or $e0
   cp $ff
   jr nz, keyhitA

   ld e,25
   ld b,$df
   in a,(c)
   or $e0
   cp $ff
   jr nz, keyhitA

   ld e,30
   ld b,$bf
   in a,(c)
   or $e0
   cp $ff
   jr nz, keyhitA

   ld e,35
   ld b,$7f
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

   ld hl,kbd_transtbl
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

.rowtbl

   defb 255,255,255,255,255,255,255
   defb 255,255,255,255,255,255,255,255
   defb 4,255,255,255,255,255,255
   defb 255,3,255,255,255,2,255,1
   defb 0,255
