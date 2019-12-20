; uint in_Inkey(void)

; Read current state of keyboard but only return
; keypress if a single key is pressed.

SECTION code_clib
PUBLIC in_Inkey
PUBLIC _in_Inkey
EXTERN in_keytranstbl
EXTERN in_keyrowmap

; exit : carry set and HL = 0 for no keys registered
;        else HL = ASCII character code
; uses : AF,BC,DE,HL

.in_Inkey
._in_Inkey

   ld hl,in_keyrowmap
   ld b,9
   ld e,0
loop:
   ld   c,(hl)
   in   a,(c)
   cpl
   inc  hl
   and  (hl)
   jr   nz,hitkey
   ld   a,8
   add  e
   ld   e,a
   inc  hl
   djnz loop
.nokey

   ld hl,0
   scf
   ret

hitkey:
    ; a = key pressed
    ; e = offset
    ld   c,8
hitkey_loop:
    rlca
    jr   c,doneinc
    inc  e
    dec  c
    jr   nz,hitkey_loop
doneinc:

    ; check for shift/func etc
    ld d,0
    ld bc,72
    in a,($e3)

    bit 4,a
    jr  z, done
    ld bc,144
    bit 0,a
    jr  z,done
    ld  bc,0
done:
   ld  hl,in_keytranstbl
   add hl,bc
   add hl,de
   ld  a,(hl)
   cp  255
   jr  z,nokey
   ld  l,a
   ld  h,0
   and a
   ret
    

