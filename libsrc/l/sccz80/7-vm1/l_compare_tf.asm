;       Z88 Small C+ Run time Library
;
;       The true/false tails the comparison routines in this tier jump to.
;
;       These live in 7-8085/l_compare_result.asm on the 8085, which SHADOWS
;       9-common/l_compare_result.asm by filename - affordable there because
;       that tier overrides all ten comparisons and so nothing is left calling
;       l_compare_result. This tier leaves the four SIGNED comparisons to
;       9-common, which does call it, so the file must not be shadowed and
;       these two symbols need a name of their own.

SECTION code_clib
SECTION code_l_sccz80

PUBLIC l_compare_true
PUBLIC l_compare_false

; return hl=1 with carry set, or hl=0 with carry clear

.l_compare_true
    scf
    ld hl,1
    ret

.l_compare_false
    xor a
    ld l,a
    ld h,a
    ret
