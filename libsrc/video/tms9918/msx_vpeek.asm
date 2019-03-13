;
;        MSX specific routines
;
;        Improved functions by Rafael de Oliveira Jannone
;        Originally released in 2004 for GFX - a small graphics library
;
;        int msx_vpeek(int address);
;
;        Read the MSX video memory
;
;        $Id: msx_vpeek.asm,v 1.10 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
        PUBLIC  msx_vpeek
        PUBLIC  _msx_vpeek
        EXTERN  l_tms9918_disable_interrupts
        EXTERN  l_tms9918_enable_interrupts
        
        INCLUDE        "video/tms9918/vdp.inc"


msx_vpeek:
_msx_vpeek:
        ; (FASTCALL) -> HL = address
        ; enter vdp address pointer
        ld      a,l
        call    l_tms9918_disable_interrupts
IF VDP_CMD < 0
        ld      (-VDP_CMD),a
ELSE
        ld      bc,VDP_CMD
        out     (c),a
ENDIF
        ld      a,h
        and     @00111111
IF VDP_CMD < 0
        ld      (-VDP_CMD),a
        out     (c),a
ENDIF
        ; read data
IF VDP_DATAIN < 0
        ld      a,(-VDP_DATAIN)
ELSE
    IF VDP_DATAIN > 255
            ld        a,+(VDP_DATAIN / 256)
    ENDIF
        in      a,(VDP_DATAIN % 256)
ENDIF
        
        ld      h,0
        ld      l,a
        call    l_tms9918_enable_interrupts
        ret

