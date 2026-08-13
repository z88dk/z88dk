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
    defw    SETINT_1D

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
  LD HL,PLOT_TBL

  LD A,E
  RLA
  RLA
  RLA
  JP NC,TBL1

  LD HL,PLOT_TBL2

TBL1:
  ADD HL,BC
  LD B,A
;  CALL SET_LCD_ADDR
    ROMCALL
    defw    SET_LCD_ADDR
  LD A,B
  AND $C0
  OR D
  LD B,A
  LD E,$01
  LD HL,SHAPE
;  CALL SET_LCD
    ROMCALL
    defw    SET_LCD

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
  LD HL,SHAPE

  RET


 
