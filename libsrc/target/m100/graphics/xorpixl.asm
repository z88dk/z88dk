;
;       Tandy M100 ROM based graphics routines
;       Written by Stefano Bodrato 2020
;
;
;       Xor pixel at (x,y) coordinate.
;
;
;   $Id: xorpixl.asm $
;


    INCLUDE "classic/gfx/grafix.inc"

    SECTION code_clib
    PUBLIC  xorpixel

    EXTERN  __gfx_coords
    EXTERN  base_graphics
    INCLUDE "target/m100/def/romcalls.def"



;LABEL				M100	KC85	M10
;----------------------------------------
;SHAPE				$FFEC	$FFAD	$FF90
;SETINT_1D			$765C	$730A	$7376
;SET_LCD_ADDR		$753B	$71E9	$7255
;SET_LCD			$74F5	$71A3	$720F
;GET_LCD			$74F6	$71A4	$7210
;SET_CLOCK_HL_16	$743C	$70EA	$7146
;PLOT_TBL			$7643	$72F1	$735D
;PLOT_TBL2			$764D	$72FB	$7367


defc SHAPE				= $FFEC
defc SETINT_1D			= $765C
defc SET_LCD_ADDR		= $753B
defc SET_LCD			= $74F5
defc GET_LCD			= $74F6
defc SET_CLOCK_HL_16	= $743C
defc PLOT_TBL			= $7643
defc PLOT_TBL2			= $764D


xorpixel:
    push    bc
    ld      d, h
    ld      e, l
    ld      (__gfx_coords), hl

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
  XOR (HL)

    ROMCALL
	defw $7498   ; L7497+1

  POP  BC
  RET


 
