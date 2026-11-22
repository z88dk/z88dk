; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; unsigned char BIFROSTH_getTile(unsigned int px,unsigned int py)
; callee

SECTION code_clib
SECTION code_bifrost_h

PUBLIC BIFROSTH_getTile_callee

EXTERN asm_BIFROSTH_getTile

BIFROSTH_getTile_callee:

        pop hl          ; RET address
        pop bc          ; BC=py
        ex (sp),hl      ; HL=px
		  
		  jp asm_BIFROSTH_getTile

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _BIFROSTH_getTile_callee
defc _BIFROSTH_getTile_callee = BIFROSTH_getTile_callee
ENDIF

