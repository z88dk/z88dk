; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAP_drawT_raw(unsigned int tile, unsigned int lin, unsigned int col)

SECTION code_clib
SECTION code_nirvanap

PUBLIC NIRVANAP_drawT_raw

EXTERN asm_NIRVANAP_drawT

NIRVANAP_drawT_raw:

   	ld hl,2
   	add hl,sp
   	ld e,(hl)       ; col
   	inc hl
   	inc hl
   	ld d,(hl)       ; lin
   	inc hl
   	inc hl
   	ld a,(hl)       ; tile
   	
   	jp asm_NIRVANAP_drawT

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _NIRVANAP_drawT_raw
defc _NIRVANAP_drawT_raw = NIRVANAP_drawT_raw
ENDIF

