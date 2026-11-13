;
; fat_mount: mount FAT12, FAT16, or FAT32 from LBA 0 or an MBR.
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

PUBLIC  fat_mount
PUBLIC  _fat_mount

EXTERN  _cpm_fat_vol
EXTERN  asm_disk_initialize
EXTERN  clst_cache_sclust
EXTERN  fat_cwd
EXTERN  fat_fsi_dirty
EXTERN  fat_fsi_lba
EXTERN  fat_last_clst
EXTERN  fat_ld32
EXTERN  fat_move_window
EXTERN  fat_wflag
EXTERN  fat_winsect
EXTERN  fat_work
EXTERN  fatwin

DEFC    MAX_FAT12       = $0FF5
DEFC    MAX_FAT16       = $FFF5
DEFC    MAX_FAT32       = $0FFFFFF5
DEFC    MAX_FATSZ       = $1FFFFF
DEFC    MAX_LBA28       = $0FFFFFFF
DEFC    BPB_BytsPerSec  = 11
DEFC    BPB_SecPerClus  = 13
DEFC    BPB_RsvdSecCnt  = 14
DEFC    BPB_NumFATs     = 16
DEFC    BPB_RootEntCnt  = 17
DEFC    BPB_TotSec16    = 19
DEFC    BPB_FATSz16     = 22
DEFC    BPB_TotSec32    = 32
DEFC    BPB_FATSz32     = 36
DEFC    BPB_ExtFlags    = 40
DEFC    BPB_FSVer       = 42
DEFC    BPB_RootClus32  = 44
DEFC    BPB_FSInfo      = 48
DEFC    BS_55AA         = 510
DEFC    MBR_PTE         = 446
DEFC    SZ_PTE          = 16
DEFC    PTE_StLba       = 8

;------------------------------------------------------------------------------
; fat_check_vbr — ff.c check_fs (FAT/FAT32 only)
; Require 55AA, 512-byte sectors, csize 2^n and <= 64, reserved != 0, 1 or 2 FATs.
; JumpBoot is not checked. 55AA is required.
; C = looks like a FAT16/32 VBR (type decided later from nclst).
;------------------------------------------------------------------------------
fat_check_vbr:
    ld      a,(fatwin+BS_55AA)
    cp      $55                     ;sig byte $55
    jr      NZ,fat_check_fail       ;not a 55AA sector
    ld      a,(fatwin+BS_55AA+1)
    cp      $AA                     ;sig byte $AA
    jr      NZ,fat_check_fail       ;not a 55AA sector
    ld      a,(fatwin+BPB_BytsPerSec)
    or      a
    jr      NZ,fat_check_fail       ;not a 512-byte sector
    ld      a,(fatwin+BPB_BytsPerSec+1)
    cp      2                       ;512
    jr      NZ,fat_check_fail       ;not a 512-byte sector
    ld      a,(fatwin+BPB_SecPerClus)
    or      a
    jr      Z,fat_check_fail        ;SecPerClus is 0
    ld      b,a
    dec     a
    and     b
    jr      NZ,fat_check_fail       ;not 2^n
    ld      a,b
    cp      65                      ;64 KiB clusters do not fit the 16-bit math
    jr      C,fat_check_rsvd        ;csize is 64 sectors or less
    ld      a,19                    ;FR_INVALID_PARAMETER
    ld      (_cpm_fat_vol+27),a
    jr      fat_check_fail
fat_check_rsvd:
    ld      a,(fatwin+BPB_RsvdSecCnt)
    ld      hl,fatwin+BPB_RsvdSecCnt+1
    or      (hl)
    jr      Z,fat_check_fail        ;reserved count is 0
    ld      a,(fatwin+BPB_NumFATs)
    cp      1                       ;one FAT copy
    jr      Z,fat_check_ok          ;NumFATs is 1
    cp      2                       ;two FAT copies
    jr      NZ,fat_check_fail       ;not 1 or 2 FATs
fat_check_ok:
    scf
    ret
fat_check_fail:
    or      a
    ret

; Wait for ready, then SET FEATURES 8-bit. Cold CF is BSY after power-on;
; SET FEATURES issued while BSY is ignored (warm reset then works).
fat_ide_delay:
    xor     a
fat_ide_d0:
    ex      (sp),hl
    ex      (sp),hl
    dec     a
    jr      NZ,fat_ide_d0           ;spin is not finished
    ret

; 8 tries of disk_initialize with delay. C: ready. NC: still busy.
fat_ide_bringup:
    ld      b,8
fat_ide_br1:
    push    bc
    ld      l,0
    call    asm_disk_initialize     ;C: drive is ready
    pop     bc
    ret     C                       ;drive came ready
    call    fat_ide_delay           ;pause before another try
    djnz    fat_ide_br1             ;bring-up tries remain
    or      a
    ret

;------------------------------------------------------------------------------
; fat_mount — ff.c find_volume + mount_volume
; LBA 0 as SFD VBR; else four MBR primary PTEs (no GPT, no extended).
; nclst from (tsect - reserved - fats - rootsecs) / csize.
; nclst <= $0FF5 fails as FAT12. Spec 1.03 would call 4085 FAT16.
; nclst == $FFF5 stays FAT16. Spec 1.03 would call it FAT32. Above that, FAT32.
; FAT32 dirbase = BPB_RootClus32 (cluster); FAT16 dirbase = root LBA.
; OUT: C OK
;------------------------------------------------------------------------------
_fat_mount:
fat_mount:
    xor     a
    ld      (_cpm_fat_vol),a        ;type stays 0 until every check passes
    ld      (_cpm_fat_vol+26),a
    ld      (_cpm_fat_vol+27),a
    ld      b,8
fat_mount_cold:
    push    bc
    call    fat_ide_bringup         ;C: media is ready
    jr      C,fat_mount_up
    ld      a,3                     ;FR_NOT_READY
    ld      (_cpm_fat_vol+27),a
    jr      fat_mount_cold1
fat_mount_up:
    xor     a
    ld      (_cpm_fat_vol+27),a     ;a later check is not a disk error
    ld      (fat_wflag),a
    ld      (_cpm_fat_vol+25),a     ;free_valid
    ld      (fat_last_clst),a
    ld      (fat_last_clst+1),a
    ld      (fat_last_clst+2),a
    ld      (fat_last_clst+3),a
    ld      (fat_fsi_lba),a
    ld      (fat_fsi_lba+1),a
    ld      (fat_fsi_lba+2),a
    ld      (fat_fsi_lba+3),a
    ld      (fat_fsi_dirty),a
    ld      hl,clst_cache_sclust
    ld      (hl+),a
    ld      (hl+),a
    ld      (hl+),a
    ld      (hl),a
    ld      hl,$FFFF
    ld      (fat_winsect),hl
    ld      (fat_winsect+2),hl
    ld      bc,0
    ld      de,0
    call    fat_move_window         ;read LBA 0
    jr      C,fat_mount_lba0
    ld      a,1                     ;FR_DISK_ERR
    ld      (_cpm_fat_vol+27),a
    jr      fat_mount_cold1
fat_mount_lba0:
    call    fat_check_vbr           ;C: sector looks like FAT
    pop     bc
    jp      C,fat_parse_bpb         ;LBA 0 is a FAT VBR
    ld      a,(fatwin+BS_55AA)
    cp      $55                     ;MBR sig $55
    jr      NZ,fat_mount_cold2      ;not 55AA
    ld      a,(fatwin+BS_55AA+1)
    cp      $AA                     ;MBR sig $AA
    jr      NZ,fat_mount_cold2      ;not 55AA
    jr      fat_mount_mbr
fat_mount_cold1:
    pop     bc
fat_mount_cold2:
    djnz    fat_mount_cold          ;cold-start tries remain
    jp      fat_mount_fail

fat_mount_mbr:
    ld      hl,fatwin+MBR_PTE+PTE_StLba
    ld      de,fat_work
    ld      b,4
fat_mount_savept:
    push    bc
    ld      bc,4
    ldir
    ld      bc,SZ_PTE-4
    add     hl,bc
    pop     bc
    djnz    fat_mount_savept        ;partition slots remain
    ld      hl,fat_work
    ld      b,4
fat_mount_trypt:
    push    bc
    push    hl
    ld      e,(hl+)
    ld      d,(hl+)
    ld      c,(hl+)
    ld      b,(hl)
    ld      a,b
    or      c
    or      d
    or      e
    jr      Z,fat_mount_nextpt      ;start LBA is 0
    ld      a,b
    cp      (MAX_LBA28>>24)+1       ;high byte past $0FFFFFFF
    jr      NC,fat_mount_nextpt     ;start LBA above 28 bits
    call    fat_move_window         ;read this partition
    jr      C,fat_mount_ptok
    ld      a,1                     ;FR_DISK_ERR
    ld      (_cpm_fat_vol+27),a
    jr      fat_mount_nextpt
fat_mount_ptok:
    xor     a
    ld      (_cpm_fat_vol+27),a     ;this sector was read
    call    fat_check_vbr           ;C: PTE looks like FAT
    jr      C,fat_mount_gotpt       ;FAT VBR in this PTE
fat_mount_nextpt:
    pop     hl
    ld      bc,4
    add     hl,bc
    pop     bc
    djnz    fat_mount_trypt         ;primary PTEs remain
    jp      fat_mount_fail
fat_mount_gotpt:
    pop     hl
    pop     bc
fat_parse_bpb:
    ld      a,(fatwin+BPB_SecPerClus)
    ld      (_cpm_fat_vol+1),a      ;csize
    ld      a,(fatwin+BPB_NumFATs)
    ld      (_cpm_fat_vol+24),a     ;n_fats
    ld      hl,(fatwin+BPB_RootEntCnt)
    ld      (_cpm_fat_vol+2),hl     ;n_rootent
    ld      de,(fatwin+BPB_FATSz16)
    ld      a,d
    or      e
    jr      NZ,fat_mount_fsz        ;FATSz16 is set
    ld      de,(fatwin+BPB_FATSz32)
    ld      bc,(fatwin+BPB_FATSz32+2)
    jr      fat_mount_fsz32
fat_mount_fsz:
    ld      bc,0
fat_mount_fsz32:
    ld      (_cpm_fat_vol+20),de    ;fatsz
    ld      (_cpm_fat_vol+22),bc
    ld      a,b
    or      a
    jp      NZ,fat_mount_fail       ;fatsz >= $01000000
    ld      a,c
    cp      (MAX_FATSZ+1)>>16       ;high byte of $200000
    jp      NC,fat_mount_fail       ;fatsz >= $200000
    ld      hl,(fatwin+BPB_TotSec16)
    ld      a,h
    or      l
    jr      NZ,fat_mount_tsz16      ;TotSec16 is set
    ld      hl,(fatwin+BPB_TotSec32)
    ld      de,(fatwin+BPB_TotSec32+2)
    jr      fat_mount_tsz
fat_mount_tsz16:
    ld      de,0
fat_mount_tsz:
    ld      (fat_work+4),hl         ;tsect
    ld      (fat_work+6),de
    ld      hl,(_cpm_fat_vol+20)    ;fatsz
    ld      de,(_cpm_fat_vol+22)
    ld      a,(_cpm_fat_vol+24)
    cp      2                       ;n_fats vs 2
    jr      NZ,fat_mount_fatarea    ;only one FAT
    add     hl,hl                   ;fatsz * n_fats
    rl      de                      ;fatsz * n_fats
    jp      C,fat_mount_fail        ;CVE-2026-6682 analog
fat_mount_fatarea:
    ld      bc,(fatwin+BPB_RsvdSecCnt)
    add     hl,bc                   ;fat area + reserved sectors
    jr      NC,fat_mount_sy1        ;reserved add fits in 16 bits
    inc     de
    ld      a,d
    or      e
    jp      Z,fat_mount_fail        ;system area wrapped
fat_mount_sy1:
    ld      bc,(fatwin+BPB_FATSz16) ;HL stays the system-area low word
    ld      a,b
    or      c
    jr      Z,fat_mount_r32root     ;FATSz16 == 0
    ld      bc,(_cpm_fat_vol+2)     ;n_rootent
    ld      a,b
    or      c
    jp      Z,fat_mount_fail        ;FAT16 root count is 0
    ld      a,c
    and     $0F
    jp      NZ,fat_mount_fail       ;not a whole number of sectors
    srl     b
    rr      c
    srl     b
    rr      c
    srl     b
    rr      c
    srl     b
    rr      c                       ;root sectors = n_rootent/16
    jr      fat_mount_addroot
fat_mount_r32root:
    ld      bc,(fatwin+BPB_RootEntCnt) ;HL stays the system-area low word
    ld      a,b
    or      c
    jp      NZ,fat_mount_fail       ;RootEntCnt is not 0
    ld      bc,(fatwin+BPB_FSVer)
    ld      a,b
    or      c
    jp      NZ,fat_mount_fail       ;FSVer is not 0
    ld      bc,0                    ;FAT32 has no static root
    jr      fat_mount_addroot
fat_mount_addroot:
    add     hl,bc                   ;system sectors + root
    jr      NC,fat_mount_sy2        ;root add fits in 16 bits
    inc     de
    ld      a,d
    or      e
    jp      Z,fat_mount_fail        ;root area wrapped
fat_mount_sy2:
    ld      (fat_work+8),hl         ;sysect
    ld      (fat_work+10),de
    ld      hl,(fat_work+4)         ;tsect - sysect
    ld      bc,(fat_work+8)
    or      a
    sbc     hl,bc                   ;tsect - sysect
    ld      (fat_work+12),hl
    ld      hl,(fat_work+6)
    ld      bc,(fat_work+10)
    sbc     hl,bc
    ld      (fat_work+14),hl
    jp      C,fat_mount_fail        ;tsect < sysect
    ld      a,(_cpm_fat_vol+1)      ;csize = 2^n
    ld      b,0
fat_mount_log:
    srl     a
    jr      Z,fat_mount_shr         ;log2(csize) is in B
    inc     b
    jr      fat_mount_log
fat_mount_shr:
    ld      hl,(fat_work+12)
    ld      de,(fat_work+14)
    ld      a,b
    or      a
    jr      Z,fat_mount_ncl         ;csize is 1 sector
fat_mount_shrl:
    srl     d                       ;data sectors >> log2(csize)
    rr      e
    rr      h
    rr      l
    djnz    fat_mount_shrl          ;nclst is still shifting
fat_mount_ncl:
    ld      (fat_work+12),hl        ;nclst low
    ld      (fat_work+14),de        ;nclst high
    ld      a,h
    or      l
    or      d
    or      e
    jp      Z,fat_mount_fail        ;volume has no clusters
    ld      a,d
    cp      $10
    jp      NC,fat_mount_fail       ;nclst >= $10000000
    cp      $0F
    jr      NZ,fat_mount_band       ;below $0F000000
    ld      a,e
    inc     a
    jr      NZ,fat_mount_band       ;byte 2 is not $FF
    ld      a,h
    inc     a
    jr      NZ,fat_mount_band       ;byte 1 is not $FF
    ld      a,l
    cp      (MAX_FAT32 & $FF)+1     ;low byte past $0FFFFFF5
    jp      NC,fat_mount_fail       ;nclst > $0FFFFFF5
fat_mount_band:
    ld      a,d
    or      e
    jr      NZ,fat_mount_fat32      ;nclst does not fit FAT16
    ld      de,hl                   ;park low; high is 0
    ld      bc,MAX_FAT12+1
    or      a
    sbc     hl,bc
    jp      C,fat_mount_fat12       ;nclst <= $0FF5 (ChaN FAT12)
    ld      hl,de
    ld      bc,MAX_FAT16
    or      a
    sbc     hl,bc
    jr      Z,fat_mount_fat16       ;nclst is $FFF5
    jr      NC,fat_mount_fat32      ;nclst is above FAT16
fat_mount_fat16:
    ld      hl,(_cpm_fat_vol+2)     ;FAT32 shape, count in the FAT16 band
    ld      a,h
    or      l
    jp      Z,fat_mount_fail        ;FAT32 shape in the FAT16 band
    ld      a,FS_FAT16
    jr      fat_mount_type
fat_mount_fat32:
    ld      hl,(fatwin+BPB_FATSz16) ;FAT16 shape, count in the FAT32 band
    ld      a,h
    or      l
    jp      NZ,fat_mount_fail       ;FAT16 size in the FAT32 band
    ld      a,FS_FAT32
    jr      fat_mount_type
fat_mount_fat12:
    ld      hl,(_cpm_fat_vol+2)     ;FAT12 uses the FAT16 root shape
    ld      a,h
    or      l
    jp      Z,fat_mount_fail        ;FAT12 with an empty root
    ld      a,FS_FAT12
fat_mount_type:
    ld      (_cpm_fat_vol+26),a     ;publish to +0 only at fat_mount_ok
    ld      hl,(fat_work+12)
    ld      de,(fat_work+14)
    ld      bc,2
    add     hl,bc                   ;nclst + 2
    jr      NC,fat_mount_nfe        ;nclst+2 fits in 16 bits
    inc     de
    ld      a,d
    or      e
    jp      Z,fat_mount_fail        ;n_fatent wrapped
fat_mount_nfe:
    ld      (_cpm_fat_vol+4),hl     ;n_fatent
    ld      (_cpm_fat_vol+6),de
    ; fatsz must cover n_fatent (Windows/Linux volumes do; undersize
    ; would let get_fat/put_fat index into dir/data).
    ld      a,(_cpm_fat_vol+26)     ;pending type
    cp      FS_FAT12                ;pending type vs FAT12
    jr      Z,fat_mount_need12      ;FAT12 entries are 12 bits
    cp      FS_FAT32                ;pending type vs FAT32
    jr      Z,fat_mount_need32      ;FAT32 entries are 4 bytes
    ld      bc,255                  ;FAT16: (n_fatent+255)>>8
    add     hl,bc                   ;n_fatent + 255
    jr      NC,fat_mount_need16     ;FAT16 sum fits in 16 bits
    inc     de
fat_mount_need16:
    ld      l,h
    ld      h,e
    ld      e,d
    ld      d,0
    jr      fat_mount_needc
; Bytes in one FAT12 = (n_fatent * 3 + 1) / 2. That covers the
; second byte of the last entry, including a sector span.
; Sectors = ceil(bytes / 512). n_fatent fits in 16 bits here.
fat_mount_need12:
    push    hl
    add     hl,hl                   ;n_fatent * 2
    pop     bc
    add     hl,bc                   ;n_fatent * 3
    inc     hl                      ;+ 1
    srl     h
    rr      l                       ;/ 2 = bytes
    ld      bc,511
    add     hl,bc                   ;round up to a sector
    ld      a,h
    srl     a                       ;>> 9
    ld      l,a
    ld      h,0
    ld      de,0
    jr      fat_mount_needc
fat_mount_need32:
    ld      bc,127                  ;FAT32: (n_fatent+127)>>7
    add     hl,bc                   ;n_fatent + 127
    jr      NC,fat_mount_need32s    ;FAT32 sum fits in 16 bits
    inc     de
fat_mount_need32s:
    ld      b,7
fat_mount_need32l:
    srl     d                       ;(n_fatent+127) >> 7
    rr      e
    rr      h
    rr      l
    djnz    fat_mount_need32l       ;>>7 is not finished
fat_mount_needc:
    ld      bc,(_cpm_fat_vol+20)    ;fatsz - needed (C if fatsz < needed)
    ld      a,c
    sub     l                       ;fatsz - sectors the FAT needs
    ld      a,b
    sbc     a,h
    ld      bc,(_cpm_fat_vol+22)
    ld      a,c
    sbc     a,e
    ld      a,b
    sbc     a,d
    jp      C,fat_mount_fail        ;FAT does not cover n_fatent
    ld      hl,(fat_winsect)        ;fatbase = bsect + nrsv
    ld      bc,(fatwin+BPB_RsvdSecCnt)
    add     hl,bc                   ;volume LBA + reserved
    ld      (_cpm_fat_vol+8),hl
    ld      hl,(fat_winsect+2)
    ld      bc,0
    adc     hl,bc
    ld      a,h
    cp      (MAX_LBA28>>24)+1       ;high byte past $0FFFFFFF
    jp      NC,fat_mount_fail       ;fatbase above 28 bits
    ld      (_cpm_fat_vol+10),hl
    ld      hl,(fat_winsect)        ;database = bsect + sysect
    ld      bc,(fat_work+8)
    add     hl,bc                   ;volume LBA + sysect
    ld      (_cpm_fat_vol+16),hl
    ld      hl,(fat_winsect+2)
    ld      bc,(fat_work+10)
    adc     hl,bc
    ld      a,h
    cp      (MAX_LBA28>>24)+1       ;high byte past $0FFFFFFF
    jp      NC,fat_mount_fail       ;database above 28 bits
    ld      (_cpm_fat_vol+18),hl
    ld      a,(_cpm_fat_vol+26)     ;pending type
    cp      FS_FAT32                ;pending type vs FAT32
    jr      Z,fat_mount_r32         ;root cluster comes from the BPB
    ld      hl,(_cpm_fat_vol+16)    ;dirbase = database - rootsecs
    ld      bc,(_cpm_fat_vol+2)
    srl     b
    rr      c
    srl     b
    rr      c
    srl     b
    rr      c
    srl     b
    rr      c
    or      a
    sbc     hl,bc                   ;database - root sectors
    ld      (_cpm_fat_vol+12),hl
    ld      hl,(_cpm_fat_vol+18)
    ld      bc,0
    sbc     hl,bc
    ld      (_cpm_fat_vol+14),hl
    jp      fat_mount_ok
fat_mount_r32:
    ld      hl,(fatwin+BPB_RootClus32)
    ld      a,l
    sub     2                       ;RootClus - 2
    ld      a,h
    sbc     a,0
    ld      de,(fatwin+BPB_RootClus32+2)
    ld      a,e
    sbc     a,0
    ld      a,d
    sbc     a,0
    jp      C,fat_mount_fail        ;RootClus < 2
    ld      hl,(fatwin+BPB_RootClus32)
    ld      de,(_cpm_fat_vol+4)     ;n_fatent low
    or      a
    ld      a,l
    sub     e
    ld      a,h
    sbc     a,d
    push    af
    ld      hl,(fatwin+BPB_RootClus32+2)
    ld      de,(_cpm_fat_vol+6)     ;n_fatent high
    pop     af
    ld      a,l
    sbc     a,e
    ld      a,h
    sbc     a,d
    jp      NC,fat_mount_fail       ;RootClus >= n_fatent
    ld      hl,(fatwin+BPB_RootClus32)
    ld      (_cpm_fat_vol+12),hl
    ld      hl,(fatwin+BPB_RootClus32+2)
    ld      (_cpm_fat_vol+14),hl
    xor     a
    ld      (_cpm_fat_vol+2),a
    ld      (_cpm_fat_vol+3),a
    ld      a,(fatwin+BPB_ExtFlags+1)
    and     $80                     ;mirroring disabled: one active FAT
    jr      Z,fat_mount_ok          ;mirroring stays enabled
    ld      a,(fatwin+BPB_ExtFlags)
    and     $0F
    ld      b,a
    ld      a,(_cpm_fat_vol+24)     ;n_fats
    cp      b                       ;n_fats vs active index
    jp      C,fat_mount_fail        ;active index >= n_fats
    jp      Z,fat_mount_fail        ;active index == n_fats
    ld      a,b
    or      a
    jr      Z,fat_mount_act0        ;active FAT is already fatbase
    ld      hl,(_cpm_fat_vol+8)
    ld      de,(_cpm_fat_vol+20)
    add     hl,de                   ;fatbase of the active FAT
    ld      (_cpm_fat_vol+8),hl
    ld      hl,(_cpm_fat_vol+10)
    ld      de,(_cpm_fat_vol+22)
    adc     hl,de
    ld      a,h
    cp      (MAX_LBA28>>24)+1       ;high byte past $0FFFFFFF
    jp      NC,fat_mount_fail       ;active FAT above 28 bits
    ld      (_cpm_fat_vol+10),hl
fat_mount_act0:
    ld      a,1
    ld      (_cpm_fat_vol+24),a     ;do not mirror onto the inactive FAT
fat_mount_ok:
    ld      a,(_cpm_fat_vol+26)
    ld      (_cpm_fat_vol),a
    xor     a
    ld      (_cpm_fat_vol+26),a
    ld      (_cpm_fat_vol+27),a
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT32                ;mounted type vs FAT32
    jr      Z,fat_mount_cwd32       ;cwd is the FAT32 root
    xor     a
    ld      (fat_cwd),a
    ld      (fat_cwd+1),a
    ld      (fat_cwd+2),a
    ld      (fat_cwd+3),a
    ld      hl,0
    scf
    ret
fat_mount_cwd32:
    call    fat_seed_fsinfo         ;take a valid next-free hint
    ld      hl,(_cpm_fat_vol+12)    ;FAT32 root cluster
    ld      (fat_cwd),hl
    ld      hl,(_cpm_fat_vol+14)
    ld      (fat_cwd+2),hl
    ld      hl,0
    scf
    ret
fat_mount_fail:
    ld      a,(_cpm_fat_vol+27)     ;19 when the cluster size was refused
    ld      l,a
    xor     a
    ld      (_cpm_fat_vol),a
    ld      (_cpm_fat_vol+26),a
    ld      (_cpm_fat_vol+27),a
    ld      a,l
    or      a
    jr      NZ,fat_mount_code       ;1, 3, or 19 already in L
    ld      l,13                    ;FR_NO_FILESYSTEM
fat_mount_code:
    ld      h,0
    or      a
    ret

; FAT32 FSInfo (fatgen103 section 5). The VBR is still in fatwin.
; FSI_Nxt_Free is the cluster where the next search should start,
; usually the last cluster a driver allocated. FSI_Free_Count is the
; last known free total. Either field may be $FFFFFFFF (unknown).
; A bad info sector leaves the hint clear and the mount still succeeds.
fat_seed_fsinfo:
    ld      hl,(fatwin+BPB_FSInfo)
    ld      a,h
    or      l
    ret     Z                       ;FSInfo offset is 0
    inc     hl
    ld      a,h
    or      l
    ret     Z                       ;offset was $FFFF
    dec     hl
    ld      de,(fat_winsect)
    add     hl,de                   ;volume LBA + FSInfo
    ld      de,hl
    ld      hl,(fat_winsect+2)
    ld      bc,0
    adc     hl,bc
    ld      a,h
    cp      (MAX_LBA28>>24)+1       ;high byte past $0FFFFFFF
    ret     NC                      ;FSInfo above 28 bits; mount ok
    ld      bc,hl
    push    bc
    push    de
    call    fat_move_window         ;read the info sector
    jp      NC,seed_drop            ;info sector not read
    ld      hl,fatwin
    ld      a,(hl+)
    cp      $52                     ;LeadSig 'R'
    jp      NZ,seed_drop            ;not an info sector
    ld      a,(hl+)
    cp      $61                     ;LeadSig 'a'
    jp      NZ,seed_drop            ;not an info sector
    ld      a,(hl+)
    cp      $41                     ;LeadSig 'A'
    jp      NZ,seed_drop            ;not an info sector
    ld      a,(hl)
    cp      $41                     ;FSI_LeadSig 0x41615252
    jp      NZ,seed_drop            ;LeadSig is not RRaA
    ld      hl,fatwin+484
    ld      a,(hl+)
    cp      $72                     ;StrucSig 'r'
    jp      NZ,seed_drop            ;not an info sector
    ld      a,(hl+)
    cp      $72                     ;StrucSig 'r'
    jp      NZ,seed_drop            ;not an info sector
    ld      a,(hl+)
    cp      $41                     ;StrucSig 'A'
    jp      NZ,seed_drop            ;not an info sector
    ld      a,(hl)
    cp      $61                     ;FSI_StrucSig 0x61417272
    jp      NZ,seed_drop            ;StrucSig is not rrAa
    ld      a,(fatwin+510)
    cp      $55                     ;info sig $55
    jp      NZ,seed_drop            ;info sector has no 55AA
    ld      a,(fatwin+511)
    cp      $AA                     ;info sig $AA
    jp      NZ,seed_drop            ;info sector has no 55AA
    pop     de
    pop     bc
    ld      (fat_fsi_lba),de
    ld      (fat_fsi_lba+2),bc
    xor     a
    ld      (fat_fsi_dirty),a
    ld      hl,fatwin+492           ;FSI_Nxt_Free
    call    fat_ld32                ;load FSI_Nxt_Free
    ld      a,e
    and     d
    and     c
    and     b
    cp      $FF                     ;next-free vs $FF
    jr      Z,seed_free             ;next-free is unknown
    push    bc
    push    de
    ld      a,b
    or      c
    or      d
    jr      NZ,seed_nxt_hi          ;hint is above 65535
    ld      a,e
    cp      2                       ;hint vs cluster 2
    jr      C,seed_nxt_pop          ;hint is 0 or 1
seed_nxt_hi:
    ld      hl,(_cpm_fat_vol+4)
    ld      a,l
    sub     e                       ;n_fatent - hint
    ld      l,a
    ld      a,h
    sbc     a,d
    ld      h,a
    ld      a,(_cpm_fat_vol+6)
    sbc     a,c
    ld      c,a
    ld      a,(_cpm_fat_vol+7)
    sbc     a,b
    jr      C,seed_nxt_pop          ;hint >= n_fatent
    or      c
    or      h
    or      l
    jr      Z,seed_nxt_pop          ;hint == n_fatent
    pop     de
    pop     bc
    ld      (fat_last_clst),de
    ld      (fat_last_clst+2),bc
    jr      seed_free
seed_nxt_pop:
    pop     de
    pop     bc
seed_free:
    ld      hl,fatwin+488           ;FSI_Free_Count
    call    fat_ld32                ;load FSI_Free_Count
    ld      a,e
    and     d
    and     c
    and     b
    cp      $FF                     ;free count vs $FF
    ret     Z                       ;free count is unknown
    push    bc
    push    de
    ld      hl,(_cpm_fat_vol+4)     ;nclst = n_fatent - 2
    ld      de,(_cpm_fat_vol+6)
    ld      bc,2
    or      a
    sbc     hl,bc                   ;n_fatent - 2
    jr      NC,seed_ncl             ;nclst high did not borrow
    dec     de
seed_ncl:
    ld      (fat_work),hl
    ld      (fat_work+2),de
    pop     de                      ;free count
    pop     bc
    ld      hl,fat_work
    ld      a,(hl+)
    sub     e                       ;nclst - free count
    ld      a,(hl+)
    sbc     a,d
    ld      a,(hl+)
    sbc     a,c
    ld      a,(hl)
    sbc     a,b
    ret     C                       ;free > nclst
    ld      (_cpm_fat_vol+28),de
    ld      (_cpm_fat_vol+30),bc
    ld      a,1
    ld      (_cpm_fat_vol+25),a
    ret
seed_drop:
    pop     de
    pop     bc
    ret
