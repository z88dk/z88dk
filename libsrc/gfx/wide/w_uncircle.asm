;
;      Z88 Graphics Functions - Small C+ stubs
;
;      Written around the Interlogic Standard Library
;
;      Stubs Written by D Morris - 30/9/98
;
;
;    $Id: w_uncircle.asm $
;


; Usage: uncircle(int x, int y, int radius, int skip);


IF !__CPU_INTEL__
    SECTION    code_graphics
    
    PUBLIC     uncircle
    PUBLIC     _uncircle

    EXTERN     uncircle_callee
    EXTERN     ASMDISP_UNCIRCLE_CALLEE


.uncircle
._uncircle
    push    ix
    ld ix,2
    add ix,sp

;      de = x0, hl = y0, bc = radius, a = scale factor

    ld a,(ix+2)    ;skip
    ld c,(ix+4)    ;radius
    ld b,(ix+5)
    ld l,(ix+6)    ;y
    ld h,(ix+7)
    ld e,(ix+8)    ;x
    ld d,(ix+9)

    
    jp uncircle_callee + ASMDISP_UNCIRCLE_CALLEE
ENDIF
