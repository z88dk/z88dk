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
; Mini-FAT12/16/32 (gbz80).
; jr is native when the target is in this file and in range.
; A cross-module target stays jp.
; ld hl,sp+n is native and forces Z = 0.
;
; The human description is mini-fat.md in this directory.
; ChaN's application interface is
; http://elm-chan.org/fsw/ff/00index_e.html
; This file is the sector and directory layer under that interface.
;
; Same PUBLIC API, BSS names, and function contracts as the Z80 core.
; ROM-resident, no PHASE. Shell buffers live in fat_bss.asm (RAM).
; The sector window is fatwin.
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
;   Specification 1.03 also allows sectors of 1024, 2048, and 4096 bytes.
;
; Checks this file does not make:
;   JumpBoot. 55AA is required. ChaN accepts some VBRs that have no 55AA.
;   BPB_Media. Partition type. GPT and extended partitions fail the VBR check.
;   FAT entry 0 is not compared with BPB_Media.
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
EXTERN  dir_clust                           ; cluster of the current directory sector
EXTERN  dir_sect
EXTERN  dir_ofs
EXTERN  fat_work
EXTERN  pack_sv
EXTERN  fat_last_clst                       ; last cluster this session allocated
EXTERN  fat_fsi_lba                         ; absolute FSInfo LBA, or 0
EXTERN  fat_fsi_dirty                       ; 1 = write FSI_Free_Count and FSI_Nxt_Free
EXTERN  clst_cache_sclust
EXTERN  clst_cache_ci
EXTERN  clst_cache_clst

PUBLIC  clst2sect                           ; cluster -> first sector LBA
PUBLIC  fat_sync_window                     ; write fatwin if dirty, then mirror FAT#2
PUBLIC  _fat_sync                           ; C: fat_sync_window
PUBLIC  fat_move_window                     ; flush dirty, read LBA into fatwin
PUBLIC  get_fat                             ; next cluster from FAT entry
PUBLIC  put_fat                             ; store next cluster in FAT
PUBLIC  clst_from_off                       ; cluster containing file offset
PUBLIC  create_chain                        ; allocate and link a new cluster
PUBLIC  remove_chain                        ; free a cluster chain
PUBLIC  dir_sdi                             ; seek directory to byte offset
PUBLIC  dir_next                            ; next 32-byte dirent (no stretch)


; Copy BC bytes from HL to DE.
; Call. HL is the source. DE is the destination. BC is the count.
; Return. HL and DE point past the last byte copied.
; Return. BC is 0. A count of 0 copies 65536 bytes.
; Clobber. AF, BC, DE, HL.
; The page test is inc b and inc c. dec bc does not set Z.
fat_copy:
    dec     bc
    inc     b
    inc     c
fat_copy_lp:
    ld      a,(hl+)                         ; byte copy, not ldir
    ld      (de+),a
    dec     c
    jr      NZ,fat_copy_lp                  ; more bytes in this page
    dec     b
    jr      NZ,fat_copy_lp                  ; more pages
    ret

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
    ld      hl,_cpm_fat_vol+4               ; n_fatent, little-endian
    ld      a,e
    sub     (hl+)                           ; cluster - n_fatent
    ld      a,d
    sbc     a,(hl+)
    ld      a,c
    sbc     a,(hl+)
    ld      a,b
    sbc     a,(hl)
    ret     NC                              ; cluster is at or past n_fatent
    ld      a,e
    sub     2                               ; cluster below 2 is invalid
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
    jr      C,clst2sect_ov                  ; cluster is below 2
    ld      hl,de                           ; DEHL = clst-2
    ld      de,bc
    ld      a,(_cpm_fat_vol+1)              ; csize is 2^n
    ld      b,a                             ; csize stays in B
clst2sect_mul:
    ld      a,b
    or      a                               ; rra forces Z = 0, so Z is taken after the shift
    rra
    ld      b,a
    or      a                              ; Z comes from the bits still to shift. Carry is clear for the add.
    jr      Z,clst2sect_base                ; every csize bit is consumed
    add     hl,hl                           ; (clst-2)<<1. Carry enters the high half.
    rl      e                               ; high half << 1. A stays.
    rl      d
    jr      C,clst2sect_ov                  ; (cluster-2) times csize wrapped
    jr      clst2sect_mul                   ; shift the next csize bit
clst2sect_base:
    ld      bc,de
    ld      de,hl                           ; BCDE = (clst-2)*csize
    ld      hl,_cpm_fat_vol+16              ; database
    ld      a,(hl+)
    add     a,e                             ; database plus the scaled cluster
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
    jr      C,clst2sect_ov                  ; database plus the product wrapped
    scf
    ret

clst2sect_ov:
    or      a                               ; clear carry. This cluster has no sector.
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
    jr      Z,fat_sync_ok                   ; the window is already clean
    call    fat_ldhl
    defw    fat_winsect+2
    ld      bc,hl
    call    fat_ldhl
    defw    fat_winsect
    ld      de,hl
    ld      hl,fatwin                       ; sector window
    call    ide_write_sector                ; carry set: sector written. HL is fatwin plus 512.
    ld      hl,1
    ret     NC                              ; the write failed. Leave the window dirty.
    ld      a,(_cpm_fat_vol+24)             ; n_fats
    cp      2                               ; one FAT has no mirror
    jr      C,fat_sync_clear                ; n_fats is below 2
    ld      hl,_cpm_fat_vol+8               ; winsect minus fatbase
    ld      a,(fat_winsect)
    sub     (hl+)                           ; winsect minus fatbase
    ld      e,a
    ld      a,(fat_winsect+1)
    sbc     a,(hl+)
    ld      d,a
    ld      a,(fat_winsect+2)
    sbc     a,(hl+)
    ld      c,a
    ld      a,(fat_winsect+3)
    sbc     a,(hl)
    jr      C,fat_sync_clear                ; the sector is below fatbase
    ld      b,a                             ; BCDE is winsect minus fatbase
    ld      hl,_cpm_fat_vol+20              ; compare with fatsz
    ld      a,e
    sub     (hl+)                           ; offset in the FAT minus fatsz
    ld      a,d
    sbc     a,(hl+)
    ld      a,c
    sbc     a,(hl+)
    ld      a,b
    sbc     a,(hl)
    jr      NC,fat_sync_clear               ; the sector is not in the first FAT
    call    fat_ldhl
    defw    fat_winsect+2
    ld      bc,hl                           ; park winsect high
    call    fat_ldhl
    defw    fat_winsect
    ld      de,(_cpm_fat_vol+20)
    add     hl,de                           ; mirror LBA is winsect plus fatsz
    ld      de,hl                           ; DE = winsect.lo + fatsz.lo
    call    fat_ldhl
    defw    _cpm_fat_vol+22
    ld      a,c
    adc     a,l
    ld      c,a
    ld      a,b
    adc     a,h
    ld      b,a                             ; BCDE = winsect + fatsz
    ld      hl,fatwin
    call    ide_write_sector                ; carry set: mirror written. HL is fatwin plus 512.
    ld      hl,1
    ret     NC                              ; the mirror failed. The first FAT copy is on disk.
fat_sync_clear:
    xor     a                               ; no mirror is required
    ld      (fat_wflag),a
fat_sync_ok:
    call    fat_fsi_write                   ; write FSInfo when it is dirty
    ld      hl,0
    scf                                     ; sync success. H is 0 and L is 0.
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
    ret     Z                               ; the info sector is already clean
    call    fat_ldhl
    defw    fat_fsi_lba
    ld      a,h
    or      l
    call    fat_ldhl
    defw    fat_fsi_lba+2
    or      h
    or      l
    ret     Z                               ; LBA 0 means this volume has no info sector
    xor     a
    ld      (fat_fsi_dirty),a               ; clear dirty before the read, so it cannot re-enter
    call    fat_ldhl
    defw    fat_fsi_lba+2
    ld      bc,hl
    call    fat_ldhl
    defw    fat_fsi_lba
    ld      de,hl
    call    fat_move_window                 ; read the info sector
    jr      NC,fat_fsi_again                ; the info sector was not read
    ld      a,(_cpm_fat_vol+25)
    or      a
    jr      Z,fat_fsi_unk                   ; free_valid is clear, so the count is unknown
    call    fat_ldhl
    defw    _cpm_fat_vol+28
    ld      de,hl
    call    fat_ldhl
    defw    _cpm_fat_vol+30
    ld      bc,hl
    jr      fat_fsi_free                    ; store the known free count
fat_fsi_unk:
    ld      de,$FFFF                        ; $FFFFFFFF means the free count is unknown
    ld      bc,$FFFF
fat_fsi_free:
    ld      hl,fatwin+488
    call    fat_st32                        ; store FSI_Free_Count
    call    fat_ldhl
    defw    fat_last_clst
    ld      de,hl
    call    fat_ldhl
    defw    fat_last_clst+2
    ld      bc,hl
    ld      a,b
    or      c
    or      d
    jr      NZ,fat_fsi_nxt                  ; the hint is above 255
    ld      a,e
    cp      2                               ; a hint below cluster 2 is not a cluster
    jr      NC,fat_fsi_nxt                  ; the hint is a real cluster
    ld      de,$FFFF                        ; store $FFFFFFFF for a hint below cluster 2
    ld      bc,$FFFF
fat_fsi_nxt:
    ld      hl,fatwin+492
    call    fat_st32                        ; store FSI_Nxt_Free
    call    fat_ldhl
    defw    fat_fsi_lba+2
    ld      bc,hl
    call    fat_ldhl
    defw    fat_fsi_lba
    ld      de,hl
    ld      hl,fatwin
    call    ide_write_sector                ; carry set: info sector written. HL is fatwin plus 512.
    ret     C                               ; the info sector is on disk
fat_fsi_again:
    ld      a,1                             ; the info sector was not written
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
    call    fat_ldhl
    defw    fat_winsect
    ld      a,l
    cp      e                               ; LBA byte 0 against the window
    jr      NZ,fat_move_do                  ; byte 0 differs, so read the new LBA
    ld      a,h
    cp      d                               ; LBA byte 1 against the window
    jr      NZ,fat_move_do                  ; byte 1 differs, so read the new LBA
    call    fat_ldhl
    defw    fat_winsect+2
    ld      a,l
    cp      c                               ; LBA byte 2 against the window
    jr      NZ,fat_move_do                  ; byte 2 differs, so read the new LBA
    ld      a,h
    cp      b                               ; LBA byte 3 against the window
    jr      NZ,fat_move_do                  ; byte 3 differs, so read the new LBA
    scf                                     ; this LBA is already in the window
    ret
fat_move_do:
    push    bc
    push    de                              ; keep the LBA. sync and the disk call write BCDE.
    call    fat_sync_window                 ; write the dirty window first
    pop     de
    pop     bc
    ret     NC                              ; the dirty window was not written
    push    bc
    push    de
    ld      hl,fatwin                       ; sector window
    call    ide_read_sector                 ; carry set: sector read. HL is fatwin plus 512.
    pop     de
    pop     bc
    ret     NC                              ; the sector was not read
    push    de
    ld      de,hl
    pop     hl
    call    fat_sthl
    defw    fat_winsect
    ld      hl,bc
    call    fat_sthl
    defw    fat_winsect+2
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
    ld      a,e                             ; a cluster below 2 is not in the FAT
    sub     2                               ; cluster below 2 sets carry
    ld      a,d
    sbc     a,0
    ld      a,c
    sbc     a,0
    ld      a,b
    sbc     a,0
    ret     C                               ; below 2. Carry stays set from the subtract.
    ld      hl,_cpm_fat_vol+4               ; cluster minus n_fatent. BCDE stays.
    ld      a,e
    sub     (hl+)                           ; cluster minus n_fatent
    ld      a,d
    sbc     (hl+)
    ld      a,c
    sbc     (hl+)
    ld      a,b
    sbc     a,(hl)
    ret     NC                              ; the cluster is at or past n_fatent
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT32                        ; fs_type against FAT32
    jr      Z,fat_fatent32                  ; FAT32 uses a 4-byte entry
    ; FAT16. The sector is fatbase plus cluster/256. The offset is the low byte times 2.
    ld      l,e
    ld      h,0
    add     hl,hl                           ; offset is below 512
    push    hl
    ld      e,d
    ld      d,c
    ld      c,b
    ld      b,0                             ; BCDE is cluster >> 8
    jr      fat_fatent_sec                  ; add fatbase and read that sector
fat_fatent32:
    ; FAT32. 128 entries fill one 512-byte sector. The offset is (cluster mod 128)*4.
    ; That offset is 0 to 508. An 8-bit add would wrap, so the shift uses HL.
    ld      a,e
    and     127                             ; 128 FAT32 entries fill one sector
    ld      l,a
    ld      h,0
    add     hl,hl
    add     hl,hl
    push    hl                              ; offset 0 to 508
    ld      a,e
    rla                                     ; carry is cluster bit 7
    ld      e,d
    ld      d,c
    ld      c,b
    ld      b,0                             ; cluster >> 8
    rl      e                               ; low *2 + bit 7. A stays.
    rl      d
    rl      c
    rl      b                               ; clst >> 7
fat_fatent_sec:
    ld      hl,_cpm_fat_vol+8               ; fatbase
    ld      a,(hl+)
    add     a,e                             ; fatbase plus the FAT sector
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
    call    fat_move_window                 ; read the FAT sector into fatwin
    pop     de                              ; byte offset in the 512-byte sector
    ret     NC                              ; the FAT sector was not read
    ld      hl,fatwin
    add     hl,de
    scf
    ret

; FAT12 entry. Byte offset is clst + clst/2. Even cluster: low
; 12 bits. Odd cluster: high 12 bits. The two bytes can sit in
; different sectors when the offset ends on byte 511.
; IN: BCDE = cluster, already in range for fat12_load.
; OUT C: E = first raw byte, D = second, C = 1 if odd.
;     The window sits on the second sector when the entry spans.
; NC: the FAT sector was not read.
fat12_range:
    ld      a,e                             ; clst < 2
    sub     2
    ld      a,d
    sbc     a,0
    ld      a,c
    sbc     a,0
    ld      a,b
    sbc     a,0
    jr      C,fat12_range_lo
    ld      hl,_cpm_fat_vol+4               ; clst - n_fatent
    ld      a,e
    sub     (hl+)
    ld      a,d
    sbc     a,(hl+)
    ld      a,c
    sbc     a,(hl+)
    ld      a,b
    sbc     a,(hl)
    ret     NC                              ; clst >= n_fatent
    scf
    ret
fat12_range_lo:
    or      a
    ret

fat12_shr1:
    or      a
    ld      a,h
    rra
    ld      h,a
    ld      a,l
    rra
    ld      l,a
    ret

fat12_load:
    push    bc
    push    de
    ld      hl,de
    call    fat12_shr1                      ; clst / 2
    add     hl,de                           ; byte offset = clst + clst/2
    ld      a,h
    or      a
    rra                                     ; sector = offset >> 9
    ld      e,a
    ld      d,0
    ld      bc,0
    ld      hl,_cpm_fat_vol+8               ; + fatbase
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
    jr      NC,fat12_load_fail
    pop     de                              ; cluster low
    pop     bc                              ; cluster high
    push    bc
    push    de
    ld      hl,de
    call    fat12_shr1
    add     hl,de                           ; byte offset again
    ld      a,h
    and     1
    ld      h,a                             ; offset in the sector
    ld      a,l
    inc     a
    jr      NZ,fat12_same                   ; not byte 255 or 511
    ld      a,h
    or      a
    jr      Z,fat12_off255                  ; offset 255, still this sector
    ld      de,fatwin
    add     hl,de
    ld      c,(hl)                          ; first byte at offset 511
    push    bc
    call    fat_ldhl
    defw    fat_winsect
    inc     hl
    ld      a,h
    or      l
    jr      NZ,fat12_span_lba
    call    fat_ldhl
    defw    fat_winsect+2
    inc     hl
    ld      bc,hl
    ld      hl,0
    jr      fat12_span_go
fat12_span_lba:
    ld      de,hl
    call    fat_ldhl
    defw    fat_winsect+2
    ld      bc,hl
    ld      hl,de
fat12_span_go:
    ld      de,hl
    call    fat_move_window
    jr      NC,fat12_span_err
    ld      a,(fatwin)                      ; second byte at offset 0
    pop     bc
    ld      e,c
    ld      d,a
    jr      fat12_par
fat12_off255:
    ld      l,255
fat12_same:
    dec     a                               ; A was L+1 when we came from inc
    ld      l,a
    ld      de,fatwin
    add     hl,de
    ld      c,(hl+)
    ld      d,(hl)
    ld      e,c
fat12_par:
    pop     hl                              ; cluster low
    pop     bc                              ; cluster high, discarded
    ld      a,l
    and     1
    ld      c,a                             ; 1 = odd cluster
    scf
    ret
fat12_span_err:
    pop     bc
fat12_load_fail:
    pop     de
    pop     bc
    or      a
    ret

; Turn the raw FAT12 word into a 12-bit link.
; Call. DE is the raw word. E is the first byte. C is 1 when the cluster is odd.
; Return. DE is the 12-bit link. swap clears carry.
; Return. An odd word 0xABCD becomes 0x0ABC.
; Return. An even entry keeps the low 12 bits.
; Clobber. AF, DE. BC and HL stay.
fat12_value:
    ld      a,c
    or      a
    jr      Z,fat12_even                    ; an even cluster keeps the low 12 bits
    swap    e                               ; exchange the nibbles. swap clears carry
    swap    d
    ld      a,e
    and     $0F                             ; low nibble of the first byte, after the swap
    ld      e,a
    ld      a,d
    and     $F0                             ; high nibble of the second byte
    or      e
    ld      e,a
    ld      a,d
    and     $0F                             ; the link now fits in 12 bits
    ld      d,a
    ret
fat12_even:
    ld      a,d
    and     $0F
    ld      d,a
    ret

get_fat12:
    call    fat12_range
    ret     NC                              ; cluster is not in the FAT
    call    fat12_load
    ret     NC                              ; FAT sector not read
    call    fat12_value                     ; DE = 12-bit link
    ld      a,d
    cp      $0F                             ; high nibble of $FF8..$FFF
    jr      NZ,get_fat12_ok
    ld      a,e
    cp      $F7                             ; FAT12 bad cluster $FF7
    jp      Z,get_fat_bad
    cp      $F8                             ; FAT12 EOC $FF8..$FFF
    jr      C,get_fat12_ok
    ld      de,$FFFF
    ld      bc,$0FFF                        ; fold to EOC32 for callers
    scf
    ret
get_fat12_ok:
    ld      bc,0
    scf
    ret

; Write the low 12 bits of the dword at HL into cluster BCDE.
; Keeps the neighbour nibble. A span writes the first byte and marks
; the window dirty before the window moves.
fat12_store:
    push    hl                              ; source
    push    bc
    push    de
    call    fat12_range
    jp      NC,fat12_store_fail             ; cluster is not in the FAT
    call    fat12_load                      ; DE = old raw, C = parity
    jp      NC,fat12_store_fail
    ld      a,c
    pop     hl                              ; cluster low
    pop     bc                              ; cluster high
    push    af
    push    bc
    push    de
    ld      de,hl                           ; cluster low
    ld      hl,sp+6                         ; source word
    ld      a,(hl)
    ld      (hl),e
    ld      e,a
    inc     hl
    ld      a,(hl)
    ld      (hl),d
    ld      d,a
    ld      hl,de                           ; HL = source, stack = cluster low
    pop     de
    pop     bc
    pop     af
    push    bc
    push    af                              ; parity
    push    de                              ; old raw (E first, D second)
    ld      e,(hl+)
    ld      d,(hl)                          ; new link
    pop     hl                              ; old raw
    pop     af                              ; parity
    or      a
    jr      Z,fat12_st_even
    ld      a,e
    and     $0F
    rlca
    rlca
    rlca
    rlca                                    ; (new & $0F) << 4
    ld      c,a
    ld      a,l
    and     $0F
    or      c
    ld      l,a                             ; new first byte
    ld      a,e
    and     $F0
    rlca
    rlca
    rlca
    rlca                                    ; new >> 4, low half
    ld      c,a
    ld      a,d
    and     $0F
    rlca
    rlca
    rlca
    rlca
    or      c
    ld      h,a                             ; new second byte
    jr      fat12_st_wr
fat12_st_even:
    ld      a,h
    and     $F0
    ld      c,a
    ld      a,d
    and     $0F
    or      c
    ld      h,a                             ; new second, old high nibble kept
    ld      l,e                             ; new first
fat12_st_wr:
    pop     bc                              ; cluster high
    pop     de                              ; cluster low
    push    hl                              ; new raw: L first, H second
    ld      hl,de
    call    fat12_shr1
    add     hl,de                           ; byte offset. FAT12 cluster fits in DE
    ld      a,l
    cp      255
    jr      NZ,fat12_st_same
    ld      a,h
    and     1
    jr      NZ,fat12_st_span                ; offset ends on byte 511 of its sector
fat12_st_same:
    ld      a,h
    and     1
    ld      h,a                             ; offset in this sector
    ld      de,fatwin
    add     hl,de
    pop     de                              ; E first, D second
    ld      (hl+),e
    ld      (hl),d
    jr      fat12_st_dirty
fat12_st_span:
    call    fat_ldhl
    defw    fat_winsect
    ld      a,h
    or      l
    jr      Z,fat12_st_backhi
    dec     hl
    ld      de,hl
    call    fat_ldhl
    defw    fat_winsect+2
    ld      bc,hl
    jr      fat12_st_back
fat12_st_backhi:
    ld      de,$FFFF
    call    fat_ldhl
    defw    fat_winsect+2
    dec     hl
    ld      bc,hl
fat12_st_back:
    call    fat_move_window                 ; first sector, still clean
    jr      NC,fat12_st_pop
    pop     hl
    push    hl
    ld      a,l
    ld      (fatwin+511),a
    ld      a,1
    ld      (fat_wflag),a                   ; flush this byte before the window moves
    call    fat_ldhl
    defw    fat_winsect
    inc     hl
    ld      a,h
    or      l
    jr      Z,fat12_st_fwdhi
    ld      de,hl
    call    fat_ldhl
    defw    fat_winsect+2
    ld      bc,hl
    jr      fat12_st_fwd
fat12_st_fwdhi:
    ld      de,0
    call    fat_ldhl
    defw    fat_winsect+2
    inc     hl
    ld      bc,hl
fat12_st_fwd:
    call    fat_move_window                 ; writes the first sector, then the second
    jr      NC,fat12_st_pop
    pop     hl
    ld      a,h
    ld      (fatwin),a
    jr      fat12_st_dirty
fat12_st_pop:
    pop     hl
    or      a
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
    or      a
    ret

put_fat12:
    push    hl
    push    bc
    push    de
    call    get_fat                        ; the old link. Carry clear means bad or unread.
    ld      a,0
    jr      NC,put_fat12_old                ; treat a bad entry as in use
    ld      a,b
    or      c
    or      d
    or      e
    ld      a,0
    jr      NZ,put_fat12_old
    inc     a                               ; old entry was free
put_fat12_old:
    pop     de
    pop     bc
    pop     hl
    push    af
    push    hl
    call    fat12_store
    pop     hl                              ; source
    pop     bc                              ; B = old free. pop af would clear carry
    ret     NC
    ld      a,b
    push    af
    push    hl
    jp      put_fat_wrote

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
    cp      FS_FAT12                        ; fs_type vs FAT12
    jp      Z,get_fat12                     ; FAT12 stores a 12-bit packed entry
    call    fat_fatent                      ; map the cluster into fatwin
    ret     NC                              ; at or past n_fatent, or the sector was not read
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT32                        ; fs_type against FAT32
    jr      Z,get_fat32                     ; read a 28-bit FAT32 entry
    ld      e,(hl+)
    ld      d,(hl)
    ld      a,d
    cp      $FF                             ; FAT16 end range starts at high byte $FF
    jr      NZ,get_fat16ok                  ; not an end mark and not a bad cluster
    ld      a,e
    cp      $F7                             ; FAT16 bad cluster is $FFF7
    jr      Z,get_fat_bad                   ; $FFF7 is an error, not a link
    cp      $F8                             ; FAT16 end-of-chain is $FFF8 to $FFFF
    jr      C,get_fat16ok                   ; the link is below $FFF8
    ld      de,$FFFF
    ld      bc,$0FFF                        ; fold $FFF8..$FFFF to $0FFFFFFF
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
    and     $0F                             ; a FAT32 link keeps 28 bits
    ld      b,a
    cp      $0F                             ; the top nibble of an end range is $0F
    jr      NZ,get_fat32ok                  ; not an end-range entry
    ld      a,c
    inc     a
    jr      NZ,get_fat32ok                  ; byte 2 is not $FF
    ld      a,d
    inc     a
    jr      NZ,get_fat32ok                  ; byte 1 is not $FF
    ld      a,e
    cp      $F7                             ; a FAT32 bad cluster is $0FFFFFF7
    jr      Z,get_fat_bad                   ; $0FFFFFF7 is an error, not a link
    cp      $F8                             ; FAT32 end-of-chain is $0FFFFFF8 and above
    jr      C,get_fat32ok                   ; the link is below $0FFFFFF8
    ld      de,$FFFF
    ld      bc,$0FFF                        ; fold the end mark to $0FFFFFFF
get_fat32ok:
    scf
    ret
get_fat_bad:
    or      a                               ; a bad cluster is not a link. Carry is clear.
    ret

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
    cp      FS_FAT12                        ; fs_type vs FAT12
    jp      Z,put_fat12                     ; FAT12 stores a 12-bit packed entry
    push    hl
    call    fat_fatent                      ; map the cluster into fatwin
    pop     de                              ; DE points at the new link
    ret     NC                              ; at or past n_fatent, or the sector was not read
    ld      a,(_cpm_fat_vol+25)
    or      a
    jr      Z,put_fat_cold                  ; free_valid is clear, so skip the old-entry test
    push    de
    push    hl
    call    fat_win_is_free                 ; Z: the old FAT entry is free
    ld      a,0
    jr      NZ,put_fat_old                  ; the old entry is in use
    inc     a
put_fat_old:
    pop     hl
    pop     de
    jr      put_fat_adj                     ; adjust the free count from the old flag
put_fat_cold:
    xor     a                               ; the old flag is 0. The stack still receives AF.
put_fat_adj:
    push    af                              ; A is 1 when the old entry was free
    push    de                              ; source for the new-link test
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT32                        ; fs_type vs FAT32
    jr      Z,put_fat32                     ; store a 28-bit link
    ld      a,(de+)
    ld      (hl+),a
    ld      a,(de)
    ld      (hl),a
put_fat_wrote:
    pop     de
    pop     af
    ld      c,a                             ; keep the old-free flag in C
    ld      a,(_cpm_fat_vol+25)
    or      a
    jr      Z,put_fat_dirty                 ; free_valid is clear, so do not adjust the count
    push    bc
    call    fat_src_is_free                 ; Z: the new link is free
    pop     bc
    ld      a,c
    jr      Z,put_fat_new0                  ; the new link is free
    or      a
    jr      Z,put_fat_dirty                 ; used to used. The free count stays.
    call    fat_nfree_dec                   ; free to used
    jr      put_fat_dirty
put_fat_new0:
    or      a
    jr      NZ,put_fat_dirty                ; free to free. The free count stays.
    call    fat_nfree_inc                   ; used to free
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
    and     $0F                             ; keep FAT32 high nibble on disk
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
    cp      FS_FAT32                        ; fs_type against FAT32
    jr      Z,fat_win_free32                ; test the low 28 bits
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
    and     $0F                             ; FAT32 free means the low 28 bits are 0
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
    ld      hl,de
    call    fat_win_is_free                 ; Z from the dword at DE
    pop     hl
    ret

; Add one to the free-cluster count.
; Call. No arguments. The caller has a valid free count.
; Return. The count is one higher. fat_fsi_dirty is 1.
; Clobber. AF, HL. BC and DE stay.
; Writes. The free count and fat_fsi_dirty.
fat_nfree_inc:
    call    fat_ldhl
    defw    _cpm_fat_vol+28
    inc     hl
    call    fat_sthl
    defw    _cpm_fat_vol+28
    ld      a,h
    or      l
    jr      Z,fat_nfree_inc_hi              ; low half of free count wrapped
    jp      fat_fsi_mark
fat_nfree_inc_hi:
    call    fat_ldhl
    defw    _cpm_fat_vol+30
    inc     hl
    call    fat_sthl
    defw    _cpm_fat_vol+30
    jp      fat_fsi_mark                    ; mark the info sector after the high half increments

; Subtract one from the free-cluster count.
; Call. No arguments.
; Return. Z and carry clear: the count was already 0. It is not changed.
; Return. Otherwise the count is one lower and fat_fsi_dirty is 1.
; Clobber. AF, DE, HL. BC stays.
; Writes. The free count, unless it was already 0.
fat_nfree_dec:
    call    fat_ldhl
    defw    _cpm_fat_vol+28
    ld      a,h
    or      l
    push    hl
    call    fat_ldhl
    defw    _cpm_fat_vol+30
    or      h
    or      l
    pop     hl
    ret     Z                               ; the free count is already 0
    ld      a,h
    or      l
    jr      NZ,fat_nfree_dec_lo             ; the low half is not zero, so decrement it
    call    fat_ldhl
    defw    _cpm_fat_vol+30
    dec     hl
    call    fat_sthl
    defw    _cpm_fat_vol+30
    call    fat_ldhl
    defw    _cpm_fat_vol+28
fat_nfree_dec_lo:
    dec     hl
    call    fat_sthl
    defw    _cpm_fat_vol+28
    jp      fat_fsi_mark

; Find the cluster that holds a file offset.
; The index is (file pointer >> 9) / csize. A sector is 512 bytes.
; Call. HL points at a start cluster and a file pointer. Both are little-endian dwords.
; Return. Carry set: BCDE is that cluster. E is the low byte. The cache records the walk.
; Return. Carry clear: the index does not fit, the chain ended, or a link was not read.
; Clobber. AF, BC, DE, HL.
; Writes. fat_work. On success, the cluster cache.
clst_from_off:
    call    fat_ld32                        ; load the start cluster
    push    hl
    push    de
    ld      de,hl
    pop     hl
    call    fat_sthl
    defw    fat_work                        ; sclust
    ld      hl,bc
    call    fat_sthl
    defw    fat_work+2
    pop     hl
    inc     hl
    call    fat_ld32                        ; file pointer
    ; The index is (file pointer >> 9) / csize. A sector is 512 bytes.
    ; The first shift is a byte slide. One more shift completes >> 9.
    ld      e,d
    ld      d,c
    ld      c,b
    ld      b,0                             ; file pointer >> 8
    ld      a,c
    or      a                              ; clear carry. The file pointer shifts right by 9 through rra.
    rra
    ld      c,a
    ld      a,d
    rra
    ld      d,a
    ld      a,e
    rra
    ld      e,a                             ; fptr >> 9 = sector index in CDE
    ld      a,(_cpm_fat_vol+1)
    ld      b,0
cfo_log:
    or      a                              ; csize shifts right by 1. rra leaves Z stale.
    rra
    or      a
    jr      Z,cfo_div                       ; csize bit count is done
    inc     b
    jr      cfo_log
cfo_div:
    ld      a,b
    or      a
    jr      Z,cfo_ci                        ; csize is one sector
cfo_shr:
    ld      a,c
    or      a                               ; cluster index >>= 1 via rra
    rra
    ld      c,a
    ld      a,d
    rra
    ld      d,a
    ld      a,e
    rra
    ld      e,a
    dec     b
    jr      NZ,cfo_shr                      ; shifts left
cfo_ci:
    ld      a,c
    or      a
    jp      NZ,cfo_bad                      ; cluster index does not fit in 16 bits
    ld      a,(_cpm_fat_vol+6)
    ld      hl,_cpm_fat_vol+7
    or      (hl)
    jr      NZ,cfo_ci_ok                    ; n_fatent above 65535
    call    fat_ldhl
    defw    _cpm_fat_vol+4
    ld      bc,de
    call    fat_subhlbc                     ; n_fatent minus the index. DE stays the index
    jp      C,cfo_bad                       ; the index is past the FAT
    jp      Z,cfo_bad                       ; the index equals n_fatent, so it is not in the FAT
cfo_ci_ok:
    ; n_fatent above 65535 skips the range subtract. DE is still the index.
    push    de
    ld      de,hl
    pop     hl                              ; HL is the index. fat_sthl keeps AF, BC, and DE.
    call    fat_sthl
    defw    fat_work+4                      ; the store writes that index
    ld      hl,clst_cache_sclust
    ld      a,(fat_work)
    cp      (hl)                            ; cache vs sclust +0
    jr      NZ,cfo_from0                    ; cache is another file
    inc     hl
    ld      a,(fat_work+1)
    cp      (hl)                            ; cache vs sclust +1
    jr      NZ,cfo_from0                    ; cache is another file
    inc     hl
    ld      a,(fat_work+2)
    cp      (hl)                            ; cache vs sclust +2
    jr      NZ,cfo_from0                    ; cache is another file
    inc     hl
    ld      a,(fat_work+3)
    cp      (hl)                            ; cache vs sclust +3
    jr      NZ,cfo_from0                    ; cache is another file
    call    fat_ldhl
    defw    fat_work+4
    ld      bc,hl
    call    fat_ldhl
    defw    clst_cache_ci
    call    fat_subhlbc                     ; cache_ci - want_ci
    jr      Z,cfo_cached                    ; want_ci is the cached index
    jr      NC,cfo_from0                    ; want is behind the cache
    call    fat_ldhl
    defw    clst_cache_ci
    ld      bc,hl
    call    fat_ldhl
    defw    fat_work+4
    call    fat_subhlbc                     ; steps still to walk
    call    fat_sthl
    defw    fat_work+8                      ; steps from cached cluster
    call    fat_ldhl
    defw    clst_cache_clst+2
    ld      bc,hl
    call    fat_ldhl
    defw    clst_cache_clst
    ld      de,hl
    jr      cfo_loop
cfo_from0:
    call    fat_ldhl
    defw    fat_work+4
    call    fat_sthl
    defw    fat_work+8                      ; steps from sclust
    call    fat_ldhl
    defw    fat_work+2
    ld      bc,hl
    call    fat_ldhl
    defw    fat_work
    push    de
    ld      de,hl
    pop     hl
cfo_loop:
    ld      a,(fat_work+8)
    ld      hl,fat_work+9
    or      (hl)
    jr      Z,cfo_have                      ; the offset is consumed
    call    get_fat                         ; next cluster. This walk has no cycle counter.
    ret     NC                              ; a bad cluster, or the entry was not read
    ld      a,b
    cp      $0F                             ; an end mark has top nibble $0F
    jr      NZ,cfo_store                    ; not an end mark
    ld      a,c
    and     d
    and     e
    inc     a
    jr      Z,cfo_bad                       ; the link is $0FFFFFFF
cfo_store:
    call    fat_ldhl
    defw    fat_work+8
    dec     hl
    call    fat_sthl
    defw    fat_work+8
    jr      cfo_loop                        ; one cluster remains in the walk
cfo_cached:
    call    fat_ldhl
    defw    clst_cache_clst+2
    ld      bc,hl
    call    fat_ldhl
    defw    clst_cache_clst
    push    de
    ld      de,hl
    pop     hl
cfo_have:
    push    de
    ld      de,hl
    pop     hl
    call    fat_sthl
    defw    clst_cache_clst
    ld      de,hl                           ; DE = cluster low (clst2sect wants BCDE)
    ld      hl,bc
    call    fat_sthl
    defw    clst_cache_clst+2
    call    fat_ldhl
    defw    fat_work
    call    fat_sthl
    defw    clst_cache_sclust
    call    fat_ldhl
    defw    fat_work+2
    call    fat_sthl
    defw    clst_cache_sclust+2
    call    fat_ldhl
    defw    fat_work+4
    call    fat_sthl
    defw    clst_cache_ci
    scf
    ret
cfo_bad:
    or      a                               ; clear carry. The offset is not in the chain.
    ret

; Test that a cluster is inside the FAT.
; Call. BCDE is the cluster. E is the low byte.
; Return. Carry clear: the cluster is in range. BCDE stays.
; Return. Carry set: the cluster is below 2, or at or past n_fatent.
; Return. BCDE stays on that exit too.
; Clobber. AF and HL. BC and DE stay.
fat_clst_ok:
    push    bc
    push    de
    ld      a,b
    or      c
    or      d
    jr      NZ,fco_hi                       ; high bytes set: check n_fatent
    ld      a,e
    cp      2                               ; cluster low vs 2
    jr      C,fco_bad                       ; cluster < 2
fco_hi:
    call    fat_ldhl
    defw    _cpm_fat_vol+4
    ld      a,l
    sub     e                               ; n_fatent - cluster
    ld      l,a
    ld      a,h
    sbc     a,d
    ld      h,a
    ld      a,(_cpm_fat_vol+6)
    sbc     a,c
    ld      c,a
    ld      a,(_cpm_fat_vol+7)
    sbc     a,b
    jr      C,fco_bad                       ; cluster >= n_fatent
    or      c
    or      h
    or      l
    jr      Z,fco_bad                       ; cluster == n_fatent
    pop     de
    pop     bc
    or      a                               ; NC: cluster is in range
    ret
fco_bad:
    pop     de
    pop     bc
    scf                                     ; C: cluster is out of range
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
    ld      hl,bc
    call    fat_sthl
    defw    fat_work+10
    ld      hl,de
    call    fat_sthl
    defw    fat_work+8
    xor     a
    ld      (fat_work+7),a                  ; wrap flag
    ld      a,b
    or      c
    or      d
    or      e
    jr      Z,cc_hint                       ; cluster 0 starts a new chain
    inc     de
    ld      a,d
    or      e
    jr      NZ,cc_mark                      ; cluster+1 fits in the low word
    inc     bc                              ; cluster+1 wrapped the low word
    jr      cc_mark                         ; search from the next cluster
cc_hint:
    call    fat_ldhl
    defw    fat_last_clst+2
    ld      bc,hl
    call    fat_ldhl
    defw    fat_last_clst
    ld      de,hl
    call    fat_clst_ok                     ; C: last-clst hint is not a cluster
    jr      NC,cc_mark                      ; hint is a real cluster
cc_from2:
    ld      de,2                            ; cluster 2 is the first real cluster
    ld      bc,0
cc_mark:
    ld      hl,de
    call    fat_sthl
    defw    fat_work                        ; search origin
    ld      hl,bc
    call    fat_sthl
    defw    fat_work+2
cc_scan:
    ld      hl,bc
    call    fat_sthl
    defw    fat_work+14
    ld      hl,de
    call    fat_sthl
    defw    fat_work+12
    call    fat_ldhl
    defw    _cpm_fat_vol+4
    ld      a,l
    sub     e                               ; n_fatent - candidate
    ld      l,a
    ld      a,h
    sbc     a,d
    ld      h,a
    ld      a,(_cpm_fat_vol+6)
    sbc     a,c
    ld      c,a
    ld      a,(_cpm_fat_vol+7)
    sbc     a,b
    jp      C,cc_wrap                       ; candidate is past n_fatent
    or      c
    or      h
    or      l
    jp      Z,cc_wrap                       ; candidate >= n_fatent
    call    fat_ldhl
    defw    fat_work+14
    ld      bc,hl
    call    fat_ldhl
    defw    fat_work+12
    push    de
    ld      de,hl
    pop     hl
    ld      a,(fat_work+7)
    or      a
    jr      Z,cc_look                       ; first pass does not stop early
    call    fat_ldhl
    defw    fat_work                        ; wrapped: stop on return to origin
    ld      a,e
    cp      l                               ; candidate vs origin +0
    jr      NZ,cc_look                      ; not back at the origin
    ld      a,d
    cp      h                               ; candidate vs origin +1
    jr      NZ,cc_look                      ; not back at the origin
    call    fat_ldhl
    defw    fat_work+2
    ld      a,c
    cp      l                               ; candidate vs origin +2
    jr      NZ,cc_look                      ; not back at the origin
    ld      a,b
    cp      h                               ; candidate vs origin +3
    jp      Z,cc_fail                       ; scan returned to its origin
cc_look:
    call    get_fat                         ; read the candidate FAT entry
    ret     NC                              ; bad cluster, or the entry cannot be read
    ld      a,b
    or      c
    or      d
    or      e
    jr      NZ,cc_next                      ; in use
    call    fat_ldhl
    defw    fat_work+14
    ld      bc,hl
    call    fat_ldhl
    defw    fat_work+12
    ld      de,hl
    call    cc_wipe                         ; zero data before the FAT link is published
    ret     NC                              ; data sectors were not cleared
    call    fat_ldhl
    defw    fat_work+14
    ld      bc,hl
    call    fat_ldhl
    defw    fat_work+12
    ld      de,hl
    ld      hl,cc_eoc
    call    put_fat                         ; mark the new cluster end-of-chain first
    ret     NC                              ; the end mark was not stored
    ld      a,(fat_work+8)
    ld      hl,fat_work+9
    or      (hl+)
    or      (hl+)
    or      (hl)
    jr      Z,cc_ok                         ; no previous cluster to link
    push    bc
    push    de
    call    fat_ldhl
    defw    fat_work+10
    ld      bc,hl
    call    fat_ldhl
    defw    fat_work+8
    ld      de,hl
    ld      hl,fat_work+12
    call    put_fat                         ; link the previous cluster after the end mark
    pop     de
    pop     bc
    ret     NC                              ; the link was not stored. The end mark may already be written.
cc_ok:
    call    fat_ldhl
    defw    fat_work+14
    call    fat_sthl
    defw    fat_last_clst+2
    call    fat_ldhl
    defw    fat_work+12
    call    fat_sthl
    defw    fat_last_clst
    call    fat_fsi_mark                    ; mark FSInfo for rewrite
    call    fat_sync_window                 ; a failed second copy leaves the first FAT written
cc_ret_cl:
    call    fat_ldhl
    defw    fat_work+14                     ; mirror failure still returns the cluster
    ld      bc,hl
    call    fat_ldhl
    defw    fat_work+12
    push    de
    ld      de,hl
    pop     hl
    scf                                     ; this exit is still success
    ret
cc_next:
    call    fat_ldhl
    defw    fat_work+14
    ld      bc,hl
    call    fat_ldhl
    defw    fat_work+12
    push    de
    ld      de,hl
    pop     hl
    inc     de
    ld      a,d
    or      e
    jp      NZ,cc_scan                      ; the candidate low word did not wrap
    inc     bc
    jp      cc_scan                         ; the candidate low word wrapped
cc_wrap:
    ld      a,(fat_work+7)
    or      a
    jr      NZ,cc_fail                      ; the scan already wrapped
    ld      a,1
    ld      (fat_work+7),a
    ld      a,(fat_work)                    ; origin == 2 means the whole volume was seen
    cp      2                               ; origin vs cluster 2
    jr      NZ,cc_wrap2                     ; origin is not cluster 2
    ld      a,(fat_work+1)
    or      a
    jr      NZ,cc_wrap2                     ; origin byte 1 is not 0
    ld      a,(fat_work+2)
    or      a
    jr      NZ,cc_wrap2                     ; origin byte 2 is not 0
    ld      a,(fat_work+3)
    or      a
    jr      Z,cc_fail                       ; the origin was cluster 2, so the FAT is full
cc_wrap2:
    ld      de,2                            ; resume at cluster 2
    ld      bc,0
    jp      cc_scan                         ; the scan has wrapped once
cc_fail:
    or      a                               ; clear carry. The scan found no free cluster.
    ret
cc_eoc:
    defb    $FF,$FF,$FF,$0F                 ; end-of-chain link $0FFFFFFF

; Write zeros over every sector of one cluster before the FAT link is published.
; Call. BCDE is the cluster. E is the low byte.
; Return. Carry set: those sectors are zero on disk. The window is not a cached sector.
; Return. Carry clear: csize is 0, the cluster has no LBA, or a write failed.
; Clobber. AF, BC, DE, HL.
; Writes. The cluster sectors. fatwin is filled with zeros. fat_winsect becomes $FFFF.
cc_wipe:
    ld      a,(_cpm_fat_vol+1)
    or      a
    jr      Z,cc_wipe_bad                   ; csize is 0
    push    bc
    push    de
    call    clst2sect                       ; LBA of this cluster
    jr      C,cc_wipe_lba                   ; the cluster has an LBA
    pop     de
    pop     bc
cc_wipe_bad:
    or      a                               ; clear carry. The cluster was not cleared.
    ret
cc_wipe_lba:
    pop     hl
    pop     hl
    ld      a,(_cpm_fat_vol+1)
    push    bc
    push    de
    push    af
    call    fat_sync_window                 ; flush fatwin before the zero fill
    jr      C,cc_wipe_clr                   ; flush succeeded
    pop     af
    pop     de
    pop     bc
    or      a                               ; clear carry. The dirty window was not written.
    ret
cc_wipe_clr:
    ld      hl,$FFFF                        ; the window must not stay a cached FAT sector
    call    fat_sthl
    defw    fat_winsect
    call    fat_sthl
    defw    fat_winsect+2
    xor     a
    ld      (fat_wflag),a
    ld      hl,fatwin
    ld      b,0
cc_wipe_fill:
    ld      (hl+),a                        ; zero one byte of fatwin. This loop replaces ldir.
    ld      (hl+),a
    dec     b
    jr      NZ,cc_wipe_fill                 ; 512 bytes
cc_wipe_wr:
    pop     af
    pop     de
    pop     bc
    push    bc
    push    de
    push    af
    ld      hl,fatwin
    call    ide_write_sector                ; carry set: zero sector written. HL is fatwin plus 512.
    jr      C,cc_wipe_adv                   ; the zero sector is on disk
    pop     af
    pop     de
    pop     bc
    or      a                               ; clear carry. A zero sector was not written.
    ret
cc_wipe_adv:
    pop     af
    pop     de
    pop     bc
    dec     a
    jr      Z,cc_wipe_ok                    ; every sector of the cluster
    push    af
    inc     de
    ld      a,d
    or      e
    jr      NZ,cc_wipe_push                 ; the LBA low word did not wrap
    inc     bc
cc_wipe_push:
    pop     af
    push    bc
    push    de
    push    af
    jr      cc_wipe_wr                      ; write the next sector of this cluster
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
    ret     Z                               ; cluster 0 frees nothing. Carry stays set.
    ld      hl,0
    call    fat_sthl
    defw    fat_work                        ; 32-bit step
    call    fat_sthl
    defw    fat_work+2
rc_loop:
    call    fat_ldhl
    defw    fat_work
    inc     hl
    call    fat_sthl
    defw    fat_work
    ld      a,h
    or      l
    jr      NZ,rc_cmp                       ; step low did not wrap
    call    fat_ldhl
    defw    fat_work+2
    inc     hl
    call    fat_sthl
    defw    fat_work+2
rc_cmp:
    push    bc
    push    de
    call    fat_ldhl
    defw    fat_work+2
    ld      bc,hl
    call    fat_ldhl
    defw    fat_work
    ld      de,hl
    ld      hl,_cpm_fat_vol+4               ; step - n_fatent
    ld      a,e
    sub     (hl+)                           ; step - n_fatent
    ld      a,d
    sbc     (hl+)
    ld      a,c
    sbc     (hl+)
    ld      a,b
    sbc     a,(hl)
    pop     de
    pop     bc
    jr      NC,rc_fail                      ; the step is at or past n_fatent
    ld      hl,bc
    call    fat_sthl
    defw    fat_work+10
    ld      hl,de
    call    fat_sthl
    defw    fat_work+8
    call    get_fat                         ; the next link. Stop on 0 or on a link that is not real.
    ret     NC                              ; a bad cluster, or the entry was not read
    push    de
    ld      de,hl
    pop     hl
    call    fat_sthl
    defw    fat_work+12                     ; next
    ld      hl,bc
    call    fat_sthl
    defw    fat_work+14
    call    fat_ldhl
    defw    fat_work+10
    ld      bc,hl
    call    fat_ldhl
    defw    fat_work+8
    ld      de,hl
    ld      hl,cc_zero
    call    put_fat                         ; store a free FAT entry
    ret     NC                              ; free entry was not stored
    call    fat_ldhl
    defw    fat_work+14
    ld      bc,hl
    call    fat_ldhl
    defw    fat_work+12
    push    de
    ld      de,hl
    pop     hl
    ld      a,b
    or      c
    or      d
    or      e
    jr      Z,rc_done                       ; the next link is 0, so the chain ends
    ld      hl,_cpm_fat_vol+4               ; next >= n_fatent ends the walk
    ld      a,e
    sub     (hl+)                           ; next link - n_fatent
    ld      a,d
    sbc     (hl+)
    ld      a,c
    sbc     (hl+)
    ld      a,b
    sbc     a,(hl)
    jp      C,rc_loop                       ; next is still a cluster
rc_done:
    scf                                     ; stopped on 0 or on a link that is not a real cluster
    ret
rc_fail:
    or      a                               ; clear carry. The step reached n_fatent.
    ret
cc_zero:
    defb    0,0,0,0                         ; zero dword. A free link and a fake end of directory.

; Exclusive byte end of the FAT16 root.
; A shorter database minus dirbase span can clamp that end.
; Call. No arguments.
; Return. Carry set: the root has 2048 entries. HL is 0. Every 16-bit offset fits.
; Return. Carry clear: HL is the exclusive byte end.
; Return. An offset at or past HL is outside the root.
; Clobber. AF, DE, HL. BC stays.
fat_root16_max:
    call    fat_ldhl
    defw    _cpm_fat_vol+2
    ld      a,l
    and     $F0                             ; a FAT16 root count is a multiple of 16
    ld      l,a
    ld      a,h
    cp      8                               ; 2048 entries times 32 bytes is 65536
    jr      C,frm_mul                       ; fewer than 2048 root entries
    ld      hl,0
    scf
    jr      frm_clamp                       ; 2048 entries cover every 16-bit offset
frm_mul:
    add     hl,hl
    add     hl,hl
    add     hl,hl
    add     hl,hl
    add     hl,hl                           ; times 32. One directory entry is 32 bytes.
    or      a                               ; the byte count fits in 16 bits
frm_clamp:
    push    hl
    push    af                              ; C = entry count covers 64K
    ld      a,(_cpm_fat_vol+18)             ; database high
    ld      hl,_cpm_fat_vol+14
    or      (hl)                            ; dirbase high
    jr      NZ,frm_keep                     ; database or dirbase above 64K
    call    fat_ldhl
    defw    _cpm_fat_vol+12
    ld      bc,hl
    call    fat_ldhl
    defw    _cpm_fat_vol+16
    call    fat_subhlbc                     ; database - dirbase (sectors)
    jr      C,frm_keep                      ; database is below dirbase
    jr      Z,frm_keep                      ; root span is empty
    ld      a,h
    or      a
    jr      NZ,frm_keep                     ; >= 256 sectors
    ld      a,l
    cp      128                             ; 128 sectors times 512 bytes is 65536
    jr      NC,frm_keep                     ; 128 sectors or more is at least 64 KiB
    ld      h,l
    ld      l,0
    add     hl,hl                           ; span << 9, fits in 16 bits
    pop     af
    pop     de                              ; DE = count end
    jr      C,frm_span                      ; the count was 65536, so the span is tighter
    ld      bc,de
    push    hl
    call    fat_subhlbc                     ; span - count
    pop     hl
    jr      C,frm_clear                     ; the byte span is the tighter end
    push    de
    ld      de,hl
    pop     hl
frm_clear:
    or      a                               ; clear carry. HL is the exclusive end.
    ret
frm_span:
    or      a                               ; clear carry. The span is the exclusive end.
    ret
frm_keep:
    pop     af                              ; restore carry when 2048 entries cover the root
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
    call    fat_sthl
    defw    dir_ofs
    ld      a,b
    or      c
    or      d
    or      e
    jp      NZ,dsdi_chain_save              ; start cluster is not 0
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT32                        ; fs_type against FAT32
    jr      NZ,dsdi_root16                  ; FAT16 root is the static dirbase
    call    fat_ldhl
    defw    _cpm_fat_vol+12
    ld      de,hl
    call    fat_ldhl
    defw    _cpm_fat_vol+14
    ld      bc,hl
    jr      dsdi_chain_save
dsdi_root16:
    ld      de,hl                           ; DE = ofs
    ld      hl,0
    call    fat_sthl
    defw    dir_sclust
    call    fat_sthl
    defw    dir_sclust+2
    call    fat_sthl
    defw    dir_clust                       ; static FAT16 root
    call    fat_sthl
    defw    dir_clust+2
    push    de                              ; ofs
    call    fat_root16_max                  ; C: any 16-bit offset fits
    jr      C,dsdi_root16_in                ; 2048 entries: any 16-bit ofs
    ld      bc,hl                           ; max
    pop     hl                              ; ofs
    ld      de,hl
    call    fat_subhlbc                     ; ofs - root byte end
    jp      NC,dsdi_end                     ; unsigned ofs >= max
    push    de
    ld      de,hl
    pop     hl                              ; HL = ofs
    jr      dsdi_root
dsdi_root16_in:
    pop     hl
dsdi_root:
    ld      a,h                             ; offset >> 9
    or      a                              ; clear carry. The offset shifts right by 9 through rra.
    rra
    ld      e,a
    ld      d,0
    call    fat_ldhl
    defw    _cpm_fat_vol+12                 ; dirbase LBA
    add     hl,de                           ; dirbase + sector in the root
    call    fat_sthl
    defw    dir_sect
    call    fat_ldhl
    defw    _cpm_fat_vol+14
    ld      de,0
    ld      a,l
    adc     a,e
    ld      l,a
    ld      a,h
    adc     a,d
    ld      h,a
    call    fat_sthl
    defw    dir_sect+2
    ld      a,(dir_ofs)
    ld      e,a
    ld      a,(dir_ofs+1)
    and     1
    ld      d,a
    ld      hl,fatwin
    add     hl,de
    call    fat_sthl
    defw    dir_ptr
    call    fat_ldhl
    defw    dir_sect+2
    ld      bc,hl
    call    fat_ldhl
    defw    dir_sect
    ld      de,hl
    call    fat_move_window                 ; C: root sector in fatwin
    ret
dsdi_chain_save:
    ld      hl,bc
    call    fat_sthl
    defw    dir_sclust+2
    ld      hl,de
    call    fat_sthl
    defw    dir_sclust
    ld      hl,dir_sclust
    ld      de,fat_work
    ld      a,(hl+)
    ld      (de+),a
    ld      a,(hl+)
    ld      (de+),a
    ld      a,(hl+)
    ld      (de+),a
    ld      a,(hl)
    ld      (de),a                         ; sclust. The file pointer follows.
    call    fat_ldhl
    defw    dir_ofs
    call    fat_sthl
    defw    fat_work+4
    ld      hl,0
    call    fat_sthl
    defw    fat_work+6                      ; fptr 32-bit
    ld      hl,fat_work
    call    clst_from_off                   ; cluster that holds this offset
    ret     NC                              ; offset is not in the chain
    ld      hl,de
    call    fat_sthl
    defw    dir_clust                       ; cluster containing ofs
    ld      hl,bc
    call    fat_sthl
    defw    dir_clust+2
    call    clst2sect                       ; LBA of that cluster
    ret     NC                              ; cluster has no LBA
    ; add sector-in-cluster: (dir_ofs >> 9) % csize
    ld      a,(dir_ofs+1)
    or      a                              ; clear carry. rra completes the shift by 9.
    rra                                     ; offset/512 low
    ld      hl,_cpm_fat_vol+1
    ld      l,(hl)                          ; csize is 2^n
    dec     l
    and     l                               ; sector inside the cluster
    ld      l,a
    ld      h,0
    add     hl,de                           ; cluster LBA + sector
    jr      NC,dsdi_sec                     ; LBA low did not wrap
    inc     bc
dsdi_sec:
    call    fat_sthl
    defw    dir_sect
    ld      de,hl                           ; DE = LBA low for ide
    ld      hl,bc
    call    fat_sthl
    defw    dir_sect+2
    call    fat_move_window                 ; directory sector into fatwin
    ret     NC                              ; directory sector not read
    ld      a,(dir_ofs)
    ld      e,a
    ld      a,(dir_ofs+1)
    and     1
    ld      d,a
    ld      hl,fatwin
    add     hl,de
    call    fat_sthl
    defw    dir_ptr
    scf
    ret
dsdi_end:
    or      a                               ; clear carry. The offset is past the FAT16 root.
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
    call    fat_ldhl
    defw    dir_ofs
    ld      bc,32                           ; one directory entry is 32 bytes
    add     hl,bc
    jp      C,dir_next_end                  ; a 16-bit wrap stops the directory at 2048 entries
    ld      a,l
    or      a
    jr      NZ,dir_next_same                ; still inside this 512-byte sector
    ld      a,h
    and     1                               ; bit 9 of the offset. A sector is 512 bytes.
    jr      Z,dir_next_sect                 ; the offset is on a sector boundary
dir_next_same:
    call    fat_sthl
    defw    dir_ofs
    call    fat_ldhl
    defw    dir_ptr
    ld      de,32                           ; one directory entry is 32 bytes
    add     hl,de
    call    fat_sthl
    defw    dir_ptr
    scf
    ret
dir_next_sect:
    call    fat_sthl
    defw    dir_ofs
    call    fat_ldhl
    defw    dir_clust
    ld      a,h
    or      l
    call    fat_ldhl
    defw    dir_clust+2
    or      h
    or      l
    jr      NZ,dir_next_dyn                 ; directory is a cluster chain
    call    fat_root16_max                  ; byte end of the FAT16 root
    jr      C,dir_next_inc                  ; 2048 entries: ofs still inside
    ld      bc,hl                           ; max
    call    fat_ldhl
    defw    dir_ofs
    call    fat_subhlbc                     ; ofs - root byte end
    jp      NC,dir_next_end                 ; unsigned ofs >= max
dir_next_inc:
    call    fat_ldhl
    defw    dir_sect
    inc     hl
    call    fat_sthl
    defw    dir_sect
    ld      a,h
    or      l
    jr      NZ,dir_next_win                 ; the sector low word did not wrap
    call    fat_ldhl
    defw    dir_sect+2
    inc     hl
    call    fat_sthl
    defw    dir_sect+2
    jr      dir_next_win                    ; the sector low word wrapped
dir_next_dyn:
    ld      a,(dir_ofs+1)
    or      a                              ; clear carry. rra divides the offset by 512.
    rra                                     ; ofs / 512
    ld      hl,_cpm_fat_vol+1
    ld      l,(hl)                          ; csize
    dec     l
    and     l                               ; (ofs/512) & (csize-1)
    jr      NZ,dir_next_inc                 ; still in this cluster
    call    fat_ldhl
    defw    dir_clust+2
    ld      bc,hl
    call    fat_ldhl
    defw    dir_clust
    ld      de,hl
    call    get_fat                         ; next cluster of this directory
    jp      NC,dir_next_io                  ; bad cluster or unreadable
    ld      a,b
    cp      $0F                             ; an end mark has top nibble $0F
    jr      NZ,dir_next_got                 ; not an end mark
    ld      a,c
    and     d
    and     e
    inc     a
    jr      Z,dir_next_end                  ; EOC
dir_next_got:
    ld      a,e
    sub     2                               ; a cluster below 2 is not real
    ld      a,d
    sbc     a,0
    ld      a,c
    sbc     a,0
    ld      a,b
    sbc     a,0
    jp      C,dir_next_io                   ; the next cluster is below 2
    ld      hl,de
    call    fat_sthl
    defw    dir_clust
    ld      hl,bc
    call    fat_sthl
    defw    dir_clust+2
    call    clst2sect                       ; LBA of the next cluster
    jp      NC,dir_next_io                  ; next cluster has no LBA
    ld      hl,de
    call    fat_sthl
    defw    dir_sect
    ld      hl,bc
    call    fat_sthl
    defw    dir_sect+2
dir_next_win:
    call    fat_ldhl
    defw    dir_sect+2
    ld      bc,hl
    call    fat_ldhl
    defw    dir_sect
    ld      de,hl
    call    fat_move_window                 ; directory sector into fatwin
    jp      NC,dir_next_io                  ; directory sector not read
    ld      hl,fatwin                       ; the offset is on a 512-byte boundary
    call    fat_sthl
    defw    dir_ptr
    scf                                     ; carry set means another entry
    ret
dir_next_end:
    xor     a                               ; carry clear and Z. This is a clean end.
    ret

dir_next_io:
    ld      a,1
    or      a                               ; carry clear and NZ. This is a disk or chain error.
    ret


; HL = HL - BC with no incoming borrow.
; Call. HL and BC are the operands.
; Return. HL is the difference. Carry is the borrow. Z means the result is 0.
; Clobber. HL and flags. A, BC, and DE stay.
fat_subhlbc:
    push    de
    ld      d,a
    ld      a,l
    sub     c
    ld      l,a
    ld      a,h
    sbc     a,b
    ld      h,a
    jr      C,fat_subhlbc_c
    ld      a,h
    or      l
    ld      a,d
    pop     de
    ret

fat_subhlbc_c:
    ld      a,h
    or      l
    scf
    ld      a,d
    pop     de
    ret

; Absolute ld hl,(nn) is a long synthetic on gbz80. call plus defw is shorter.
; Call. The return address points at the defw address.
; Return. HL is that word. AF, BC, and DE stay, including carry.
; Clobber. HL. The return address moves past the defw.
; A loop calls this again. The body stores a new word at that address.
PUBLIC  fat_ldhl
fat_ldhl:
    push    af
    push    de
    push    bc
    ld      hl,sp+6
    ld      a,(hl+)
    ld      e,a
    ld      a,(hl)
    ld      d,a
    ld      a,e
    add     a,2
    dec     hl
    ld      (hl+),a
    ld      a,d
    adc     a,0
    ld      (hl),a
    ld      a,(de)
    ld      l,a
    inc     de
    ld      a,(de)
    ld      h,a
    ld      a,(hl+)
    ld      c,a
    ld      a,(hl)
    ld      b,a
    ld      hl,bc
    pop     bc
    pop     de
    pop     af
    ret

; Absolute ld (nn),hl. call plus defw is shorter than the synthetic.
; Call. HL is the word. The return address points at the defw address.
; Return. That address holds HL. AF, BC, DE, and HL stay, including carry.
; Clobber. None. The return address moves past the defw.
PUBLIC  fat_sthl

PUBLIC  cc_zero
PUBLIC  fat_clst_ok
PUBLIC  fat_copy
PUBLIC  fat_ld32
PUBLIC  fat_st32
PUBLIC  fat_subhlbc
fat_sthl:
    push    af
    push    de
    push    bc
    push    hl
    ld      hl,sp+8
    ld      a,(hl+)
    ld      e,a
    ld      a,(hl)
    ld      d,a
    ld      a,e
    add     a,2
    dec     hl
    ld      (hl+),a
    ld      a,d
    adc     a,0
    ld      (hl),a
    ld      a,(de)
    ld      l,a
    inc     de
    ld      a,(de)
    ld      h,a
    pop     bc
    ld      a,c
    ld      (hl+),a
    ld      a,b
    ld      (hl),a
    ld      hl,bc
    pop     bc
    pop     de
    pop     af
    ret
