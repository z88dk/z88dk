
;
;  Apple II Z80 SoftCard
;
;  Stefano, 2025
;
;  Get the current slot used by the Z80 SoftCard
;
;-----------------------------------------------------------------------------
;
;	$Id: z80_slot.asm $
;
;-----------------------------------------------------------------------------


    SECTION code_clib
    PUBLIC  z80_slot
    PUBLIC  _z80_slot


z80_slot:
_z80_slot:
  ld hl,($f3de)
  xor a
  and l
  jr  nz,no_softcard
  ld a,$f0
  and h
  cp $e0
  jr  nz,no_softcard
  cpl
  and h
  ld h,0
  ld l,a
  ret

no_softcard:
  ld hl,-1
  ret
