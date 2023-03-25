
SECTION code_video_vdp


INCLUDE  "video/tms9918/vdp.inc"

IFDEF V9938

PUBLIC __v9938_wait_vdp

get_status:
    push    bc
    out     (VDP_CMD),a
    ld      a,$8f           ;Set r5 so status register reads what we want
    out     (VDP_CMD),a
    in      a,(VDP_STATUS)
    pop     bc
    ret

__v9938_wait_vdp:
    ld      a,2
    call    get_status
    and     1
    jp      nz,__v9938_wait_vdp
    xor     a               ;Restore the status back to usual
    call    get_status
    ret

ENDIF