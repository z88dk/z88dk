;
; XorDrawbox
;
; Generic high resolution version
;

;
;    $Id: w_xordrawb.asm $
;

IF !__CPU_INTEL__
SECTION code_graphics
PUBLIC xordrawb
PUBLIC _xordrawb
EXTERN xordrawb_callee
EXTERN ASMDISP_XORDRAWB_CALLEE

    
.xordrawb
._xordrawb

    pop af
    
    pop de
    pop    hl
    exx        ; w_plotpixel and swapgfxbk must not use the alternate registers, no problem with w_line_r
    pop de
    pop hl
    
    push hl
    push de
    exx
    push hl
    push de
    
    push af    ; ret addr
    
   jp xordrawb_callee + ASMDISP_XORDRAWB_CALLEE
ENDIF

