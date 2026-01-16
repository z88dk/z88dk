
;
;  Apple II Z80 SoftCard
;
;  Stefano, 2025
;
;  Invoke the Rockwell 6502
;
;-----------------------------------------------------------------------------
;
;	$Id: r6502.asm $
;
;-----------------------------------------------------------------------------


    SECTION code_clib
    PUBLIC  r6502
    PUBLIC  _r6502


r6502:
_r6502:
  ld ($f3d0),hl     ; pass the entry location to the 6502
  ld hl,($f3de)     ; get the HW slot currently in use
  ld (hl),a	        ; tell the SoftCard to switch CPU
  ret
