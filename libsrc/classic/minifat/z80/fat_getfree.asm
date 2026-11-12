;
; fat_getfree: count free clusters.
; A pointer argument is __z88dk_fastcall (HL).
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

PUBLIC  _fat_getfree

EXTERN  _cpm_fat_vol
EXTERN  fat_move_window
EXTERN  fat_st32
EXTERN  fat_work
EXTERN  fatwin
EXTERN  get_fat

; ff.c f_getfree FAT16/32 window scan. Count zero entries in n_fatent
; FAT slots (0 and 1 are never free on a valid volume). The scan does
; not read FSInfo; a mount may already have stored FSI_Free_Count.
; Cache: free_valid / free_clst; put_fat updates the count.
; HL -> DWORD out. L=0 success.
_fat_getfree:
    push    hl
    ld      a,(_cpm_fat_vol+25)
    or      a
    jr      Z,gf_scan               ;free count is not cached
    ld      de,(_cpm_fat_vol+28)
    ld      bc,(_cpm_fat_vol+30)
    jp      gf_store
gf_scan:
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT12                ;fs_type vs FAT12
    jp      Z,gf12                  ;walk entries; a sector tally spans
    ld      hl,0
    ld      (fat_work),hl           ;nfree
    ld      (fat_work+2),hl
    ld      de,(_cpm_fat_vol+8)     ;sect = fatbase
    ld      (fat_work+4),de
    ld      de,(_cpm_fat_vol+10)
    ld      (fat_work+6),de
    ld      de,(_cpm_fat_vol+4)     ;remaining = n_fatent
    ld      (fat_work+8),de
    ld      de,(_cpm_fat_vol+6)
    ld      (fat_work+10),de
gf_loop:
    ld      hl,(fat_work+8)
    ld      a,h
    or      l
    ld      de,(fat_work+10)
    or      d
    or      e
    jp      Z,gf_scanned            ;no FAT entries left to scan
    ld      de,(fat_work+4)
    ld      bc,(fat_work+6)
    call    fat_move_window         ;next FAT sector into fatwin
    jp      NC,gf_fail              ;FAT sector not read
    ld      hl,(fat_work+4)
    inc     hl
    ld      (fat_work+4),hl
    ld      a,h
    or      l
    jr      NZ,gf_sect              ;sector low did not wrap
    ld      hl,(fat_work+6)
    inc     hl
    ld      (fat_work+6),hl
gf_sect:
    ; One 16-bit tally per sector, then one 32-bit add. B=0 counts 256.
    ld      bc,256
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT32                ;fs_type vs FAT32
    jr      NZ,gf_wide              ;FAT16 has 256 entries here
    ld      bc,128
gf_wide:
    ld      a,(fat_work+10)         ;remaining >= 65536 fills this sector
    or      a
    jr      NZ,gf_full              ;remaining does not fit in 16 bits
    ld      a,(fat_work+11)
    or      a
    jr      NZ,gf_full              ;remaining is at least 2^24
    ld      hl,(fat_work+8)
    or      a
    sbc     hl,bc
    jr      NC,gf_full              ;this sector is full
    ld      a,(fat_work+8)          ;tail is 1..width-1
    ld      b,a
    ld      hl,fatwin
    call    gf_tally                ;count the short tail
    call    gf_add                  ;add that tail to nfree
    jp      gf_scanned
gf_full:
    push    bc
    ld      b,c                     ;0 = 256 FAT16 entries, 128 FAT32
    ld      hl,fatwin
    call    gf_tally                ;count a full sector
    call    gf_add                  ;add that sector to nfree
    pop     bc
    ld      hl,(fat_work+8)
    or      a
    sbc     hl,bc
    ld      (fat_work+8),hl
    jp      NC,gf_loop              ;remaining low did not borrow
    ld      hl,(fat_work+10)
    dec     hl
    ld      (fat_work+10),hl
    jp      gf_loop
gf_scanned:
    ld      a,1
    ld      (_cpm_fat_vol+25),a
    ld      de,(fat_work)
    ld      (_cpm_fat_vol+28),de
    ld      de,(fat_work+2)
    ld      (_cpm_fat_vol+30),de
    ld      bc,de
    ld      de,(fat_work)
gf_store:
    pop     hl
    call    fat_st32                ;store the free count
    ld      hl,0
    scf
    ret
gf_fail:
    pop     hl
    ld      hl,1
    or      a
    ret

; FAT12 free count. A 12-bit entry can cross a sector, so walk
; cluster 2 .. n_fatent-1 through get_fat. Carry clear fails the count.
gf12:
    ld      hl,2
    ld      (fat_work+8),hl         ;cursor
    ld      hl,0
    ld      (fat_work+10),hl
    ld      (fat_work),hl           ;nfree
    ld      (fat_work+2),hl
gf12_lp:
    ld      hl,(fat_work+8)
    ld      bc,(_cpm_fat_vol+4)
    or      a
    sbc     hl,bc
    ex      de,hl                   ;carry stays; the difference is unused
    ld      hl,(fat_work+10)
    ld      bc,(_cpm_fat_vol+6)
    sbc     hl,bc
    jr      NC,gf_scanned           ;cursor >= n_fatent
    ld      de,(fat_work+8)
    ld      bc,(fat_work+10)
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
    jr      NZ,gf12_used
    ld      de,1
    call    gf_add
gf12_used:
    ld      hl,(fat_work+8)
    inc     hl
    ld      (fat_work+8),hl
    ld      a,h
    or      l
    jr      NZ,gf12_lp
    ld      hl,(fat_work+10)
    inc     hl
    ld      (fat_work+10),hl
    jr      gf12_lp

; HL = FAT window, B = entries (0 means 256). DE = free count on return.
gf_tally:
    ld      de,0
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT32                ;fs_type vs FAT32
    jr      Z,gf32_lp               ;FAT32 entries are dwords
gf16_lp:
    ld      a,(hl+)                 ;FAT16 free: both bytes zero
    or      (hl+)
    jr      NZ,gf16_used            ;FAT16 slot is in use
    inc     de
gf16_used:
    djnz    gf16_lp                 ;FAT16 entries remain
    ret
gf32_lp:
    ld      a,(hl+)                 ;FAT32 free: 28-bit value zero
    or      (hl+)
    or      (hl+)
    ld      c,a
    ld      a,(hl+)
    and     $0F
    or      c
    jr      NZ,gf32_used            ;FAT32 slot is in use
    inc     de
gf32_used:
    djnz    gf32_lp                 ;FAT32 entries remain
    ret

; fat_work (nfree) += DE. DE is at most one sector of entries.
gf_add:
    ld      hl,(fat_work)
    add     hl,de                   ;nfree + sectors just counted
    ld      (fat_work),hl
    ret     NC                      ;nfree low did not wrap
    ld      hl,(fat_work+2)
    inc     hl
    ld      (fat_work+2),hl
    ret
