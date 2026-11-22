;
;       Tandy M100 ROM based graphics routines
;       Written by Stefano Bodrato 2026
;
;   $Id: __asm_pixeladdr.asm $
;


    INCLUDE "classic/gfx/grafix.inc"

    SECTION code_clib
    PUBLIC  __asm_pixeladdr

    INCLUDE "target/m100/def/romcalls.def"


__asm_pixeladdr:

;  CALL SETINT_1D
    ROMCALL
    defw    KY_SETINT_1D

  PUSH DE
  LD C,$FE
  LD A,D

SET_OFFSET:
  INC C
  INC C
  LD D,A
  SUB $32
  JP NC,SET_OFFSET

  LD B,$00
  LD HL,KY_PLOT_TBL

  LD A,E
  RLA
  RLA
  RLA
  JP NC,TBL1

  LD HL,KY_PLOT_TBL2

TBL1:
  ADD HL,BC
  LD B,A
    ROMCALL
    defw    KY_SET_LCD_ADDR
  LD A,B
  AND $C0
  OR D
  LD B,A
  LD E,$01
  LD HL,KY_SHAPE
    ROMCALL
    defw    KY_GET_LCD

  POP DE
  LD D,B
  LD A,E
  AND $07
  ADD A,A
  LD C,A
  LD B,$00
  LD HL,PLOT_TBL
  ADD HL,BC
 
  LD A,(HL)
  LD HL,KY_SHAPE

  RET


; Here we waste 20 bytes to be cross-compatible with the ROM OPTION mode.
; The overlap 

PLOT_TBL:
  DEFB $01, $00
  DEFB $02, $00
  DEFB $04, $00
  DEFB $08, $00
  DEFB $10, $00

  DEFB $20, $00
  DEFB $40, $00
  DEFB $80, $00
  DEFB $00, $01
  DEFB $00, $02

