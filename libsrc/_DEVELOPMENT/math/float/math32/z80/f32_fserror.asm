
SECTION code_fp_math32

EXTERN m32_fsmax

EXTERN m32_fsconst_pzero
EXTERN m32_fsconst_one
EXTERN m32_fsconst_pinf
EXTERN m32_fsconst_ninf
EXTERN m32_fsconst_pnan

PUBLIC m32_derror_zc
PUBLIC m32_derror_onc
PUBLIC m32_derror_znc
PUBLIC m32_derror_nanc
PUBLIC m32_derror_nannc
PUBLIC m32_derror_infnc
PUBLIC m32_derror_pinfnc
PUBLIC m32_derror_edom_zc
PUBLIC m32_derror_edom_infc
PUBLIC m32_derror_edom_ninfc
PUBLIC m32_derror_edom_pinfc
PUBLIC m32_derror_einval_zc
PUBLIC m32_derror_erange_infc
PUBLIC m32_derror_erange_ninfc
PUBLIC m32_derror_erange_pinfc


.m32_derror_zc
    exx
    call m32_fsconst_pzero
    exx
    scf
    ret

.m32_derror_onc
    exx
    call m32_fsconst_one
    exx
    scf
    ret

.m32_derror_znc
    exx
    call m32_fsconst_pzero
    exx
    scf
    ccf
    ret

.m32_derror_nanc
    exx
    call m32_fsconst_pnan
    exx
    scf
    ret

.m32_derror_nannc
    exx
    call m32_fsconst_pnan
    exx
    scf
    ccf
    ret

.m32_derror_infnc
    exx
    call m32_fsmax
    exx
    ccf
    ret

.m32_derror_ninfnc
    exx
    call m32_fsconst_ninf
    exx
    scf
    ccf
    ret
    
.m32_derror_pinfnc
    exx
    call m32_fsconst_pinf
    exx
    scf
    ccf
    ret

.m32_derror_edom_infc
    exx
    call m32_fsmax
    exx
    ret

.m32_derror_edom_ninfc
    exx
    call m32_fsconst_ninf
    exx
    scf
    ret

.m32_derror_edom_pinfc
    exx
    call m32_fsconst_pinf
    exx
    scf
    ret

defc m32_derror_edom_zc = m32_derror_zc
defc m32_derror_einval_zc = m32_derror_zc

defc m32_derror_erange_infc = m32_derror_edom_infc
defc m32_derror_erange_ninfc = m32_derror_edom_ninfc
defc m32_derror_erange_pinfc = m32_derror_edom_pinfc

