
SECTION code_fp_math32

PUBLIC __fcmp
EXTERN m32_compare_callee

; dehl = float(iybc)
; Compare dehl and iybc
;
; Return: z = equal
;         m = hlde > iybc
__fcmp:
    ex  (sp),iy
    push bc
    push iy
    call m32_compare_callee
    ;       Exit:      Z = number is zero
    ;               (NZ) = number is non-zero
    ;                  C = number is negative 
    ;                 NC = number is positive
    push af
    ex (sp),hl
    ; Fiddle with the flags now, we've got to transfer the carry flag to the m
    res 7,l     ;clear sign flag
    bit 0,l
    jr z,noset
    set 7,l
noset:
    ex (sp),hl
    pop af
    ret
