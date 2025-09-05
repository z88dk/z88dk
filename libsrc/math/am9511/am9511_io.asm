;
; IO drivers for the am9511 library
;
; Default IO driver - relies on __IO_AM9511_BASE being exported by the CRT

IF __AM9511_HELPER_FUNC

    SECTION  code_fp_am9511

    EXTERN __am9511_out_data
    EXTERN __am9511_in_status
    EXTERN __am9511_in_data
    EXTERN __am9511_out_control

    EXTERN  __IO_AM9511_BASE_PORT

__am9511_out_data:
    out     (__IO_AM9511_BASE_PORT),a
    ret

__am9511_in_status:
    in      a,(__IO_AM9511_BASE_PORT+1)
    ret

__am9511_in_data:
    in      a,(__IO_AM9511_BASE_PORT)
    ret

__am9511_out_control:
    out     (__IO_AM9511_BASE_PORT+1),a
    ret

ENDIF
