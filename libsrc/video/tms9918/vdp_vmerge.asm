;
;        MSX specific routines
;
;        GFX - a small graphics library 
;        Copyright (C) 2004  Rafael de Oliveira Jannone
;
;        extern void vmerge(unsigned int addr, unsigned char value);
;
;        set \a value at a given vram address \a addr, merging bits (OR) with the existing value
;
;

    SECTION code_video_vdp
    PUBLIC        vdp_vmerge
    PUBLIC        _vdp_vmerge

    EXTERN  l_tms9918_disable_interrupts
    EXTERN  l_tms9918_enable_interrupts
    
    INCLUDE        "video/tms9918/vdp.inc"


vdp_vmerge:
_vdp_vmerge:

        ; enter vdp address pointer

    pop     bc
    pop     de
    pop     hl
    push    hl        ; addr
    push    de        ; value
    push    bc        ; RET address

    call    l_tms9918_disable_interrupts
IF VDP_CMD < 0
    ld      bc,-VDP_CMD
    ld      a,l
    ld      (bc),a
ELSE
    ld      bc,VDP_CMD
    out     (c),l
ENDIF
    ld      a,h
    and     @00111111
IF VDP_CMD < 0
    ld      (bc),a
ELSE
    out     (c),a
ENDIF

        ; read data

IF VDP_DATAIN < 0
    ld      bc,-VDP_DATAIN
    ld      a,(bc)
ELSE
    ld      bc,VDP_DATAIN
    in      a,(c)
ENDIF
    or      e
    ld      e,a                        ; The new value

        ; enter same address

IF VDP_CMD < 0
    ld      bc,-VDP_CMD
    ld      a,l
    ld      (bc),a
ELSE
    ld      bc,VDP_CMD
    out     (c),l
ENDIF
    ld      a,h
    or      @01000000
IF VDP_DATA < 0
    ld      (bc),a
    ld      bc,-VDP_DATA
    ld      a,e
    ld      (bc),a
ELSE
    out     (c),a
    ld      bc, VDP_DATA
    out     (c),e
ENDIF
    call    l_tms9918_enable_interrupts

    ret
