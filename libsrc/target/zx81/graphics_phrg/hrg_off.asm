;--------------------------------------------------------------
; ZX81 Pseudo - HRG library
; by Stefano Bodrato, Mar. 2020
;--------------------------------------------------------------
;
;   Set TEXT mode
;
;	$Id: hrg_off.asm $
;

	MODULE    __pseudohrg_hrg_off

	SECTION	code_graphics
	
	PUBLIC	hrg_off
	PUBLIC	_hrg_off

	EXTERN	MTCH_P3
	EXTERN	zx_slow

	INCLUDE "graphics/grafix.inc"



.hrg_off
._hrg_off

  call zx_slow
  
IF (maxy>191)
  ; patch is not necessary for 192 rows
ELSE
  xor a
  ld (MTCH_P3+1),a	; patch also our custom interrupt handler for 64 rows
ENDIF

  ld a,$1e            ; Standard ROM font
  ld i,a
  
  ret
