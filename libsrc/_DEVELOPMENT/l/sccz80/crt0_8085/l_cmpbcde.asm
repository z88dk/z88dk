; sccz80 crt0 library - 8080 version

SECTION code_crt0_sccz80

EXTERN l_cmpbcde

; {BC : DE}

.l_cmpbcde
    ld a,e
    sub c
    ld a,d
    sbc a,b
    ret

;.l_cmpbcde     ; 2 cycles more
;   ex de,hl
;   sub hl,bc
;   ex de,hl
;   ret
