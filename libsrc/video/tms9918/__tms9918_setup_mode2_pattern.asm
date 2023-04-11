

SECTION code_video_vdp
PUBLIC  __tms9918_setup_mode2_pattern

EXTERN  l_tms9918_disable_interrupts
EXTERN  l_tms9918_enable_interrupts
EXTERN  __tms9918_pattern_name
EXTERN  SETWRT

INCLUDE  "video/tms9918/vdp.inc"


__tms9918_setup_mode2_pattern:
    call    l_tms9918_disable_interrupts
    ld      hl,(__tms9918_pattern_name)      ;pattern name
    call    SETWRT
IF VDP_DATA >= 256
    ld      bc,VDP_DATA
ENDIF
    xor     a
    ld      e,3
pattern:
    VDPOUT(VDP_DATA)
    inc     a
    jr      nz,pattern
    dec     e
    jr      nz,pattern
    call    l_tms9918_enable_interrupts
    ret