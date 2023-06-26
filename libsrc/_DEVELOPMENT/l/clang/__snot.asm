
SECTION code_crt_clang

PUBLIC __snot
EXTERN l_neg_hl

; Seems to be inlined

__snot:
    push af	;TODO Necessary?
    call l_neg_hl
    pop af
    ret
