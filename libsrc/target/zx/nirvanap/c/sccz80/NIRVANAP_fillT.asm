; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANA_fillT(unsigned int attr, unsigned int lin, unsigned int col)

SECTION code_clib
SECTION code_nirvanap

PUBLIC NIRVANAP_fillT

EXTERN asm_NIRVANAP_fillT_di

NIRVANAP_fillT:

   	ld hl,2
   	add hl,sp
   	ld e,(hl)       ; col
   	inc hl
   	inc hl
   	ld d,(hl)       ; lin
   	inc hl
   	inc hl
   	ld a,(hl)       ; attr

   	jp asm_NIRVANAP_fillT_di

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _NIRVANAP_fillT
defc _NIRVANAP_fillT = NIRVANAP_fillT
ENDIF

