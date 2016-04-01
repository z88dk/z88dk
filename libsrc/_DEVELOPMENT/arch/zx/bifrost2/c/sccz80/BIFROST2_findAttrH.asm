; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

; unsigned char *BIFROST2_findAttrH(unsigned int lin,unsigned int col)

SECTION code_clib
SECTION code_bifrost2

PUBLIC BIFROST2_findAttrH

EXTERN asm_BIFROST2_findAttrH

BIFROST2_findAttrH:

        ld hl,2
        ld b,h
        add hl,sp
        ld c,(hl)       ; BC=col
        inc hl
        inc hl
        ld l,(hl)       ; HL=lin
        ld h,b

   	jp asm_BIFROST2_findAttrH
