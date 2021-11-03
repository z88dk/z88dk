
    EXTERN  __DATA_END_tail
    EXTERN  __BANK_0_END_tail
    EXTERN  __BANK_1_END_tail
    EXTERN  __BANK_2_END_tail
    EXTERN  __BANK_3_END_tail
    EXTERN  __BANK_4_END_tail
    EXTERN  __BANK_5_END_tail
    EXTERN  __BANK_6_END_tail
    EXTERN  __BANK_7_END_tail



    ld    hl,(23645)
    inc   hl
    ld    a,(hl)
    cp    234  ;REM
    ret   nz
    inc   hl

    ;The filename follows
    ld    de,filen
    ld    b,16
readf3:
     ld    a,(hl)
     cp    13
     jr    z,readf4
     ld    (de),a
     inc   hl
     inc   de
     cp    '.'
     jr    nz,not_dot
     ld    (extension),de
not_dot:
     djnz  readf3
readf4:
     ld    (23645),hl
     ld    hl,(extension)
     inc   hl
     ld    (hl),255

     ; We've now read the base of the filename
     ; Reconfigure +3 memory to allow to read into pages without breaking the cache
     ld      de,0      ;Disable cache
     ld      hl,128    ;RAMdisk uses all memory, we don't use it so no problems
     ld      ix,319
     call    dodos

     ; Load FILENAME.BIN
;     ld      c,0
;     ld      de,__DATA_END_tail - CRT_ORG_CODE
;     ld      hl,CRT_ORG_CODE
;     call    loadfile
;     ret     nc
    ld      hl,CRT_ORG_BANK_0
    ld      de,__BANK_0_END_tail - CRT_ORG_BANK_0
    ld      c,0 ;Bank 0
    call    loadbank
    ret     nc
    ld      hl,CRT_ORG_BANK_1
    ld      de,__BANK_1_END_tail - CRT_ORG_BANK_1
    ld      c,1 ;Bank 1
    call    loadbank
    ret     nc
    ld      hl,CRT_ORG_BANK_2
    ld      de,__BANK_2_END_tail - CRT_ORG_BANK_2
    ld      c,2 ;Bank 2
    call    loadbank
    ret     nc
    ld      hl,CRT_ORG_BANK_3
    ld      de,__BANK_3_END_tail - CRT_ORG_BANK_3
    ld      c,3 ;Bank 3
    call    loadbank
    ret     nc
    ld      hl,CRT_ORG_BANK_4
    ld      de,__BANK_4_END_tail - CRT_ORG_BANK_4
    ld      c,4 ;Bank 4
    call    loadbank
    ret     nc
    ld      hl,CRT_ORG_BANK_5
    ld      de,__BANK_5_END_tail - CRT_ORG_BANK_5
    ld      c,5 ;Bank 5
    call    loadbank
    ret     nc
    ld      hl,CRT_ORG_BANK_6
    ld      de,__BANK_6_END_tail - CRT_ORG_BANK_6
    ld      c,6 ;Bank 6
    call    loadbank
    ret     nc
    ld      hl,CRT_ORG_BANK_7
    ld      de,__BANK_7_END_tail - CRT_ORG_BANK_7
    ld      c,7 ;Bank 7
    call    loadbank
    ret


loadbank:
     ld     a,d
     or     e
     ccf
     ret    z
     push   hl
     ld     a,c
     add    48
     ld     hl,(extension)
     ld     (hl),a
     push   bc
     push   de
     ld     hl,filen
     ld     bc,1
     ld     de,1
     ld     ix,262
     call   dodos
     pop    de
     pop    bc
     pop    hl  ;load address
     ret    nc
     ld     b,0
     ld     ix,274
     call   dodos
     ld     b,0
     ld     ix,265
     call   dodos
     scf
     ret

dodos:
     push   af
     push   bc
     di
     ld     a,7
     ld     bc,32765
     ld     (23388),a
     out    (c),a
     ei
     pop    bc
     pop    af
     call   jpix
     push   af
     push   bc
     di
     ld     a,16
     ld     bc,32765
     ld     (23388),a
     out    (c),a
     ei
     pop    bc
     pop    af
     ret
jpix:
     jp      (ix)


; Filename as read from basic
; This contains: FILENAME.BIN initially (padded out)
extension: defw 0
filen:     defs 16
