; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; void BIFROSTH_drawBackTilesH(unsigned int lin,unsigned int col,unsigned int attr)
; callee

SECTION code_clib
SECTION code_bifrost_h

PUBLIC BIFROSTH_drawBackTilesH_callee

EXTERN asm_BIFROSTH_drawBackTilesH

BIFROSTH_drawBackTilesH_callee:

        pop hl          ; RET address
        pop bc          ; C=attrib
        pop de          ; E=col
        ex (sp),hl      ; L=lin
        ld d,l          ; D=lin

        jp asm_BIFROSTH_drawBackTilesH        ; execute 'draw_back_tiles'
