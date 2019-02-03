;
;        MSX specific routines
;        by Stefano Bodrato, 29/11/2007
;
;        void msx_vpoke(int address, int value);
;
;        Improved functions by Rafael de Oliveira Jannone
;        Originally released in 2004 for GFX - a small graphics library
;
;        $Id: msx_vpoke_callee.asm$
;

        SECTION code_clib
        PUBLIC  msx_vpoke_callee
        PUBLIC  _msx_vpoke_callee
        
        PUBLIC  msx_vpoke_direct

        PUBLIC ASMDISP_MSX_VPOKE_CALLEE
        EXTERN  l_tms9918_disable_interrupts
        EXTERN  l_tms9918_enable_interrupts

        INCLUDE "arch/tms9918/vdp.inc"
        

msx_vpoke_callee:
_msx_vpoke_callee:

        pop        bc
        pop        de        ; value
        pop        hl        ; VRAM address
        push        bc
        
.asmentry
        ld        a,e
msx_vpoke_direct:
        call    l_tms9918_disable_interrupts
        ; enter vdp address pointer
        push    af
        ld      a,l
IF VDP_CMD < 0
        ld      (-VDP_CMD),a
ELSE
        ld      bc,VDP_CMD
        out     (c),a
ENDIF
        ld      a,h
        and     @00111111
        or      @01000000
IF VDP_CMD < 0
        ld      (-VDP_CMD),a
ELSE
        out     (c),a
ENDIF

        ; enter data
        pop     af                        ; "ld a,e" could be too fast, better to keep the POP instruction
IF VDP_DATA < 0
        ld      (-VDP_DATA),a
ELSE
        ld      bc,VDP_DATA
        out     (c),a
ENDIF
        call    l_tms9918_enable_interrupts
        ret
        
DEFC ASMDISP_MSX_VPOKE_CALLEE = # asmentry - msx_vpoke_callee
