
SECTION code_video_vdp


INCLUDE  "video/tms9918/vdp.inc"

IFDEF V9938

PUBLIC  __v9938_wait_vdp
PUBLIC  __v9938_get_vdp_status

__v9938_get_vdp_status:
    push    bc
    out     (VDP_CMD),a
    ld      a,$8f           ;Set r5 so status register reads what we want
    out     (VDP_CMD),a
    in      a,(VDP_STATUS)
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