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
EXTERN  fat_clst_ok
EXTERN  fat_copy
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
    cp      $55                     ;55AA low byte
    jr      NZ,fat_check_fail       ;not a VBR
    ld      a,(fatwin+BS_55AA+1)
    cp      $AA                     ;55AA high byte
    jr      NZ,fat_check_fail       ;not a VBR
    ld      a,(fatwin+BPB_BytsPerSec)
    or      a
    jr      NZ,fat_check_fail       ;BytsPerSec low byte nonzero
    ld      a,(fatwin+BPB_BytsPerSec+1)
    cp      2                       ;512
    jr      NZ,fat_check_fail       ;not 512 bytes/sector
    ld      a,(fatwin+BPB_SecPerClus)
    or      a
    jr      Z,fat_check_fail        ;SecPerClus is 0
    ld      b,a
    dec     a
    and     b
    jr      NZ,fat_check_fail       ;not 2^n
    ld      a,b
    cp      65                      ;64 KiB clusters do not fit the 16-bit math
    jr      C,fat_check_rsvd        ;csize below 65
    ld      a,19                    ;FR_INVALID_PARAMETER
    ld      (_cpm_fat_vol+27),a
    jr      fat_check_fail
fat_check_rsvd:
    ld      a,(fatwin+BPB_RsvdSecCnt)
    ld      hl,fatwin+BPB_RsvdSecCnt+1
    or      (hl)
    jr      Z,fat_check_fail        ;reserved count is 0
    ld      a,(fatwin+BPB_NumFATs)
    cp      1                       ;NumFATs
    jr      Z,fat_check_ok          ;one FAT
    cp      2                       ;NumFATs
    jr      NZ,fat_check_fail       ;not 1 or 2 FATs
fat_check_ok:
    scf                             ;C: VBR shape accepted
    ret
fat_check_fail:
    or      a                       ;NC: not a FAT VBR
    ret

; Wait for ready, then SET FEATURES 8-bit. Cold CF is BSY after power-on;
; SET FEATURES issued while BSY is ignored (warm reset then works).
fat_ide_delay:
    xor     a
fat_ide_d0:
    ex      (sp),hl
    ex      (sp),hl
    dec     a
    jp      NZ,fat_ide_d0           ;delay not finished
    ret

; 8 tries of disk_initialize with delay. C: ready. NC: still busy.
fat_ide_bringup:
    ld      b,8
fat_ide_br1:
    push    bc
    ld      l,0
    call    asm_disk_initialize     ;C: drive ready
    pop     bc
    ret     C                       ;ready
    call    fat_ide_delay           ;pause before the next try
    dec     b
    jp      NZ,fat_ide_br1          ;tries left
    or      a                       ;NC: drive stayed busy
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
    call    fat_ide_bringup         ;C: drive came ready
    jp      C,fat_mount_up
    ld      a,3                     ;FR_NOT_READY
    ld      (_cpm_fat_vol+27),a
    jp      fat_mount_cold1
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
    call    fat_move_window         ;read LBA 0 into fatwin
    jp      C,fat_mount_lba0
    ld      a,1                     ;FR_DISK_ERR
    ld      (_cpm_fat_vol+27),a
    jp      fat_mount_cold1
fat_mount_lba0:
    call    fat_check_vbr           ;C: LBA 0 looks like a VBR
    pop     bc
    jp      C,fat_parse_bpb         ;superfloppy VBR
    ld      a,(fatwin+BS_55AA)
    cp      $55                     ;55AA low byte
    jp      NZ,fat_mount_cold2      ;not an MBR either
    ld      a,(fatwin+BS_55AA+1)
    cp      $AA                     ;55AA high byte
    jp      NZ,fat_mount_cold2      ;not an MBR either
    jp      fat_mount_mbr
fat_mount_cold1:
    pop     bc
fat_mount_cold2:
    dec     b
    jp      NZ,fat_mount_cold       ;cold-start tries left
    jp      fat_mount_fail

fat_mount_mbr:
    ld      hl,fatwin+MBR_PTE+PTE_StLba
    ld      de,fat_work
    ld      b,4
fat_mount_savept:
    push    bc
    ld      bc,4
    call    fat_copy                ;PTE start LBA; byte copy, not ldir
    ld      bc,SZ_PTE-4
    add     hl,bc
    pop     bc
    dec     b
    jp      NZ,fat_mount_savept     ;four primary PTEs
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
    jr      Z,fat_mount_nextpt      ;empty partition
    ld      a,b
    cp      (MAX_LBA28>>24)+1       ;high byte past $0FFFFFFF
    jr      NC,fat_mount_nextpt     ;start LBA above 28 bits
    call    fat_move_window         ;read that partition VBR
    jr      C,fat_mount_ptok
    ld      a,1                     ;FR_DISK_ERR
    ld      (_cpm_fat_vol+27),a
    jr      fat_mount_nextpt
fat_mount_ptok:
    xor     a
    ld      (_cpm_fat_vol+27),a     ;this sector was read
    call    fat_check_vbr           ;C: this PTE is a FAT VBR
    jr      C,fat_mount_gotpt       ;use this partition
fat_mount_nextpt:
    pop     hl
    ld      bc,4
    add     hl,bc
    pop     bc
    dec     b
    jp      NZ,fat_mount_trypt      ;more primary PTEs
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
    ld      hl,(fatwin+BPB_FATSz16)
    ex      de,hl
    ld      a,d
    or      e
    jr      NZ,fat_mount_fsz        ;FATSz16 is nonzero
    ld      hl,(fatwin+BPB_FATSz32+2)
    ld      bc,hl
    ld      hl,(fatwin+BPB_FATSz32)
    ex      de,hl
    jr      fat_mount_fsz32
fat_mount_fsz:
    ld      bc,0
fat_mount_fsz32:
    ex      de,hl
    ld      (_cpm_fat_vol+20),hl    ;fatsz
    ld      hl,bc
    ld      (_cpm_fat_vol+22),hl
    ld      a,b
    or      a
    jp      NZ,fat_mount_fail       ;fatsz >= $01000000
    ld      a,c
    cp      (MAX_FATSZ+1)>>16       ;high byte of $200000
    jp      NC,fat_mount_fail       ;fatsz >= $200000
    ld      hl,(fatwin+BPB_TotSec16)
    ld      a,h
    or      l
    jr      NZ,fat_mount_tsz16      ;TotSec16 is nonzero
    ld      hl,(fatwin+BPB_TotSec32+2)
    ex      de,hl
    ld      hl,(fatwin+BPB_TotSec32)
    jr      fat_mount_tsz
fat_mount_tsz16:
    ld      de,0
fat_mount_tsz:
    ld      (fat_work+4),hl         ;tsect
    ex      de,hl
    ld      (fat_work+6),hl
    ld      hl,(_cpm_fat_vol+22)
    ex      de,hl
    ld      hl,(_cpm_fat_vol+20)    ;fatsz
    ld      a,(_cpm_fat_vol+24)
    cp      2                       ;two FATs
    jr      NZ,fat_mount_fatarea    ;single FAT
    add     hl,hl                   ;fatsz<<1; high half is rl de
    rl      de                      ;fatsz * n_fats
    jp      C,fat_mount_fail        ;CVE-2026-6682 analog
fat_mount_fatarea:
    ld      bc,hl
    ld      hl,(fatwin+BPB_RsvdSecCnt)
    add     hl,bc                   ;reserved + FAT area
    jr      NC,fat_mount_sy1        ;sum fits in 16 bits
    inc     de
    ld      a,d
    or      e
    jp      Z,fat_mount_fail        ;high half wrapped to 0
fat_mount_sy1:
    push    hl
    ld      hl,(fatwin+BPB_FATSz16)
    ld      a,h
    or      l
    pop     hl
    jr      Z,fat_mount_r32root     ;FATSz16 == 0
    push    hl
    ld      hl,(_cpm_fat_vol+2)     ;n_rootent
    ld      a,h
    or      l
    jr      Z,fat_mount_rootbad     ;FAT16 root count is 0
    ld      a,l
    and     $0F
    jr      NZ,fat_mount_rootbad    ;not a whole number of sectors
    ld      bc,hl
    pop     hl
    ld      a,b
    or      a                       ;n_rootent >> 4 via rra, not srl
    rra
    ld      b,a
    ld      a,c
    rra
    ld      c,a
    ld      a,b
    or      a
    rra
    ld      b,a
    ld      a,c
    rra
    ld      c,a
    ld      a,b
    or      a
    rra
    ld      b,a
    ld      a,c
    rra
    ld      c,a
    ld      a,b
    or      a
    rra
    ld      b,a
    ld      a,c
    rra
    ld      c,a                     ;root sectors = n_rootent/16
    jr      fat_mount_addroot
fat_mount_r32root:
    push    hl
    ld      hl,(fatwin+BPB_RootEntCnt)
    ld      a,h
    or      l
    jr      NZ,fat_mount_rootbad    ;FAT32 root count must be 0
    ld      a,(fatwin+BPB_FSVer)
    ld      hl,fatwin+BPB_FSVer+1
    or      (hl)
    jr      NZ,fat_mount_rootbad    ;FSVer must be 0
    pop     hl
    ld      bc,0                    ;FAT32 has no static root
    jr      fat_mount_addroot
fat_mount_rootbad:
    pop     hl
    jp      fat_mount_fail
fat_mount_addroot:
    add     hl,bc                   ;add static root sectors
    jr      NC,fat_mount_sy2        ;sum fits in 16 bits
    inc     de
    ld      a,d
    or      e
    jp      Z,fat_mount_fail        ;high half wrapped to 0
fat_mount_sy2:
    ld      (fat_work+8),hl         ;sysect
    ex      de,hl
    ld      (fat_work+10),hl
    ld      hl,(fat_work+8)
    ld      bc,hl
    ld      hl,(fat_work+4)         ;tsect - sysect
    sub     hl,bc                   ;tsect - sysect
    ld      (fat_work+12),hl
    ld      hl,(fat_work+10)
    ld      bc,hl
    ld      hl,(fat_work+6)
    ld      a,l
    sbc     a,c
    ld      l,a
    ld      a,h
    sbc     a,b
    ld      h,a
    ld      (fat_work+14),hl
    jp      C,fat_mount_fail        ;tsect < sysect
    ld      a,(_cpm_fat_vol+1)      ;csize = 2^n
    ld      b,0
fat_mount_log:
    or      a                       ;csize >> 1; rra leaves Z stale
    rra
    or      a
    jr      Z,fat_mount_shr         ;log2(csize) is in B
    inc     b
    jr      fat_mount_log
fat_mount_shr:
    ld      hl,(fat_work+14)
    ex      de,hl
    ld      hl,(fat_work+12)
    ld      a,b
    or      a
    jr      Z,fat_mount_ncl         ;no divide: nclst = data sectors
fat_mount_shrl:
    ld      a,d
    or      a                       ;nclst >>= 1 through rra
    rra
    ld      d,a
    ld      a,e
    rra
    ld      e,a
    ld      a,h
    rra
    ld      h,a
    ld      a,l
    rra
    ld      l,a
    dec     b
    jp      NZ,fat_mount_shrl       ;shifts left
fat_mount_ncl:
    ld      (fat_work+12),hl        ;nclst low
    ex      de,hl
    ld      (fat_work+14),hl        ;nclst high
    ld      a,h
    or      l
    or      d
    or      e
    jp      Z,fat_mount_fail        ;no data clusters
    ld      a,h
    cp      $10
    jp      NC,fat_mount_fail       ;nclst >= $10000000
    cp      $0F
    jr      NZ,fat_mount_band       ;below $0F000000
    ld      a,l
    inc     a
    jr      NZ,fat_mount_band       ;byte 2 is not $FF
    ld      a,d
    inc     a
    jr      NZ,fat_mount_band       ;byte 1 is not $FF
    ld      a,e
    cp      (MAX_FAT32 & $FF)+1     ;low byte past $0FFFFFF5
    jp      NC,fat_mount_fail       ;nclst > $0FFFFFF5
fat_mount_band:
    ld      a,h
    or      l
    jr      NZ,fat_mount_fat32      ;nclst above 65535
    ld      hl,de                   ;low still in DE
    ld      bc,MAX_FAT12+1
    sub     hl,bc                   ;nclst - ($0FF5+1)
    jp      C,fat_mount_fat12       ;nclst <= $0FF5
    ld      hl,de
    ld      bc,MAX_FAT16
    sub     hl,bc                   ;nclst - $FFF5
    jr      Z,fat_mount_fat16       ;$FFF5 stays FAT16
    jr      NC,fat_mount_fat32      ;above $FFF5 is FAT32
fat_mount_fat16:
    ld      hl,(_cpm_fat_vol+2)     ;FAT32 shape, count in the FAT16 band
    ld      a,h
    or      l
    jp      Z,fat_mount_fail        ;FAT16 with an empty root
    ld      a,FS_FAT16
    jr      fat_mount_type
fat_mount_fat32:
    ld      hl,(fatwin+BPB_FATSz16) ;FAT16 shape, count in the FAT32 band
    ld      a,h
    or      l
    jp      NZ,fat_mount_fail       ;FAT32 shape still has FATSz16
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
    ld      hl,(fat_work+14)
    ex      de,hl
    ld      hl,(fat_work+12)
    ld      bc,2
    add     hl,bc                   ;nclst + 2 = n_fatent
    jr      NC,fat_mount_nfe        ;sum fits in 16 bits
    inc     de
    ld      a,d
    or      e
    jp      Z,fat_mount_fail        ;n_fatent wrapped
fat_mount_nfe:
    ld      (_cpm_fat_vol+4),hl     ;n_fatent
    ex      de,hl
    ld      (_cpm_fat_vol+6),hl
    ld      hl,(_cpm_fat_vol+4)
    ld      de,(_cpm_fat_vol+6)
    ld      a,(_cpm_fat_vol+26)     ;pending type
    cp      FS_FAT12                ;pending type vs FAT12
    jr      Z,fat_mount_need12      ;FAT12 entries are 12 bits
    cp      FS_FAT32                ;pending type
    jr      Z,fat_mount_need32      ;FAT32 entries are 4 bytes
    ld      bc,255
    add     hl,bc                   ;round FAT16 bytes up
    jr      NC,fat_mount_need16     ;sum fits in 16 bits
    inc     de
fat_mount_need16:
    ld      l,h
    ld      h,e
    ld      e,d
    ld      d,0
    jr      fat_mount_needc
fat_mount_need12:
    push    hl
    add     hl,hl                   ;n_fatent * 2
    pop     bc
    add     hl,bc                   ;n_fatent * 3
    inc     hl                      ;+ 1
    or      a
    ld      a,h
    rra
    ld      h,a
    ld      a,l
    rra
    ld      l,a                     ;bytes = (n_fatent * 3 + 1) / 2
    ld      bc,511
    add     hl,bc
    or      a
    ld      a,h
    rra
    ld      l,a                     ;(bytes + 511) >> 9
    ld      h,0
    ld      de,0
    jr      fat_mount_needc
fat_mount_need32:
    ld      bc,127
    add     hl,bc                   ;round FAT32 bytes up
    jr      NC,fat_mount_need32s    ;sum fits in 16 bits
    inc     de
fat_mount_need32s:
    ld      b,7
fat_mount_need32l:
    ld      a,d
    or      a                       ;needed bytes >>= 1 via rra
    rra
    ld      d,a
    ld      a,e
    rra
    ld      e,a
    ld      a,h
    rra
    ld      h,a
    ld      a,l
    rra
    ld      l,a
    dec     b
    jp      NZ,fat_mount_need32l    ;seven shifts left
fat_mount_needc:
    ld      bc,(_cpm_fat_vol+20)    ;fatsz - needed (C if fatsz < needed)
    ld      a,c
    sub     l                       ;fatsz - bytes the FAT must hold
    ld      a,b
    sbc     a,h
    ld      bc,(_cpm_fat_vol+22)
    ld      a,c
    sbc     a,e
    ld      a,b
    sbc     a,d
    jp      C,fat_mount_fail        ;FAT is shorter than the clusters
    ld      hl,(fatwin+BPB_RsvdSecCnt)
    ld      bc,hl
    ld      hl,(fat_winsect)        ;fatbase = bsect + nrsv
    add     hl,bc                   ;fatbase = volbase + reserved
    ld      (_cpm_fat_vol+8),hl
    ld      hl,(fat_winsect+2)
    ld      bc,0
    ld      a,l
    adc     a,c
    ld      l,a
    ld      a,h
    adc     a,b
    cp      (MAX_LBA28>>24)+1       ;high byte past $0FFFFFFF
    jp      NC,fat_mount_fail       ;fatbase above 28 bits
    ld      h,a
    ld      (_cpm_fat_vol+10),hl
    ld      hl,(fat_work+8)
    ld      bc,hl
    ld      hl,(fat_winsect)        ;database = bsect + sysect
    add     hl,bc                   ;database = volbase + sysect
    ld      (_cpm_fat_vol+16),hl
    ld      hl,(fat_work+10)
    ld      bc,hl
    ld      hl,(fat_winsect+2)
    ld      a,l
    adc     a,c
    ld      l,a
    ld      a,h
    adc     a,b
    cp      (MAX_LBA28>>24)+1       ;high byte past $0FFFFFFF
    jp      NC,fat_mount_fail       ;database above 28 bits
    ld      h,a
    ld      (_cpm_fat_vol+18),hl
    ld      a,(_cpm_fat_vol+26)     ;pending type
    cp      FS_FAT32                ;pending type
    jr      Z,fat_mount_r32         ;FAT32 dirbase is RootClus
    ld      hl,(_cpm_fat_vol+2)
    ld      bc,hl
    ld      hl,(_cpm_fat_vol+16)    ;dirbase = database - rootsecs
    ld      a,b
    or      a                       ;root sectors = n_rootent >> 4
    rra
    ld      b,a
    ld      a,c
    rra
    ld      c,a
    ld      a,b
    or      a
    rra
    ld      b,a
    ld      a,c
    rra
    ld      c,a
    ld      a,b
    or      a
    rra
    ld      b,a
    ld      a,c
    rra
    ld      c,a
    ld      a,b
    or      a
    rra
    ld      b,a
    ld      a,c
    rra
    ld      c,a
    sub     hl,bc                   ;database - root sectors
    ld      (_cpm_fat_vol+12),hl
    ld      hl,(_cpm_fat_vol+18)
    ld      a,l
    sbc     a,0
    ld      l,a
    ld      a,h
    sbc     a,0
    ld      h,a
    ld      (_cpm_fat_vol+14),hl
    jr      fat_mount_ok
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
    jr      Z,fat_mount_ok          ;mirroring on
    ld      a,(fatwin+BPB_ExtFlags)
    and     $0F
    ld      b,a
    ld      a,(_cpm_fat_vol+24)     ;n_fats
    cp      b                       ;active index vs n_fats
    jp      C,fat_mount_fail        ;active index >= n_fats
    jp      Z,fat_mount_fail        ;active index == n_fats
    ld      a,b
    or      a                       ;active index 0
    jr      Z,fat_mount_act0        ;active FAT is already fatbase
    ld      hl,(_cpm_fat_vol+8)
    ld      de,(_cpm_fat_vol+20)
    add     hl,de                   ;active FAT is fatbase + fatsz
    ld      (_cpm_fat_vol+8),hl
    ld      hl,(_cpm_fat_vol+10)
    ld      de,(_cpm_fat_vol+22)
    ld      a,l
    adc     a,e
    ld      l,a
    ld      a,h
    adc     a,d
    cp      (MAX_LBA28>>24)+1       ;high byte past $0FFFFFFF
    jp      NC,fat_mount_fail       ;active FAT above 28 bits
    ld      h,a
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
    cp      FS_FAT32                ;mounted type
    jr      Z,fat_mount_cwd32       ;cwd is the FAT32 root cluster
    xor     a
    ld      (fat_cwd),a
    ld      (fat_cwd+1),a
    ld      (fat_cwd+2),a
    ld      (fat_cwd+3),a
    ld      hl,0
    scf                             ;C: FAT16 mount ok
    ret
fat_mount_cwd32:
    call    fat_seed_fsinfo         ;read FSInfo; mount still succeeds
    ld      hl,(_cpm_fat_vol+12)    ;FAT32 root cluster
    ld      (fat_cwd),hl
    ld      hl,(_cpm_fat_vol+14)
    ld      (fat_cwd+2),hl
    ld      hl,0
    scf                             ;C: FAT32 mount ok
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
    or      a                       ;NC: mount failed
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
    ex      de,hl                   ;DE = sector offset
    ld      hl,(fat_winsect)
    add     hl,de                   ;volbase + FSInfo offset
    ex      de,hl                   ;DE = low sum; carry stays
    ld      hl,(fat_winsect+2)
    ld      a,l
    adc     a,0
    ld      l,a
    ld      a,h
    adc     a,0
    cp      (MAX_LBA28>>24)+1       ;high byte past $0FFFFFFF
    ret     NC                      ;FSInfo above 28 bits; mount ok
    ld      h,a
    ld      bc,hl
    push    bc
    push    de
    call    fat_move_window         ;C: info sector in fatwin
    jp      NC,seed_drop            ;unreadable; mount still ok
    ld      hl,fatwin
    ld      a,(hl+)
    cp      $52                     ;LeadSig 'R'
    jp      NZ,seed_drop            ;bad lead signature
    ld      a,(hl+)
    cp      $61                     ;LeadSig 'a'
    jp      NZ,seed_drop            ;bad lead signature
    ld      a,(hl+)
    cp      $41                     ;LeadSig 'A'
    jp      NZ,seed_drop            ;bad lead signature
    ld      a,(hl)
    cp      $41                     ;FSI_LeadSig 0x41615252
    jp      NZ,seed_drop            ;bad lead signature
    ld      hl,fatwin+484
    ld      a,(hl+)
    cp      $72                     ;StrucSig 'r'
    jp      NZ,seed_drop            ;bad structure signature
    ld      a,(hl+)
    cp      $72                     ;StrucSig 'r'
    jp      NZ,seed_drop            ;bad structure signature
    ld      a,(hl+)
    cp      $41                     ;StrucSig 'A'
    jp      NZ,seed_drop            ;bad structure signature
    ld      a,(hl)
    cp      $61                     ;FSI_StrucSig 0x61417272
    jp      NZ,seed_drop            ;bad structure signature
    ld      a,(fatwin+510)
    cp      $55                     ;55AA low byte
    jp      NZ,seed_drop            ;info sector has no 55AA
    ld      a,(fatwin+511)
    cp      $AA                     ;55AA high byte
    jp      NZ,seed_drop            ;info sector has no 55AA
    pop     hl
    ld      (fat_fsi_lba),hl
    pop     hl
    ld      (fat_fsi_lba+2),hl
    xor     a
    ld      (fat_fsi_dirty),a
    ld      hl,fatwin+492           ;FSI_Nxt_Free
    call    fat_ld32                ;FSI_Nxt_Free into BCDE
    ld      a,e
    and     d
    and     c
    and     b
    cp      $FF                     ;all $FF means unknown
    jr      Z,seed_free             ;no next-free hint
    call    fat_clst_ok             ;C: hint is not a cluster
    jr      C,seed_free             ;hint out of range
    ld      hl,de
    ld      (fat_last_clst),hl
    ld      hl,bc
    ld      (fat_last_clst+2),hl
seed_free:
    ld      hl,fatwin+488           ;FSI_Free_Count
    call    fat_ld32                ;FSI_Free_Count into BCDE
    ld      a,e
    and     d
    and     c
    and     b
    cp      $FF                     ;all $FF means unknown
    ret     Z                       ;free count unknown
    push    bc
    push    de
    ld      hl,(_cpm_fat_vol+4)     ;nclst = n_fatent - 2
    ld      a,l
    sub     2                       ;n_fatent - 2 = nclst
    ld      l,a
    ld      a,h
    sbc     a,0
    ld      h,a
    ld      (fat_work),hl
    ld      hl,(_cpm_fat_vol+6)
    ld      a,l
    sbc     a,0
    ld      l,a
    ld      a,h
    sbc     a,0
    ld      h,a
    ld      (fat_work+2),hl
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
    ld      hl,de
    ld      (_cpm_fat_vol+28),hl
    ld      hl,bc
    ld      (_cpm_fat_vol+30),hl
    ld      a,1
    ld      (_cpm_fat_vol+25),a
    ret
seed_drop:
    pop     hl
    pop     hl
    ret
