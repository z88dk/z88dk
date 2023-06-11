;
;        MSX specific routines
;        by Stefano Bodrato, 29/11/2007
;
;        void vdp_vpoke(int address, int value);
;
;        Improved functions by Rafael de Oliveira Jannone
;        Originally released in 2004 for GFX - a small graphics library
;
;        $Id: vdp_vpoke_callee.asm$
;

    SECTION code_video_vdp
    PUBLIC  vdp_vpoke_callee
    PUBLIC  _vdp_vpoke_callee
    
    PUBLIC  vdp_vpoke_direct

    PUBLIC asm_vdp_vpoke
    EXTERN  SETWRT

    INCLUDE "video/tms9918/vdp.inc"
        

vdp_vpoke_callee:
_vdp_vpoke_callee:

    pop     bc
    pop     de        ; value
    pop     hl        ; VRAM address
    push    bc
        
.asm_vdp_vpoke
    ld        a,e
vdp_vpoke_direct:
    ex      af,af

    call    SETWRT

IF VDP_DATA >= 256
    ld      bc,VDP_DATA
ENDIF
    VDPOUT(VDP_DATA)
    ret
    
