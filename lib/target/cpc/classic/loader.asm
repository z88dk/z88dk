;
; CPC bank loader, after @iratahack
;

    EXTERN  __DATA_END_tail
    EXTERN  __BANK_0_END_tail
    EXTERN  __BANK_1_END_tail
    EXTERN  __BANK_2_END_tail
    EXTERN  __BANK_3_END_tail
    EXTERN  __BANK_4_END_tail
    EXTERN  __BANK_5_END_tail
    EXTERN  __BANK_6_END_tail
    EXTERN  __BANK_7_END_tail



    ; Turn off tape messages
    ld      a,0
    call    cas_noisy

    ld      hl,__crt_loader_filename
find_ext:
    ld      a,(hl)
    cp      '.'
    inc     hl
    jr      nz,find_ext
    inc     hl
    ld      (extension),hl
    ; This may well contain the loading screen
    ld      hl,CRT_ORG_BANK_3
    ld      de,__BANK_3_END_tail - CRT_ORG_BANK_3
    ld      bc, $33c0       ;bank port, extension
    call    loadbank

    ; Probably part of the program as loaded, so not expected to be used
    ld      hl,CRT_ORG_BANK_0
    ld      de,__BANK_0_END_tail - CRT_ORG_BANK_0
    ld      bc,$30c0 ;Bank 0
    call    loadbank
    ld      hl,CRT_ORG_BANK_1
    ld      de,__BANK_1_END_tail - CRT_ORG_BANK_1
    ld      bc,$31c0 ;Bank 1
    call    loadbank

    ld      hl,CRT_ORG_BANK_4
    ld      de,__BANK_4_END_tail - CRT_ORG_BANK_4
    ld      bc,$34c4 ;Bank 4
    call    loadbank
    ld      hl,CRT_ORG_BANK_5
    ld      de,__BANK_5_END_tail - CRT_ORG_BANK_5
    ld      bc,$35c5 ;Bank 5
    call    loadbank
    ld      hl,CRT_ORG_BANK_6
    ld      de,__BANK_6_END_tail - CRT_ORG_BANK_6
    ld      bc,$36c6 ;Bank 6
    call    loadbank
    ld      hl,CRT_ORG_BANK_7
    ld      de,__BANK_7_END_tail - CRT_ORG_BANK_7
    ld      bc,$37c7 ;Bank 7
    call    loadbank

    ; Load bank2 into screen memory and copy across
    ; Loading into page2 will clobber ROM vectors
    ld      hl,49152
    ld      de,__BANK_2_END_tail - CRT_ORG_BANK_2
    ld      a,d
    or      e
    ret     z
    ld      bc,$32c0 ;Bank 2
    call    loadbank
    di
    ld      hl,49152
    ld      de,$8000
    ld      bc,__BANK_2_END_tail - CRT_ORG_BANK_2
    ldir
    ret


; hl = address
; de = length
; c = bank page, b = extension character
loadbank:
    ld      a,d
    or      e
    ret     z
    push    hl
    ld      hl,(extension)
    ld      (hl),b
    ; Page in the bank
    ld      b,$7F       ;gate array address
    out     (c),c
    ld      hl,__crt_loader_filename
    call    printit

    pop     de          ;de = address to load
    ld      hl,__crt_loader_filename    ;hl = filename
    push    hl
    ld      b,0
    ; Figure out length of filename
get_length:
    ld      a,(hl)
    and     a
    jr      z,length_found
    inc     hl
    inc     b
    jr      get_length
length_found:
    pop     hl
    call    cas_in_open             ; Load address returned in DE
    ex      de, hl
    call    cas_in_direct
    call    cas_in_close
    ld      bc,$7fc0
    out     (c),c
    ret


printit:
        ld      a, (hl)
        inc     hl
        or      a
        ret     z
        call    txt_output
        jr      printit

; Populated by appmake
    PUBLIC  __crt_loader_filename
extension:
    defw    0
__crt_loader_filename:
    defs    16

