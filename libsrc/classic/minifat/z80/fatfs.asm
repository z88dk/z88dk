;
; Copyright (c) November 2026 Phillip Stevens (feilipu)
;
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:
;
; The above copyright notice and this permission notice shall be included in all
; copies or substantial portions of the Software.
;
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; SOFTWARE.
;
;
; Mini-FAT12/16/32 (Z80).
;
; The human description is mini-fat.md in this directory.
; ChaN's application interface is
; http://elm-chan.org/fsw/ff/00index_e.html
; This file is the sector and directory layer under that interface.
;
; Same PUBLIC API, BSS names, and function contracts as fatfs_85.asm /
; fatfs.h. ROM-resident, no PHASE. Shell buffers live in fat_bss.asm
; (RAM). The sector window is fatwin.
;
; C: PUBLIC _names. Pointers are __z88dk_fastcall (HL).
; DWORD cluster/LBA is BCDE (E LSB).
; _fat_next, _fat_alloc, _fat_free, _fat_clst2sect, and _fat_dir_open
; load that little-endian dword from (HL).
; Success: L=0 and carry set. Fail: L=1 and carry clear.
; A 64 KiB cluster is the exception: L=19 and carry clear.
; sccz80 treats a char return as an int, so these exits also clear H.
;
; FatFs R0.16 map (z88dk-libraries/ff/source/ff.c):
;   check_fs / find_volume / mount_volume
;   move_window / sync_window
;   clst2sect, get_fat, put_fat, create_chain, remove_chain
;   dir_sdi, dir_next, dir_find, dir_create
;
; In scope: FAT12, FAT16 and FAT32, 512-byte sectors, 8.3 SFN only.
; Out of scope: exFAT, LFN, GPT.
; FAT32 directory stretch is dir_create only, when the chain is at end.
; FAT16 root and FAT16 subdirectories stay a fixed size.
; FAT32 FSInfo is read at mount. A sync writes FSI_Free_Count and
; FSI_Nxt_Free when the free count or fat_last_clst has changed.
;
; FatFs cases we honour:
;   A cluster below 2 is invalid. n_fatent is nclst + 2.
;   FAT16 end-of-chain is $FFF8 to $FFFF.
;   FAT32 end-of-chain is $0FFFFFF8 to $0FFFFFFF. put_fat keeps bits 28-31.
;   nclst <= $0FF5 is FAT12 (ChaN MAX_FAT12). Spec 1.03 treats 4085 as FAT16.
;   nclst == $FFF5 stays FAT16 (ChaN MAX_FAT16). Spec 1.03 would use FAT32.
;   nclst > $0FFFFFF5 is rejected (ChaN MAX_FAT32). put_fat keeps 28 bits.
;   fatsz >= $200000 is rejected (ChaN ff16p2, before fatsz is doubled)
;   a partition, fatbase, database, or active FAT at LBA >= $10000000 fails
;   An FSInfo LBA >= $10000000 leaves the hint clear. The mount still succeeds.
;   Neither boundary is built by test/fatfs. BPB_Media is never read.
;   FAT16 root count is a non-zero multiple of 16. A FAT32-shaped VBR
;   whose cluster count falls in the FAT16 band is rejected.
;   FAT32 requires FATSz16 == 0, FSVer == 0 and RootEntCnt == 0
;   csize is 2^n. SecPerClus >= 65 (64 KiB clusters) is refused with
;   L = 19. A 64 KiB cluster is 0 in the 16-bit sector math.
;   FAT32 with mirroring off uses the active FAT in BPB_ExtFlags and
;   does not write the other copy. A bad cluster ($FFF7 / $0FFFFFF7)
;   is an error, not a link. fs_type is stored only after every check.
;   DIR_Name[0] == $05 compares as $E5. dir_create stores $E5 as $05.
;   FAT16 root of 2048 entries is the whole 16-bit offset (65536 bytes)
;   A directory entry of $00 ends the directory. $E5 is deleted and reusable.
;   A long-name entry is attribute $0F, which includes the volume bit.
;   The volume-bit test therefore skips both labels and long names.
;   dir_next stops on 16-bit ofs wrap (2048 dirents) for long directories
;   FAT32 root is BPB_RootClus32. Cluster 0 means that root (ff dir_sdi).
;   FAT16 root is static dirbase LBA
;   SFD (VBR at LBA 0) then four MBR primary partitions
;   1 or 2 FATs. csize is a power of 2. BytsPerSec == 512.
;
; Checks this file does not make:
;   JumpBoot. 55AA is required. ChaN accepts some VBRs that have no 55AA.
;   BPB_Media. Partition type. GPT and extended partitions fail the VBR check.
;
; Other limits:
;   dir_next itself does not stretch (dir_create does, FAT32 only)
;   dir_zap writes $E5 only. The caller frees the chain with _fat_free.
;
; How to read this file. Each operation is one label, top to bottom:
; clst2sect, sync_window, get_fat, put_fat, create_chain, remove_chain,
; dir_sdi, dir_next. mount, dir_find, dir_create, dir_zap, and the
; C dword calls are the next files in this directory. fat_sync stays
; here because move_window and create_chain call fat_sync_window.
; fat_ld32, fat_st32, and fat_move_window stay shared.
; Every cluster and every LBA is a dword in BCDE with E as the low byte.
; The one sector window supplies every FAT or directory byte.
; Inlining those two jobs would paste the FAT16/FAT32 cases into every caller.
; fat_ld32 leaves HL on the last byte, so a caller that reads the
; next dword has to inc hl first.
;

SECTION code_lib

EXTERN  asm_disk_initialize
EXTERN  ide_read_sector
EXTERN  ide_write_sector

EXTERN  _cpm_fat_vol
EXTERN  fatwin
EXTERN  fat_winsect
EXTERN  fat_wflag
EXTERN  fat_cwd
EXTERN  fat_found_sclust
EXTERN  fat_found_size
EXTERN  dir_ptr
EXTERN  dir_sclust
EXTERN  dir_clust                   ;cluster of the current directory sector
EXTERN  dir_sect
EXTERN  dir_ofs
EXTERN  fat_work
EXTERN  pack_sv
EXTERN  fat_last_clst               ;last cluster this session allocated
EXTERN  fat_fsi_lba                 ;absolute FSInfo LBA, or 0
EXTERN  fat_fsi_dirty               ;1 = write FSI_Free_Count and FSI_Nxt_Free
EXTERN  clst_cache_sclust
EXTERN  clst_cache_ci
EXTERN  clst_cache_clst

PUBLIC  clst2sect                   ;cluster -> first sector LBA
PUBLIC  fat_sync_window             ;write fatwin if dirty, then mirror FAT#2
PUBLIC  _fat_sync                   ;C: fat_sync_window
PUBLIC  fat_move_window             ;flush dirty, read LBA into fatwin
PUBLIC  get_fat                     ;next cluster from FAT entry
PUBLIC  put_fat                     ;store next cluster in FAT
PUBLIC  clst_from_off               ;cluster containing file offset
PUBLIC  create_chain                ;allocate and link a new cluster
PUBLIC  remove_chain                ;free a cluster chain
PUBLIC  dir_sdi                     ;seek directory to byte offset
PUBLIC  dir_next                    ;next 32-byte dirent (no stretch)

PUBLIC  cc_zero
PUBLIC  fat_ld32
PUBLIC  fat_st32


DEFC    FS_FAT12        = 1
DEFC    FS_FAT16        = 2
DEFC    FS_FAT32        = 3
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
DEFC    DIR_Attr        = 11
DEFC    DIR_ClusHI      = 20
DEFC    DIR_ClusLO      = 26
DEFC    DIR_FileSize    = 28
DEFC    AM_VOL          = $08


; Turn a cluster into the first sector of that cluster.
; Call. BCDE is the cluster. E is the low byte.
; Return. Carry set: BCDE is database plus (cluster-2) times csize.
; Return. csize is 2^n.
; Return. Carry clear: the cluster is below 2, or at or past n_fatent.
; Return. Carry clear: (cluster-2) times csize wrapped, or the add wrapped.
; Clobber. AF, BC, DE, HL.
clst2sect:
    ld      hl,_cpm_fat_vol+4       ;n_fatent, little-endian
    ld      a,e
    sub     (hl+)                   ;cluster - n_fatent
    ld      a,d
    sbc     a,(hl+)
    ld      a,c
    sbc     a,(hl+)
    ld      a,b
    sbc     a,(hl)
    ret     NC                      ;cluster is at or past n_fatent
    ld      a,e
    sub     2                       ;cluster below 2 is invalid
    ld      e,a
    ld      a,d
    sbc     a,0
    ld      d,a
    ld      a,c
    sbc     a,0
    ld      c,a
    ld      a,b
    sbc     a,0
    ld      b,a
    jr      C,clst2sect_ov          ;cluster is below 2
    ld      a,(_cpm_fat_vol+1)      ;csize is 2^n
clst2sect_mul:
    srl     a
    jr      Z,clst2sect_base        ;every csize bit is consumed
    sla     e                       ;(cluster-2) times two
    rl      d
    rl      c
    rl      b
    jr      C,clst2sect_ov          ;(cluster-2) times csize wrapped
    jr      clst2sect_mul           ;shift the next csize bit
clst2sect_base:
    ld      hl,_cpm_fat_vol+16      ;database
    ld      a,(hl+)
    add     a,e                     ;database plus the scaled cluster
    ld      e,a
    ld      a,(hl+)
    adc     a,d
    ld      d,a
    ld      a,(hl+)
    adc     a,c
    ld      c,a
    ld      a,(hl)
    adc     a,b
    ld      b,a
    jr      C,clst2sect_ov          ;database plus the product wrapped
    scf
    ret

clst2sect_ov:
    or      a                       ;clear carry. This cluster has no sector.
    ret

; Write the dirty window. Write the first FAT copy, then the mirror.
; The dirty flag stays set until every copy succeeds.
; ChaN clears that flag before the second FAT and ignores a failed mirror.
; A directory window is not mirrored. Mount allows 1 or 2 FAT copies.
; Call. No arguments. _fat_sync is this same entry.
; Return. Carry set and HL = 0: the window is clean or every copy was written.
; Return. A failed info-sector write still takes that carry-set exit.
; Return. Carry clear and HL = 1: a sector write failed. The dirty flag stays set.
; Return. A failed mirror leaves the first FAT copy written.
; Clobber. AF, BC, DE, HL.
; Writes. fat_wflag, and the window sector when it was dirty.
_fat_sync:
fat_sync_window:
    ld      a,(fat_wflag)
    or      a
    jr      Z,fat_sync_ok           ;the window is already clean
    ld      de,(fat_winsect)        ;E is the low byte
    ld      bc,(fat_winsect+2)      ;C, then B
    ld      hl,fatwin               ;sector window
    call    ide_write_sector        ;carry set: sector written. HL is fatwin plus 512.
    ld      hl,1
    ret     NC                      ;the write failed. Leave the window dirty.
    ld      a,(_cpm_fat_vol+24)     ;n_fats
    cp      2                       ;one FAT has no mirror
    jr      C,fat_sync_clear        ;n_fats is below 2
    ld      hl,_cpm_fat_vol+8       ;winsect minus fatbase
    ld      a,(fat_winsect)
    sub     (hl+)                   ;winsect minus fatbase
    ld      e,a
    ld      a,(fat_winsect+1)
    sbc     a,(hl+)
    ld      d,a
    ld      a,(fat_winsect+2)
    sbc     a,(hl+)
    ld      c,a
    ld      a,(fat_winsect+3)
    sbc     a,(hl)
    jr      C,fat_sync_clear        ;the sector is below fatbase
    ld      b,a                     ;BCDE is winsect minus fatbase
    ld      hl,_cpm_fat_vol+20      ;compare with fatsz
    ld      a,e
    sub     (hl+)                   ;offset in the FAT minus fatsz
    ld      a,d
    sbc     a,(hl+)
    ld      a,c
    sbc     a,(hl+)
    ld      a,b
    sbc     a,(hl)
    jr      NC,fat_sync_clear       ;the sector is not in the first FAT
    ld      hl,(fat_winsect)
    ld      de,(_cpm_fat_vol+20)
    add     hl,de                   ;mirror LBA is winsect plus fatsz
    ex      de,hl
    ld      hl,(fat_winsect+2)
    ld      bc,(_cpm_fat_vol+22)
    adc     hl,bc
    ld      bc,hl
    ld      hl,fatwin
    call    ide_write_sector        ;carry set: mirror written. HL is fatwin plus 512.
    ld      hl,1
    ret     NC                      ;the mirror failed. The first FAT copy is on disk.
fat_sync_clear:
    xor     a                       ;no mirror is required
    ld      (fat_wflag),a
fat_sync_ok:
    call    fat_fsi_write           ;write FSInfo when it is dirty
    ld      hl,0
    scf                             ;sync success. H is 0 and L is 0.
    ret

; Write FSI_Free_Count and FSI_Nxt_Free when the info sector is dirty.
; Call. No arguments.
; Return. Carry clear and Z: the sector is clean, or its LBA is 0.
; Return. Those exits are not disk errors. fat_sync_window ignores the flags.
; Return. Carry set: the info sector is written and the dirty flag is clear.
; Return. Carry clear after a failed read or write: the dirty flag is set again.
; Clobber. AF, BC, DE, HL.
; Writes. The free-count and next-free fields. fat_fsi_dirty. The info sector.
fat_fsi_write:
    ld      a,(fat_fsi_dirty)
    or      a
    ret     Z                       ;the info sector is already clean
    ld      hl,(fat_fsi_lba)
    ld      a,h
    or      l
    ld      hl,(fat_fsi_lba+2)
    or      h
    or      l
    ret     Z                       ;LBA 0 means this volume has no info sector
    xor     a
    ld      (fat_fsi_dirty),a       ;clear dirty before the read, so it cannot re-enter
    ld      de,(fat_fsi_lba)
    ld      bc,(fat_fsi_lba+2)
    call    fat_move_window         ;read the info sector
    jr      NC,fat_fsi_again        ;the info sector was not read
    ld      a,(_cpm_fat_vol+25)
    or      a
    jr      Z,fat_fsi_unk           ;free_valid is clear, so the count is unknown
    ld      de,(_cpm_fat_vol+28)
    ld      bc,(_cpm_fat_vol+30)
    jr      fat_fsi_free            ;store the known free count
fat_fsi_unk:
    ld      de,$FFFF                ;$FFFFFFFF means the free count is unknown
    ld      bc,$FFFF
fat_fsi_free:
    ld      hl,fatwin+488
    call    fat_st32                ;store FSI_Free_Count
    ld      de,(fat_last_clst)
    ld      bc,(fat_last_clst+2)
    ld      a,b
    or      c
    or      d
    jr      NZ,fat_fsi_nxt          ;the hint is above 255
    ld      a,e
    cp      2                       ;a hint below cluster 2 is not a cluster
    jr      NC,fat_fsi_nxt          ;the hint is a real cluster
    ld      de,$FFFF                ;store $FFFFFFFF for a hint below cluster 2
    ld      bc,$FFFF
fat_fsi_nxt:
    ld      hl,fatwin+492
    call    fat_st32                ;store FSI_Nxt_Free
    ld      de,(fat_fsi_lba)
    ld      bc,(fat_fsi_lba+2)
    ld      hl,fatwin
    call    ide_write_sector        ;carry set: info sector written. HL is fatwin plus 512.
    ret     C                       ;the info sector is on disk
fat_fsi_again:
    ld      a,1                     ;the info sector was not written
    ld      (fat_fsi_dirty),a
    ret

; Mark the info sector dirty.
; Call. No arguments.
; Return. fat_fsi_dirty is 1. Flags are unchanged.
; Clobber. AF. BC, DE, and HL stay.
; Writes. fat_fsi_dirty.
fat_fsi_mark:
    ld      a,1
    ld      (fat_fsi_dirty),a
    ret

; Read one sector into the window. Write the dirty window first.
; Call. BCDE is the LBA. E is the low byte.
; Return. Carry set: fatwin holds that sector and fat_wflag is clear.
; Return. Carry clear: the dirty window was not written, or the read failed.
; Clobber. AF, HL. BC and DE stay.
; Writes. fatwin, fat_winsect, and fat_wflag when a new sector is read.
fat_move_window:
    ld      hl,(fat_winsect)
    ld      a,l
    cp      e                       ;LBA byte 0 against the window
    jr      NZ,fat_move_do          ;byte 0 differs, so read the new LBA
    ld      a,h
    cp      d                       ;LBA byte 1 against the window
    jr      NZ,fat_move_do          ;byte 1 differs, so read the new LBA
    ld      hl,(fat_winsect+2)
    ld      a,l
    cp      c                       ;LBA byte 2 against the window
    jr      NZ,fat_move_do          ;byte 2 differs, so read the new LBA
    ld      a,h
    cp      b                       ;LBA byte 3 against the window
    jr      NZ,fat_move_do          ;byte 3 differs, so read the new LBA
    scf                             ;this LBA is already in the window
    ret
fat_move_do:
    push    bc
    push    de                      ;keep the LBA. sync and the disk call write BCDE.
    call    fat_sync_window         ;write the dirty window first
    pop     de
    pop     bc
    ret     NC                      ;the dirty window was not written
    push    bc
    push    de
    ld      hl,fatwin               ;sector window
    call    ide_read_sector         ;carry set: sector read. HL is fatwin plus 512.
    pop     de
    pop     bc
    ret     NC                      ;the sector was not read
    ld      (fat_winsect),de
    ld      (fat_winsect+2),bc
    xor     a
    ld      (fat_wflag),a
    scf
    ret

; Map a cluster onto its FAT entry in the window.
; A FAT16 entry is 2 bytes. A FAT32 entry is 4 bytes. A sector is 512 bytes.
; Call. BCDE is the cluster. E is the low byte.
; Return. Carry set and the cluster is in range: HL points at the entry.
; Return. Carry set and the cluster is below 2: HL is not an entry.
; Return. That carry is still set from the cluster-2 subtract. It is not success.
; Return. Carry clear: the cluster is at or past n_fatent, or the sector was not read.
; Clobber. AF, BC, DE, HL.
; Writes. fatwin and fat_winsect when the FAT sector is read.
fat_fatent:
    ld      a,e                     ;a cluster below 2 is not in the FAT
    sub     2                       ;cluster below 2 sets carry
    ld      a,d
    sbc     a,0
    ld      a,c
    sbc     a,0
    ld      a,b
    sbc     a,0
    ret     C                       ;below 2. Carry stays set from the subtract.
    ld      hl,_cpm_fat_vol+4       ;cluster minus n_fatent. BCDE stays.
    ld      a,e
    sub     (hl+)                   ;cluster minus n_fatent
    ld      a,d
    sbc     (hl+)
    ld      a,c
    sbc     (hl+)
    ld      a,b
    sbc     a,(hl)
    ret     NC                      ;the cluster is at or past n_fatent
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT32                ;fs_type against FAT32
    jr      Z,fat_fatent32          ;FAT32 uses a 4-byte entry
    ; FAT16. The sector is fatbase plus cluster/256. The offset is the low byte times 2.
    ld      l,e
    ld      h,0
    add     hl,hl                   ;offset is below 512
    push    hl
    ld      e,d
    ld      d,c
    ld      c,b
    ld      b,0                     ;BCDE is cluster >> 8
    jr      fat_fatent_sec          ;add fatbase and read that sector
fat_fatent32:
    ; FAT32. 128 entries fill one 512-byte sector. The offset is (cluster mod 128)*4.
    ; That offset is 0 to 508. An 8-bit add would wrap, so the shift uses HL.
    ld      a,e
    and     127                     ;128 FAT32 entries fill one sector
    ld      l,a
    ld      h,0
    add     hl,hl
    add     hl,hl
    push    hl                      ;offset 0 to 508
    ld      a,e
    rla                             ;carry is cluster bit 7
    ld      e,d
    ld      d,c
    ld      c,b
    ld      b,0                     ;cluster >> 8
    rl      e
    rl      d
    rl      c
    rl      b                       ;cluster >> 7
fat_fatent_sec:
    ld      hl,_cpm_fat_vol+8       ;fatbase
    ld      a,(hl+)
    add     a,e                     ;fatbase plus the FAT sector
    ld      e,a
    ld      a,(hl+)
    adc     a,d
    ld      d,a
    ld      a,(hl+)
    adc     a,c
    ld      c,a
    ld      a,(hl)
    adc     a,b
    ld      b,a
    call    fat_move_window         ;read the FAT sector into fatwin
    pop     de                      ;byte offset in the 512-byte sector
    ret     NC                      ;the FAT sector was not read
    ld      hl,fatwin
    add     hl,de
    scf
    ret

; Read the FAT link for one cluster.
; Call. BCDE is the cluster. E is the low byte.
; Return. Carry set: BCDE is the link. An end-of-chain link is $0FFFFFFF.
; Return. FAT12 end-of-chain is $FF8 to $FFF. FAT16 end-of-chain is $FFF8 to $FFFF.
; Return. FAT32 end-of-chain is $0FFFFFF8 and above. A bad cluster is $FFF7 or $0FFFFFF7.
; Return. Carry clear: the cluster is bad, at or past n_fatent, or the sector was not read.
; Return. A cluster below 2 does not take that carry-clear exit.
; Clobber. AF, BC, DE, HL.
get_fat:
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT12                ;fs_type vs FAT12
    jp      Z,get_fat12             ;FAT12 stores a 12-bit packed entry
    call    fat_fatent              ;map the cluster into fatwin
    ret     NC                      ;at or past n_fatent, or the sector was not read
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT32                ;fs_type against FAT32
    jr      Z,get_fat32             ;read a 28-bit FAT32 entry
    ld      e,(hl+)
    ld      d,(hl)
    ld      a,d
    cp      $FF                     ;FAT16 end range starts at high byte $FF
    jr      NZ,get_fat16ok          ;not an end mark and not a bad cluster
    ld      a,e
    cp      $F7                     ;FAT16 bad cluster is $FFF7
    jr      Z,get_fat_bad           ;$FFF7 is an error, not a link
    cp      $F8                     ;FAT16 end-of-chain is $FFF8 to $FFFF
    jr      C,get_fat16ok           ;the link is below $FFF8
    ld      de,$FFFF
    ld      bc,$0FFF                ;fold $FFF8..$FFFF to $0FFFFFFF
    scf
    ret
get_fat16ok:
    ld      bc,0
    scf
    ret
get_fat32:
    ld      e,(hl+)
    ld      d,(hl+)
    ld      c,(hl+)
    ld      a,(hl)
    and     $0F                     ;a FAT32 link keeps 28 bits
    ld      b,a
    cp      $0F                     ;the top nibble of an end range is $0F
    jr      NZ,get_fat32ok          ;not an end-range entry
    ld      a,c
    inc     a
    jr      NZ,get_fat32ok          ;byte 2 is not $FF
    ld      a,d
    inc     a
    jr      NZ,get_fat32ok          ;byte 1 is not $FF
    ld      a,e
    cp      $F7                     ;a FAT32 bad cluster is $0FFFFFF7
    jr      Z,get_fat_bad           ;$0FFFFFF7 is an error, not a link
    cp      $F8                     ;FAT32 end-of-chain is $0FFFFFF8 and above
    jr      C,get_fat32ok           ;the link is below $0FFFFFF8
    ld      de,$FFFF
    ld      bc,$0FFF                ;fold the end mark to $0FFFFFFF
get_fat32ok:
    scf
    ret
get_fat_bad:
    or      a                       ;a bad cluster is not a link. Carry is clear.
    ret

; Test that a FAT12 cluster is inside the FAT.
; Call. BCDE is the cluster. E is the low byte.
; Return. Carry set: the cluster is in range. BCDE is unchanged.
; Return. Carry clear: the cluster is below 2, or at or past n_fatent.
; Clobber. AF, HL. BC and DE stay.
fat12_range:
    ld      a,e                     ;a cluster below 2 is not in the FAT
    sub     2
    ld      a,d
    sbc     a,0
    ld      a,c
    sbc     a,0
    ld      a,b
    sbc     a,0
    jr      C,fat12_range_lo        ;the cluster is below 2
    ld      hl,_cpm_fat_vol+4       ;cluster minus n_fatent
    ld      a,e
    sub     (hl+)
    ld      a,d
    sbc     a,(hl+)
    ld      a,c
    sbc     a,(hl+)
    ld      a,b
    sbc     a,(hl)
    ret     NC                      ;the cluster is at or past n_fatent
    scf
    ret
fat12_range_lo:
    or      a                       ;clear the subtract carry. The cluster is below 2.
    ret

; Load the two raw bytes of one FAT12 entry.
; Two clusters share three bytes. The packed offset is cluster plus cluster/2.
; An even cluster owns the low 12 bits. An odd cluster owns the high 12 bits.
; Cluster 341 ends on byte 511 and spans two FAT sectors.
; Call. BCDE is a cluster already known to be in range.
; Return. Carry set: E is the first raw byte and D is the second.
; Return. C is 1 when the cluster is odd. C is 0 when it is even.
; Return. A span leaves the window on the second sector.
; Return. Carry clear: a FAT sector was not read. BCDE is the cluster again.
; Clobber. AF, C, DE, HL. B stays.
fat12_load:
    push    bc
    push    de
    ld      l,e
    ld      h,d
    srl     h
    rr      l                       ;cluster / 2
    add     hl,de                   ;packed offset is cluster plus cluster/2
    ld      a,h
    srl     a                       ;sector is offset / 512
    ld      e,a
    ld      d,0
    ld      bc,0
    ld      hl,_cpm_fat_vol+8       ;+ fatbase
    ld      a,(hl+)
    add     a,e
    ld      e,a
    ld      a,(hl+)
    adc     a,d
    ld      d,a
    ld      a,(hl+)
    adc     a,c
    ld      c,a
    ld      a,(hl)
    adc     a,b
    ld      b,a
    call    fat_move_window
    jr      NC,fat12_load_fail      ;the FAT sector was not read
    pop     de                      ;cluster low
    pop     bc                      ;cluster high
    push    bc
    push    de
    ld      l,e
    ld      h,d
    srl     h
    rr      l
    add     hl,de                   ;packed offset is cluster plus cluster/2
    ld      a,h
    and     1
    ld      h,a                     ;offset inside the 512-byte sector
    ld      a,l
    inc     a
    jr      NZ,fat12_same           ;the offset is not 255 or 511
    ld      a,h
    or      a
    jr      Z,fat12_off255          ;offset 255 stays in this sector
    ld      de,fatwin
    add     hl,de
    ld      c,(hl)                  ;cluster 341. The first byte is at offset 511.
    push    bc
    ld      hl,(fat_winsect)
    inc     hl
    ld      a,h
    or      l
    jr      NZ,fat12_span_lba       ;the next sector does not wrap the low word
    ld      a,(fat_winsect+2)
    add     a,1
    ld      c,a
    ld      a,(fat_winsect+3)
    adc     a,0
    ld      b,a
    jr      fat12_span_go           ;the low word wrapped, so carry into the high word
fat12_span_lba:
    ld      a,(fat_winsect+2)
    ld      c,a
    ld      a,(fat_winsect+3)
    ld      b,a
fat12_span_go:
    ld      e,l
    ld      d,h
    call    fat_move_window
    jr      NC,fat12_span_err       ;the second FAT sector was not read
    ld      a,(fatwin)              ;the second byte is at offset 0
    pop     bc
    ld      e,c
    ld      d,a
    ld      b,1
    jr      fat12_par               ;join the common parity exit
fat12_off255:
    ld      l,255                   ;offset 255. dec a below restores that offset.
fat12_same:
    dec     a                       ;A was one past the low offset byte
    ld      l,a
    ld      de,fatwin
    add     hl,de
    ld      c,(hl+)
    ld      d,(hl)
    ld      e,c
    ld      b,0
fat12_par:
    pop     hl                      ;cluster low
    pop     bc                      ;cluster high, discarded
    ld      a,l
    and     1
    ld      c,a                     ;1 means an odd cluster
    scf
    ret
fat12_span_err:
    pop     bc
fat12_load_fail:
    pop     de                      ;restore the cluster
    pop     bc
    or      a                       ;clear carry. A FAT sector was not read.
    ret

; Turn the raw FAT12 word into a 12-bit link.
; Call. DE is the raw word. E is the first byte. C is 1 when the cluster is odd.
; Return. DE is the 12-bit link. An odd entry is a nibble shift.
; Return. An even entry keeps the low 12 bits.
; Return. The even path clears carry. The odd path leaves carry from the shift.
; Clobber. AF, DE. BC and HL stay.
fat12_value:
    ld      a,c
    or      a
    jr      Z,fat12_even            ;an even cluster keeps the low 12 bits
    srl     d                       ;odd entry: nibble shift
    rr      e
    srl     d
    rr      e
    srl     d
    rr      e
    srl     d
    rr      e
    ret
fat12_even:
    ld      a,d
    and     $0F                     ;keep the low 12 bits
    ld      d,a
    ret

; Read one FAT12 link and fold an end mark to $0FFFFFFF.
; Call. BCDE is the cluster. E is the low byte.
; Return. Carry set: BCDE is the link. A normal link has BC = 0.
; Return. End-of-chain $FF8 to $FFF comes back as $0FFFFFFF.
; Return. Carry clear: the cluster is out of range, the sector was not read, or the link is $FF7.
; Clobber. AF, BC, DE, HL.
get_fat12:
    call    fat12_range
    ret     NC                      ;the cluster is not in the FAT
    call    fat12_load
    ret     NC                      ;a FAT sector was not read
    call    fat12_value             ;DE is the 12-bit link
    ld      a,d
    cp      $0F                     ;an end range has high nibble $0F
    jr      NZ,get_fat12_ok         ;not an end mark and not a bad cluster
    ld      a,e
    cp      $F7                     ;a FAT12 bad cluster is $FF7
    jp      Z,get_fat_bad           ;$FF7 is an error, not a link
    cp      $F8                     ;FAT12 end-of-chain is $FF8 to $FFF
    jr      C,get_fat12_ok          ;the link is below $FF8
    ld      de,$FFFF
    ld      bc,$0FFF                ;fold $FF8..$FFF to $0FFFFFFF
    scf
    ret
get_fat12_ok:
    ld      bc,0
    scf
    ret

; Store the low 12 bits of a link. The neighbour nibble stays as it was.
; Call. BCDE is the cluster. HL points at the new link.
; Return. Carry set: the bytes are in the window and the window is dirty.
; Return. A span marks the first byte dirty before the window moves.
; Return. Carry clear: the cluster is out of range, or a sector was not read.
; Clobber. AF, BC, DE, HL.
; Writes. The FAT bytes in fatwin. fat_wflag. A span may write the first sector.
fat12_store:
    push    hl                      ;source
    push    bc
    push    de
    call    fat12_range
    jp      NC,fat12_store_fail     ;the cluster is not in the FAT
    call    fat12_load              ;DE is the old raw word. C is the odd flag.
    jp      NC,fat12_store_fail     ;a FAT sector was not read
    ld      a,c
    pop     hl                      ;cluster low
    pop     bc                      ;cluster high
    ex      (sp),hl                 ;HL is the source. The stack keeps the cluster low.
    push    bc
    push    af                      ;odd flag
    push    de                      ;old raw word. E is the first byte.
    ld      e,(hl)
    inc     hl
    ld      d,(hl)                  ;new link
    pop     hl                      ;old raw word
    pop     af                      ;odd flag
    or      a
    jr      Z,fat12_st_even         ;an even cluster keeps the low 12 bits
    ld      a,e
    and     $0F
    rlca
    rlca
    rlca
    rlca                            ;(new & $0F) << 4
    ld      c,a
    ld      a,l
    and     $0F
    or      c
    ld      l,a                     ;new first byte
    ld      a,e
    and     $F0
    rlca
    rlca
    rlca
    rlca                            ;new >> 4, low half
    ld      c,a
    ld      a,d
    and     $0F
    rlca
    rlca
    rlca
    rlca
    or      c
    ld      h,a                     ;new second byte
    jr      fat12_st_wr
fat12_st_even:
    ld      a,h
    and     $F0
    ld      c,a
    ld      a,d
    and     $0F
    or      c
    ld      h,a                     ;new second, old high nibble kept
    ld      l,e                     ;new first
fat12_st_wr:
    pop     bc                      ;cluster high
    pop     de                      ;cluster low
    push    hl                      ;new raw: L first, H second
    ld      l,e
    ld      h,d
    srl     h
    rr      l
    add     hl,de                   ;packed offset is cluster plus cluster/2
    ld      a,l
    cp      255
    jr      NZ,fat12_st_same        ;the offset is not 255, so it is not byte 511
    bit     0,h
    jr      NZ,fat12_st_span        ;cluster 341. Byte 511 spans two sectors.
fat12_st_same:
    ld      a,h
    and     1
    ld      h,a                     ;offset in this sector
    ld      de,fatwin
    add     hl,de
    pop     de                      ;E first, D second
    ld      (hl),e
    inc     hl
    ld      (hl),d
    jr      fat12_st_dirty          ;both bytes are in this sector
fat12_st_span:
    ; fat12_load left the window on the second sector. Step back for byte 511.
    ld      hl,(fat_winsect)
    ld      a,h
    or      l
    jr      Z,fat12_st_backhi       ;the low word is 0, so the previous sector borrows
    dec     hl
    ld      e,l
    ld      d,h
    ld      bc,(fat_winsect+2)
    jr      fat12_st_back           ;read the sector that holds byte 511
fat12_st_backhi:
    ld      de,$FFFF
    ld      hl,(fat_winsect+2)
    dec     hl
    ld      b,h
    ld      c,l
fat12_st_back:
    call    fat_move_window         ;the first sector is still clean
    jr      NC,fat12_st_pop         ;the first sector was not read
    pop     hl
    push    hl
    ld      a,l
    ld      (fatwin+511),a
    ld      a,1
    ld      (fat_wflag),a           ;mark the first byte dirty before the window moves
    ld      hl,(fat_winsect)
    inc     hl
    ld      a,h
    or      l
    jr      Z,fat12_st_fwdhi        ;the next sector wraps the low word
    ld      e,l
    ld      d,h
    ld      bc,(fat_winsect+2)
    jr      fat12_st_fwd            ;return to the second sector
fat12_st_fwdhi:
    ld      de,0
    ld      hl,(fat_winsect+2)
    inc     hl
    ld      b,h
    ld      c,l
fat12_st_fwd:
    call    fat_move_window         ;write the first sector, then read the second
    jr      NC,fat12_st_pop         ;the second sector was not read
    pop     hl
    ld      a,h
    ld      (fatwin),a
    jr      fat12_st_dirty          ;the second byte is stored
fat12_st_pop:
    pop     hl
    or      a                       ;clear carry. A spanned sector was not read.
    ret
fat12_st_dirty:
    ld      a,1
    ld      (fat_wflag),a
    scf
    ret
fat12_store_fail:
    pop     de
    pop     bc
    pop     hl
    or      a                       ;clear carry. The entry was not stored.
    ret

; Store a FAT12 link and remember whether the old entry was free.
; The old-free flag is kept for put_fat_wrote, which stores it in C.
; A is reloaded from B only after the write.
; The path is pop bc, then ld a,b, then jp put_fat_wrote.
; Call. BCDE is the cluster. HL points at the new link.
; Return. Carry set: the entry is stored. The exit is put_fat_wrote.
; Return. Carry clear: the store failed. The free count is not changed.
; Clobber. AF, BC, DE, HL.
; Writes. The FAT12 entry, fat_wflag, and the free count when it changes.
put_fat12:
    push    hl
    push    bc
    push    de
    call    get_fat                 ;the old link. Carry clear means bad or unread.
    ld      a,0
    jr      NC,put_fat12_old        ;a bad or unread entry counts as in use
    ld      a,b
    or      c
    or      d
    or      e
    ld      a,0
    jr      NZ,put_fat12_old        ;the old link is not 0, so the cluster is in use
    inc     a                       ;the old entry was free
put_fat12_old:
    pop     de
    pop     bc
    pop     hl
    push    af                      ;A is 1 when the old entry was free
    push    hl
    call    fat12_store
    pop     hl                      ;source
    pop     bc                      ;B is the old-free flag
    ret     NC                      ;the store failed. Do not change the free count.
    ld      a,b                     ;reload A from B only after the write
    push    af
    push    hl
    jp      put_fat_wrote           ;put_fat_wrote keeps the old-free flag in C

; Store a FAT link for one cluster.
; FAT16 stores 16 bits. FAT32 stores 28 bits and keeps the high nibble.
; Call. BCDE is the cluster. HL points at the new link.
; Return. Carry set: the entry is in the window and the window is dirty.
; Return. Carry clear: the cluster is at or past n_fatent, or the sector was not read.
; Return. A cluster below 2 does not take that carry-clear exit.
; Clobber. AF, BC, DE, HL.
; Writes. The FAT entry, fat_wflag, and the free count when free_valid is set.
put_fat:
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT12                ;fs_type vs FAT12
    jp      Z,put_fat12             ;FAT12 stores a 12-bit packed entry
    push    hl
    call    fat_fatent              ;map the cluster into fatwin
    pop     de                      ;DE points at the new link
    ret     NC                      ;at or past n_fatent, or the sector was not read
    ld      a,(_cpm_fat_vol+25)
    or      a
    jr      Z,put_fat_cold          ;free_valid is clear, so skip the old-entry test
    push    de
    push    hl
    call    fat_win_is_free         ;Z: the old FAT entry is free
    ld      a,0
    jr      NZ,put_fat_old          ;the old entry is in use
    inc     a
put_fat_old:
    pop     hl
    pop     de
    jr      put_fat_adj             ;adjust the free count from the old flag
put_fat_cold:
    xor     a                       ;the old flag is 0. The stack still receives AF.
put_fat_adj:
    push    af                      ;A is 1 when the old entry was free
    push    de                      ;source for the new-link test
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT32                ;fs_type vs FAT32
    jr      Z,put_fat32             ;store a 28-bit link
    ld      a,(de+)
    ld      (hl+),a
    ld      a,(de)
    ld      (hl),a
put_fat_wrote:
    pop     de
    pop     af
    ld      c,a                     ;keep the old-free flag in C
    ld      a,(_cpm_fat_vol+25)
    or      a
    jr      Z,put_fat_dirty         ;free_valid is clear, so do not adjust the count
    push    bc
    call    fat_src_is_free         ;Z: the new link is free
    pop     bc
    ld      a,c
    jr      Z,put_fat_new0          ;the new link is free
    or      a
    jr      Z,put_fat_dirty         ;used to used. The free count stays.
    call    fat_nfree_dec           ;free to used
    jr      put_fat_dirty
put_fat_new0:
    or      a
    jr      NZ,put_fat_dirty        ;free to free. The free count stays.
    call    fat_nfree_inc           ;used to free
put_fat_dirty:
    ld      a,1
    ld      (fat_wflag),a
    scf
    ret
put_fat32:
    ld      a,(de+)
    ld      (hl+),a
    ld      a,(de+)
    ld      (hl+),a
    ld      a,(de+)
    ld      (hl+),a
    ld      a,(de)
    and     $0F                     ;keep FAT32 high nibble on disk
    ld      b,a
    ld      a,(hl)
    and     $F0
    or      b
    ld      (hl),a
    jr      put_fat_wrote

; Test whether the FAT entry at HL is free.
; Call. HL points at the entry in memory.
; Return. Z means the entry is free. Carry is clear. HL returns to the first byte.
; Return. FAT32 tests the low 28 bits. FAT16 tests both bytes.
; Clobber. AF. BC, DE, and HL stay.
fat_win_is_free:
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT32                ;fs_type against FAT32
    jr      Z,fat_win_free32        ;test the low 28 bits
    ld      a,(hl+)
    or      (hl-)
    ret
fat_win_free32:
    push    bc
    ld      a,(hl+)
    or      (hl+)
    or      (hl+)
    ld      b,a
    ld      a,(hl-)
    and     $0F                     ;FAT32 free means the low 28 bits are 0
    dec     hl
    dec     hl
    or      b
    pop     bc
    ret

; Test whether the link at DE is free.
; Call. DE points at a little-endian dword.
; Return. Z means the link is free. Carry is clear. DE and HL stay.
; Clobber. AF. BC, DE, and HL stay.
fat_src_is_free:
    push    hl
    ex      de,hl
    call    fat_win_is_free         ;Z: the dword at DE is free
    ex      de,hl
    pop     hl
    ret

; Add one to the free-cluster count.
; Call. No arguments. The caller has a valid free count.
; Return. The count is one higher. fat_fsi_dirty is 1.
; Clobber. AF, HL. BC and DE stay.
; Writes. The free count and fat_fsi_dirty.
fat_nfree_inc:
    ld      hl,(_cpm_fat_vol+28)
    inc     hl
    ld      (_cpm_fat_vol+28),hl
    ld      a,h
    or      l
    jr      Z,fat_nfree_inc_hi      ;low half of free count wrapped
    jp      fat_fsi_mark
fat_nfree_inc_hi:
    ld      hl,(_cpm_fat_vol+30)
    inc     hl
    ld      (_cpm_fat_vol+30),hl
    jp      fat_fsi_mark            ;mark the info sector after the high half increments

; Subtract one from the free-cluster count.
; Call. No arguments.
; Return. Z and carry clear: the count was already 0. It is not changed.
; Return. Otherwise the count is one lower and fat_fsi_dirty is 1.
; Clobber. AF, DE, HL. BC stays.
; Writes. The free count, unless it was already 0.
fat_nfree_dec:
    ld      hl,(_cpm_fat_vol+28)
    ld      a,h
    or      l
    ld      de,(_cpm_fat_vol+30)
    or      d
    or      e
    ret     Z                       ;the free count is already 0
    ld      a,h
    or      l
    jr      NZ,fat_nfree_dec_lo     ;the low half is not zero, so decrement it
    ld      hl,(_cpm_fat_vol+30)
    dec     hl
    ld      (_cpm_fat_vol+30),hl
    ld      hl,(_cpm_fat_vol+28)
fat_nfree_dec_lo:
    dec     hl
    ld      (_cpm_fat_vol+28),hl
    jp      fat_fsi_mark

; Load a little-endian dword into BCDE.
; Call. HL points at the dword.
; Return. E is the low byte. HL is left on the last byte.
; Return. A caller that reads the next dword must inc hl first.
; Return. Flags are unchanged.
; Clobber. BC, DE, HL. AF stays.
fat_ld32:
    ld      e,(hl+)
    ld      d,(hl+)
    ld      c,(hl+)
    ld      b,(hl)
    ret

; Store BCDE as a little-endian dword at HL.
; Call. HL points at the destination. E is the low byte.
; Return. HL is left on the last byte. Flags are unchanged.
; Clobber. HL. AF, BC, and DE stay.
; Writes. Four bytes at HL.
fat_st32:
    ld      (hl+),e
    ld      (hl+),d
    ld      (hl+),c
    ld      (hl),b
    ret

; Find the cluster that holds a file offset.
; The index is (file pointer >> 9) / csize. A sector is 512 bytes.
; Call. HL points at a start cluster and a file pointer. Both are little-endian dwords.
; Return. Carry set: BCDE is that cluster. E is the low byte. The cache records the walk.
; Return. Carry clear: the index does not fit, the chain ended, or a link was not read.
; Clobber. AF, BC, DE, HL.
; Writes. fat_work. On success, the cluster cache.
clst_from_off:
    call    fat_ld32                ;load the start cluster
    ld      (fat_work),de           ;sclust
    ld      (fat_work+2),bc
    inc     hl
    call    fat_ld32                ;file pointer
    ; The index is (file pointer >> 9) / csize. A sector is 512 bytes.
    ; The first shift is a byte slide. One more shift completes >> 9.
    ld      e,d
    ld      d,c
    ld      c,b
    ld      b,0                     ;file pointer >> 8
    srl     c                       ;divide by 512. This is the sector index.
    rr      d
    rr      e                       ;sector index in CDE
    ld      a,(_cpm_fat_vol+1)
    ld      b,0
cfo_log:
    srl     a
    jr      Z,cfo_div               ;csize bit count is done
    inc     b
    jr      cfo_log
cfo_div:
    ld      a,b
    or      a
    jr      Z,cfo_ci                ;csize is one sector
cfo_shr:
    srl     c                       ;sector index / csize
    rr      d
    rr      e
    djnz    cfo_shr                 ;index is still shifting
cfo_ci:
    ld      a,c
    or      a
    jp      NZ,cfo_bad              ;cluster index does not fit in 16 bits
    ld      a,(_cpm_fat_vol+6)
    ld      hl,_cpm_fat_vol+7
    or      (hl)
    jr      NZ,cfo_ci_ok            ;n_fatent above 65535
    ld      hl,(_cpm_fat_vol+4)
    or      a
    sbc     hl,de                   ;n_fatent - index
    jp      C,cfo_bad               ;the index is past the FAT
    jp      Z,cfo_bad               ;the index equals n_fatent, so it is not in the FAT
cfo_ci_ok:
    ; n_fatent above 65535 skips the range subtract. DE is still the index.
    ld      (fat_work+4),de         ;the store writes that index
    ld      hl,clst_cache_sclust
    ld      a,(fat_work)
    cp      (hl)                    ;cache vs sclust +0
    jr      NZ,cfo_from0            ;cache is another file
    inc     hl
    ld      a,(fat_work+1)
    cp      (hl)                    ;cache vs sclust +1
    jr      NZ,cfo_from0            ;cache is another file
    inc     hl
    ld      a,(fat_work+2)
    cp      (hl)                    ;cache vs sclust +2
    jr      NZ,cfo_from0            ;cache is another file
    inc     hl
    ld      a,(fat_work+3)
    cp      (hl)                    ;cache vs sclust +3
    jr      NZ,cfo_from0            ;cache is another file
    ld      hl,(clst_cache_ci)
    ld      de,(fat_work+4)
    or      a
    sbc     hl,de                   ;cache_ci - want_ci
    jr      Z,cfo_cached            ;want_ci is the cached index
    jr      NC,cfo_from0            ;want is behind the cache
    ld      hl,(fat_work+4)
    ld      de,(clst_cache_ci)
    or      a                       ;clear carry left by cache_ci minus want
    sbc     hl,de
    ld      (fat_work+8),hl         ;steps from cached cluster
    ld      de,(clst_cache_clst)
    ld      bc,(clst_cache_clst+2)
    jr      cfo_loop
cfo_from0:
    ld      hl,(fat_work+4)
    ld      (fat_work+8),hl         ;steps from sclust
    ld      de,(fat_work)
    ld      bc,(fat_work+2)
cfo_loop:
    ld      a,(fat_work+8)
    ld      hl,fat_work+9
    or      (hl)
    jr      Z,cfo_have              ;the offset is consumed
    call    get_fat                 ;next cluster. This walk has no cycle counter.
    ret     NC                      ;a bad cluster, or the entry was not read
    ld      a,b
    cp      $0F                     ;an end mark has top nibble $0F
    jr      NZ,cfo_store            ;not an end mark
    ld      a,c
    and     d
    and     e
    inc     a
    jr      Z,cfo_bad               ;the link is $0FFFFFFF
cfo_store:
    ld      hl,(fat_work+8)
    dec     hl
    ld      (fat_work+8),hl
    jr      cfo_loop                ;one cluster remains in the walk
cfo_cached:
    ld      de,(clst_cache_clst)
    ld      bc,(clst_cache_clst+2)
cfo_have:
    ld      (clst_cache_clst),de
    ld      (clst_cache_clst+2),bc
    ld      hl,(fat_work)
    ld      (clst_cache_sclust),hl
    ld      hl,(fat_work+2)
    ld      (clst_cache_sclust+2),hl
    ld      hl,(fat_work+4)
    ld      (clst_cache_ci),hl
    scf
    ret
cfo_bad:
    or      a                       ;clear carry. The offset is not in the chain.
    ret

; Allocate one cluster and link it on the chain.
; A new chain starts at fat_last_clst when that hint is a real cluster.
; That hint is FSI_Nxt_Free. Otherwise the scan starts at cluster 2.
; An extension starts at the next cluster, and takes it when it is free.
; The scan wraps once to cluster 2 and stops at the start cluster.
; The tail is not read twice.
; Call. BCDE is the previous cluster. Zero starts a new chain.
; Return. Carry set: BCDE is the new cluster.
; Return. The new cluster is marked end-of-chain, then linked.
; Return. A failed second FAT copy leaves the first copy written.
; Return. This exit is still success. fat_sync_window does not decide it.
; Return. Carry clear: no free cluster remains, a read failed, cc_wipe failed, or put_fat did not store the link.
; Return. If the link store fails, the end mark may already sit in the window.
; Clobber. AF, BC, DE, HL.
; Writes. The FAT, fat_last_clst, the cluster data, and fat_fsi_dirty.
create_chain:
    ld      (fat_work+8),de         ;link-from
    ld      (fat_work+10),bc
    xor     a
    ld      (fat_work+7),a          ;wrap flag
    ld      a,b
    or      c
    or      d
    or      e
    jr      Z,cc_hint               ;cluster 0 starts a new chain
    inc     de
    ld      a,d
    or      e
    jr      NZ,cc_mark              ;cluster+1 fits in the low word
    inc     bc                      ;cluster+1 wrapped the low word
    jr      cc_mark                 ;search from the next cluster
cc_hint:
    ld      de,(fat_last_clst)
    ld      bc,(fat_last_clst+2)
    ld      a,b
    or      c
    or      d
    jr      NZ,cc_hint_hi           ;hint is above 255
    ld      a,e
    cp      2                       ;a hint below cluster 2 is not a cluster
    jr      C,cc_from2              ;no hint, or the hint is 0 or 1
cc_hint_hi:
    push    bc
    push    de
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
    jr      C,cc_hint_bad           ;hint is past n_fatent
    or      c
    or      h
    or      l
    jr      Z,cc_hint_bad           ;the hint is at or past n_fatent
    pop     de
    pop     bc
    jr      cc_mark                 ;the hint is inside the FAT
cc_hint_bad:
    pop     de
    pop     bc
cc_from2:
    ld      de,2                    ;cluster 2 is the first real cluster
    ld      bc,0
cc_mark:
    ld      (fat_work),de           ;search origin
    ld      (fat_work+2),bc
cc_scan:
    ld      (fat_work+12),de
    ld      (fat_work+14),bc
    ld      hl,(_cpm_fat_vol+4)
    ld      a,l
    sub     e                       ;n_fatent - candidate
    ld      l,a
    ld      a,h
    sbc     a,d
    ld      h,a
    ld      a,(_cpm_fat_vol+6)
    sbc     a,c
    ld      c,a
    ld      a,(_cpm_fat_vol+7)
    sbc     a,b
    jp      C,cc_wrap               ;candidate is past n_fatent
    or      c
    or      h
    or      l
    jp      Z,cc_wrap               ;candidate >= n_fatent
    ld      de,(fat_work+12)
    ld      bc,(fat_work+14)
    ld      a,(fat_work+7)
    or      a
    jr      Z,cc_look               ;first pass does not stop early
    ld      hl,(fat_work)           ;wrapped: stop on return to origin
    ld      a,e
    cp      l                       ;candidate vs origin +0
    jr      NZ,cc_look              ;not back at the origin
    ld      a,d
    cp      h                       ;candidate vs origin +1
    jr      NZ,cc_look              ;not back at the origin
    ld      hl,(fat_work+2)
    ld      a,c
    cp      l                       ;candidate vs origin +2
    jr      NZ,cc_look              ;not back at the origin
    ld      a,b
    cp      h                       ;candidate vs origin +3
    jp      Z,cc_fail               ;scan returned to its origin
cc_look:
    call    get_fat                 ;read the candidate FAT entry
    ret     NC                      ;bad cluster, or the entry cannot be read
    ld      a,b
    or      c
    or      d
    or      e
    jp      NZ,cc_next              ;in use
    ld      de,(fat_work+12)
    ld      bc,(fat_work+14)
    call    cc_wipe                 ;zero data before the FAT link is published
    ret     NC                      ;data sectors were not cleared
    ld      de,(fat_work+12)
    ld      bc,(fat_work+14)
    ld      hl,cc_eoc
    call    put_fat                 ;mark the new cluster end-of-chain first
    ret     NC                      ;the end mark was not stored
    ld      a,(fat_work+8)
    ld      hl,fat_work+9
    or      (hl+)
    or      (hl+)
    or      (hl)
    jr      Z,cc_ok                 ;no previous cluster to link
    push    bc
    push    de
    ld      de,(fat_work+8)
    ld      bc,(fat_work+10)
    ld      hl,fat_work+12
    call    put_fat                 ;link the previous cluster after the end mark
    pop     de
    pop     bc
    ret     NC                      ;the link was not stored. The end mark may already be written.
cc_ok:
    ld      de,(fat_work+12)
    ld      bc,(fat_work+14)
    ld      (fat_last_clst),de
    ld      (fat_last_clst+2),bc
    call    fat_fsi_mark            ;mark FSInfo for rewrite
    call    fat_sync_window         ;a failed second copy leaves the first FAT written
cc_ret_cl:
    ld      de,(fat_work+12)        ;the sync result is ignored
    ld      bc,(fat_work+14)
    scf                             ;this exit is still success
    ret
cc_next:
    ld      de,(fat_work+12)
    ld      bc,(fat_work+14)
    inc     de
    ld      a,d
    or      e
    jp      NZ,cc_scan              ;the candidate low word did not wrap
    inc     bc
    jp      cc_scan                 ;the candidate low word wrapped
cc_wrap:
    ld      a,(fat_work+7)
    or      a
    jr      NZ,cc_fail              ;the scan already wrapped
    ld      a,1
    ld      (fat_work+7),a
    ld      a,(fat_work)            ;origin == 2 means the whole volume was seen
    cp      2                       ;origin vs cluster 2
    jr      NZ,cc_wrap2             ;origin is not cluster 2
    ld      a,(fat_work+1)
    or      a
    jr      NZ,cc_wrap2             ;origin byte 1 is not 0
    ld      a,(fat_work+2)
    or      a
    jr      NZ,cc_wrap2             ;origin byte 2 is not 0
    ld      a,(fat_work+3)
    or      a
    jr      Z,cc_fail               ;the origin was cluster 2, so the FAT is full
cc_wrap2:
    ld      de,2                    ;resume at cluster 2
    ld      bc,0
    jp      cc_scan                 ;the scan has wrapped once
cc_fail:
    or      a                       ;clear carry. The scan found no free cluster.
    ret
cc_eoc:
    defb    $FF,$FF,$FF,$0F         ;end-of-chain link $0FFFFFFF

; Write zeros over every sector of one cluster before the FAT link is published.
; Call. BCDE is the cluster. E is the low byte.
; Return. Carry set: those sectors are zero on disk. The window is not a cached sector.
; Return. Carry clear: csize is 0, the cluster has no LBA, or a write failed.
; Clobber. AF, BC, DE, HL.
; Writes. The cluster sectors. fatwin is filled with zeros. fat_winsect becomes $FFFF.
cc_wipe:
    ld      a,(_cpm_fat_vol+1)
    or      a
    jr      Z,cc_wipe_bad           ;csize is 0
    push    bc
    push    de
    call    clst2sect               ;LBA of this cluster
    jr      C,cc_wipe_lba           ;the cluster has an LBA
    pop     de
    pop     bc
cc_wipe_bad:
    or      a                       ;clear carry. The cluster was not cleared.
    ret
cc_wipe_lba:
    pop     hl
    pop     hl
    ld      a,(_cpm_fat_vol+1)
    push    bc
    push    de
    push    af
    call    fat_sync_window         ;flush fatwin before the zero fill
    jr      C,cc_wipe_clr           ;flush succeeded
    pop     af
    pop     de
    pop     bc
    or      a                       ;clear carry. The dirty window was not written.
    ret
cc_wipe_clr:
    ld      hl,$FFFF                ;the window must not stay a cached FAT sector
    ld      (fat_winsect),hl
    ld      (fat_winsect+2),hl
    xor     a
    ld      (fat_wflag),a
    ld      hl,fatwin
    ld      de,hl
    inc     de
    ld      (hl),a
    ld      bc,511                  ;one more byte makes a 512-byte sector
    ldir
cc_wipe_wr:
    pop     af
    pop     de
    pop     bc
    push    bc
    push    de
    push    af
    ld      hl,fatwin
    call    ide_write_sector        ;carry set: zero sector written. HL is fatwin plus 512.
    jr      C,cc_wipe_adv           ;the zero sector is on disk
    pop     af
    pop     de
    pop     bc
    or      a                       ;clear carry. A zero sector was not written.
    ret
cc_wipe_adv:
    pop     af
    pop     de
    pop     bc
    dec     a
    jr      Z,cc_wipe_ok            ;every sector of the cluster
    push    af
    inc     de
    ld      a,d
    or      e
    jr      NZ,cc_wipe_push         ;the LBA low word did not wrap
    inc     bc
cc_wipe_push:
    pop     af
    push    bc
    push    de
    push    af
    jr      cc_wipe_wr              ;write the next sector of this cluster
cc_wipe_ok:
    scf
    ret

; Free a cluster chain.
; The walk stops at 0 or at a link that is not a real cluster.
; A link at or past n_fatent is not a real cluster.
; The step stops at n_fatent so a long FAT32 chain is not cut at 65535.
; Call. BCDE is the first cluster. E is the low byte.
; Return. Carry set and Z: the cluster is 0. Nothing is freed.
; Return. Carry set: clusters were freed until the next link stopped the walk.
; Return. Carry clear: a link was bad or not read, the free store failed, or the step reached n_fatent.
; Clobber. AF, BC, DE, HL.
; Writes. Each freed FAT entry, and the free count when free_valid is set.
remove_chain:
    ld      a,b
    or      c
    or      d
    or      e
    scf
    ret     Z                       ;cluster 0 frees nothing. Carry stays set.
    ld      hl,0
    ld      (fat_work),hl           ;32-bit step
    ld      (fat_work+2),hl
rc_loop:
    ld      hl,(fat_work)
    inc     hl
    ld      (fat_work),hl
    ld      a,h
    or      l
    jr      NZ,rc_cmp               ;step low did not wrap
    ld      hl,(fat_work+2)
    inc     hl
    ld      (fat_work+2),hl
rc_cmp:
    push    bc
    push    de
    ld      de,(fat_work)
    ld      bc,(fat_work+2)
    ld      hl,_cpm_fat_vol+4       ;step - n_fatent
    ld      a,e
    sub     (hl+)                   ;step - n_fatent
    ld      a,d
    sbc     (hl+)
    ld      a,c
    sbc     (hl+)
    ld      a,b
    sbc     a,(hl)
    pop     de
    pop     bc
    jr      NC,rc_fail              ;the step is at or past n_fatent
    ld      (fat_work+8),de
    ld      (fat_work+10),bc
    call    get_fat                 ;the next link. Stop on 0 or on a link that is not real.
    ret     NC                      ;a bad cluster, or the entry was not read
    ld      (fat_work+12),de        ;next
    ld      (fat_work+14),bc
    ld      de,(fat_work+8)
    ld      bc,(fat_work+10)
    ld      hl,cc_zero
    call    put_fat                 ;store a free FAT entry
    ret     NC                      ;free entry was not stored
    ld      de,(fat_work+12)
    ld      bc,(fat_work+14)
    ld      a,b
    or      c
    or      d
    or      e
    jr      Z,rc_done               ;the next link is 0, so the chain ends
    ld      hl,_cpm_fat_vol+4       ;next >= n_fatent ends the walk
    ld      a,e
    sub     (hl+)                   ;next link - n_fatent
    ld      a,d
    sbc     (hl+)
    ld      a,c
    sbc     (hl+)
    ld      a,b
    sbc     a,(hl)
    jr      C,rc_loop               ;the next link is below n_fatent, so it is a real cluster
rc_done:
    scf                             ;stopped on 0 or on a link that is not a real cluster
    ret
rc_fail:
    or      a                       ;clear carry. The step reached n_fatent.
    ret
cc_zero:
    defb    0,0,0,0                 ;zero dword. A free link and a fake end of directory.

; Exclusive byte end of the FAT16 root.
; A shorter database minus dirbase span can clamp that end.
; Call. No arguments.
; Return. Carry set: the root has 2048 entries. HL is 0. Every 16-bit offset fits.
; Return. Carry clear: HL is the exclusive byte end.
; Return. An offset at or past HL is outside the root.
; Clobber. AF, DE, HL. BC stays.
fat_root16_max:
    ld      hl,(_cpm_fat_vol+2)
    ld      a,l
    and     $F0                     ;a FAT16 root count is a multiple of 16
    ld      l,a
    ld      a,h
    cp      8                       ;2048 entries times 32 bytes is 65536
    jr      C,frm_mul               ;fewer than 2048 root entries
    ld      hl,0
    scf
    jr      frm_clamp               ;2048 entries cover every 16-bit offset
frm_mul:
    add     hl,hl
    add     hl,hl
    add     hl,hl
    add     hl,hl
    add     hl,hl                   ;times 32. One directory entry is 32 bytes.
    or      a                       ;the byte count fits in 16 bits
frm_clamp:
    push    hl
    push    af                      ;C = entry count covers 64K
    ld      a,(_cpm_fat_vol+18)     ;database high
    ld      hl,_cpm_fat_vol+14
    or      (hl)                    ;dirbase high
    jr      NZ,frm_keep             ;database or dirbase above 64K
    ld      hl,(_cpm_fat_vol+16)
    ld      de,(_cpm_fat_vol+12)
    or      a
    sbc     hl,de                   ;database - dirbase (sectors)
    jr      C,frm_keep              ;database is below dirbase
    jr      Z,frm_keep              ;root span is empty
    ld      a,h
    or      a
    jr      NZ,frm_keep             ;>= 256 sectors
    ld      a,l
    cp      128                     ;128 sectors times 512 bytes is 65536
    jr      NC,frm_keep             ;128 sectors or more is at least 64 KiB
    ld      h,l
    ld      l,0
    add     hl,hl                   ;span << 9, fits in 16 bits
    pop     af
    pop     de                      ;DE = count end
    jr      C,frm_span              ;the count was 65536, so the span is tighter
    push    hl
    or      a
    sbc     hl,de                   ;span minus the count end
    pop     hl
    jr      C,frm_clear             ;the byte span is the tighter end
    ex      de,hl                   ;the count end is tighter, or the two ends match
frm_clear:
    or      a                       ;clear carry. HL is the exclusive end.
    ret
frm_span:
    or      a                       ;clear carry. The span is the exclusive end.
    ret
frm_keep:
    pop     af                      ;restore carry when 2048 entries cover the root
    pop     hl
    ret

; Seek a directory to a byte offset. Cluster 0 means the root.
; The caller aligns the offset to one directory entry of 32 bytes.
; Call. BCDE is the start cluster. HL is the byte offset.
; Return. Carry set: the window holds that sector and dir_ptr points at the offset.
; Return. Carry clear: the offset is outside the root or the chain, or the sector was not read.
; Clobber. AF, BC, DE, HL.
; Writes. dir_sclust, dir_ofs, dir_clust, dir_sect, and dir_ptr.
dir_sdi:
    ld      (dir_sclust),de
    ld      (dir_sclust+2),bc
    ld      (dir_ofs),hl
    ld      a,b
    or      c
    or      d
    or      e
    jr      NZ,dsdi_chain           ;cluster 0 means the root. This cluster is not 0.
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT32                ;fs_type against FAT32
    jr      NZ,dsdi_root16          ;FAT16 root is the static dirbase
    ld      de,(_cpm_fat_vol+12)    ;FAT32 root is BPB_RootClus, stored in dirbase
    ld      bc,(_cpm_fat_vol+14)
    ld      (dir_sclust),de
    ld      (dir_sclust+2),bc
    jr      dsdi_chain              ;follow that root cluster
dsdi_root16:
    ld      (dir_clust),bc          ;BC is 0. The FAT16 root is not a cluster chain.
    ld      (dir_clust+2),bc
    push    hl                      ;ofs
    call    fat_root16_max          ;C: any 16-bit offset fits
    jr      C,dsdi_root16_in        ;2048 entries: any 16-bit ofs
    ex      de,hl                   ;DE = max
    pop     hl                      ;HL = dir_ofs
    push    hl
    or      a
    sbc     hl,de                   ;unsigned ofs >= max
    pop     hl
    jp      NC,dsdi_end             ;offset is past the FAT16 root
    jr      dsdi_root
dsdi_root16_in:
    pop     hl
dsdi_root:
    ld      a,h                     ;offset >> 9
    srl     a
    ld      e,a
    ld      d,0
    ld      hl,(_cpm_fat_vol+12)    ;dirbase LBA
    add     hl,de                   ;dirbase + root sector
    ld      (dir_sect),hl
    ld      hl,(_cpm_fat_vol+14)
    ld      de,0
    adc     hl,de
    ld      (dir_sect+2),hl
    ld      a,(dir_ofs)
    ld      e,a
    ld      a,(dir_ofs+1)
    and     1
    ld      d,a
    ld      hl,fatwin
    add     hl,de
    ld      (dir_ptr),hl
    ld      de,(dir_sect)
    ld      bc,(dir_sect+2)
    call    fat_move_window         ;C: root sector in fatwin
    ret
dsdi_chain:
    ld      hl,dir_sclust
    ld      de,fat_work
    ld      bc,4
    ldir                            ;copy the start cluster. The file pointer follows.
    ld      hl,(dir_ofs)
    ld      (fat_work+4),hl
    ld      hl,0
    ld      (fat_work+6),hl         ;fptr 32-bit
    ld      hl,fat_work
    call    clst_from_off           ;cluster that holds this offset
    ret     NC                      ;offset is not in the chain
    ld      (dir_clust),de          ;cluster containing ofs
    ld      (dir_clust+2),bc
    call    clst2sect               ;LBA of that cluster
    ret     NC                      ;cluster has no LBA
    ; add sector-in-cluster: (dir_ofs >> 9) % csize
    ld      a,(dir_ofs+1)
    srl     a                       ;offset / 512. A sector is 512 bytes.
    ld      hl,_cpm_fat_vol+1
    ld      l,(hl)                  ;csize is 2^n
    dec     l
    and     l                       ;sector inside the cluster
    ld      l,a
    ld      h,0
    add     hl,de                   ;cluster LBA + sector
    ex      de,hl                   ;DE = LBA + sector-in-cluster
    jr      NC,dsdi_sec             ;LBA low did not wrap
    inc     bc
dsdi_sec:
    ld      (dir_sect),de
    ld      (dir_sect+2),bc
    call    fat_move_window         ;directory sector into fatwin
    ret     NC                      ;directory sector not read
    ld      a,(dir_ofs)
    ld      e,a
    ld      a,(dir_ofs+1)
    and     1
    ld      d,a
    ld      hl,fatwin
    add     hl,de
    ld      (dir_ptr),hl
    scf
    ret
dsdi_end:
    or      a                       ;clear carry. The offset is past the FAT16 root.
    ret

; Step to the next directory entry. This does not stretch the directory.
; A 16-bit offset wrap stops a long directory at 2048 entries.
; Call. No arguments. The position is dir_ofs, dir_ptr, dir_clust, and dir_sect.
; Return. Carry set means another entry.
; Return. Carry clear and Z means a clean end. dir_next_end is xor a.
; Return. Carry clear and NZ means a disk or chain error.
; Clobber. AF, BC, DE, HL.
; Writes. dir_ofs and dir_ptr. A new sector also writes dir_sect, dir_clust, and the window.
dir_next:
    ld      hl,(dir_ofs)
    ld      bc,32                   ;one directory entry is 32 bytes
    add     hl,bc
    jp      C,dir_next_end          ;a 16-bit wrap stops the directory at 2048 entries
    ld      a,l
    or      a
    jr      NZ,dir_next_same        ;still inside this 512-byte sector
    ld      a,h
    and     1                       ;bit 9 of the offset. A sector is 512 bytes.
    jr      Z,dir_next_sect         ;the offset is on a sector boundary
dir_next_same:
    ld      (dir_ofs),hl
    ld      hl,(dir_ptr)
    ld      de,32                   ;one directory entry is 32 bytes
    add     hl,de
    ld      (dir_ptr),hl
    scf
    ret
dir_next_sect:
    ld      (dir_ofs),hl
    ld      hl,(dir_clust)
    ld      a,h
    or      l
    ld      hl,(dir_clust+2)
    or      h
    or      l
    jr      NZ,dir_next_dyn         ;directory is a cluster chain
    call    fat_root16_max          ;byte end of the FAT16 root
    jr      C,dir_next_inc          ;2048 entries: ofs still inside
    ex      de,hl                   ;DE = max
    ld      hl,(dir_ofs)
    or      a
    sbc     hl,de
    jp      NC,dir_next_end         ;unsigned ofs >= max
dir_next_inc:
    ld      hl,(dir_sect)
    inc     hl
    ld      (dir_sect),hl
    ld      a,h
    or      l
    jr      NZ,dir_next_win         ;the sector low word did not wrap
    ld      hl,(dir_sect+2)
    inc     hl
    ld      (dir_sect+2),hl
    jr      dir_next_win            ;the sector low word wrapped
dir_next_dyn:
    ld      a,(dir_ofs+1)
    srl     a                       ;offset / 512. A sector is 512 bytes.
    ld      hl,_cpm_fat_vol+1
    ld      l,(hl)                  ;csize
    dec     l
    and     l                       ;(ofs/512) & (csize-1)
    jr      NZ,dir_next_inc         ;still in this cluster
    ld      de,(dir_clust)
    ld      bc,(dir_clust+2)
    call    get_fat                 ;next cluster of this directory
    jp      NC,dir_next_io          ;bad cluster or unreadable
    ld      a,b
    cp      $0F                     ;an end mark has top nibble $0F
    jr      NZ,dir_next_got         ;not an end mark
    ld      a,c
    and     d
    and     e
    inc     a
    jp      Z,dir_next_end          ;the link is $0FFFFFFF, so the directory ends
dir_next_got:
    ld      a,e
    sub     2                       ;a cluster below 2 is not real
    ld      a,d
    sbc     a,0
    ld      a,c
    sbc     a,0
    ld      a,b
    sbc     a,0
    jp      C,dir_next_io           ;the next cluster is below 2
    ld      (dir_clust),de
    ld      (dir_clust+2),bc
    call    clst2sect               ;LBA of the next cluster
    jp      NC,dir_next_io          ;next cluster has no LBA
    ld      (dir_sect),de
    ld      (dir_sect+2),bc
dir_next_win:
    ld      de,(dir_sect)
    ld      bc,(dir_sect+2)
    call    fat_move_window         ;directory sector into fatwin
    jp      NC,dir_next_io          ;directory sector not read
    ld      hl,fatwin               ;the offset is on a 512-byte boundary
    ld      (dir_ptr),hl
    scf                             ;carry set means another entry
    ret
dir_next_end:
    xor     a                       ;carry clear and Z. This is a clean end.
    ret

dir_next_io:
    ld      a,1
    or      a                       ;carry clear and NZ. This is a disk or chain error.
    ret
