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

; Call. HL points at a 4-byte count. This is __z88dk_fastcall.
; Return. Success is L = 0 and carry set. H is 0.
; Return. Failure is L = 1 and carry clear. H is 0.
; Writes. The caller's count. A new scan also stores the free cache.
; Clobber. AF, BC, DE, HL.
_fat_getfree:
    push    hl
    ld      a,(_cpm_fat_vol+25)
    or      a
    jr      Z,gf_scan                       ; free_valid is clear. Scan the FAT.
    ld      hl,(_cpm_fat_vol+28)
    ex      de,hl
    ld      hl,(_cpm_fat_vol+30)
    ld      bc,hl
    jr      gf_store
gf_scan:
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT12                        ; fs_type against FAT12
    jp      Z,gf12                          ; FAT12 walks clusters. A window can split one entry.
    ld      hl,0
    ld      (fat_work),hl                   ; nfree
    ld      (fat_work+2),hl
    ld      hl,(_cpm_fat_vol+8)             ; sect = fatbase
    ld      (fat_work+4),hl
    ld      hl,(_cpm_fat_vol+10)
    ld      (fat_work+6),hl
    ld      hl,(_cpm_fat_vol+4)             ; remaining = n_fatent
    ld      (fat_work+8),hl
    ld      hl,(_cpm_fat_vol+6)
    ld      (fat_work+10),hl
gf_loop:
    ld      hl,(fat_work+8)
    ld      a,h
    or      l
    ld      hl,(fat_work+10)
    or      h
    or      l
    jp      Z,gf_scanned                    ; no FAT entries are left
    ld      hl,(fat_work+6)
    ld      bc,hl
    ld      hl,(fat_work+4)
    ex      de,hl
    call    fat_move_window                 ; read the next FAT sector into the window
    jp      NC,gf_fail                      ; the FAT sector was not read
    ld      hl,(fat_work+4)
    inc     hl
    ld      (fat_work+4),hl
    ld      a,h
    or      l
    jr      NZ,gf_sect                      ; the sector low word did not wrap
    ld      hl,(fat_work+6)
    inc     hl
    ld      (fat_work+6),hl
gf_sect:
    ; One 16-bit tally per sector, then one 32-bit add. B = 0 counts 256.
    ld      bc,256                          ; FAT16 has 256 entries in one sector
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT32                        ; fs_type against FAT32
    jr      NZ,gf_wide                      ; FAT16 uses the 256-entry width
    ld      bc,128                          ; FAT32 has 128 entries in one sector
gf_wide:
    ld      a,(fat_work+10)                 ; a high half means this sector is full
    or      a
    jr      NZ,gf_full                      ; the remainder does not fit in 16 bits
    ld      a,(fat_work+11)
    or      a
    jr      NZ,gf_full                      ; the remainder is at least 2^24
    ld      hl,(fat_work+8)
    ld      a,l                             ; C set when remaining < width
    sub     c
    ld      l,a
    ld      a,h
    sbc     a,b
    ld      h,a
    jr      NC,gf_full                      ; the remainder fills this sector
    ld      a,(fat_work+8)                  ; the tail is 1 to width-1
    ld      b,a
    ld      hl,fatwin
    call    gf_tally                        ; count the short tail
    call    gf_add                          ; add that tail to nfree
    jp      gf_scanned
gf_full:
    push    bc
    ld      b,c                             ; 0 means 256 FAT16 entries, or 128 FAT32
    ld      hl,fatwin
    call    gf_tally                        ; count a full sector
    call    gf_add                          ; add that sector to nfree
    pop     bc
    ld      hl,(fat_work+8)
    ld      a,l                             ; remaining - entries just scanned
    sub     c
    ld      l,a
    ld      a,h
    sbc     a,b
    ld      h,a
    ld      (fat_work+8),hl
    jp      NC,gf_loop                      ; the low word did not borrow
    ld      hl,(fat_work+10)
    dec     hl
    ld      (fat_work+10),hl
    jp      gf_loop
gf_scanned:
    ld      a,1
    ld      (_cpm_fat_vol+25),a             ; free_valid
    ld      hl,(fat_work)
    ld      (_cpm_fat_vol+28),hl
    ex      de,hl
    ld      hl,(fat_work+2)
    ld      (_cpm_fat_vol+30),hl
    ld      bc,hl
gf_store:
    pop     hl
    call    fat_st32                        ; store the free count
    ld      hl,0
    scf                                     ; L = 0 and carry set
    ret
gf_fail:
    pop     hl
    ld      hl,1
    or      a                               ; L = 1 and carry clear
    ret

; FAT12. One entry can cross a sector, so do not tally a window.
; Walk cluster 2 through n_fatent-1 with get_fat.
; There is no cycle counter.
gf12:
    ld      hl,2                            ; the walk starts at cluster 2
    ld      (fat_work+8),hl                 ; cursor
    ld      hl,0
    ld      (fat_work+10),hl
    ld      (fat_work),hl                   ; nfree
    ld      (fat_work+2),hl
gf12_lp:
    ld      hl,(fat_work+8)
    ld      de,(_cpm_fat_vol+4)
    ld      a,l
    sub     e
    ld      a,h
    sbc     a,d
    push    af                              ; borrow from the low half
    ld      hl,(fat_work+10)
    ld      de,(_cpm_fat_vol+6)
    pop     af
    ld      a,l
    sbc     a,e
    ld      a,h
    sbc     a,d
    jr      NC,gf_scanned                   ; cursor >= n_fatent
    ld      hl,(fat_work+8)
    ex      de,hl                           ; low half of the cursor, for get_fat
    ld      hl,(fat_work+10)
    ld      bc,hl
    push    bc
    push    de
    call    get_fat
    pop     hl
    pop     bc
    jp      NC,gf_fail                      ; a disk error or a bad cluster
    ld      a,d
    or      e
    or      c
    or      b
    jr      NZ,gf12_used                    ; the cluster is in use
    ld      de,1
    call    gf_add
gf12_used:
    ld      hl,(fat_work+8)
    inc     hl
    ld      (fat_work+8),hl
    ld      a,h
    or      l
    jr      NZ,gf12_lp                      ; the cursor low word did not wrap
    ld      hl,(fat_work+10)
    inc     hl
    ld      (fat_work+10),hl
    jr      gf12_lp

; Call. HL points at the FAT window. B is the entry count.
; Call. B = 0 means 256 entries.
; Return. DE is the number of free entries in that span.
; Clobber. AF, BC, DE, HL.
gf_tally:
    ld      de,0
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT32                        ; fs_type against FAT32
    jr      Z,gf32_lp                       ; FAT32 entries are 4 bytes
gf16_lp:
    ld      a,(hl+)                         ; a FAT16 free entry is two zero bytes
    or      (hl+)
    jr      NZ,gf16_used                    ; this FAT16 entry is in use
    inc     de
gf16_used:
    dec     b
    jr      NZ,gf16_lp                      ; entries left in this sector
    ret
gf32_lp:
    ld      a,(hl+)                         ; a FAT32 free entry has 28 zero bits
    or      (hl+)
    or      (hl+)
    ld      c,a
    ld      a,(hl+)
    and     $0F                             ; the top nibble is not part of the value
    or      c
    jr      NZ,gf32_used                    ; this FAT32 entry is in use
    inc     de
gf32_used:
    dec     b
    jr      NZ,gf32_lp                      ; entries left in this sector
    ret

; Call. DE is a count of at most one sector of entries.
; Return. fat_work holds nfree plus DE.
; Clobber. AF, HL. BC and DE stay.
; Writes. The free count at fat_work.
gf_add:
    ld      hl,(fat_work)
    add     hl,de                           ; nfree plus the count just made
    ld      (fat_work),hl
    ret     NC                              ; the low word did not wrap
    ld      hl,(fat_work+2)
    inc     hl
    ld      (fat_work+2),hl
    ret
