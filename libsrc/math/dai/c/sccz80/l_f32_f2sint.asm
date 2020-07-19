
    SECTION    code_fp_dai32

    PUBLIC    l_f32_f2sint
    PUBLIC    l_f32_f2uint
    PUBLIC    l_f32_f2ulong
    PUBLIC    l_f32_f2slong
    EXTERN    ___dai32_setup_single_reg
    EXTERN    ___dai32_return
    EXTERN    ___dai32_xfix
    EXTERN    ___dai32_fpac


l_f32_f2sint:
l_f32_f2uint:
l_f32_f2slong:
l_f32_f2ulong:
    call    ___dai32_setup_single_reg
    call    ___dai32_xfix
    ld      hl,(___dai32_fpac)
    ld      a,h
    ld      h,l
    ld      l,a
    ex      de,hl
    ld      hl,(___dai32_fpac+2)
    ld      a,h
    ld      h,l
    ld      l,a
    ret
