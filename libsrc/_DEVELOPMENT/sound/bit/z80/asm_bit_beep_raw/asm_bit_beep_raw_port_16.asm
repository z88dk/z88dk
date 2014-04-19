
   ; "sound/bit/z80/asm_bit_beep_raw/asm_bit_beep_raw_port_16.asm"
   ; ported by Dominic Morris, adapted by Stefano Bodrato

   ; beep generator outputting to 16-bit port address
   ; included into "sound/bit/z80/asm_bit_beep_raw.asm"

   ; enter : de = duration in tone cycles
   ;         hl = tone period in z80 T states
   ;
   ; uses  : af, bc, de, hl, ix, bc'

LIB asm_bit_open, asm_bit_close

beeper:

   ld a,l
   srl l
   srl l
   srl l
   cpl
   and $03
   ld c,a
   ld b,0
   
   ld ix,beixp3
   add ix,bc

   call asm_bit_open
   
   exx
   ld bc,__sound_bit_port
   exx
   
beixp3:

   nop
   nop
   nop
   inc b
   inc c

behllp:

   dec c
   jr nz, behllp
   
   ld c,$3f

   dec b
   jp nz, behllp

   xor __sound_bit_toggle
   
   exx                         ; nine cycles slower than eight bit port version
   out (c),a                   ; but this does not affect period calculation appreciably
   exx
   
   ld b,h
   ld c,a
   
   bit __sound_bit_toggle_pos,a
   jr nz, be_again
   
   ld a,d
   or e
   jr z, be_end

   ld a,c
   ld c,l
   
   dec de
   jp (ix)

be_again:

   ld c,l
   
   inc c
   jp (ix)

be_end:

   jp asm_bit_close
