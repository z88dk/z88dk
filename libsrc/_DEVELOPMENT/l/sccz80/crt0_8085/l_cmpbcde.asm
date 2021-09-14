; sccz80 crt0 library - 8085 version

SECTION code_crt0_sccz80

EXTERN l_cmpbcde

; {BC : DE}

.l_cmpbcde
    ld a,e      ; 4
    sub c       ; 4
    ld a,d      ; 4
    sbc a,b     ; 4
    ret         ; 10

;.l_cmpbcde     ; 2 cycles more
;   ex de,hl    ; 4
;   sub hl,bc   ; 10
;   ex de,hl    ; 4
;   ret         ; 10
