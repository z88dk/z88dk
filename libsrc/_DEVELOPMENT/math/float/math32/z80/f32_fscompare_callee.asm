SECTION code_clib
SECTION code_fp_math32

PUBLIC  m32_compare_callee

; Compare two IEEE floats. NB. Needs to handle -0 == +0
;       Entry: dehl=secondary
;              onstack (sp+4: under two return addresses) = primary
;
;       Exit:     z=number is zero
;              (nz)=number is non-zero
;                 c=number is negative 
;                nc=number is positive

.m32_compare_callee
    pop     bc      ;return address from this function
                    ;this leaves return address to real program
                    ;and the primary on the stack

    exx             ;left
    pop     bc
    pop     hl
    pop     de
    push    bc      ;return address to program
    ld      a,l
    exx             ;right
    push    bc      ;return address from function
    sub     l
    ld      c,a    
    exx             ;left
    ld      a,h
    exx             ;right
    sbc     a,h
    ld      b,a
    exx             ;left
    ld    a,e
    exx             ;right
        sbc     a,e
    exx             ;left
    ld    c,a
    ld      a,d
    exx             ;right
    sbc     a,d
    exx             ;left
    ld      b,a

    ; left dehl = float, bc = highword of result
    ; (exx) right dehl = float, bc = low word of result
    ld    a,b
    or    c

    bit    7,b
    jr    z,consider_positive

    ; Calculate zero state of result
    exx
    or    b
    or    c
    exx
    ld    hl,1    
    scf
    ret

consider_positive:
    exx
    or    b
    or    c
    exx
    scf
    ccf
    ld    hl,1
    ret
    
