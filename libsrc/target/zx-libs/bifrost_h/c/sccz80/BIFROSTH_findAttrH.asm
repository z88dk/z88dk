; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; unsigned char *BIFROSTH_findAttrH(unsigned int lin,unsigned int col)

SECTION code_clib
SECTION code_bifrost_h

PUBLIC BIFROSTH_findAttrH

EXTERN asm_BIFROSTH_findAttrH

BIFROSTH_findAttrH:

        ld hl,2
        add hl,sp
        ld c,(hl)       ; C=col
        inc hl
        inc hl
        ld l,(hl)       ; L=lin

   	  jp asm_BIFROSTH_findAttrH
