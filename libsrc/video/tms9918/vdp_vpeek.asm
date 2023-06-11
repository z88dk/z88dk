;
;        MSX specific routines
;
;        Improved functions by Rafael de Oliveira Jannone
;        Originally released in 2004 for GFX - a small graphics library
;
;        int vdp_vpeek(int address);
;
;        Read the MSX video memory
;
;        $Id: vdp_vpeek.asm,v 1.10 2016-06-16 19:30:25 dom Exp $
;

    SECTION code_video_vdp
    PUBLIC  vdp_vpeek
    PUBLIC  _vdp_vpeek
    EXTERN  l_tms9918_disable_interrupts
    EXTERN  l_tms9918_enable_interrupts
    
    INCLUDE        "video/tms9918/vdp.inc"


vdp_vpeek:
_vdp_vpeek:
    ; (FASTCALL) -> HL = address
    ; enter vdp address pointer
    ld      a,l
    call    l_tms9918_disable_interrupts


IF VDP_CMD >= 256
    ld      bc,VDP_CMD
ENDIF

IFDEF V9938
    ; High bit of address (bits 14,15,16)
    ld      a,h
    rlca
    rlca
    and     3           ;Ignoring bit 16
    VDPOUT(VDP_CMD)
    ld      a,14 + 0x80
    VDPOUT(VDP_CMD)
ENDIF
    ld      a,l
    VDPOUT(VDP_CMD)
    ld      a,h
    and     @00111111
    VDPOUT(VDP_CMD)
    ; TODO: timing?

IF VDP_DATAIN >= 256
    ld      bc,VDP_DATAIN
ENDIF
    VDPIN(VDP_DATAIN)

    
    ld      h,0
    ld      l,a
    call    l_tms9918_enable_interrupts
    ret

