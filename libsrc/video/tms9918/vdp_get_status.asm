
SECTION code_video_vdp

PUBLIC  vdp_get_status
PUBLIC  _vdp_get_status
EXTERN  __tms9918_status_register
EXTERN  l_tms9918_disable_interrupts
EXTERN  l_tms9918_enable_interrupts

INCLUDE  "video/tms9918/vdp.inc"

IFDEF V9938

PUBLIC  __v9938_wait_vdp
PUBLIC  __v9938_get_vdp_status

__v9938_get_vdp_status:
    push    bc
IF VDP_CMD >= 256
    ld      bc,VDP_CMD
ENDIF
    VDPOUT(VDP_CMD)
    out     (VDP_CMD),a
    ld      a,$8f           ;Set r15 so status register reads what we want
    VDPOUT(VDP_CMD)
IF VDP_STATUS >= 256
    ld      bc,VDP_DATAIN
ENDIF
    VDPIN(VDP_STATUS)
    pop     bc
    ret

__v9938_wait_vdp:
    ld      a,2
    call    __v9938_get_vdp_status
    and     1
    jp      nz,__v9938_wait_vdp
    xor     a               ;Restore the status back to usual
    call    __v9938_get_vdp_status
    ret
ENDIF

; int vdp_get_status(int sr) __z88dk_fastcall
vdp_get_status:
_vdp_get_status:
IF V9938
    ld      a,l
    and     a
    jr      z,read_status0
    ld      l,a
    call    l_tms9918_disable_interrupts
    ld      a,l
    call    __v9938_get_vdp_status
    ld      l,a
    ld      h,0
    ; Reset to regular status register
    xor     a
IF VDP_CMD >= 256
    ld      bc,VDP_CMD
ENDIF
    VDPOUT(VDP_CMD)
    ld      a,$8f
    VDPOUT(VDP_CMD)
    call    l_tms9918_enable_interrupts
    ret
ENDIF
read_status0:
    ; status register is populated by the interrupt
    ld      hl,(__tms9918_status_register)
    ld      h,0
    ret


