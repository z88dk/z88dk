;
;   Some extra routines to deal with the F18A FPGA recreation
;
    SECTION code_video_vdp

    PUBLIC vdp_f18a_present  
    PUBLIC vdp_f18a_unlock
    PUBLIC vdp_f18a_lock
    PUBLIC _vdp_f18a_present  
    PUBLIC _vdp_f18a_unlock
    PUBLIC _vdp_f18a_lock


    EXTERN VDPreg_Write
    EXTERN vdp_get_status

vdp_f18a_present:
_vdp_f18a_present:
    ld      hl,0
    call    vdp_get_status
    ld      a,@11111100
    and     l
    ld      hl,0
    cp      $e0
    ret     nz
    inc     hl
    ret

vdp_f18a_lock:
_vdp_f18a_lock:
    ld      a,0x00
    ld      e,0x39
    call    VDPreg_Write
    ret


; Should be called before initialising the VDP
vdp_f18a_unlock:
_vdp_f18a_unlock:
    ld      a,0x1c
    ld      e,0x39
    call    VDPreg_Write
    ld      a,0x1c
    ld      e,0x39
    call    VDPreg_Write
    ret
