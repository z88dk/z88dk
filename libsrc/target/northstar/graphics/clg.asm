;
;       Clear Graphics Screen
;
;       Northstar Advantage version by Stefano Bodrato, 2026
;
;   $Id: clg.asm $
;

    SECTION code_graphics
    PUBLIC  clg
    PUBLIC  _clg
    ;EXTERN  generic_console_cls

    EXTERN  __gfx_vram_page_in
    EXTERN  __gfx_vram_page_out


    ;defc    clg=generic_console_cls
    ;defc    _clg=clg

clg:
_clg:

    call    __gfx_vram_page_in
    ; --- Set graphics page to page 0 ---
    LD A,80h
    OUT (0A1h),A

    LD   HL,16384
    LD   BC,16384

CLS:
    LD   (HL),0
    INC  HL
    DEC  BC
    LD   A,B
    OR   C
    JR   NZ,CLS

    LD A,81h
    OUT (0A1h),A

    LD   HL,16384
    LD   BC,4096

CLS1:
    LD   (HL),0
    INC  HL
    DEC  BC
    LD   A,B
    OR   C
    JR   NZ,CLS1

    call    __gfx_vram_page_out

    RET
