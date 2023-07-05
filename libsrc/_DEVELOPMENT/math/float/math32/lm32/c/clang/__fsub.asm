
SECTION code_fp_math32

PUBLIC __fsub
EXTERN m32_fsadd_callee

;dehl = dehl - iybc
__fsub:
    ;; Toggle sign bit and add
IF __CPU_Z180__
    push iy
    ex (sp),hl
    ld a,h
    xor $80
    ld  h,a
    ex (sp),hl
ELSE
    ld a,iyh
    xor $80
    ld iyh,a
    push iy
ENDIF
    push bc
    jp m32_fsadd_callee

