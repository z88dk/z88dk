;
; fat_getfree: count free clusters.
; A pointer argument is __z88dk_fastcall (HL).
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

PUBLIC  _fat_getfree

EXTERN  _cpm_fat_vol
EXTERN  fat_ldhl
EXTERN  fat_move_window
EXTERN  fat_st32
EXTERN  fat_sthl
EXTERN  fat_subhlbc
EXTERN  fat_work
EXTERN  fatwin
EXTERN  get_fat

; ff.c f_getfree FAT16/32 window scan. Count zero entries in n_fatent
; FAT slots (0 and 1 are never free on a valid volume). The scan does
; not read FSInfo; a mount may already have stored FSI_Free_Count.
; Cache: free_valid / free_clst; put_fat updates the count.
; HL -> DWORD out. L=0 success.
; Uses: fat_work+0 nfree, +4 sect, +8 remaining
_fat_getfree:
    push    hl
    ld      a,(_cpm_fat_vol+25)
    or      a
    jp      Z,gf_scan               ;free count is not cached
    call    fat_ldhl
    defw    _cpm_fat_vol+28
    ex      de,hl
    call    fat_ldhl
    defw    _cpm_fat_vol+30
    ld      bc,hl
    jp      gf_store
gf_scan:
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT12                ;fs_type vs FAT12
    jp      Z,gf12                  ;walk entries; a sector tally spans
    ld      hl,0
    call    fat_sthl
    defw    fat_work           ;nfree
    call    fat_sthl
    defw    fat_work+2
    call    fat_ldhl
    defw    _cpm_fat_vol+8     ;sect = fatbase
    call    fat_sthl
    defw    fat_work+4
    call    fat_ldhl
    defw    _cpm_fat_vol+10
    call    fat_sthl
    defw    fat_work+6
    call    fat_ldhl
    defw    _cpm_fat_vol+4     ;remaining = n_fatent
    call    fat_sthl
    defw    fat_work+8
    call    fat_ldhl
    defw    _cpm_fat_vol+6
    call    fat_sthl
    defw    fat_work+10
gf_loop:
    call    fat_ldhl
    defw    fat_work+8
    ld      a,h
    or      l
    call    fat_ldhl
    defw    fat_work+10
    or      h
    or      l
    jp      Z,gf_scanned            ;no FAT entries left
    call    fat_ldhl
    defw    fat_work+6
    ld      bc,hl
    call    fat_ldhl
    defw    fat_work+4
    ex      de,hl
    call    fat_move_window         ;C: this FAT sector in fatwin
    jp      NC,gf_fail              ;FAT sector unread
    call    fat_ldhl
    defw    fat_work+4
    inc     hl
    call    fat_sthl
    defw    fat_work+4
    ld      a,h
    or      l
    jp      NZ,gf_sect              ;sect low did not wrap
    call    fat_ldhl
    defw    fat_work+6
    inc     hl
    call    fat_sthl
    defw    fat_work+6
gf_sect:
    ; One 16-bit tally per sector, then one 32-bit add. B=0 counts 256.
    ld      bc,256
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT32                ;fs_type
    jp      NZ,gf_wide              ;FAT16: 256 entries
    ld      bc,128
gf_wide:
    ld      a,(fat_work+10)         ;remaining >= 65536 fills this sector
    or      a
    jp      NZ,gf_full              ;remaining above 65535
    ld      a,(fat_work+11)
    or      a
    jp      NZ,gf_full              ;remaining above 65535
    call    fat_ldhl
    defw    fat_work+8
    call    fat_subhlbc                   ;C set when remaining < width
    jp      NC,gf_full              ;sector is full of entries
    ld      a,(fat_work+8)          ;tail is 1..width-1
    ld      b,a
    ld      hl,fatwin
    call    gf_tally                ;count free slots in the tail
    call    gf_add                  ;add that tally to nfree
    jp      gf_scanned
gf_full:
    push    bc
    ld      b,c                     ;0 = 256 FAT16 entries, 128 FAT32
    ld      hl,fatwin
    call    gf_tally                ;count free slots in the sector
    call    gf_add                  ;add that tally to nfree
    pop     bc
    call    fat_ldhl
    defw    fat_work+8
    call    fat_subhlbc                   ;remaining - entries just scanned
    call    fat_sthl
    defw    fat_work+8
    jp      NC,gf_loop              ;high half unchanged
    call    fat_ldhl
    defw    fat_work+10
    dec     hl
    call    fat_sthl
    defw    fat_work+10
    jp      gf_loop
gf_scanned:
    ld      a,1
    ld      (_cpm_fat_vol+25),a
    call    fat_ldhl
    defw    fat_work
    call    fat_sthl
    defw    _cpm_fat_vol+28
    ex      de,hl
    call    fat_ldhl
    defw    fat_work+2
    call    fat_sthl
    defw    _cpm_fat_vol+30
    ld      bc,hl
gf_store:
    pop     hl
    call    fat_st32                ;write the free-cluster count
    ld      hl,0
    scf                             ;C: count stored
    ret
gf_fail:
    pop     hl
    ld      hl,1
    or      a                       ;NC: FAT sector unread
    ret

; FAT12 free count. A 12-bit entry can cross a sector, so walk
; cluster 2 .. n_fatent-1 through get_fat. Carry clear fails the count.
gf12:
    ld      hl,2
    call    fat_sthl
    defw    fat_work+8         ;cursor
    ld      hl,0
    call    fat_sthl
    defw    fat_work+10
    call    fat_sthl
    defw    fat_work           ;nfree
    call    fat_sthl
    defw    fat_work+2
gf12_lp:
    call    fat_ldhl
    defw    fat_work+8
    ld      de,(_cpm_fat_vol+4)
    ld      a,l
    sub     e
    ld      a,h
    sbc     a,d
    push    af                      ;borrow from the low half
    call    fat_ldhl
    defw    fat_work+10
    ld      de,(_cpm_fat_vol+6)
    pop     af
    ld      a,l
    sbc     a,e
    ld      a,h
    sbc     a,d
    jp      NC,gf_scanned           ;cursor >= n_fatent
    call    fat_ldhl
    defw    fat_work+8
    ex      de,hl
    call    fat_ldhl
    defw    fat_work+10
    ld      bc,hl
    push    bc
    push    de
    call    get_fat
    pop     hl
    pop     bc
    jp      NC,gf_fail              ;disk error or bad cluster
    ld      a,d
    or      e
    or      c
    or      b
    jp      NZ,gf12_used
    ld      de,1
    call    gf_add
gf12_used:
    call    fat_ldhl
    defw    fat_work+8
    inc     hl
    call    fat_sthl
    defw    fat_work+8
    ld      a,h
    or      l
    jp      NZ,gf12_lp
    call    fat_ldhl
    defw    fat_work+10
    inc     hl
    call    fat_sthl
    defw    fat_work+10
    jp      gf12_lp

; HL = FAT window, B = entries (0 means 256). DE = free count on return.
gf_tally:
    ld      de,0
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT32                ;fs_type
    jp      Z,gf32_lp               ;FAT32 entries are dwords
gf16_lp:
    ld      a,(hl+)                 ;FAT16 free: both bytes zero
    or      (hl+)
    jp      NZ,gf16_used            ;FAT16 entry in use
    inc     de
gf16_used:
    dec     b
    jp      NZ,gf16_lp              ;entries left in this sector
    ret
gf32_lp:
    ld      a,(hl+)                 ;FAT32 free: 28-bit value zero
    or      (hl+)
    or      (hl+)
    ld      c,a
    ld      a,(hl+)
    and     $0F
    or      c
    jp      NZ,gf32_used            ;FAT32 entry in use
    inc     de
gf32_used:
    dec     b
    jp      NZ,gf32_lp              ;entries left in this sector
    ret

; fat_work (nfree) += DE. DE is at most one sector of entries.
gf_add:
    call    fat_ldhl
    defw    fat_work
    add     hl,de                   ;nfree += this sector
    call    fat_sthl
    defw    fat_work
    ret     NC                      ;low half did not wrap
    call    fat_ldhl
    defw    fat_work+2
    inc     hl
    call    fat_sthl
    defw    fat_work+2
    ret
