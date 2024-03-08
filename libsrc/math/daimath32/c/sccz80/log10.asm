
    SECTION code_fp_dai32

    PUBLIC  log10
    EXTERN  ___dai32_setup_single
    EXTERN  ___dai32_xlog10
    EXTERN  ___dai32_return

log10:
    call    ___dai32_setup_single
    call    ___dai32_xlog10
    jp      ___dai32_return
