; uint in_Inkey(void)

; Read current state of keyboard 

SECTION code_clib
PUBLIC in_Inkey
PUBLIC _in_Inkey
EXTERN in_keytranstbl

; exit : carry set and HL = 0 for no keys registered
;        else HL = ASCII character code
; uses : AF,BC,DE,HL

; Or values for each port to ignore modifiers

.in_Inkey
._in_Inkey
   ld hl,mask_table
   ld de,0
   ld b,@11111110
loop:
   ld c,$fe
   in a,(c)
   or (hl)
   cp $ff
   jr nz,keyhit
   ld c,$f9
   in a,(c)
   or @00011111
   cp $ff
   jr nz,keyhit
   inc hl
   ld a,e
   add 8
   ld e,a
   scf
   rlc b
   jr c,loop
   ; Now consider the extra row
   ld bc,$fffe
   in a,(c)
   or (hl)
   cp $ff
   jr nz,keyhit
nokey:
   ld hl,0
   scf
   ret


.keyhit
   ; Key e into the right position
   rrca
   jr nc,shiftdone
   inc e
   jr keyhit


shiftdone:
   ; Lets detect modifiers
   ld bc,0
   ld a,$fe
   in a,($fe)
   and 1
   jr  nz,no_caps
   ld  c,72
no_caps:
   ld  a,$7f
   in  a,($fe)
   and 2
   jr  nz,no_sym
   ld  a,c
   add 144
   ld  c,a
no_sym:
   ; Check for control
   ld  a,$ff
   in  a,($fe)
   and 1
   jr  nz,done
   ld  c,72 * 3
done:
   ld  hl,in_keytranstbl
   add hl,de
   add hl,bc
   ld a,(hl)
   cp $ff
   jr z,nokey
   ld l,a
   ld h,0
   and a
   ret

   SECTION rodata_clib

mask_table:
  defb $e1, $e0, $e0, $e0, $e0, $e0, $e0, $e2, $e1
