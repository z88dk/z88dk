; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

; void BIFROST2_drawTileH(unsigned int lin,unsigned int col,unsigned int tile)
; callee

SECTION code_clib
SECTION code_bifrost2

PUBLIC BIFROST2_drawTileH_callee

EXTERN asm_BIFROST2_drawTileH

BIFROST2_drawTileH_callee:

        pop hl          ; RET address
        pop bc          ; C=tile
        pop de          ; E=col
        ex (sp),hl      ; L=lin
        ld d,l          ; D=lin
        ld a,c          ; A=tile
       	and 127         ; discard BIFROST2STATIC

        jp asm_BIFROST2_drawTileH        ; execute 'draw_tile'

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _BIFROST2_drawTileH_callee
defc _BIFROST2_drawTileH_callee = BIFROST2_drawTileH_callee
ENDIF

