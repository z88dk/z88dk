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
EXTERN  fat_rlde
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

; Check the sector in fatwin.
; 55 AA is required at offset 510.
; There is no JumpBoot check.
; BPB_Media is never read.
; BytsPerSec at offset 11 must be 512.
; csize at offset 13 must be 2^n.
; SecPerClus of 65 or more stores 19.
; 19 is a cluster size of 64 KiB or more.
; The reserved count at offset 14 must not be zero.
; One or two FATs are allowed at offset 16.
; Call. No arguments. The sector is already in fatwin.
; Return. Carry is set when every check passes.
; Return. Carry is clear when a check fails.
; Writes. SecPerClus of 65 or more stores 19 at _cpm_fat_vol+27.
; Clobber. AF, B, HL. C and DE stay.
fat_check_vbr:
    ld      a,(fatwin+BS_55AA)
    cp      $55                             ; offset 510 low byte
    jr      NZ,fat_check_fail               ; offset 510 is not $55
    ld      a,(fatwin+BS_55AA+1)
    cp      $AA                             ; offset 510 high byte
    jr      NZ,fat_check_fail               ; offset 510 is not $AA
    ld      a,(fatwin+BPB_BytsPerSec)
    or      a
    jr      NZ,fat_check_fail               ; offset 11 low byte is not zero
    ld      a,(fatwin+BPB_BytsPerSec+1)
    cp      2                               ; 512
    jr      NZ,fat_check_fail               ; offset 11 is not 512
    ld      a,(fatwin+BPB_SecPerClus)
    or      a
    jr      Z,fat_check_fail                ; offset 13 is zero
    ld      b,a
    dec     a
    and     b
    jr      NZ,fat_check_fail               ; csize is not 2^n
    ld      a,b
    cp      65                              ; SecPerClus of 65 or more
    jr      C,fat_check_rsvd                ; SecPerClus is below 65
    ld      a,19                            ; cluster size of 64 KiB or more
    ld      (_cpm_fat_vol+27),a
    jr      fat_check_fail
; The reserved count and the FAT count still need a check.
fat_check_rsvd:
    ld      a,(fatwin+BPB_RsvdSecCnt)
    ld      hl,fatwin+BPB_RsvdSecCnt+1
    or      (hl)
    jr      Z,fat_check_fail                ; offset 14 is zero
    ld      a,(fatwin+BPB_NumFATs)
    cp      1                               ; one FAT
    jr      Z,fat_check_ok                  ; offset 16 is one FAT
    cp      2                               ; two FATs
    jr      NZ,fat_check_fail               ; offset 16 is not one or two FATs
; The sector can be a volume boot record. The type comes later.
fat_check_ok:
    scf                                     ; carry is set
    ret
; A check failed. Carry is clear.
fat_check_fail:
    or      a                               ; clear carry
    ret

; Burn time between bring-up tries.
; Call. No arguments.
; Return. A is 0 and carry is clear.
; Clobber. AF. BC, DE, and HL stay.
fat_ide_delay:
    xor     a                               ; clear A and carry
; The count in A has not wrapped back to zero.
fat_ide_d0:
    ex      (sp),hl                         ; burn time
    ex      (sp),hl                         ; restore HL
    dec     a
    jp      NZ,fat_ide_d0                   ; delay not finished
    ret

; Ask the drive until it is ready.
; Call. No arguments. L is set to 0 for asm_disk_initialize.
; Return. Carry is set when the drive is ready.
; Return. Carry is clear after eight busy tries.
; Clobber. AF, B, DE, HL. C stays.
fat_ide_bringup:
    ld      b,8
; One bring-up try. B counts the tries that remain.
fat_ide_br1:
    push    bc
    ld      l,0                             ; drive 0
    call    asm_disk_initialize             ; ready is carry set
    pop     bc
    ret     C                               ; the drive is ready
    call    fat_ide_delay                   ; pause before another try
    dec     b
    jp      NZ,fat_ide_br1                  ; tries left
    or      a                               ; eight tries stayed busy
    ret

; Mount FAT12, FAT16, or FAT32 from LBA 0 or an MBR.
; SFD is LBA 0.
; Otherwise the code tries four primary MBR partitions.
; The partition entry is 16 bytes at offset 446.
; The start LBA is at byte 8 of that entry.
; There is no partition-type check.
; GPT and extended partitions fail the volume boot record check.
; Call. fat_mount has no arguments.
; Return. Success leaves L at 0, H at 0, and carry set.
; Return. Failure leaves H at 0 and carry clear.
; Return. L is 1 for a sector error, 3 when not ready, 13 for no filesystem, or 19 for a cluster of 64 KiB or more.
; Writes. The path stores 1, 3, or 19 at _cpm_fat_vol+27 and returns that value in L.
; Writes. The fail exit clears +27. L is 13 when that byte was 0.
; Writes. A later f_* call reads L.
; Writes. fs_type is stored at _cpm_fat_vol only after every check.
; Clobber. AF, BC, DE, HL.
_fat_mount:
fat_mount:
    xor     a
    ld      (_cpm_fat_vol),a                ; fs_type stays 0 until every check passes
    ld      (_cpm_fat_vol+26),a
    ld      (_cpm_fat_vol+27),a
    ld      b,8
; One cold-start try. A miss retries while B remains.
fat_mount_cold:
    push    bc
    call    fat_ide_bringup                 ; carry means the drive is ready
    jp      C,fat_mount_up
    ld      a,3                             ; 3 means the drive is not ready
    ld      (_cpm_fat_vol+27),a
    jp      fat_mount_cold1
; The drive is ready. Clear the old volume state.
fat_mount_up:
    xor     a
    ld      (_cpm_fat_vol+27),a             ; a later miss is not a sector error
    ld      (fat_wflag),a
    ld      (_cpm_fat_vol+25),a             ; free count is not valid yet
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
    ld      (fat_winsect),hl                ; no sector is in the window
    ld      (fat_winsect+2),hl
    ld      bc,0
    ld      de,0
    call    fat_move_window                 ; read LBA 0
    jp      C,fat_mount_lba0
    ld      a,1                             ; 1 is a sector error
    ld      (_cpm_fat_vol+27),a
    jp      fat_mount_cold1
; LBA 0 is in the window.
fat_mount_lba0:
    call    fat_check_vbr                   ; carry means a volume boot record
    pop     bc
    jp      C,fat_parse_bpb                 ; SFD is LBA 0
    ld      a,(fatwin+BS_55AA)
    cp      $55                             ; offset 510 low byte
    jp      NZ,fat_mount_cold2              ; not an MBR either
    ld      a,(fatwin+BS_55AA+1)
    cp      $AA                             ; offset 510 high byte
    jp      NZ,fat_mount_cold2              ; not an MBR either
    jp      fat_mount_mbr
; Pop the saved try count, then maybe retry.
fat_mount_cold1:
    pop     bc
; Cold-start tries remain, or the mount fails.
fat_mount_cold2:
    dec     b
    jp      NZ,fat_mount_cold               ; cold-start tries left
    jp      fat_mount_fail

; Four primary entries. The type byte is not read.
fat_mount_mbr:
    ld      hl,fatwin+MBR_PTE+PTE_StLba
    ld      de,fat_work
    ld      b,4                             ; four primary partitions
; Copy byte 8 of the 16-byte entry at offset 446.
fat_mount_savept:
    push    bc
    ld      bc,4
    call    fat_copy                       ; copy the partition start LBA
    ld      bc,SZ_PTE-4                     ; step to the next 16-byte entry
    add     hl,bc
    pop     bc
    dec     b
    jp      NZ,fat_mount_savept             ; four primary PTEs
    ld      hl,fat_work
    ld      b,4
; Try one saved start LBA.
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
    jr      Z,fat_mount_nextpt              ; the start LBA is zero
    ld      a,b
    cp      (MAX_LBA28>>24)+1               ; high byte at or past $10
    jr      NC,fat_mount_nextpt             ; the start LBA is at or past $10000000
    call    fat_move_window                 ; read this partition
    jr      C,fat_mount_ptok                ; the partition sector is in the window
    ld      a,1                             ; 1 is a sector error
    ld      (_cpm_fat_vol+27),a
    jr      fat_mount_nextpt
; The partition sector was read.
fat_mount_ptok:
    xor     a
    ld      (_cpm_fat_vol+27),a             ; this read is not a sector error
    call    fat_check_vbr                   ; carry means a volume boot record
    jr      C,fat_mount_gotpt               ; this entry passed the volume boot record check
; This entry is not a FAT volume. Step to the next start LBA.
fat_mount_nextpt:
    pop     hl
    ld      bc,4
    add     hl,bc
    pop     bc
    dec     b
    jp      NZ,fat_mount_trypt              ; more primary PTEs
    jp      fat_mount_fail
; GPT and an extended partition fail the check above.
fat_mount_gotpt:
    pop     hl
    pop     bc
; Read the BIOS parameter block. The type is not stored yet.
fat_parse_bpb:
    ld      a,(fatwin+BPB_SecPerClus)
    ld      (_cpm_fat_vol+1),a              ; csize from offset 13
    ld      a,(fatwin+BPB_NumFATs)
    ld      (_cpm_fat_vol+24),a             ; n_fats from offset 16
    ld      hl,(fatwin+BPB_RootEntCnt)
    ld      (_cpm_fat_vol+2),hl             ; root entry count from offset 17
    ld      hl,(fatwin+BPB_FATSz16)
    ex      de,hl
    ld      a,d
    or      e
    jr      NZ,fat_mount_fsz                ; offset 22 is not zero
    ld      hl,(fatwin+BPB_FATSz32+2)
    ld      bc,hl
    ld      hl,(fatwin+BPB_FATSz32)
    ex      de,hl
    jr      fat_mount_fsz32
; FATSz16 at offset 22 is the FAT size. The high half is zero.
fat_mount_fsz:
    ld      bc,0
; fatsz is in BCDE. Reject a size at or above $200000 before any double.
fat_mount_fsz32:
    ex      de,hl
    ld      (_cpm_fat_vol+20),hl            ; fatsz
    ld      hl,bc
    ld      (_cpm_fat_vol+22),hl
    ld      a,b
    or      a
    jp      NZ,fat_mount_fail               ; fatsz is at or above $01000000
    ld      a,c
    cp      (MAX_FATSZ+1)>>16               ; high byte of $200000
    jp      NC,fat_mount_fail               ; fatsz is at or above $200000
    ld      hl,(fatwin+BPB_TotSec16)
    ld      a,h
    or      l
    jr      NZ,fat_mount_tsz16              ; offset 19 is not zero
    ld      hl,(fatwin+BPB_TotSec32+2)
    ex      de,hl
    ld      hl,(fatwin+BPB_TotSec32)
    jr      fat_mount_tsz
; TotSec16 at offset 19 is the sector count. The high half is zero.
fat_mount_tsz16:
    ld      de,0
; HLDE is the total sector count.
fat_mount_tsz:
    ld      (fat_work+4),hl                 ; total sectors
    ex      de,hl
    ld      (fat_work+6),hl
    ld      hl,(_cpm_fat_vol+22)
    ex      de,hl
    ld      hl,(_cpm_fat_vol+20)            ; fatsz
    ld      a,(_cpm_fat_vol+24)
    cp      2                               ; two FATs
    jr      NZ,fat_mount_fatarea            ; there is one FAT
    add     hl,hl                           ; double the low half
    call    fat_rlde                        ; fatsz * n_fats
    jp      C,fat_mount_fail                ; two FAT copies do not fit
; Add the reserved sector count to the FAT area.
fat_mount_fatarea:
    ld      bc,hl
    ld      hl,(fatwin+BPB_RsvdSecCnt)
    add     hl,bc                           ; add offset 14
    jr      NC,fat_mount_sy1                ; the reserved add fits in 16 bits
    inc     de
    ld      a,d
    or      e
    jp      Z,fat_mount_fail                ; the system area wrapped
; HL stays the low half of the system area.
fat_mount_sy1:
    push    hl
    ld      hl,(fatwin+BPB_FATSz16)
    ld      a,h
    or      l
    pop     hl
    jr      Z,fat_mount_r32root             ; FATSz16 == 0
    push    hl
    ld      hl,(_cpm_fat_vol+2)             ; n_rootent
    ld      a,h
    or      l
    jr      Z,fat_mount_rootbad             ; FAT16 root count is 0
    ld      a,l
    and     $0F
    jr      NZ,fat_mount_rootbad            ; not a whole number of sectors
    ld      bc,hl
    pop     hl
    ld      a,b
    or      a                               ; n_rootent >> 4 via rra, not srl
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
    ld      c,a                             ; root sectors = n_rootent/16
    jr      fat_mount_addroot
; FAT32 shape. Offset 17 and offset 42 must be zero.
fat_mount_r32root:
    push    hl
    ld      hl,(fatwin+BPB_RootEntCnt)
    ld      a,h
    or      l
    jr      NZ,fat_mount_rootbad            ; FAT32 root count must be 0
    ld      a,(fatwin+BPB_FSVer)
    ld      hl,fatwin+BPB_FSVer+1
    or      (hl)
    jr      NZ,fat_mount_rootbad            ; FSVer must be 0
    pop     hl
    ld      bc,0                            ; FAT32 has no static root
    jr      fat_mount_addroot
fat_mount_rootbad:
    pop     hl
    jp      fat_mount_fail
; Add the static root sectors to the system area.
fat_mount_addroot:
    add     hl,bc                           ; system sectors plus the root
    jr      NC,fat_mount_sy2                ; the root add fits in 16 bits
    inc     de
    ld      a,d
    or      e
    jp      Z,fat_mount_fail                ; the root area wrapped
; HLDE is sysect. Subtract it from the total sector count.
fat_mount_sy2:
    ld      (fat_work+8),hl                 ; sysect
    ex      de,hl
    ld      (fat_work+10),hl
    ld      hl,(fat_work+4)                 ; total sectors
    sub     hl,de                           ; tsect - sysect
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
    jp      C,fat_mount_fail                ; the total is below sysect
    ld      a,(_cpm_fat_vol+1)              ; csize is 2^n
    ld      b,0
; Count the shifts in csize.
; srl sets Z when the result is zero.
fat_mount_log:
    or      a                              ; csize shifts right by 1. rra leaves Z stale.
    rra
    or      a
    jr      Z,fat_mount_shr                 ; B holds log2(csize)
    inc     b
    jr      fat_mount_log
; Shift the data sectors down by log2(csize).
fat_mount_shr:
    ld      hl,(fat_work+14)
    ex      de,hl
    ld      hl,(fat_work+12)
    ld      a,b
    or      a
    jr      Z,fat_mount_ncl                 ; csize is 1, so nclst is the data sectors
; Shift nclst one bit to the right.
fat_mount_shrl:
    ld      a,d
    or      a                               ; nclst >>= 1 through rra
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
    jp      NZ,fat_mount_shrl               ; shifts left
; HLDE is nclst.
fat_mount_ncl:
    ld      (fat_work+12),hl                ; nclst low
    ex      de,hl
    ld      (fat_work+14),hl                ; nclst high
    ld      a,h
    or      l
    or      d
    or      e
    jp      Z,fat_mount_fail                ; the volume has no clusters
    ld      a,h
    cp      $10
    jp      NC,fat_mount_fail               ; nclst is at or past $10000000
    cp      $0F
    jr      NZ,fat_mount_band               ; the high byte is below $0F
    ld      a,l
    inc     a
    jr      NZ,fat_mount_band               ; byte 2 is not $FF
    ld      a,d
    inc     a
    jr      NZ,fat_mount_band               ; byte 1 is not $FF
    ld      a,e
    cp      (MAX_FAT32 & $FF)+1             ; low byte past $0FFFFFF5
    jp      NC,fat_mount_fail               ; a count above $0FFFFFF5 is rejected
; Choose FAT12, FAT16, or FAT32 from nclst.
fat_mount_band:
    ld      a,h
    or      l
    jr      NZ,fat_mount_fat32              ; nclst does not fit in 16 bits
    ld      hl,de                           ; low still in DE
    ld      bc,MAX_FAT12+1                  ; $0FF5 + 1
    sub     hl,bc                           ; nclst - ($0FF5+1)
    jp      C,fat_mount_fat12               ; FAT12 is nclst at most $0FF5
    ld      hl,de                           ; drop the compare difference
    ld      bc,MAX_FAT16                    ; $FFF5
    sub     hl,bc                           ; nclst - $FFF5
    jr      Z,fat_mount_fat16               ; $FFF5 stays FAT16
    jr      NC,fat_mount_fat32              ; nclst is above $FFF5
; nclst is in the FAT16 band, including $FFF5.
fat_mount_fat16:
    ld      hl,(_cpm_fat_vol+2)             ; root entry count
    ld      a,h
    or      l
    jp      Z,fat_mount_fail                ; a FAT32-shaped record in the FAT16 band is rejected
    ld      a,FS_FAT16                      ; 2 is FAT16
    jr      fat_mount_type
; nclst is above the FAT16 limit.
fat_mount_fat32:
    ld      hl,(fatwin+BPB_FATSz16)         ; offset 22
    ld      a,h
    or      l
    jp      NZ,fat_mount_fail               ; a FAT16 size cannot hold this FAT32 count
    ld      a,FS_FAT32                      ; 3 is FAT32
    jr      fat_mount_type
; FAT12 is reached only by the jump above.
; The FAT12 block sits after the FAT32 block so a count of 4085 does not fall into it by accident.
fat_mount_fat12:
    ld      hl,(_cpm_fat_vol+2)             ; FAT12 uses the FAT16 root shape
    ld      a,h
    or      l
    jp      Z,fat_mount_fail                ; the FAT12 root entry count is zero
    ld      a,FS_FAT12                      ; 1 is FAT12
; Hold the type at +26. +0 is written only at fat_mount_ok.
fat_mount_type:
    ld      (_cpm_fat_vol+26),a             ; fs_type waits until every check passes
    ld      hl,(fat_work+14)
    ex      de,hl
    ld      hl,(fat_work+12)
    ld      bc,2                            ; n_fatent is nclst plus 2
    add     hl,bc                           ; nclst + 2
    jr      NC,fat_mount_nfe                ; nclst + 2 fits in 16 bits
    inc     de
    ld      a,d
    or      e
    jp      Z,fat_mount_fail                ; n_fatent wrapped
; Store n_fatent. Then check that fatsz covers it.
fat_mount_nfe:
    ld      (_cpm_fat_vol+4),hl             ; n_fatent
    ex      de,hl
    ld      (_cpm_fat_vol+6),hl
    ld      hl,(_cpm_fat_vol+4)
    ld      de,(_cpm_fat_vol+6)
    ; The FAT must be long enough for n_fatent.
    ; A short FAT would let a cluster walk leave the FAT.
    ld      a,(_cpm_fat_vol+26)             ; type held at +26
    cp      FS_FAT12                        ; 1 is FAT12
    jr      Z,fat_mount_need12              ; FAT12 entries are 12 bits
    cp      FS_FAT32                        ; 3 is FAT32
    jr      Z,fat_mount_need32              ; FAT32 entries are 4 bytes
    ld      bc,255                          ; round the FAT16 byte count up
    add     hl,bc                           ; n_fatent + 255
    jr      NC,fat_mount_need16             ; the FAT16 sum fits in 16 bits
    inc     de
; FAT16 sectors are (n_fatent + 255) / 256.
fat_mount_need16:
    ld      l,h
    ld      h,e
    ld      e,d
    ld      d,0
    jr      fat_mount_needc
; One FAT12 uses (n_fatent * 3 + 1) / 2 bytes.
; The extra byte covers the last entry.
; The sector count rounds those bytes up to 512.
; n_fatent fits in 16 bits on this path.
fat_mount_need12:
    push    hl
    add     hl,hl                           ; n_fatent * 2
    pop     bc
    add     hl,bc                           ; n_fatent * 3
    inc     hl                              ; add 1
    or      a
    ld      a,h
    rra
    ld      h,a
    ld      a,l
    rra
    ld      l,a                             ; bytes = (n_fatent * 3 + 1) / 2
    ld      bc,511                          ; round up to 512
    add     hl,bc                           ; bytes plus 511
    or      a
    ld      a,h
    rra
    ld      l,a
    ld      h,0
    ld      de,0
    jr      fat_mount_needc
; FAT32 sectors are (n_fatent + 127) / 128.
fat_mount_need32:
    ld      bc,127
    add     hl,bc                           ; n_fatent + 127
    jr      NC,fat_mount_need32s            ; the FAT32 sum fits in 16 bits
    inc     de
; Seven shifts divide by 128.
fat_mount_need32s:
    ld      b,7
; One shift of the FAT32 sector count remains.
fat_mount_need32l:
    ld      a,d
    or      a                               ; needed bytes >>= 1 via rra
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
    jp      NZ,fat_mount_need32l            ; seven shifts left
; Compare fatsz with the sectors this FAT needs.
fat_mount_needc:
    ld      bc,(_cpm_fat_vol+20)            ; fatsz
    ld      a,c
    sub     l                               ; fatsz minus the needed sectors
    ld      a,b
    sbc     a,h
    ld      bc,(_cpm_fat_vol+22)
    ld      a,c
    sbc     a,e
    ld      a,b
    sbc     a,d
    jp      C,fat_mount_fail                ; the FAT does not cover n_fatent
    ld      hl,(fatwin+BPB_RsvdSecCnt)
    ld      bc,hl
    ld      hl,(fat_winsect)                ; fatbase = bsect + nrsv
    add     hl,bc                           ; volume LBA plus offset 14
    ld      (_cpm_fat_vol+8),hl
    ld      hl,(fat_winsect+2)
    ld      bc,0
    ld      a,l
    adc     a,c
    ld      l,a
    ld      a,h
    adc     a,b
    cp      (MAX_LBA28>>24)+1               ; high byte at or past $10
    jp      NC,fat_mount_fail               ; fatbase is at or past $10000000
    ld      h,a
    ld      (_cpm_fat_vol+10),hl
    ld      hl,(fat_work+8)
    ld      bc,hl
    ld      hl,(fat_winsect)                ; database = bsect + sysect
    add     hl,bc                           ; volume LBA plus sysect
    ld      (_cpm_fat_vol+16),hl
    ld      hl,(fat_work+10)
    ld      bc,hl
    ld      hl,(fat_winsect+2)
    ld      a,l
    adc     a,c
    ld      l,a
    ld      a,h
    adc     a,b
    cp      (MAX_LBA28>>24)+1               ; high byte at or past $10
    jp      NC,fat_mount_fail               ; database is at or past $10000000
    ld      h,a
    ld      (_cpm_fat_vol+18),hl
    ld      a,(_cpm_fat_vol+26)             ; type held at +26
    cp      FS_FAT32                        ; 3 is FAT32
    jr      Z,fat_mount_r32                 ; the FAT32 root cluster comes from offset 44
    ld      hl,(_cpm_fat_vol+2)
    ld      bc,hl
    ld      hl,(_cpm_fat_vol+16)            ; database
    ld      a,b
    or      a                               ; root sectors = n_rootent >> 4
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
    sub     hl,bc                           ; database - root sectors
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
; FAT32 root cluster from offset 44.
fat_mount_r32:
    ld      hl,(fatwin+BPB_RootClus32)
    ld      a,l
    sub     2                               ; a cluster below 2 is invalid
    ld      a,h
    sbc     a,0
    ld      de,(fatwin+BPB_RootClus32+2)
    ld      a,e
    sbc     a,0
    ld      a,d
    sbc     a,0
    jp      C,fat_mount_fail                ; BPB_RootClus below 2 fails the mount
    ld      hl,(fatwin+BPB_RootClus32)
    ld      de,(_cpm_fat_vol+4)             ; n_fatent low
    or      a                               ; clear carry before the compare
    ld      a,l
    sub     e
    ld      a,h
    sbc     a,d
    push    af                              ; keep the low-half borrow
    ld      hl,(fatwin+BPB_RootClus32+2)
    ld      de,(_cpm_fat_vol+6)             ; n_fatent high
    pop     af
    ld      a,l
    sbc     a,e
    ld      a,h
    sbc     a,d
    jp      NC,fat_mount_fail               ; BPB_RootClus at or past n_fatent fails the mount
    ld      hl,(fatwin+BPB_RootClus32)
    ld      (_cpm_fat_vol+12),hl            ; dirbase is the root cluster
    ld      hl,(fatwin+BPB_RootClus32+2)
    ld      (_cpm_fat_vol+14),hl
    xor     a
    ld      (_cpm_fat_vol+2),a              ; FAT32 has no static root count
    ld      (_cpm_fat_vol+3),a
    ld      a,(fatwin+BPB_ExtFlags+1)
    and     $80                             ; offset 40 bit 7 disables mirroring
    jr      Z,fat_mount_ok                  ; mirroring stays enabled
    ld      a,(fatwin+BPB_ExtFlags)
    and     $0F                             ; active FAT index
    ld      b,a
    ld      a,(_cpm_fat_vol+24)             ; n_fats
    cp      b                               ; n_fats compared with the active index
    jp      C,fat_mount_fail                ; the active index is above n_fats
    jp      Z,fat_mount_fail                ; the active index equals n_fats
    ld      a,b
    or      a
    jr      Z,fat_mount_act0                ; the active FAT is already fatbase
    ld      hl,(_cpm_fat_vol+8)
    ld      de,(_cpm_fat_vol+20)
    add     hl,de                           ; fatbase of the active FAT
    ld      (_cpm_fat_vol+8),hl
    ld      hl,(_cpm_fat_vol+10)
    ld      de,(_cpm_fat_vol+22)
    ld      a,l
    adc     a,e
    ld      l,a
    ld      a,h
    adc     a,d
    cp      (MAX_LBA28>>24)+1               ; high byte at or past $10
    jp      NC,fat_mount_fail               ; the active FAT is at or past $10000000
    ld      h,a
    ld      (_cpm_fat_vol+10),hl
; One FAT stays active. Do not write the other copy.
fat_mount_act0:
    ld      a,1
    ld      (_cpm_fat_vol+24),a             ; do not mirror onto the inactive FAT
; Every check has passed. Publish fs_type now.
fat_mount_ok:
    ld      a,(_cpm_fat_vol+26)
    ld      (_cpm_fat_vol),a                ; fs_type is stored only after every check
    xor     a
    ld      (_cpm_fat_vol+26),a
    ld      (_cpm_fat_vol+27),a
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT32                        ; 3 is FAT32
    jr      Z,fat_mount_cwd32               ; the current directory is the FAT32 root
    xor     a
    ld      (fat_cwd),a                     ; FAT12 and FAT16 start at cluster 0
    ld      (fat_cwd+1),a
    ld      (fat_cwd+2),a
    ld      (fat_cwd+3),a
    ld      hl,0                            ; L is 0 and H is 0
    scf                                     ; carry is set
    ret
; FAT32 success. Seed the hint, then return L at 0 with carry set.
fat_mount_cwd32:
    call    fat_seed_fsinfo                 ; a miss still leaves this mount successful
    ld      hl,(_cpm_fat_vol+12)            ; FAT32 root cluster
    ld      (fat_cwd),hl
    ld      hl,(_cpm_fat_vol+14)
    ld      (fat_cwd+2),hl
    ld      hl,0                            ; L is 0 and H is 0
    scf                                     ; carry is set
    ret
; Copy the stored code into L, then clear +27.
fat_mount_fail:
    ld      a,(_cpm_fat_vol+27)             ; 1, 3, 19, or 0
    ld      l,a
    xor     a
    ld      (_cpm_fat_vol),a                ; fs_type stays unpublished
    ld      (_cpm_fat_vol+26),a
    ld      (_cpm_fat_vol+27),a             ; the exit clears +27
    ld      a,l
    or      a
    jr      NZ,fat_mount_code               ; L already holds 1, 3, or 19
    ld      l,13                            ; 13 means there is no filesystem
; H is 0. or a clears carry on every failure exit.
fat_mount_code:
    ld      h,0
    or      a                               ; carry is clear
    ret

; Read the FAT32 info sector. The volume boot record is still in fatwin.
; Offset 48 holds the info-sector number.
; A field of $FFFFFFFF means the value is unknown.
; A bad info sector leaves the hint clear.
; The mount still succeeds.
; Call. No arguments. The volume boot record is still in fatwin.
; Return. This helper does not fail the mount.
; Return. Carry here is not a mount status. The caller sets carry after the return.
; Writes. A valid next-free hint is stored at fat_last_clst.
; Writes. A valid free count is stored at _cpm_fat_vol+28 and +25 is set.
; Clobber. AF, BC, DE, HL.
fat_seed_fsinfo:
    ld      hl,(fatwin+BPB_FSInfo)          ; offset 48
    ld      a,h
    or      l
    ret     Z                               ; offset 48 is zero and the hint stays clear
    inc     hl
    ld      a,h
    or      l
    ret     Z                               ; offset 48 was $FFFF and the hint stays clear
    dec     hl
    ex      de,hl                           ; DE = sector offset
    ld      hl,(fat_winsect)
    add     hl,de                           ; volbase + FSInfo offset
    ex      de,hl                          ; DE is the low sum. Carry stays.
    ld      hl,(fat_winsect+2)
    ld      a,l
    adc     a,0
    ld      l,a
    ld      a,h
    adc     a,0
    cp      (MAX_LBA28>>24)+1               ; high byte at or past $10
    ret     NC                              ; an FSInfo LBA at or past $10000000 leaves the hint clear
    ld      h,a
    ld      bc,hl
    push    bc
    push    de
    call    fat_move_window                 ; read the info sector
    jp      NC,seed_drop                    ; the info sector was not read
    ld      hl,fatwin
    ld      a,(hl+)
    cp      $52                             ; lead byte 'R'
    jp      NZ,seed_drop                    ; the lead signature is not RRaA
    ld      a,(hl+)
    cp      $61                             ; lead byte 'a'
    jp      NZ,seed_drop                    ; the lead signature is not RRaA
    ld      a,(hl+)
    cp      $41                             ; lead byte 'A'
    jp      NZ,seed_drop                    ; the lead signature is not RRaA
    ld      a,(hl)
    cp      $41                             ; lead byte 'A'
    jp      NZ,seed_drop                    ; the lead signature is not RRaA
    ld      hl,fatwin+484
    ld      a,(hl+)
    cp      $72                             ; structure byte 'r'
    jp      NZ,seed_drop                    ; the structure signature is not rrAa
    ld      a,(hl+)
    cp      $72                             ; structure byte 'r'
    jp      NZ,seed_drop                    ; the structure signature is not rrAa
    ld      a,(hl+)
    cp      $41                             ; structure byte 'A'
    jp      NZ,seed_drop                    ; the structure signature is not rrAa
    ld      a,(hl)
    cp      $61                             ; structure byte 'a'
    jp      NZ,seed_drop                    ; the structure signature is not rrAa
    ld      a,(fatwin+510)
    cp      $55                             ; offset 510 low byte
    jp      NZ,seed_drop                    ; the info sector has no 55 AA
    ld      a,(fatwin+511)
    cp      $AA                             ; offset 510 high byte
    jp      NZ,seed_drop                    ; the info sector has no 55 AA
    pop     hl
    ld      (fat_fsi_lba),hl
    pop     hl
    ld      (fat_fsi_lba+2),hl
    xor     a
    ld      (fat_fsi_dirty),a
    ld      hl,fatwin+492                   ; next-free hint
    call    fat_ld32                        ; load the next-free hint
    ld      a,e
    and     d
    and     c
    and     b
    cp      $FF                             ; $FFFFFFFF
    jr      Z,seed_free                     ; the next-free hint is unknown
    call    fat_clst_ok                     ; C: hint is not a cluster
    jr      C,seed_free                     ; hint out of range
    ld      hl,de
    ld      (fat_last_clst),hl
    ld      hl,bc
    ld      (fat_last_clst+2),hl
; Read the free-count field.
seed_free:
    ld      hl,fatwin+488                   ; free count
    call    fat_ld32                        ; load the free count
    ld      a,e
    and     d
    and     c
    and     b
    cp      $FF                             ; $FFFFFFFF
    ret     Z                               ; the free count is unknown
    push    bc
    push    de
    ld      hl,(_cpm_fat_vol+4)             ; n_fatent
    ld      a,l
    sub     2                               ; n_fatent - 2 = nclst
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
    pop     de                              ; free count
    pop     bc
    ld      hl,fat_work
    ld      a,(hl+)
    sub     e                               ; nclst minus the free count
    ld      a,(hl+)
    sbc     a,d
    ld      a,(hl+)
    sbc     a,c
    ld      a,(hl)
    sbc     a,b
    ret     C                               ; the free count is above nclst
    ld      hl,de
    ld      (_cpm_fat_vol+28),hl
    ld      hl,bc
    ld      (_cpm_fat_vol+30),hl
    ld      a,1
    ld      (_cpm_fat_vol+25),a             ; the free count is valid
    ret
; The info sector is not usable. Leave the hint clear.
seed_drop:
    pop     hl
    pop     hl
    ret
