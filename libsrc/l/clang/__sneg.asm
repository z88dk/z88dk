
SECTION code_l_clang

PUBLIC __sneg
EXTERN l_neg_hl

; Seems to be inlined

__sneg:
    push af	;TODO Necessary?
    call l_neg_hl
    pop af
    ret
