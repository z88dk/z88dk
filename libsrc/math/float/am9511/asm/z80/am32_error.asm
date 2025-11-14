
SECTION code_fp_am9511

EXTERN asm_am9511_max

EXTERN asm_am9511_const_pzero
EXTERN asm_am9511_const_one
EXTERN asm_am9511_const_pinf
EXTERN asm_am9511_const_ninf
EXTERN asm_am9511_const_pnan

PUBLIC asm_am9511_derror_zc
PUBLIC asm_am9511_derror_onc
PUBLIC asm_am9511_derror_znc
PUBLIC asm_am9511_derror_nanc
PUBLIC asm_am9511_derror_nannc
PUBLIC asm_am9511_derror_infnc
PUBLIC asm_am9511_derror_pinfnc
PUBLIC asm_am9511_derror_edom_zc
PUBLIC asm_am9511_derror_edom_infc
PUBLIC asm_am9511_derror_edom_ninfc
PUBLIC asm_am9511_derror_edom_pinfc
PUBLIC asm_am9511_derror_einval_zc
PUBLIC asm_am9511_derror_erange_infc
PUBLIC asm_am9511_derror_erange_ninfc
PUBLIC asm_am9511_derror_erange_pinfc


.asm_am9511_derror_zc
    exx
    call asm_am9511_const_pzero
    exx
    scf
    ret

.asm_am9511_derror_onc
    exx
    call asm_am9511_const_one
    exx
    scf
    ret

.asm_am9511_derror_znc
    exx
    call asm_am9511_const_pzero
    exx
    scf
    ccf
    ret

.asm_am9511_derror_nanc
    exx
    call asm_am9511_const_pnan
    exx
    scf
    ret

.asm_am9511_derror_nannc
    exx
    call asm_am9511_const_pnan
    exx
    scf
    ccf
    ret

.asm_am9511_derror_infnc
    exx
    call asm_am9511_max
    exx
    ccf
    ret

.asm_am9511_derror_ninfnc
    exx
    call asm_am9511_const_ninf
    exx
    scf
    ccf
    ret
    
.asm_am9511_derror_pinfnc
    exx
    call asm_am9511_const_pinf
    exx
    scf
    ccf
    ret

.asm_am9511_derror_edom_infc
    exx
    call asm_am9511_max
    exx
    ret

.asm_am9511_derror_edom_ninfc
    exx
    call asm_am9511_const_ninf
    exx
    scf
    ret

.asm_am9511_derror_edom_pinfc
    exx
    call asm_am9511_const_pinf
    exx
    scf
    ret

defc asm_am9511_derror_edom_zc = asm_am9511_derror_zc
defc asm_am9511_derror_einval_zc = asm_am9511_derror_zc

defc asm_am9511_derror_erange_infc = asm_am9511_derror_edom_infc
defc asm_am9511_derror_erange_ninfc = asm_am9511_derror_edom_ninfc
defc asm_am9511_derror_erange_pinfc = asm_am9511_derror_edom_pinfc

