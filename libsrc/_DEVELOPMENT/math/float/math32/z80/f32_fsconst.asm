
SECTION code_fp_math32

PUBLIC m32_fsconst_pzero
PUBLIC m32_fsconst_nzero
PUBLIC m32_fsconst_one
PUBLIC m32_fsconst_1_3
PUBLIC m32_fsconst_pi
PUBLIC m32_fsconst_pinf
PUBLIC m32_fsconst_ninf
PUBLIC m32_fsconst_pnan
PUBLIC m32_fsconst_nnan

.m32_fsconst_pzero
    ld de,0
    ld h,e
    ld l,e
    ret

.m32_fsconst_nzero
    ld de,$8000
    ld h,e
    ld l,e
    ret

.m32_fsconst_one
    ld de,$3f80
    ld hl,$0000
    ret

.m32_fsconst_1_3
    ld de,$3eaa
    ld hl,$aaab
    ret

.m32_fsconst_pi
    ld de,$4049
    ld hl,$0fdb
    ret

.m32_fsconst_pinf
    ld de,$7f80
    ld hl,0
    ret

.m32_fsconst_ninf
    ld de,$ff80
    ld hl,0
    ret

.m32_fsconst_pnan
    ld de,$7fff
    ld h,e
    ld l,e
    ret

.m32_fsconst_nnan
    ld de,$ffff
    ld h,e
    ld l,e
    ret

