;
;  feilipu, 2026 July
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
; 8085 m32_derror_* — error returns (const float in DEHL + carry)
; Stack only. No exx (Z80 original sandwiches exx around const load).
;

SECTION code_clib
SECTION code_fp_math32

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
PUBLIC m32_derror_ninfnc
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
    call m32_fsconst_pzero
    scf
    ret

.m32_derror_onc
    call m32_fsconst_one
    scf
    ret

.m32_derror_znc
    call m32_fsconst_pzero
    or a                            ; NC
    ret

.m32_derror_nanc
    call m32_fsconst_pnan
    scf
    ret

.m32_derror_nannc
    call m32_fsconst_pnan
    or a
    ret

.m32_derror_infnc
    call m32_fsconst_pinf
    or a
    ret

.m32_derror_ninfnc
    call m32_fsconst_ninf
    or a
    ret

.m32_derror_pinfnc
    call m32_fsconst_pinf
    or a
    ret

.m32_derror_edom_infc
    call m32_fsconst_pinf
    ret                             ; C undefined / as left by const

.m32_derror_edom_ninfc
    call m32_fsconst_ninf
    scf
    ret

.m32_derror_edom_pinfc
    call m32_fsconst_pinf
    scf
    ret

defc m32_derror_edom_zc = m32_derror_zc
defc m32_derror_einval_zc = m32_derror_zc

defc m32_derror_erange_infc = m32_derror_edom_infc
defc m32_derror_erange_ninfc = m32_derror_edom_ninfc
defc m32_derror_erange_pinfc = m32_derror_edom_pinfc
