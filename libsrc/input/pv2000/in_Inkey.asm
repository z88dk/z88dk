; uint in_Inkey(void)
; 05.2018 suborb

; Read current state of keyboard but only return
; keypress if a single key is pressed.

SECTION code_clib
PUBLIC in_Inkey
PUBLIC _in_Inkey
EXTERN in_keytranstbl

; exit : carry set and HL = 0 for no keys registered
;        else HL = ASCII character code
; uses : AF,BC,DE,HL

.in_Inkey
._in_Inkey

   ld de,0
   ld b,10
loop:
   dec  b
   ld   a,9
   sub  b
   out  ($20),a
   in   a,($20)
   rlca  
   rlca
   rlca
   rlca
   and  240
   ld   c,a
   in   a,($10)
   and  15
   or   c
   jr   nz,hitkey
   ld   a,8		;Point de to next row
   add  e
   ld   e,a
   ld   a,b
   and  a
   jr   nz,loop
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
    ld bc,80
    in a,($40)

    bit 2,a
    jr  nz, done
    ld bc,160
    bit 1,a
    jr  nz,done
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
    

