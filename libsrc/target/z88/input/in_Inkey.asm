; uint in_Inkey(void)

; Read current state of keyboard

SECTION code_clib
PUBLIC in_Inkey
PUBLIC _in_Inkey
EXTERN in_keytranstbl

; exit : carry set and HL = 0 for no keys registered
;        else HL = ASCII character code
; uses : AF,BC,DE,HL

.in_Inkey
._in_Inkey

   ld  de,0
   ld  bc,$7fb2
   in  a,(c)
   cpl 
   and 127	;Exclude RSH
   jr  nz,gotkey
   rrc b
   ld  e,8
   in  a,(c)
   cpl
   and @10101111 ;Exclude RSH, DIA
   jr  nz,gotkey
   rrc b
   ld  e,16

read_loop:
   in a,(c)
   cpl
   and a
   jr  nz,gotkey
   ld  a,e
   add 8
   ld  e,a
   rrc  b
   jr   c,read_loop

nokey:
   ld  hl,0
   scf
   ret

gotkey:
   rlca
   jr  c,rot_done
   inc e
   jr gotkey
rot_done:
   ; de = key index
   ; Check for modifiers
   ld hl,in_keytranstbl + 64
   ld bc,$7fb2
   in a,(c)
   bit 7,a		;LSH
   jr  z,add_modifier
   rrc b
   in  a,(c)
   bit 6,a  		;RSH
   jr  z,add_modifier
   ld  hl,in_keytranstbl + 128
   bit 4,a     		;DIA
   jr  z,add_modifier
   ld  hl,in_keytranstbl
add_modifier:  
   add hl,de
   ld  a,(hl)
   cp  255
   jr  z,nokey
   ld l,a
   ld h,0
   and a
   ret

