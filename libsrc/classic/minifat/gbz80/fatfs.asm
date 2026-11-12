;
; Copyright (c) October 2026 Phillip Stevens (feilipu)
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
;
; The human description is mini-fat.md in this directory.
; ChaN's application interface is
; http://elm-chan.org/fsw/ff/00index_e.html
; This file is the sector and directory layer under that interface.
;
; Same PUBLIC API, BSS names, and function contracts as fatfs.asm /
; fatfs.h. ROM-resident, no PHASE. Shell buffers live in fat_bss.asm
; (RAM). The sector window is fatwin.
;
; C: PUBLIC _names. Pointers are __z88dk_fastcall (HL).
; DWORD cluster/LBA is BCDE (E LSB); _fat_next/_fat_alloc/_fat_free/
; _fat_clst2sect/_fat_dir_open load that little-endian dword from (HL).
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
;   cluster < 2 invalid; n_fatent = nclst + 2
;   FAT16 EOC $FFF8..$FFFF; FAT32 EOC $0FFFFFF8..F (put_fat keeps bits 28-31)
;   nclst <= $0FF5 is FAT12 (ChaN MAX_FAT12; spec 1.03 treats 4085 as FAT16)
;   nclst == $FFF5 stays FAT16 (ChaN MAX_FAT16; spec 1.03 would use FAT32)
;   nclst > $0FFFFFF5 is rejected (ChaN MAX_FAT32; put_fat keeps 28 bits)
;   fatsz >= $200000 is rejected (ChaN ff16p2, before fatsz is doubled)
;   a partition, fatbase, database, or active FAT at LBA >= $10000000 fails
;   an FSInfo LBA >= $10000000 leaves the hint clear; the mount still succeeds
;   Neither boundary is built by test/fatfs. BPB_Media is never read.
;   FAT16 root count is a non-zero multiple of 16. A FAT32-shaped VBR
;   whose cluster count falls in the FAT16 band is rejected.
;   FAT32 requires FATSz16 == 0, FSVer == 0 and RootEntCnt == 0
;   csize is 2^n. SecPerClus >= 65 (64 KiB clusters) is refused with
;   L = 19. A 64 KiB cluster is 0 in the 16-bit sector math.
;   FAT32 with mirroring off uses the active FAT in BPB_ExtFlags and
;   does not write the other copy. A bad cluster ($FFF7 / $0FFFFFF7)
;   is an error, not a link. fs_type is stored only after every check.
;   DIR_Name[0] == $05 compares as $E5; dir_create stores $E5 as $05
;   FAT16 root of 2048 entries is the whole 16-bit offset (65536 bytes)
;   dirent 0x00 = end of directory; 0xE5 = deleted (reusable)
;   A long-name entry is attribute $0F, which includes the volume bit.
;   The volume-bit test therefore skips both labels and long names.
;   dir_next stops on 16-bit ofs wrap (2048 dirents) for long directories
;   FAT32 root is BPB_RootClus32; cluster 0 means that root (ff dir_sdi)
;   FAT16 root is static dirbase LBA
;   SFD (VBR at LBA 0) then four MBR primary partitions
;   1 or 2 FATs; csize power of 2; BytsPerSec == 512
;
; Checks this file does not make:
;   JumpBoot. 55AA is required. ChaN accepts some VBRs that have no 55AA.
;   BPB_Media. Partition type. GPT and extended partitions fail the VBR check.
;
; Other limits:
;   dir_next itself does not stretch (dir_create does, FAT32 only)
;   dir_zap is E5 only; the caller frees the chain with _fat_free
;
; How to read this file. Each operation is one label, top to bottom:
; mount, clst2sect, get_fat, put_fat, create_chain, remove_chain,
; dir_sdi, dir_next, dir_find, dir_create. The C entry points
; (_fat_alloc and the rest) only load or store the caller's
; little-endian dword and call that operation. They are not a
; second copy of the work.
; fat_ld32, fat_st32, and fat_move_window stay shared. Every cluster
; and every LBA is a dword in BCDE with E as the low byte, and every
; FAT or directory byte is read from the one sector window. Inlining
; those two jobs would paste the FAT16/FAT32 cases into every caller.
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
PUBLIC  fat_sync_window             ;write fatwin if dirty; mirror FAT#2
PUBLIC  _fat_sync                   ;C: fat_sync_window
PUBLIC  _fat_dirty                  ;C: mark fatwin dirty
PUBLIC  fat_move_window             ;flush dirty, read LBA into fatwin
PUBLIC  fat_mount                   ;mount FAT16/32 from LBA 0 or MBR
PUBLIC  _fat_mount                  ;C: fat_mount
PUBLIC  get_fat                     ;next cluster from FAT entry
PUBLIC  put_fat                     ;store next cluster in FAT
PUBLIC  clst_from_off               ;cluster containing file offset
PUBLIC  create_chain                ;allocate and link a new cluster
PUBLIC  remove_chain                ;free a cluster chain
PUBLIC  dir_sdi                     ;seek directory to byte offset
PUBLIC  dir_next                    ;next 32-byte dirent (no stretch)
PUBLIC  dir_find                    ;find 8.3 in current directory
PUBLIC  _dir_find                   ;C: dir_find
PUBLIC  dir_create                  ;alloc/register 8.3 (FAT32 may stretch)
PUBLIC  _dir_create                 ;C: dir_create
PUBLIC  dir_zap                     ;mark dirent deleted (E5)
PUBLIC  _dir_zap                    ;C: dir_zap
PUBLIC  _fat_dir_open               ;C: open dir from sclust dword
PUBLIC  _fat_dir_read               ;C: copy 32-byte dirent; 0x00 = EOT
PUBLIC  _fat_next                   ;C: get_fat of dword at (HL)
PUBLIC  _fat_alloc                  ;C: create_chain of dword at (HL)
PUBLIC  _fat_free                   ;C: remove_chain of dword at (HL)
PUBLIC  _fat_clst2sect              ;C: clst2sect of dword at (HL)
PUBLIC  _fat_getfree                ;C: count free clusters into dword at (HL)
PUBLIC  _fat_clusters               ;C: bytes at (HL) -> cluster count, or 0


; HL = src, DE = dst, BC = count. Advances HL/DE. Clobbers AF, BC.
; BC = 0 copies 65536 bytes, the same as Z80 ldir.
; 16-bit trip: dec bc / inc b / inc c (dec bc does not set Z).
fat_copy:
    dec     bc
    inc     b
    inc     c
fat_copy_lp:
    ld      a,(hl+)                 ;byte copy, not ldir
    ld      (de+),a
    dec     c
    jp      NZ,fat_copy_lp          ;more bytes in this page
    dec     b
    jp      NZ,fat_copy_lp          ;more pages
    ret

; ff.c ld_32 / st_32 as *(DWORD *). Word cursor DE, native ld hl,(de) /
; ld (de),hl. Last byte has no post-increment: HL at offset +3. Streamed
; callers inc hl to the next dword. BCDE is E LSB.
fat_ld32:
    ex      de,hl
    ld      hl,(de)
    inc     de
    inc     de
    push    hl
    ld      hl,(de)
    inc     de
    ld      bc,hl
    pop     hl
    ex      de,hl
    ret

fat_st32:
    push    bc
    ex      de,hl
    ld      (de),hl
    inc     de
    inc     de
    pop     hl
    ld      (de),hl
    inc     de
    ex      de,hl
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


; ff.c clst2sect: if (clst < 2 || clst >= n_fatent) fail;
; clst -= 2; return database + csize * clst. csize is 2^n.
; IN:  BCDE = cluster (B MSB … E LSB)
; OUT: C: BCDE = LBA of first sector of cluster
;      NC: fail
; clobbers AF, HL
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
    ret     NC                      ;cluster >= n_fatent
    ld      a,e
    sub     2                       ;cluster - 2
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
    jp      C,clst2sect_ov          ;cluster < 2
    ld      hl,de                   ;DEHL = clst-2
    ld      de,bc
    ld      a,(_cpm_fat_vol+1)      ;csize is 2^n
clst2sect_mul:
    or      a                       ;csize >> 1; rra leaves Z stale
    rra
    or      a                       ;rra does not set Z
    jp      Z,clst2sect_base        ;no csize bits left
    add     hl,hl                   ;(clst-2)<<1; high half is rl de
    call    fat_rlde
    jp      C,clst2sect_ov          ;csize*(clst-2) wrapped
    jp      clst2sect_mul
clst2sect_base:
    ld      bc,de
    ex      de,hl                   ;BCDE = (clst-2)*csize
    ld      hl,_cpm_fat_vol+16      ;database
    ld      a,(hl+)
    add     a,e                     ;database + sector offset
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
    jp      C,clst2sect_ov          ;database + off wrapped
    scf                             ;C: LBA in BCDE
    ret

clst2sect_ov:
    or      a                       ;NC: cluster out of range
    ret

; ff.c sync_window, fail closed. Writes FAT #1 first. wflag stays set
; until every copy succeeds (ff clears it before FAT #2 and ignores a
; failed mirror). n_fats >= 2 and winsect in FAT #1 (unsigned
; winsect - fatbase < fatsz): write winsect + fatsz. Directory windows
; are not mirrored. Mount only allows 1 or 2 FATs.
; OUT: C: OK; NC: write failed
; clobbers AF, BC, DE, HL (ide_write_sector contract)
_fat_dirty:
    ld      a,1
    ld      (fat_wflag),a
    ret

_fat_sync:
fat_sync_window:
    ld      a,(fat_wflag)
    or      a
    jp      Z,fat_sync_ok           ;nothing dirty
    call    fat_ldhl
    defw    fat_winsect+2
    ld      bc,hl
    call    fat_ldhl
    defw    fat_winsect
    ex      de,hl
    ld      hl,fatwin               ;high RAM FAT window
    call    ide_write_sector        ;C: OK; HL += 512
    ld      hl,1
    ret     NC                      ;leave flag dirty
    ld      a,(_cpm_fat_vol+24)     ;n_fats
    cp      2                       ;mirror only when n_fats is 2
    jp      C,fat_sync_clear        ;n_fats < 2
    ld      hl,_cpm_fat_vol+8       ;winsect - fatbase
    ld      a,(fat_winsect)
    sub     (hl+)                   ;winsect - fatbase
    ld      e,a
    ld      a,(fat_winsect+1)
    sbc     a,(hl+)
    ld      d,a
    ld      a,(fat_winsect+2)
    sbc     a,(hl+)
    ld      c,a
    ld      a,(fat_winsect+3)
    sbc     a,(hl)
    jp      C,fat_sync_clear        ;winsect < fatbase
    ld      b,a                     ;BCDE = winsect - fatbase
    ld      hl,_cpm_fat_vol+20      ;compare to fatsz
    ld      a,e
    sub     (hl+)                   ;offset - fatsz
    ld      a,d
    sbc     a,(hl+)
    ld      a,c
    sbc     a,(hl+)
    ld      a,b
    sbc     a,(hl)
    jp      NC,fat_sync_clear       ;not in FAT #1
    call    fat_ldhl
    defw    fat_winsect+2
    ld      bc,hl                   ;park winsect high
    call    fat_ldhl
    defw    fat_winsect
    ld      de,(_cpm_fat_vol+20)
    add     hl,de                   ;winsect.lo + fatsz.lo
    ex      de,hl                   ;DE = winsect.lo + fatsz.lo
    call    fat_ldhl
    defw    _cpm_fat_vol+22
    ld      a,c
    adc     a,l
    ld      c,a
    ld      a,b
    adc     a,h
    ld      b,a                     ;BCDE = winsect + fatsz
    ld      hl,fatwin
    call    ide_write_sector        ;C: FAT#2 written; HL += 512
    ld      hl,1
    ret     NC                      ;mirror failed; flag stays dirty
fat_sync_clear:
    xor     a
    ld      (fat_wflag),a
fat_sync_ok:
    call    fat_fsi_write           ;then the FSInfo sector
    ld      hl,0
    scf                             ;C: window and FSInfo synced
    ret

; Write FSI_Free_Count and FSI_Nxt_Free. A failed write leaves the dirty
; flag set and does not fail the FAT sync that called this. Dirty is
; cleared before fat_move_window so that call cannot re-enter here.
; free_valid clear stores $FFFFFFFF (unknown). A next-free hint below
; 2 stores $FFFFFFFF. LBA 0 means this volume has no info sector.
fat_fsi_write:
    ld      a,(fat_fsi_dirty)
    or      a
    ret     Z                       ;FSInfo not dirty
    call    fat_ldhl
    defw    fat_fsi_lba
    ld      a,h
    or      l
    call    fat_ldhl
    defw    fat_fsi_lba+2
    or      h
    or      l
    ret     Z                       ;no FSInfo LBA
    xor     a
    ld      (fat_fsi_dirty),a
    call    fat_ldhl
    defw    fat_fsi_lba+2
    ld      bc,hl
    call    fat_ldhl
    defw    fat_fsi_lba
    ex      de,hl
    call    fat_move_window         ;C: FSInfo sector in fatwin
    jp      NC,fat_fsi_again        ;read failed; mark dirty again
    ld      a,(_cpm_fat_vol+25)
    or      a
    jp      Z,fat_fsi_unk           ;free_valid clear
    call    fat_ldhl
    defw    _cpm_fat_vol+28
    ex      de,hl
    call    fat_ldhl
    defw    _cpm_fat_vol+30
    ld      bc,hl
    jp      fat_fsi_free
fat_fsi_unk:
    ld      de,$FFFF
    ld      bc,$FFFF
fat_fsi_free:
    ld      hl,fatwin+488
    call    fat_st32                ;FSI_Free_Count
    call    fat_ldhl
    defw    fat_last_clst
    ex      de,hl
    call    fat_ldhl
    defw    fat_last_clst+2
    ld      bc,hl
    ld      a,b
    or      c
    or      d
    jp      NZ,fat_fsi_nxt          ;hint is above 255
    ld      a,e
    cp      2                       ;hint below 2 is unknown
    jp      NC,fat_fsi_nxt          ;hint >= 2
    ld      de,$FFFF
    ld      bc,$FFFF
fat_fsi_nxt:
    ld      hl,fatwin+492
    call    fat_st32                ;FSI_Nxt_Free
    call    fat_ldhl
    defw    fat_fsi_lba+2
    ld      bc,hl
    call    fat_ldhl
    defw    fat_fsi_lba
    ex      de,hl
    ld      hl,fatwin
    call    ide_write_sector        ;C: FSInfo written; HL += 512
    ret     C                       ;write ok
fat_fsi_again:
    ld      a,1
    ld      (fat_fsi_dirty),a
    ret

fat_fsi_mark:
    ld      a,1
    ld      (fat_fsi_dirty),a
    ret

; ff.c move_window: flush if dirty, then read LBA into fatwin.
; IN:  BCDE = LBA (B MSB … E LSB)
; OUT: C: fatwin holds that sector
;      NC: read failed
; clobbers AF, HL; BCDE may be clobbered
fat_move_window:
    call    fat_ldhl
    defw    fat_winsect
    ld      a,l
    cp      e                       ;winsect vs LBA, byte 0
    jp      NZ,fat_move_do          ;different sector
    ld      a,h
    cp      d                       ;winsect vs LBA, byte 1
    jp      NZ,fat_move_do          ;different sector
    call    fat_ldhl
    defw    fat_winsect+2
    ld      a,l
    cp      c                       ;winsect vs LBA, byte 2
    jp      NZ,fat_move_do          ;different sector
    ld      a,h
    cp      b                       ;winsect vs LBA, byte 3
    jp      NZ,fat_move_do          ;different sector
    scf                             ;already in window
    ret
fat_move_do:
    push    bc
    push    de                      ;save LBA (ide_* and sync clobber)
    call    fat_sync_window         ;flush a dirty window first
    pop     de
    pop     bc
    ret     NC                      ;flush failed
    push    bc
    push    de
    ld      hl,fatwin               ;high RAM FAT window
    call    ide_read_sector         ;C: fatwin filled; HL += 512
    pop     de
    pop     bc
    ret     NC                      ;sector read failed
    ex      de,hl
    call    fat_sthl
    defw    fat_winsect
    ld      hl,bc
    call    fat_sthl
    defw    fat_winsect+2
    xor     a
    ld      (fat_wflag),a
    scf                             ;C: fatwin holds this LBA
    ret

;------------------------------------------------------------------------------
; fat_check_vbr — ff.c check_fs (FAT/FAT32 only)
; Require 55AA, 512-byte sectors, csize 2^n and <= 64, reserved != 0, 1 or 2 FATs.
; JumpBoot is not checked. 55AA is required.
; C = looks like a FAT16/32 VBR (type decided later from nclst).
;------------------------------------------------------------------------------
fat_check_vbr:
    ld      a,(fatwin+BS_55AA)
    cp      $55                     ;55AA low byte
    jp      NZ,fat_check_fail       ;not a VBR
    ld      a,(fatwin+BS_55AA+1)
    cp      $AA                     ;55AA high byte
    jp      NZ,fat_check_fail       ;not a VBR
    ld      a,(fatwin+BPB_BytsPerSec)
    or      a
    jp      NZ,fat_check_fail       ;BytsPerSec low byte nonzero
    ld      a,(fatwin+BPB_BytsPerSec+1)
    cp      2                       ;512
    jp      NZ,fat_check_fail       ;not 512 bytes/sector
    ld      a,(fatwin+BPB_SecPerClus)
    or      a
    jp      Z,fat_check_fail        ;SecPerClus is 0
    ld      b,a
    dec     a
    and     b
    jp      NZ,fat_check_fail       ;not 2^n
    ld      a,b
    cp      65                      ;64 KiB clusters do not fit the 16-bit math
    jp      C,fat_check_rsvd        ;csize below 65
    ld      a,19                    ;FR_INVALID_PARAMETER
    ld      (_cpm_fat_vol+27),a
    jp      fat_check_fail
fat_check_rsvd:
    ld      a,(fatwin+BPB_RsvdSecCnt)
    ld      hl,fatwin+BPB_RsvdSecCnt+1
    or      (hl)
    jp      Z,fat_check_fail        ;reserved count is 0
    ld      a,(fatwin+BPB_NumFATs)
    cp      1                       ;NumFATs
    jp      Z,fat_check_ok          ;one FAT
    cp      2                       ;NumFATs
    jp      NZ,fat_check_fail       ;not 1 or 2 FATs
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
    jp      NC,fat_mount_cold1      ;not ready yet
    xor     a
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
    call    fat_sthl
    defw    fat_winsect
    call    fat_sthl
    defw    fat_winsect+2
    ld      bc,0
    ld      de,0
    call    fat_move_window         ;read LBA 0 into fatwin
    jp      NC,fat_mount_cold1      ;LBA 0 unread
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
    jp      Z,fat_mount_nextpt      ;empty partition
    ld      a,b
    cp      (MAX_LBA28>>24)+1       ;high byte past $0FFFFFFF
    jp      NC,fat_mount_nextpt     ;start LBA above 28 bits
    call    fat_move_window         ;read that partition VBR
    jp      NC,fat_mount_nextpt     ;partition unread
    call    fat_check_vbr           ;C: this PTE is a FAT VBR
    jp      C,fat_mount_gotpt       ;use this partition
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
    call    fat_ldhl
    defw    fatwin+BPB_RootEntCnt
    call    fat_sthl
    defw    _cpm_fat_vol+2     ;n_rootent
    call    fat_ldhl
    defw    fatwin+BPB_FATSz16
    ex      de,hl
    ld      a,d
    or      e
    jp      NZ,fat_mount_fsz        ;FATSz16 is nonzero
    call    fat_ldhl
    defw    fatwin+BPB_FATSz32+2
    ld      bc,hl
    call    fat_ldhl
    defw    fatwin+BPB_FATSz32
    ex      de,hl
    jp      fat_mount_fsz32
fat_mount_fsz:
    ld      bc,0
fat_mount_fsz32:
    ex      de,hl
    call    fat_sthl
    defw    _cpm_fat_vol+20    ;fatsz
    ld      hl,bc
    call    fat_sthl
    defw    _cpm_fat_vol+22
    ld      a,b
    or      a
    jp      NZ,fat_mount_fail       ;fatsz >= $01000000
    ld      a,c
    cp      (MAX_FATSZ+1)>>16       ;high byte of $200000
    jp      NC,fat_mount_fail       ;fatsz >= $200000
    call    fat_ldhl
    defw    fatwin+BPB_TotSec16
    ld      a,h
    or      l
    jp      NZ,fat_mount_tsz16      ;TotSec16 is nonzero
    call    fat_ldhl
    defw    fatwin+BPB_TotSec32+2
    ex      de,hl
    call    fat_ldhl
    defw    fatwin+BPB_TotSec32
    jp      fat_mount_tsz
fat_mount_tsz16:
    ld      de,0
fat_mount_tsz:
    call    fat_sthl
    defw    fat_work+4         ;tsect
    ex      de,hl
    call    fat_sthl
    defw    fat_work+6
    call    fat_ldhl
    defw    _cpm_fat_vol+22
    ex      de,hl
    call    fat_ldhl
    defw    _cpm_fat_vol+20    ;fatsz
    ld      a,(_cpm_fat_vol+24)
    cp      2                       ;two FATs
    jp      NZ,fat_mount_fatarea    ;single FAT
    add     hl,hl                   ;fatsz<<1; high half is rl de
    call    fat_rlde                      ;fatsz * n_fats
    jp      C,fat_mount_fail        ;CVE-2026-6682 analog
fat_mount_fatarea:
    ld      bc,hl
    call    fat_ldhl
    defw    fatwin+BPB_RsvdSecCnt
    add     hl,bc                   ;reserved + FAT area
    jp      NC,fat_mount_sy1        ;sum fits in 16 bits
    inc     de
    ld      a,d
    or      e
    jp      Z,fat_mount_fail        ;high half wrapped to 0
fat_mount_sy1:
    push    hl
    call    fat_ldhl
    defw    fatwin+BPB_FATSz16
    ld      a,h
    or      l
    pop     hl
    jp      Z,fat_mount_r32root     ;FATSz16 == 0
    push    hl
    call    fat_ldhl
    defw    _cpm_fat_vol+2     ;n_rootent
    ld      a,h
    or      l
    jp      Z,fat_mount_rootbad     ;FAT16 root count is 0
    ld      a,l
    and     $0F
    jp      NZ,fat_mount_rootbad    ;not a whole number of sectors
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
    jp      fat_mount_addroot
fat_mount_r32root:
    push    hl
    call    fat_ldhl
    defw    fatwin+BPB_RootEntCnt
    ld      a,h
    or      l
    jp      NZ,fat_mount_rootbad    ;FAT32 root count must be 0
    ld      a,(fatwin+BPB_FSVer)
    ld      hl,fatwin+BPB_FSVer+1
    or      (hl)
    jp      NZ,fat_mount_rootbad    ;FSVer must be 0
    pop     hl
    ld      bc,0                    ;FAT32 has no static root
    jp      fat_mount_addroot
fat_mount_rootbad:
    pop     hl
    jp      fat_mount_fail
fat_mount_addroot:
    add     hl,bc                   ;add static root sectors
    jp      NC,fat_mount_sy2        ;sum fits in 16 bits
    inc     de
    ld      a,d
    or      e
    jp      Z,fat_mount_fail        ;high half wrapped to 0
fat_mount_sy2:
    call    fat_sthl
    defw    fat_work+8         ;sysect
    ex      de,hl
    call    fat_sthl
    defw    fat_work+10
    call    fat_ldhl
    defw    fat_work+8
    ld      bc,hl
    call    fat_ldhl
    defw    fat_work+4         ;tsect - sysect
    call    fat_subhlbc                   ;tsect - sysect
    call    fat_sthl
    defw    fat_work+12
    call    fat_ldhl
    defw    fat_work+10
    ld      bc,hl
    call    fat_ldhl
    defw    fat_work+6
    ld      a,l
    sbc     a,c
    ld      l,a
    ld      a,h
    sbc     a,b
    ld      h,a
    call    fat_sthl
    defw    fat_work+14
    jp      C,fat_mount_fail        ;tsect < sysect
    ld      a,(_cpm_fat_vol+1)      ;csize = 2^n
    ld      b,0
fat_mount_log:
    or      a                       ;csize >> 1; rra leaves Z stale
    rra
    or      a
    jp      Z,fat_mount_shr         ;log2(csize) is in B
    inc     b
    jp      fat_mount_log
fat_mount_shr:
    call    fat_ldhl
    defw    fat_work+14
    ex      de,hl
    call    fat_ldhl
    defw    fat_work+12
    ld      a,b
    or      a
    jp      Z,fat_mount_ncl         ;no divide: nclst = data sectors
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
    call    fat_sthl
    defw    fat_work+12        ;nclst low
    ex      de,hl
    call    fat_sthl
    defw    fat_work+14        ;nclst high
    ld      a,h
    or      l
    or      d
    or      e
    jp      Z,fat_mount_fail        ;no data clusters
    ld      a,h
    or      a
    jp      NZ,fat_mount_fail       ;nclst >= $01000000
    ld      a,l
    cp      $10
    jp      NC,fat_mount_fail       ;nclst >= $00100000
    cp      $0F
    jp      NZ,fat_mount_band       ;high word is not $0FFF
    ld      a,d
    inc     a
    jp      NZ,fat_mount_band       ;low word < $FF00
    ld      a,e
    cp      (MAX_FAT32 & $FF)+1     ;low byte past $0FFFFFF5
    jp      NC,fat_mount_fail       ;nclst > $0FFFFFF5
fat_mount_band:
    ld      a,h
    or      l
    jp      NZ,fat_mount_fat32      ;nclst above 65535
    ld      hl,de                   ;low still in DE
    ld      bc,MAX_FAT12+1
    call    fat_subhlbc                   ;nclst - ($0FF5+1)
    jp      C,fat_mount_fat12       ;nclst <= $0FF5
    ld      hl,de
    ld      bc,MAX_FAT16
    call    fat_subhlbc                   ;nclst - $FFF5
    jp      Z,fat_mount_fat16       ;$FFF5 stays FAT16
    jp      NC,fat_mount_fat32      ;above $FFF5 is FAT32
fat_mount_fat16:
    call    fat_ldhl
    defw    _cpm_fat_vol+2     ;FAT32 shape, count in the FAT16 band
    ld      a,h
    or      l
    jp      Z,fat_mount_fail        ;FAT16 with an empty root
    ld      a,FS_FAT16
    jp      fat_mount_type
fat_mount_fat32:
    call    fat_ldhl
    defw    fatwin+BPB_FATSz16 ;FAT16 shape, count in the FAT32 band
    ld      a,h
    or      l
    jp      NZ,fat_mount_fail       ;FAT32 shape still has FATSz16
    ld      a,FS_FAT32
    jp      fat_mount_type
fat_mount_fat12:
    call    fat_ldhl
    defw    _cpm_fat_vol+2     ;FAT12 uses the FAT16 root shape
    ld      a,h
    or      l
    jp      Z,fat_mount_fail        ;FAT12 with an empty root
    ld      a,FS_FAT12
fat_mount_type:
    ld      (_cpm_fat_vol+26),a     ;publish to +0 only at fat_mount_ok
    call    fat_ldhl
    defw    fat_work+14
    ex      de,hl
    call    fat_ldhl
    defw    fat_work+12
    ld      bc,2
    add     hl,bc                   ;nclst + 2 = n_fatent
    jp      NC,fat_mount_nfe        ;sum fits in 16 bits
    inc     de
    ld      a,d
    or      e
    jp      Z,fat_mount_fail        ;n_fatent wrapped
fat_mount_nfe:
    call    fat_sthl
    defw    _cpm_fat_vol+4     ;n_fatent
    ex      de,hl
    call    fat_sthl
    defw    _cpm_fat_vol+6
    call    fat_ldhl
    defw    _cpm_fat_vol+4
    ld      de,(_cpm_fat_vol+6)
    ld      a,(_cpm_fat_vol+26)     ;pending type
    cp      FS_FAT12                ;pending type vs FAT12
    jp      Z,fat_mount_need12      ;FAT12 entries are 12 bits
    cp      FS_FAT32                ;pending type
    jp      Z,fat_mount_need32      ;FAT32 entries are 4 bytes
    ld      bc,255
    add     hl,bc                   ;round FAT16 bytes up
    jp      NC,fat_mount_need16     ;sum fits in 16 bits
    inc     de
fat_mount_need16:
    ld      l,h
    ld      h,e
    ld      e,d
    ld      d,0
    jp      fat_mount_needc
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
    jp      fat_mount_needc
fat_mount_need32:
    ld      bc,127
    add     hl,bc                   ;round FAT32 bytes up
    jp      NC,fat_mount_need32s    ;sum fits in 16 bits
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
    call    fat_ldhl
    defw    fatwin+BPB_RsvdSecCnt
    ld      bc,hl
    call    fat_ldhl
    defw    fat_winsect        ;fatbase = bsect + nrsv
    add     hl,bc                   ;fatbase = volbase + reserved
    call    fat_sthl
    defw    _cpm_fat_vol+8
    call    fat_ldhl
    defw    fat_winsect+2
    ld      bc,0
    ld      a,l
    adc     a,c
    ld      l,a
    ld      a,h
    adc     a,b
    cp      (MAX_LBA28>>24)+1       ;high byte past $0FFFFFFF
    jp      NC,fat_mount_fail       ;fatbase above 28 bits
    ld      h,a
    call    fat_sthl
    defw    _cpm_fat_vol+10
    call    fat_ldhl
    defw    fat_work+8
    ld      bc,hl
    call    fat_ldhl
    defw    fat_winsect        ;database = bsect + sysect
    add     hl,bc                   ;database = volbase + sysect
    call    fat_sthl
    defw    _cpm_fat_vol+16
    call    fat_ldhl
    defw    fat_work+10
    ld      bc,hl
    call    fat_ldhl
    defw    fat_winsect+2
    ld      a,l
    adc     a,c
    ld      l,a
    ld      a,h
    adc     a,b
    cp      (MAX_LBA28>>24)+1       ;high byte past $0FFFFFFF
    jp      NC,fat_mount_fail       ;database above 28 bits
    ld      h,a
    call    fat_sthl
    defw    _cpm_fat_vol+18
    ld      a,(_cpm_fat_vol+26)     ;pending type
    cp      FS_FAT32                ;pending type
    jp      Z,fat_mount_r32         ;FAT32 dirbase is RootClus
    call    fat_ldhl
    defw    _cpm_fat_vol+2
    ld      bc,hl
    call    fat_ldhl
    defw    _cpm_fat_vol+16    ;dirbase = database - rootsecs
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
    call    fat_subhlbc                   ;database - root sectors
    call    fat_sthl
    defw    _cpm_fat_vol+12
    call    fat_ldhl
    defw    _cpm_fat_vol+18
    ld      a,l
    sbc     a,0
    ld      l,a
    ld      a,h
    sbc     a,0
    ld      h,a
    call    fat_sthl
    defw    _cpm_fat_vol+14
    jp      fat_mount_ok
fat_mount_r32:
    call    fat_ldhl
    defw    fatwin+BPB_RootClus32
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
    call    fat_ldhl
    defw    fatwin+BPB_RootClus32
    call    fat_sthl
    defw    _cpm_fat_vol+12
    call    fat_ldhl
    defw    fatwin+BPB_RootClus32+2
    call    fat_sthl
    defw    _cpm_fat_vol+14
    xor     a
    ld      (_cpm_fat_vol+2),a
    ld      (_cpm_fat_vol+3),a
    ld      a,(fatwin+BPB_ExtFlags+1)
    and     $80                     ;mirroring disabled: one active FAT
    jp      Z,fat_mount_ok          ;mirroring on
    ld      a,(fatwin+BPB_ExtFlags)
    and     $0F
    ld      b,a
    ld      a,(_cpm_fat_vol+24)     ;n_fats
    cp      b                       ;active index vs n_fats
    jp      C,fat_mount_fail        ;active index >= n_fats
    jp      Z,fat_mount_fail        ;active index == n_fats
    ld      a,b
    or      a                       ;active index 0
    jp      Z,fat_mount_act0        ;active FAT is already fatbase
    call    fat_ldhl
    defw    _cpm_fat_vol+8
    ld      de,(_cpm_fat_vol+20)
    add     hl,de                   ;active FAT is fatbase + fatsz
    call    fat_sthl
    defw    _cpm_fat_vol+8
    call    fat_ldhl
    defw    _cpm_fat_vol+10
    ld      de,(_cpm_fat_vol+22)
    ld      a,l
    adc     a,e
    ld      l,a
    ld      a,h
    adc     a,d
    cp      (MAX_LBA28>>24)+1       ;high byte past $0FFFFFFF
    jp      NC,fat_mount_fail       ;active FAT above 28 bits
    ld      h,a
    call    fat_sthl
    defw    _cpm_fat_vol+10
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
    jp      Z,fat_mount_cwd32       ;cwd is the FAT32 root cluster
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
    call    fat_ldhl
    defw    _cpm_fat_vol+12    ;FAT32 root cluster
    call    fat_sthl
    defw    fat_cwd
    call    fat_ldhl
    defw    _cpm_fat_vol+14
    call    fat_sthl
    defw    fat_cwd+2
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
    jp      NZ,fat_mount_code       ;L already holds FR 19
    ld      l,1
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
    call    fat_ldhl
    defw    fatwin+BPB_FSInfo
    ld      a,h
    or      l
    ret     Z                       ;FSInfo offset is 0
    inc     hl
    ld      a,h
    or      l
    ret     Z                       ;offset was $FFFF
    dec     hl
    ex      de,hl                   ;DE = sector offset
    call    fat_ldhl
    defw    fat_winsect
    add     hl,de                   ;volbase + FSInfo offset
    ex      de,hl                   ;DE = low sum; carry stays
    call    fat_ldhl
    defw    fat_winsect+2
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
    call    fat_sthl
    defw    fat_fsi_lba
    pop     hl
    call    fat_sthl
    defw    fat_fsi_lba+2
    xor     a
    ld      (fat_fsi_dirty),a
    ld      hl,fatwin+492           ;FSI_Nxt_Free
    call    fat_ld32                ;FSI_Nxt_Free into BCDE
    ld      a,e
    and     d
    and     c
    and     b
    cp      $FF                     ;all $FF means unknown
    jp      Z,seed_free             ;no next-free hint
    call    fat_clst_ok             ;C: hint is not a cluster
    jp      C,seed_free             ;hint out of range
    ld      hl,de
    call    fat_sthl
    defw    fat_last_clst
    ld      hl,bc
    call    fat_sthl
    defw    fat_last_clst+2
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
    call    fat_ldhl
    defw    _cpm_fat_vol+4     ;nclst = n_fatent - 2
    ld      a,l
    sub     2                       ;n_fatent - 2 = nclst
    ld      l,a
    ld      a,h
    sbc     a,0
    ld      h,a
    call    fat_sthl
    defw    fat_work
    call    fat_ldhl
    defw    _cpm_fat_vol+6
    ld      a,l
    sbc     a,0
    ld      l,a
    ld      a,h
    sbc     a,0
    ld      h,a
    call    fat_sthl
    defw    fat_work+2
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
    call    fat_sthl
    defw    _cpm_fat_vol+28
    ld      hl,bc
    call    fat_sthl
    defw    _cpm_fat_vol+30
    ld      a,1
    ld      (_cpm_fat_vol+25),a
    ret
seed_drop:
    pop     hl
    pop     hl
    ret

;------------------------------------------------------------------------------
; fat_fatent: map cluster BCDE onto fatwin (ff get_fat/put_fat window).
; Byte offset = clst*2 (FAT16) or clst*4 (FAT32); LBA = fatbase + offset/512.
; Rejects cluster < 2 or cluster >= n_fatent. OUT C: HL -> the entry in fatwin.
;------------------------------------------------------------------------------
fat_fatent:
    ld      a,e                     ;reject clst < 2
    sub     2                       ;cluster - 2
    ld      a,d
    sbc     a,0
    ld      a,c
    sbc     a,0
    ld      a,b
    sbc     a,0
    ret     C                       ;cluster < 2
    ld      hl,_cpm_fat_vol+4       ;clst - n_fatent (BCDE live)
    ld      a,e
    sub     (hl+)                   ;cluster - n_fatent
    ld      a,d
    sbc     (hl+)
    ld      a,c
    sbc     (hl+)
    ld      a,b
    sbc     a,(hl)
    ret     NC                      ;clst >= n_fatent
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT32                ;fs_type
    jp      Z,fat_fatent32          ;FAT32 slot is 4 bytes
    ; FAT16: pff/ff WORD array. sect = fatbase + clst/256; off = (BYTE)clst*2
    ld      l,e
    ld      h,0
    add     hl,hl                   ;off = (BYTE)clst * 2  (< 512)
    push    hl
    ld      e,d
    ld      d,c
    ld      c,b
    ld      b,0                     ;BCDE = clst >> 8
    jp      fat_fatent_sec
fat_fatent32:
    ; FAT32: pff DWORD array. sect = fatbase + clst/128; off = (clst%128)*4
    ; (clst%128)*4 is 0..508 — must be 16-bit; add a,a wraps at 64.
    ld      a,e
    and     127
    ld      l,a
    ld      h,0
    add     hl,hl                   ;(clst % 128) * 4
    add     hl,hl
    push    hl                      ;off 0..508
    ld      a,e
    rla                             ;C = clst bit 7
    ld      e,d
    ld      d,c
    ld      c,b
    ld      b,0                     ;clst >> 8
    call    fat_rlde                      ;low *2 + bit 7
    ld      a,c
    rla
    ld      c,a
    ld      a,b
    rla
    ld      b,a                     ;clst >> 7
fat_fatent_sec:
    ld      hl,_cpm_fat_vol+8       ;+ fatbase
    ld      a,(hl+)
    add     a,e                     ;fatbase + FAT sector
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
    call    fat_move_window         ;C: FAT sector in fatwin
    pop     de                      ;offset in sector (< 512)
    ret     NC                      ;FAT sector unread
    ld      hl,fatwin
    add     hl,de
    scf                             ;C: HL points at the entry
    ret

; FAT12 entry. Byte offset is clst + clst/2. Even cluster: low
; 12 bits. Odd cluster: high 12 bits. The two bytes can sit in
; different sectors when the offset ends on byte 511.
; IN: BCDE = cluster, already in range for fat12_load.
; OUT C: E = first raw byte, D = second, C = 1 if odd.
;     The window sits on the second sector when the entry spans.
; NC: the FAT sector was not read.
fat12_range:
    ld      a,e                     ;clst < 2
    sub     2
    ld      a,d
    sbc     a,0
    ld      a,c
    sbc     a,0
    ld      a,b
    sbc     a,0
    jp      C,fat12_range_lo
    ld      hl,_cpm_fat_vol+4       ;clst - n_fatent
    ld      a,e
    sub     (hl+)
    ld      a,d
    sbc     a,(hl+)
    ld      a,c
    sbc     a,(hl+)
    ld      a,b
    sbc     a,(hl)
    ret     NC                      ;clst >= n_fatent
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
    ld      l,e
    ld      h,d
    call    fat12_shr1              ;clst / 2
    add     hl,de                   ;byte offset = clst + clst/2
    ld      a,h
    or      a
    rra                             ;sector = offset >> 9
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
    jp      NC,fat12_load_fail
    pop     de                      ;cluster low
    pop     bc                      ;cluster high
    push    bc
    push    de
    ld      l,e
    ld      h,d
    call    fat12_shr1
    add     hl,de                   ;byte offset again
    ld      a,h
    and     1
    ld      h,a                     ;offset in the sector
    ld      a,l
    inc     a
    jp      NZ,fat12_same           ;not byte 255 or 511
    ld      a,h
    or      a
    jp      Z,fat12_off255          ;offset 255, still this sector
    ld      de,fatwin
    add     hl,de
    ld      c,(hl)                  ;first byte at offset 511
    push    bc
    call    fat_ldhl
    defw    fat_winsect
    inc     hl
    ld      a,h
    or      l
    jp      NZ,fat12_span_lba
    call    fat_ldhl
    defw    fat_winsect+2
    inc     hl
    ld      b,h
    ld      c,l
    ld      hl,0
    jp      fat12_span_go
fat12_span_lba:
    ld      de,hl
    call    fat_ldhl
    defw    fat_winsect+2
    ld      b,h
    ld      c,l
    ex      de,hl
fat12_span_go:
    ld      de,hl
    call    fat_move_window
    jp      NC,fat12_span_err
    ld      a,(fatwin)              ;second byte at offset 0
    pop     bc
    ld      e,c
    ld      d,a
    jp      fat12_par
fat12_off255:
    ld      l,255
fat12_same:
    dec     a                       ;A was L+1 when we came from inc
    ld      l,a
    ld      de,fatwin
    add     hl,de
    ld      c,(hl+)
    ld      d,(hl)
    ld      e,c
fat12_par:
    pop     hl                      ;cluster low
    pop     bc                      ;cluster high, discarded
    ld      a,l
    and     1
    ld      c,a                     ;1 = odd cluster
    scf
    ret
fat12_span_err:
    pop     bc
fat12_load_fail:
    pop     de
    pop     bc
    or      a
    ret

; Shift the raw word in DE to the 12-bit value. C = 1 if odd.
fat12_value:
    ld      a,c
    or      a
    jp      Z,fat12_even
    ld      b,4
fat12_shr4:
    or      a
    ld      a,d
    rra
    ld      d,a
    ld      a,e
    rra
    ld      e,a
    dec     b
    jp      NZ,fat12_shr4           ;four logical shifts left
    ret
fat12_even:
    ld      a,d
    and     $0F
    ld      d,a
    ret

get_fat12:
    call    fat12_range
    ret     NC                      ;cluster is not in the FAT
    call    fat12_load
    ret     NC                      ;FAT sector not read
    call    fat12_value             ;DE = 12-bit link
    ld      a,d
    cp      $0F                     ;high nibble of $FF8..$FFF
    jp      NZ,get_fat12_ok
    ld      a,e
    cp      $F7                     ;FAT12 bad cluster $FF7
    jp      Z,get_fat_bad
    cp      $F8                     ;FAT12 EOC $FF8..$FFF
    jp      C,get_fat12_ok
    ld      de,$FFFF
    ld      bc,$0FFF                ;fold to EOC32 for callers
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
    push    hl                      ;source
    push    bc
    push    de
    call    fat12_range
    jp      NC,fat12_store_fail     ;cluster is not in the FAT
    call    fat12_load              ;DE = old raw, C = parity
    jp      NC,fat12_store_fail
    ld      a,c
    pop     hl                      ;cluster low
    pop     bc                      ;cluster high
    ex      (sp),hl                 ;HL = source, stack = cluster low
    push    bc
    push    af                      ;parity
    push    de                      ;old raw (E first, D second)
    ld      e,(hl)
    inc     hl
    ld      d,(hl)                  ;new link
    pop     hl                      ;old raw
    pop     af                      ;parity
    or      a
    jp      Z,fat12_st_even
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
    jp      fat12_st_wr
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
    call    fat12_shr1
    add     hl,de                   ;byte offset. FAT12 cluster fits in DE
    ld      a,l
    cp      255
    jp      NZ,fat12_st_same
    ld      a,h
    and     1
    jp      NZ,fat12_st_span        ;offset ends on byte 511 of its sector
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
    jp      fat12_st_dirty
fat12_st_span:
    call    fat_ldhl
    defw    fat_winsect
    ld      a,h
    or      l
    jp      Z,fat12_st_backhi
    dec     hl
    ex      de,hl
    call    fat_ldhl
    defw    fat_winsect+2
    ld      bc,hl
    jp      fat12_st_back
fat12_st_backhi:
    ld      de,$FFFF
    call    fat_ldhl
    defw    fat_winsect+2
    dec     hl
    ld      bc,hl
fat12_st_back:
    call    fat_move_window         ;first sector, still clean
    jp      NC,fat12_st_pop
    pop     hl
    push    hl
    ld      a,l
    ld      (fatwin+511),a
    ld      a,1
    ld      (fat_wflag),a           ;flush this byte before the window moves
    call    fat_ldhl
    defw    fat_winsect
    inc     hl
    ld      a,h
    or      l
    jp      Z,fat12_st_fwdhi
    ex      de,hl
    call    fat_ldhl
    defw    fat_winsect+2
    ld      bc,hl
    jp      fat12_st_fwd
fat12_st_fwdhi:
    ld      de,0
    call    fat_ldhl
    defw    fat_winsect+2
    inc     hl
    ld      bc,hl
fat12_st_fwd:
    call    fat_move_window         ;writes the first sector, then the second
    jp      NC,fat12_st_pop
    pop     hl
    ld      a,h
    ld      (fatwin),a
    jp      fat12_st_dirty
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
    call    get_fat                 ;old link; NC is bad or unread
    ld      a,0
    jp      NC,put_fat12_old        ;treat a bad entry as in use
    ld      a,b
    or      c
    or      d
    or      e
    ld      a,0
    jp      NZ,put_fat12_old
    inc     a                       ;old entry was free
put_fat12_old:
    pop     de
    pop     bc
    pop     hl
    push    af
    push    hl
    call    fat12_store
    pop     hl                      ;source
    pop     bc                      ;B = old free. pop af would clear carry
    ret     NC
    ld      a,b
    push    af
    push    hl
    jp      put_fat_wrote

; ff.c get_fat. FAT12 packed 12-bit; FAT16 word; FAT32 dword & $0FFFFFFF.
; EOC is folded to $0FFFFFFF (FAT12 $FF8..$FFF; FAT16 $FFF8..$FFFF;
; FAT32 >= $0FFFFFF8).
get_fat:
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT12                ;fs_type vs FAT12
    jp      Z,get_fat12             ;12-bit packed entry
    call    fat_fatent              ;C: FAT entry in fatwin
    ret     NC                      ;window failed
    ex      de,hl                   ;DE = word cursor in fatwin
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT32                ;fs_type
    jp      Z,get_fat32             ;FAT32 dword
    ld      hl,(de)                 ;ff ld_16
    ld      a,h
    cp      $FF                     ;high byte of the FAT16 link
    jp      NZ,get_fat16ok          ;not an $FFxx link
    ld      a,l
    cp      $F7                     ;FAT16 bad cluster
    jp      Z,get_fat_bad           ;$FFF7 is bad, not a link
    cp      $F8                     ;FAT16 EOC $FFF8..$FFFF
    jp      C,get_fat16ok           ;link below $FFF8
    ld      de,$FFFF
    ld      bc,$0FFF                ;fold to EOC32 for callers
    scf                             ;C: FAT16 end of chain
    ret
get_fat16ok:
    ex      de,hl                   ;DE = cluster
    ld      bc,0
    scf                             ;C: link in DE, high half 0
    ret
get_fat32:
    ld      hl,(de)                 ;low
    inc     de
    inc     de
    push    hl
    ld      hl,(de)                 ;high
    ld      a,h
    and     $0F                     ;ff ld_32 & 0x0FFFFFFF
    ld      b,a
    ld      c,l
    pop     de
    cp      $0F                     ;masked high byte
    jp      NZ,get_fat32ok          ;not an EOC pattern
    ld      a,c
    inc     a
    jp      NZ,get_fat32ok          ;high mid-byte not $FF
    ld      a,d
    inc     a
    jp      NZ,get_fat32ok          ;low mid-byte not $FF
    ld      a,e
    cp      $F7                     ;FAT32 bad cluster $0FFFFFF7
    jp      Z,get_fat_bad           ;$0FFFFFF7 is bad, not a link
    cp      $F8                     ;low byte vs EOC
    jp      C,get_fat32ok           ;link below $0FFFFFF8
    ld      de,$FFFF
    ld      bc,$0FFF
get_fat32ok:
    scf                             ;C: link in BCDE
    ret
get_fat_bad:
    or      a                       ;NC: bad cluster
    ret

; ff.c put_fat. FAT16 stores 16 bits; FAT32 stores 28 bits and keeps
; the on-disk high nibble (bits 28-31).
; IN: BCDE=cluster, HL->DWORD next (LE)
; If free_valid, bump free_clst when a free entry becomes used or
; a used entry becomes free (create_chain / remove_chain).
put_fat:
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT12                ;fs_type vs FAT12
    jp      Z,put_fat12             ;12-bit packed entry
    push    hl
    call    fat_fatent              ;C: FAT entry in fatwin
    pop     de                      ;DE -> next dword
    ret     NC                      ;window failed
    ld      a,(_cpm_fat_vol+25)
    or      a
    jp      Z,put_fat_cold          ;free count is not live
    push    de
    push    hl
    call    fat_win_is_free         ;Z: old FAT entry is free
    ld      a,0
    jp      NZ,put_fat_old          ;old entry is in use
    inc     a
put_fat_old:
    pop     hl
    pop     de
    jp      put_fat_adj
put_fat_cold:
    xor     a
put_fat_adj:
    push    af                      ;A = 1 if old entry was free
    push    de                      ;src for new-free test
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT32                ;fs_type
    jp      Z,put_fat32             ;keep the FAT32 high nibble
    ex      de,hl                   ;HL = src dword, DE = dest in window
    push    de
    ex      de,hl                   ;DE = src
    ld      hl,(de)                 ;ff st_16
    pop     de
    ld      (de),hl
put_fat_wrote:
    pop     de
    pop     af
    ld      c,a                     ;old free
    ld      a,(_cpm_fat_vol+25)
    or      a
    jp      Z,put_fat_dirty         ;free count is not live
    push    bc
    call    fat_src_is_free         ;Z: new link is free
    pop     bc
    ld      a,c
    jp      Z,put_fat_new0          ;new value is a free entry
    or      a
    jp      Z,put_fat_dirty         ;used -> used
    call    fat_nfree_dec           ;free -> used
    jp      put_fat_dirty
put_fat_new0:
    or      a
    jp      NZ,put_fat_dirty        ;free -> free
    call    fat_nfree_inc           ;used -> free
put_fat_dirty:
    ld      a,1
    ld      (fat_wflag),a
    scf                             ;C: entry stored
    ret
put_fat32:
    ld      a,(de+)                 ;copy the link; mask the nibble
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
    jp      put_fat_wrote

; Z if FAT entry at HL is free (ff ld_16==0 / ld_32&0x0FFFFFFF==0).
; Preserves HL. put_fat cache and f_getfree window scan.
fat_win_is_free:
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT32                ;fs_type
    jp      Z,fat_win_free32        ;FAT32 free is a 28-bit zero
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
    and     $0F
    dec     hl
    dec     hl
    or      b
    pop     bc
    ret

; Z if LE dword at DE is a free next-cluster. Preserves DE, HL.
fat_src_is_free:
    push    hl
    ex      de,hl
    call    fat_win_is_free         ;Z from the dword at DE
    ex      de,hl
    pop     hl
    ret

fat_nfree_inc:
    call    fat_ldhl
    defw    _cpm_fat_vol+28
    inc     hl
    call    fat_sthl
    defw    _cpm_fat_vol+28
    ld      a,h
    or      l
    jp      Z,fat_nfree_inc_hi      ;free_clst low half wrapped
    jp      fat_fsi_mark
fat_nfree_inc_hi:
    call    fat_ldhl
    defw    _cpm_fat_vol+30
    inc     hl
    call    fat_sthl
    defw    _cpm_fat_vol+30
    jp      fat_fsi_mark

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
    ret     Z                       ;free count is already 0
    ld      a,h
    or      l
    jp      NZ,fat_nfree_dec_lo     ;low half still nonzero
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

; IN: HL -> {sclust:4, fptr:4} LE
; OUT C: BCDE = cluster containing fptr
; Cluster index is (fptr >> 9) / csize. Sequential CP/M I/O hits
; clst_cache_* so we do not re-walk from sclust.
clst_from_off:
    call    fat_ld32                ;sclust into BCDE
    push    hl
    ex      de,hl
    call    fat_sthl
    defw    fat_work           ;sclust
    ld      hl,bc
    call    fat_sthl
    defw    fat_work+2
    pop     hl
    inc     hl
    call    fat_ld32                ;fptr
    ; cluster index = (fptr >> 9) / csize. >>8 is a byte slide; >>1 after that.
    ld      e,d
    ld      d,c
    ld      c,b
    ld      b,0                     ;fptr >> 8
    ld      a,c
    or      a                       ;clear C; fptr >> 9 via rra
    rra
    ld      c,a
    ld      a,d
    rra
    ld      d,a
    ld      a,e
    rra
    ld      e,a                     ;fptr >> 9 = sector index in CDE
    ld      a,(_cpm_fat_vol+1)
    ld      b,0
cfo_log:
    or      a                       ;csize >> 1; rra leaves Z stale
    rra
    or      a
    jp      Z,cfo_div               ;log2(csize) is in B
    inc     b
    jp      cfo_log
cfo_div:
    ld      a,b
    or      a
    jp      Z,cfo_ci                ;cluster index needs no shift
cfo_shr:
    ld      a,c
    or      a                       ;cluster index >>= 1 via rra
    rra
    ld      c,a
    ld      a,d
    rra
    ld      d,a
    ld      a,e
    rra
    ld      e,a
    dec     b
    jp      NZ,cfo_shr              ;shifts left
cfo_ci:
    ex      de,hl
    call    fat_sthl
    defw    fat_work+4         ;want_ci — kept for the cache store
    ld      hl,clst_cache_sclust
    ld      a,(fat_work)
    cp      (hl)                    ;cached sclust byte 0
    jp      NZ,cfo_from0            ;cache is another chain
    inc     hl
    ld      a,(fat_work+1)
    cp      (hl)                    ;cached sclust byte 1
    jp      NZ,cfo_from0            ;cache is another chain
    inc     hl
    ld      a,(fat_work+2)
    cp      (hl)                    ;cached sclust byte 2
    jp      NZ,cfo_from0            ;cache is another chain
    inc     hl
    ld      a,(fat_work+3)
    cp      (hl)                    ;cached sclust byte 3
    jp      NZ,cfo_from0            ;cache is another chain
    call    fat_ldhl
    defw    fat_work+4
    ld      bc,hl
    call    fat_ldhl
    defw    clst_cache_ci
    call    fat_subhlbc                   ;cache_ci - want_ci
    jp      Z,cfo_cached            ;cached index is this offset
    jp      NC,cfo_from0            ;want is behind the cache
    call    fat_ldhl
    defw    clst_cache_ci
    ld      bc,hl
    call    fat_ldhl
    defw    fat_work+4
    call    fat_subhlbc                   ;steps still to walk
    call    fat_sthl
    defw    fat_work+8         ;steps from cached cluster
    call    fat_ldhl
    defw    clst_cache_clst+2
    ld      bc,hl
    call    fat_ldhl
    defw    clst_cache_clst
    ex      de,hl
    jp      cfo_loop
cfo_from0:
    call    fat_ldhl
    defw    fat_work+4
    call    fat_sthl
    defw    fat_work+8         ;steps from sclust
    call    fat_ldhl
    defw    fat_work+2
    ld      bc,hl
    call    fat_ldhl
    defw    fat_work
    ex      de,hl
cfo_loop:
    ld      a,(fat_work+8)
    ld      hl,fat_work+9
    or      (hl)
    jp      Z,cfo_have              ;walk finished
    call    get_fat                 ;NC: chain broke
    ret     NC                      ;FAT read failed
    ld      a,b
    cp      $0F                     ;EOC high byte
    jp      NZ,cfo_store            ;link is not end of chain
    ld      a,c
    and     d
    and     e
    inc     a
    jp      Z,cfo_bad               ;EOC before the file offset
cfo_store:
    call    fat_ldhl
    defw    fat_work+8
    dec     hl
    call    fat_sthl
    defw    fat_work+8
    jp      cfo_loop
cfo_cached:
    call    fat_ldhl
    defw    clst_cache_clst+2
    ld      bc,hl
    call    fat_ldhl
    defw    clst_cache_clst
    ex      de,hl
cfo_have:
    ex      de,hl
    call    fat_sthl
    defw    clst_cache_clst
    ex      de,hl                   ;DE = cluster low (clst2sect wants BCDE)
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
    scf                             ;C: cluster is in BCDE
    ret
cfo_bad:
    or      a                       ;NC: offset past end of chain
    ret

; IN: BCDE = cluster. OUT: carry set when clst < 2 or clst >= n_fatent.
; Preserves BCDE. Clobbers HL and AF.
fat_clst_ok:
    push    bc
    push    de
    ld      a,b
    or      c
    or      d
    jp      NZ,fco_hi               ;high bytes set: check n_fatent
    ld      a,e
    cp      2                       ;cluster low vs 2
    jp      C,fco_bad               ;cluster < 2
fco_hi:
    call    fat_ldhl
    defw    _cpm_fat_vol+4
    ld      a,l
    sub     e                       ;n_fatent - cluster
    ld      l,a
    ld      a,h
    sbc     a,d
    ld      h,a
    ld      a,(_cpm_fat_vol+6)
    sbc     a,c
    ld      c,a
    ld      a,(_cpm_fat_vol+7)
    sbc     a,b
    jp      C,fco_bad               ;cluster >= n_fatent
    or      c
    or      h
    or      l
    jp      Z,fco_bad               ;cluster == n_fatent
    pop     de
    pop     bc
    or      a                       ;NC: cluster is in range
    ret
fco_bad:
    pop     de
    pop     bc
    scf                             ;C: cluster is out of range
    ret

; Allocate one cluster and link it.
; IN: BCDE = cluster to link after, or 0 to start a new chain.
; A new chain starts at fat_last_clst when that hint is a real cluster
; (fatgen103 FSI_Nxt_Free: start where the driver last allocated).
; Otherwise it starts at cluster 2. Extending a chain starts at clst+1,
; so the next cluster is taken when it is free.
; The scan wraps once to cluster 2 and stops at the cluster where this
; search started, so the tail is not read twice.
; The new cluster is marked EOC ($0FFFFFFF), remembered as fat_last_clst,
; and linked from the previous cluster when there is one.
; OUT C: BCDE = new cluster. A failed FAT#2 mirror still returns it.
create_chain:
    ld      hl,bc
    call    fat_sthl
    defw    fat_work+10
    ld      hl,de
    call    fat_sthl
    defw    fat_work+8
    xor     a
    ld      (fat_work+7),a          ;wrap flag
    ld      a,b
    or      c
    or      d
    or      e
    jp      Z,cc_hint               ;0 starts a new chain
    inc     de
    ld      a,d
    or      e
    jp      NZ,cc_mark              ;clst+1 did not wrap
    inc     bc
    jp      cc_mark
cc_hint:
    call    fat_ldhl
    defw    fat_last_clst+2
    ld      bc,hl
    call    fat_ldhl
    defw    fat_last_clst
    ex      de,hl
    call    fat_clst_ok             ;C: last-clst hint is not a cluster
    jp      NC,cc_mark              ;hint is a real cluster
cc_from2:
    ld      de,2
    ld      bc,0
cc_mark:
    ld      hl,de
    call    fat_sthl
    defw    fat_work           ;search origin
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
    jp      C,cc_wrap               ;candidate >= n_fatent
    or      c
    or      h
    or      l
    jp      Z,cc_wrap               ;candidate >= n_fatent
    call    fat_ldhl
    defw    fat_work+14
    ld      bc,hl
    call    fat_ldhl
    defw    fat_work+12
    ex      de,hl
    ld      a,(fat_work+7)
    or      a
    jp      Z,cc_look               ;have not wrapped yet
    call    fat_ldhl
    defw    fat_work           ;wrapped: stop on return to origin
    ld      a,e
    cp      l                       ;candidate vs origin, byte 0
    jp      NZ,cc_look              ;not back at the origin
    ld      a,d
    cp      h                       ;candidate vs origin, byte 1
    jp      NZ,cc_look              ;not back at the origin
    call    fat_ldhl
    defw    fat_work+2
    ld      a,c
    cp      l                       ;candidate vs origin, byte 2
    jp      NZ,cc_look              ;not back at the origin
    ld      a,b
    cp      h                       ;candidate vs origin, byte 3
    jp      Z,cc_fail               ;back at the search origin
cc_look:
    call    get_fat                 ;read the candidate link
    ret     NC                      ;bad cluster, or the entry cannot be read
    ld      a,b
    or      c
    or      d
    or      e
    jp      NZ,cc_next              ;in use
    call    fat_ldhl
    defw    fat_work+14
    ld      bc,hl
    call    fat_ldhl
    defw    fat_work+12
    ex      de,hl
    call    cc_wipe                 ;zero data before the FAT link is published
    ret     NC                      ;zero-fill failed; FAT unchanged
    call    fat_ldhl
    defw    fat_work+14
    ld      bc,hl
    call    fat_ldhl
    defw    fat_work+12
    ex      de,hl
    ld      hl,cc_eoc
    call    put_fat                 ;mark the new cluster EOC
    ret     NC                      ;EOC store failed
    ld      a,(fat_work+8)
    ld      hl,fat_work+9
    or      (hl+)
    or      (hl+)
    or      (hl)
    jp      Z,cc_ok                 ;no previous cluster to link
    push    bc
    push    de
    call    fat_ldhl
    defw    fat_work+10
    ld      bc,hl
    call    fat_ldhl
    defw    fat_work+8
    ex      de,hl
    ld      hl,fat_work+12
    call    put_fat                 ;link previous to this cluster
    pop     de
    pop     bc
    ret     NC                      ;back-link failed
cc_ok:
    call    fat_ldhl
    defw    fat_work+14
    call    fat_sthl
    defw    fat_last_clst+2
    call    fat_ldhl
    defw    fat_work+12
    call    fat_sthl
    defw    fat_last_clst
    call    fat_fsi_mark            ;next-free hint changed
    call    fat_sync_window         ;FAT#1 has the link; a failed mirror stays dirty
cc_ret_cl:
    call    fat_ldhl
    defw    fat_work+14        ;mirror failure still returns the cluster
    ld      bc,hl
    call    fat_ldhl
    defw    fat_work+12
    ex      de,hl
    scf                             ;C: new cluster, even if mirror failed
    ret
cc_next:
    call    fat_ldhl
    defw    fat_work+14
    ld      bc,hl
    call    fat_ldhl
    defw    fat_work+12
    ex      de,hl
    inc     de
    ld      a,d
    or      e
    jp      NZ,cc_scan              ;candidate low half did not wrap
    inc     bc
    jp      cc_scan
cc_wrap:
    ld      a,(fat_work+7)
    or      a
    jp      NZ,cc_fail              ;already wrapped once
    ld      a,1
    ld      (fat_work+7),a
    ld      a,(fat_work)            ;origin == 2 means the whole volume was seen
    cp      2                       ;origin low vs 2
    jp      NZ,cc_wrap2             ;origin is not cluster 2
    ld      a,(fat_work+1)
    or      a
    jp      NZ,cc_wrap2             ;origin byte 1
    ld      a,(fat_work+2)
    or      a
    jp      NZ,cc_wrap2             ;origin byte 2
    ld      a,(fat_work+3)
    or      a
    jp      Z,cc_fail               ;search started at 2; disk full
cc_wrap2:
    ld      de,2
    ld      bc,0
    jp      cc_scan
cc_fail:
    or      a                       ;NC: no free cluster
    ret
cc_eoc:
    defb    $FF,$FF,$FF,$0F

; Zero every sector of cluster BCDE before put_fat publishes it.
; NC leaves the FAT unchanged. fat_work is not used. csize 0 fails.
; The window is invalidated before the zero fill so fatwin is not a
; cached FAT sector full of zeros.
cc_wipe:
    ld      a,(_cpm_fat_vol+1)
    or      a
    jp      Z,cc_wipe_bad           ;csize is 0
    push    bc
    push    de
    call    clst2sect               ;C: LBA of the new cluster
    jp      C,cc_wipe_lba           ;have an LBA
    pop     de
    pop     bc
cc_wipe_bad:
    or      a                       ;NC: cluster has no LBA
    ret
cc_wipe_lba:
    pop     hl
    pop     hl
    ld      a,(_cpm_fat_vol+1)
    push    bc
    push    de
    push    af
    call    fat_sync_window         ;flush before reusing fatwin
    jp      C,cc_wipe_clr           ;window is clean
    pop     af
    pop     de
    pop     bc
    or      a                       ;NC: flush failed
    ret
cc_wipe_clr:
    ld      hl,$FFFF
    call    fat_sthl
    defw    fat_winsect
    call    fat_sthl
    defw    fat_winsect+2
    xor     a
    ld      (fat_wflag),a
    ld      hl,fatwin
    ld      b,0
cc_wipe_fill:
    ld      (hl+),a                 ;zero fatwin; Z80 twin uses ldir
    ld      (hl+),a
    dec     b
    jp      NZ,cc_wipe_fill         ;512 bytes
cc_wipe_wr:
    pop     af
    pop     de
    pop     bc
    push    bc
    push    de
    push    af
    ld      hl,fatwin
    call    ide_write_sector        ;C: zero sector written; HL += 512
    jp      C,cc_wipe_adv           ;advance to the next sector
    pop     af
    pop     de
    pop     bc
    or      a                       ;NC: zero sector failed
    ret
cc_wipe_adv:
    pop     af
    pop     de
    pop     bc
    dec     a
    jp      Z,cc_wipe_ok            ;csize sectors written
    push    af
    inc     de
    ld      a,d
    or      e
    jp      NZ,cc_wipe_push         ;LBA low did not wrap
    inc     bc
cc_wipe_push:
    pop     af
    push    bc
    push    de
    push    af
    jp      cc_wipe_wr
cc_wipe_ok:
    scf                             ;C: cluster data is zero
    ret

; ff.c remove_chain (entire chain, pclst=0). Walks until 0 or a link
; that is not a cluster (EOC, bad, or >= n_fatent). The step stops at
; n_fatent so a long FAT32 chain is not cut at 65535.
; IN: BCDE = start cluster
remove_chain:
    ld      a,b
    or      c
    or      d
    or      e
    scf                             ;empty chain is success
    ret     Z                       ;start cluster is 0
    ld      hl,0
    call    fat_sthl
    defw    fat_work           ;32-bit step
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
    jp      NZ,rc_cmp               ;step low half did not wrap
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
    ex      de,hl
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
    jp      NC,rc_fail              ;step >= n_fatent
    ld      hl,bc
    call    fat_sthl
    defw    fat_work+10
    ld      hl,de
    call    fat_sthl
    defw    fat_work+8
    call    get_fat                 ;NC: link unreadable or bad
    ret     NC                      ;stop; earlier frees stay written
    ex      de,hl
    call    fat_sthl
    defw    fat_work+12        ;next
    ld      hl,bc
    call    fat_sthl
    defw    fat_work+14
    call    fat_ldhl
    defw    fat_work+10
    ld      bc,hl
    call    fat_ldhl
    defw    fat_work+8
    ex      de,hl
    ld      hl,cc_zero
    call    put_fat                 ;store a free entry
    ret     NC                      ;free store failed
    call    fat_ldhl
    defw    fat_work+14
    ld      bc,hl
    call    fat_ldhl
    defw    fat_work+12
    ex      de,hl
    ld      a,b
    or      c
    or      d
    or      e
    jp      Z,rc_done               ;next link is 0
    ld      hl,_cpm_fat_vol+4       ;next >= n_fatent ends the walk
    ld      a,e
    sub     (hl+)                   ;next - n_fatent
    ld      a,d
    sbc     (hl+)
    ld      a,c
    sbc     (hl+)
    ld      a,b
    sbc     a,(hl)
    jp      C,rc_loop               ;next is still a cluster
rc_done:
    scf                             ;C: chain freed
    ret
rc_fail:
    or      a                       ;NC: step ran past n_fatent
    ret
cc_zero:
    defb    0,0,0,0

; Exclusive byte end of the FAT16 static root.
; Carry set: the end is 65536, so every 16-bit offset is inside
; (2048 entries). Carry clear: offset >= HL is past the root.
; A shorter database-dirbase span still clamps the end.
fat_root16_max:
    call    fat_ldhl
    defw    _cpm_fat_vol+2
    ld      a,l
    and     $F0
    ld      l,a
    ld      a,h
    cp      8                       ;2048 entries * 32 = 65536
    jp      C,frm_mul               ;fewer than 2048 root entries
    ld      hl,0
    scf                             ;C: end is 65536 bytes
    jp      frm_clamp
frm_mul:
    add     hl,hl                   ;entries << 5; result fits in HL
    add     hl,hl
    add     hl,hl
    add     hl,hl
    add     hl,hl                   ;*32, fits in 16 bits
    or      a                       ;C clear: end fits in 16 bits
frm_clamp:
    push    hl
    push    af                      ;C = entry count covers 64K
    ld      a,(_cpm_fat_vol+18)
    ld      hl,_cpm_fat_vol+14
    or      (hl)
    jp      NZ,frm_keep             ;span is not a 16-bit sector count
    call    fat_ldhl
    defw    _cpm_fat_vol+12
    ld      bc,hl
    call    fat_ldhl
    defw    _cpm_fat_vol+16
    call    fat_subhlbc                   ;database - dirbase (sectors)
    jp      C,frm_keep              ;dirbase above database
    jp      Z,frm_keep              ;database == dirbase
    ld      a,h
    or      a
    jp      NZ,frm_keep             ;>= 256 sectors
    ld      a,l
    cp      128                     ;sectors vs 128
    jp      NC,frm_keep             ;>= 128 sectors is >= 64K bytes
    ld      h,l
    ld      l,0
    add     hl,hl                   ;span << 9, fits in 16 bits
    pop     af
    pop     de                      ;DE = count end
    jp      C,frm_span              ;count was 64K: span is tighter
    ld      bc,de
    push    hl
    call    fat_subhlbc                   ;span - count
    pop     hl
    jp      C,frm_clear             ;span is shorter than the entry end
    ex      de,hl
frm_clear:
    or      a                       ;NC: HL is the byte end
    ret
frm_span:
    or      a                       ;NC: HL is the tighter span
    ret
frm_keep:
    pop     af
    pop     hl
    ret

; ff.c dir_sdi. Cluster 0 = FAT16 static root at dirbase LBA.
; FAT32 cluster 0 is the root cluster (dirbase), matching ff dir_sdi.
; FAT32 / subdir: follow the chain (clst_from_off). Offset must be
; 32-byte aligned by the caller.
; IN: BCDE = dir start cluster (0 = FAT16 root / FAT32 root), HL = byte offset
dir_sdi:
    call    fat_sthl
    defw    dir_ofs
    ld      a,b
    or      c
    or      d
    or      e
    jp      NZ,dsdi_chain_save      ;start cluster is not 0
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT32                ;fs_type
    jp      NZ,dsdi_root16          ;FAT16 static root
    call    fat_ldhl
    defw    _cpm_fat_vol+12
    ex      de,hl
    call    fat_ldhl
    defw    _cpm_fat_vol+14
    ld      bc,hl
    jp      dsdi_chain_save
dsdi_root16:
    ex      de,hl                   ;DE = ofs; HL = 0
    call    fat_sthl
    defw    dir_sclust
    call    fat_sthl
    defw    dir_sclust+2
    call    fat_sthl
    defw    dir_clust          ;static FAT16 root
    call    fat_sthl
    defw    dir_clust+2
    push    de                      ;ofs
    call    fat_root16_max          ;C: every 16-bit ofs is inside
    jp      C,dsdi_root16_in        ;2048 entries: any 16-bit ofs
    ld      bc,hl                   ;max
    pop     hl                      ;ofs
    ld      de,hl
    call    fat_subhlbc                   ;ofs - root byte end
    jp      NC,dsdi_end             ;unsigned ofs >= max
    ex      de,hl                   ;HL = ofs
    jp      dsdi_root
dsdi_root16_in:
    pop     hl
dsdi_root:
    ld      a,h                     ;offset >> 9
    or      a                       ;clear C; ofs >> 9 via rra
    rra
    ld      e,a
    ld      d,0
    call    fat_ldhl
    defw    _cpm_fat_vol+12    ;dirbase LBA
    add     hl,de                   ;dirbase + sector in the root
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
    ex      de,hl
    call    fat_move_window         ;C from the root-sector read
    ret
dsdi_chain_save:
    ld      hl,bc
    call    fat_sthl
    defw    dir_sclust+2
    ex      de,hl
    call    fat_sthl
    defw    dir_sclust
    ld      de,dir_sclust
    ld      hl,(de)                 ;copy sclust; Z80 twin uses ldir
    call    fat_sthl
    defw    fat_work
    inc     de
    inc     de
    ld      hl,(de)
    call    fat_sthl
    defw    fat_work+2         ;sclust; fptr follows
    call    fat_ldhl
    defw    dir_ofs
    call    fat_sthl
    defw    fat_work+4
    ld      hl,0
    call    fat_sthl
    defw    fat_work+6         ;fptr 32-bit
    ld      hl,fat_work
    call    clst_from_off           ;NC: ofs is past the chain
    ret     NC                      ;offset not in this directory
    ld      hl,de
    call    fat_sthl
    defw    dir_clust          ;cluster containing ofs
    ld      hl,bc
    call    fat_sthl
    defw    dir_clust+2
    call    clst2sect               ;NC: cluster has no LBA
    ret     NC                      ;no sector for this cluster
    ; add sector-in-cluster: (dir_ofs >> 9) % csize
    ld      a,(dir_ofs+1)
    or      a                       ;clear C; rra is ofs >> 9
    rra                             ;offset/512 low
    ld      hl,_cpm_fat_vol+1
    ld      l,(hl)                  ;csize
    dec     l
    and     l                       ;mod csize if csize 2^n
    ld      l,a
    ld      h,0
    add     hl,de                   ;HL = LBA + sector-in-cluster
    jp      NC,dsdi_sec             ;LBA low did not wrap
    inc     bc
dsdi_sec:
    call    fat_sthl
    defw    dir_sect
    ex      de,hl                   ;DE = LBA low for ide
    ld      hl,bc
    call    fat_sthl
    defw    dir_sect+2
    call    fat_move_window         ;C: directory sector in fatwin
    ret     NC                      ;directory sector unread
    ld      a,(dir_ofs)
    ld      e,a
    ld      a,(dir_ofs+1)
    and     1
    ld      d,a
    ld      hl,fatwin
    add     hl,de
    call    fat_sthl
    defw    dir_ptr
    scf                             ;C: dir_ptr aims at ofs
    ret
dsdi_end:
    or      a                       ;NC: ofs past the FAT16 root
    ret

; ff.c dir_next with stretch=0. No create_chain + dir_clear when a
; clustered directory hits EOC — the table is fixed size.
; Same-sector: pointer walk (SZDIRE). Sector change: sect++.
; Cluster change: get_fat(dir_clust) then clst2sect (no stretch).
dir_next:
    call    fat_ldhl
    defw    dir_ofs
    ld      bc,32
    add     hl,bc                   ;ofs + 32
    jp      C,dir_next_end          ;ofs wrap: 2048 dirents (LFN-heavy dirs)
    ld      a,l
    or      a
    jp      NZ,dir_next_same        ;ofs % 512 != 0
    ld      a,h
    and     1
    jp      Z,dir_next_sect         ;crossed a 512-byte boundary
dir_next_same:
    call    fat_sthl
    defw    dir_ofs
    call    fat_ldhl
    defw    dir_ptr
    ld      de,hl+32
    ex      de,hl
    call    fat_sthl
    defw    dir_ptr
    scf                             ;C: next dirent is in this sector
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
    jp      NZ,dir_next_dyn         ;clustered directory, not the root
    call    fat_root16_max          ;C: 2048-entry root has no 16-bit end
    jp      C,dir_next_inc          ;2048 entries: ofs still inside
    ld      bc,hl                   ;max
    call    fat_ldhl
    defw    dir_ofs
    call    fat_subhlbc                   ;ofs - root byte end
    jp      NC,dir_next_end         ;unsigned ofs >= max
dir_next_inc:
    call    fat_ldhl
    defw    dir_sect
    inc     hl
    call    fat_sthl
    defw    dir_sect
    ld      a,h
    or      l
    jp      NZ,dir_next_win         ;sect low did not wrap
    call    fat_ldhl
    defw    dir_sect+2
    inc     hl
    call    fat_sthl
    defw    dir_sect+2
    jp      dir_next_win
dir_next_dyn:
    ld      a,(dir_ofs+1)
    or      a                       ;clear C; rra is ofs / 512
    rra                             ;ofs / 512
    ld      hl,_cpm_fat_vol+1
    ld      l,(hl)                  ;csize
    dec     l
    and     l                       ;(ofs/512) & (csize-1)
    jp      NZ,dir_next_inc         ;still in this cluster
    call    fat_ldhl
    defw    dir_clust+2
    ld      bc,hl
    call    fat_ldhl
    defw    dir_clust
    ex      de,hl
    call    get_fat                 ;NC: next link unreadable
    jp      NC,dir_next_end         ;FAT read failed
    ld      a,b
    cp      $0F                     ;EOC high byte
    jp      NZ,dir_next_got         ;link is a cluster number
    ld      a,c
    and     d
    and     e
    inc     a
    jp      Z,dir_next_end          ;EOC
dir_next_got:
    ld      a,e
    sub     2                       ;next cluster - 2
    ld      a,d
    sbc     a,0
    ld      a,c
    sbc     a,0
    ld      a,b
    sbc     a,0
    jp      C,dir_next_end          ;cluster < 2
    ld      hl,de
    call    fat_sthl
    defw    dir_clust
    ld      hl,bc
    call    fat_sthl
    defw    dir_clust+2
    call    clst2sect               ;NC: next cluster has no LBA
    jp      NC,dir_next_end         ;no sector for the next cluster
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
    ex      de,hl
    call    fat_move_window         ;C: next directory sector in fatwin
    ret     NC                      ;directory sector unread
    ld      hl,fatwin               ;ofs % 512 == 0
    call    fat_sthl
    defw    dir_ptr
    scf                             ;C: dir_ptr at the new sector
    ret
dir_next_end:
    or      a                       ;NC: no next dirent
    ret

; A is folded to A-Z. Other bytes stay as they are.
fat_fold:
    cp      'a'                     ;below 'a' stays put
    ret     c                       ;not a lower-case letter
    cp      'z'+1                   ;past 'z'
    ret     nc                      ;not a lower-case letter
    sub     32                      ;'a'..'z' to upper case
    ret

; ff.c dir_find (no LFN). 0x00 ends the table; 0xE5 is deleted.
; AM_VOL skips labels and long names ($0F includes that bit).
; Disk $05 compares as $E5. Both sides are folded A-Z.
; IN: HL -> 11-byte 8.3
; OUT C and L=0, H=0: found, fat_found_* and dir_ptr filled. L=1: miss.
_dir_find:
dir_find:
    call    fat_sthl
    defw    pack_sv            ;8.3; dir_sdi clobbers fat_work
    call    fat_ldhl
    defw    dir_sclust+2
    ld      bc,hl
    call    fat_ldhl
    defw    dir_sclust
    ex      de,hl
    ld      hl,0
    call    dir_sdi                 ;rewind to the first dirent
    ld      hl,1
    ret     NC                      ;directory did not open
df_loop:
    call    fat_ldhl
    defw    dir_ptr
    ld      a,(hl)
    or      a                       ;0x00 = end of directory
    jp      Z,df_miss               ;0x00 ends the directory
    cp      $E5                     ;deleted
    jp      Z,df_next               ;deleted slot
    ld      de,hl+DIR_Attr
    ld      a,(de)
    and     AM_VOL
    jp      NZ,df_next              ;volume label or LFN
    call    fat_ldhl
    defw    dir_ptr
    ex      de,hl
    call    fat_ldhl
    defw    pack_sv
    ld      a,(de)
    cp      $05                     ;KANJI: stored $05 is the character $E5
    jp      NZ,df_cmp1              ;lead byte is not stored $05
    ld      a,$E5
df_cmp1:
    call    fat_fold                ;fold the disk byte
    ld      c,a
    ld      a,(hl)
    call    fat_fold                ;fold the name byte
    cp      c                       ;folded bytes
    jp      NZ,df_next              ;first byte differs
    inc     de
    inc     hl
    ld      b,10
df_cmp:
    ld      a,(de)
    call    fat_fold                ;fold the disk byte
    ld      c,a
    ld      a,(hl)
    call    fat_fold                ;fold the name byte
    cp      c                       ;folded bytes
    jp      NZ,df_next              ;name differs
    inc     de
    inc     hl
    dec     b
    jp      NZ,df_cmp               ;ten bytes still to match
    call    fat_ldhl
    defw    dir_ptr
    ld      de,hl+DIR_ClusLO
    ld      hl,(de)                 ;ff ld_16 DIR_FstClusLO
    call    fat_sthl
    defw    fat_found_sclust
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT32                ;fs_type
    ld      hl,0
    jp      NZ,df_hi                ;FAT16 cluster is 16 bits
    call    fat_ldhl
    defw    dir_ptr
    ld      de,hl+DIR_ClusHI
    ld      hl,(de)                 ;ff ld_16 DIR_FstClusHI
df_hi:
    call    fat_sthl
    defw    fat_found_sclust+2
    call    fat_ldhl
    defw    dir_ptr
    ld      de,hl+DIR_FileSize
    ld      hl,(de)
    call    fat_sthl
    defw    fat_found_size
    inc     de
    inc     de
    ld      hl,(de)
    call    fat_sthl
    defw    fat_found_size+2
    ld      hl,0
    scf                             ;C: found
    ret
df_next:
    call    dir_next                ;C: another dirent
    jp      C,df_loop               ;keep scanning
df_miss:
    ld      hl,1
    or      a                       ;NC: name not in this directory
    ret

; ff.c dir_alloc(n=1) + dir_register SFN. Reuses 0x00 or 0xE5.
; FAT32 stretches one cluster when the chain is at end. FAT16 does not.
; IN: HL -> 11-byte 8.3
_dir_create:
dir_create:
    call    fat_sthl
    defw    pack_sv            ;8.3; dir_sdi clobbers fat_work
    call    fat_ldhl
    defw    dir_sclust+2
    ld      bc,hl
    call    fat_ldhl
    defw    dir_sclust
    ex      de,hl
    ld      hl,0
    call    dir_sdi                 ;rewind to the first dirent
    ld      hl,1
    ret     NC                      ;directory did not open
dc_loop:
    call    fat_ldhl
    defw    dir_ptr
    ld      a,(hl)
    or      a                       ;free: 0x00 or 0xE5
    jp      Z,dc_fill               ;0x00 slot
    cp      $E5                     ;deleted mark
    jp      Z,dc_fill               ;reusable slot
    call    fat_ldhl
    defw    dir_ofs
    push    hl
    call    fat_ldhl
    defw    dir_clust
    push    hl
    call    fat_ldhl
    defw    dir_clust+2
    push    hl
    call    fat_ldhl
    defw    dir_sect
    push    hl
    call    fat_ldhl
    defw    dir_sect+2
    push    hl
    call    dir_next                ;C: a later dirent
    jp      NC,dc_at_end            ;no free slot in this chain
    ld      hl,10
    add     hl,sp
    ld      sp,hl
    jp      dc_loop
dc_at_end:
    call    dir_stretch             ;C: FAT32 grew a cluster
    jp      C,dc_stretched          ;new cluster is zeroed
    ld      hl,10
    add     hl,sp
    ld      sp,hl
    ld      hl,1
    or      a                       ;NC: directory is full
    ret
dc_stretched:
    ld      hl,10
    add     hl,sp
    ld      sp,hl
    jp      dc_loop
dc_fill:
    call    fat_ldhl
    defw    dir_ptr
    ld      b,32
    xor     a
dc_z:
    ld      (hl+),a
    dec     b
    jp      NZ,dc_z                 ;32-byte slot
    call    fat_ldhl
    defw    dir_ptr
    ex      de,hl
    call    fat_ldhl
    defw    pack_sv
    ld      bc,11
    call    fat_copy                ;11-byte name; byte copy, not ldir
    call    fat_ldhl
    defw    dir_ptr
    ld      a,(hl)
    cp      $E5                     ;KANJI lead byte is stored as $05
    jp      NZ,dc_stored            ;lead byte is not $E5
    ld      (hl),$05
dc_stored:
    ld      a,1
    ld      (fat_wflag),a
    ld      hl,0
    scf                             ;C: name registered
    ret

; FAT32 only. dir_create's 10-byte cursor snapshot is at SP+2:
; sect+2, sect, clust+2, clust, ofs. Carry set: one new cluster is
; zeroed and linked, and dir_ptr aims at its first 0x00 byte.
; Offset wrap, a moved cluster or sector, and a non-EOC link do not stretch.
dir_stretch:
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT32                ;fs_type
    jp      Z,ds_32                 ;FAT32 may grow
ds_no:
    or      a                       ;NC: FAT16 does not stretch
    ret
ds_32:
    ld      de,sp+2
    ld      hl,(de)
    ld      a,(dir_sect+2)
    cp      l                       ;snapshot sect high vs now
    jp      NZ,ds_no                ;sector changed
    ld      a,(dir_sect+3)
    cp      h                       ;snapshot sect high vs now
    jp      NZ,ds_no                ;sector changed
    ld      de,sp+4
    ld      hl,(de)
    ld      a,(dir_sect)
    cp      l                       ;snapshot sect low vs now
    jp      NZ,ds_no                ;sector changed
    ld      a,(dir_sect+1)
    cp      h                       ;snapshot sect low vs now
    jp      NZ,ds_no                ;sector changed
    ld      de,sp+6
    ld      hl,(de)
    ld      a,(dir_clust+2)
    cp      l                       ;snapshot clust high vs now
    jp      NZ,ds_no                ;cluster changed
    ld      a,(dir_clust+3)
    cp      h                       ;snapshot clust high vs now
    jp      NZ,ds_no                ;cluster changed
    ld      de,sp+8
    ld      hl,(de)
    ld      a,(dir_clust)
    cp      l                       ;snapshot clust low vs now
    jp      NZ,ds_no                ;cluster changed
    ld      a,(dir_clust+1)
    cp      h                       ;snapshot clust low vs now
    jp      NZ,ds_no                ;cluster changed
    ld      de,sp+10
    ld      hl,(de)
    ld      a,(dir_ofs)
    cp      l                       ;snapshot ofs vs now
    jp      NZ,ds_moved             ;ofs moved
    ld      a,(dir_ofs+1)
    cp      h                       ;snapshot ofs vs now
    jp      Z,ds_no                 ;ofs unchanged
ds_moved:
    ld      a,(dir_ofs)
    or      a
    jp      NZ,ds_no                ;ofs not on a sector edge
    ld      a,(dir_ofs+1)
    or      a                       ;clear C; ofs >> 9 via rra
    rra
    ld      hl,_cpm_fat_vol+1
    ld      l,(hl)
    dec     l
    and     l
    jp      NZ,ds_no                ;not the first sector of the cluster
    call    fat_ldhl
    defw    dir_clust+2
    ld      bc,hl
    call    fat_ldhl
    defw    dir_clust
    ex      de,hl
    call    get_fat                 ;NC: link unreadable
    ret     NC                      ;FAT read failed
    ld      a,b
    cp      $0F                     ;EOC high byte
    jp      NZ,ds_no                ;link is not end of chain
    ld      a,c
    and     d
    and     e
    inc     a
    jp      NZ,ds_no                ;not end of chain
    call    fat_ldhl
    defw    dir_clust+2
    ld      bc,hl
    call    fat_ldhl
    defw    dir_clust
    ex      de,hl
    call    create_chain            ;allocate the next cluster
    ret     NC                      ;no free cluster
    ld      hl,de
    call    fat_sthl
    defw    dir_clust
    ld      hl,bc
    call    fat_sthl
    defw    dir_clust+2
    call    clst2sect               ;NC: new cluster has no LBA
    ret     NC                      ;no sector for the new cluster
    ld      hl,de
    call    fat_sthl
    defw    dir_sect
    ld      hl,bc
    call    fat_sthl
    defw    dir_sect+2
    call    fat_move_window         ;C: first sector of the new cluster
    ret     NC                      ;new directory sector unread
    ld      hl,fatwin
    call    fat_sthl
    defw    dir_ptr
    scf                             ;C: dir_ptr at the new 0x00
    ret

; ff.c dir_remove (no LFN): first byte := $E5. Does not free the chain.
_dir_zap:
dir_zap:
    call    fat_ldhl
    defw    dir_ptr
    ld      (hl),$E5                ;DDEM; chain free is the caller's job
    ld      a,1
    ld      (fat_wflag),a
    ld      hl,0
    scf                             ;C: dirent marked deleted
    ret

; Open a directory at its first entry.
; HL points at the little-endian start cluster. 0 is the root
; (the FAT16 root area, or the FAT32 root cluster).
; L=0 and carry set when the first sector is in the window.
; L=1 and carry clear when that cluster is not on the volume.
_fat_dir_open:
    call    fat_ld32                ;start cluster into BCDE
    ld      hl,0
    call    dir_sdi                 ;open at byte 0
    ld      hl,0
    ret     C                       ;C: first sector is in fatwin
    inc     l
    ret

; HL -> 32-byte dirent. Copy dir_ptr; first byte 0x00 is EOT (L=1).
_fat_dir_read:
    push    hl
    call    fat_ldhl
    defw    dir_ptr
    ld      a,(hl)
    or      a
    jp      Z,fat_dir_read_end      ;0x00 is end of directory
    pop     de
    ld      bc,32
    call    fat_copy                ;32-byte dirent; not ldir
    call    dir_next                ;C: a following dirent exists
    jp      C,fat_dir_read_ok       ;advance succeeded
    ld      hl,cc_zero              ;no trailing 0x00: next read is end
    call    fat_sthl
    defw    dir_ptr
fat_dir_read_ok:
    ld      hl,0
    scf                             ;C: dirent copied
    ret
fat_dir_read_end:
    pop     hl
    ld      (hl),0
    ld      hl,1
    ret

; Next cluster in a chain.
; HL points at a little-endian cluster. On success that dword
; becomes the next cluster and L is 0. An end mark is stored as
; 0x0FFFFFFF (FAT16 $FFF8-$FFFF and FAT32 >= $0FFFFFF8 both fold
; to that value). On a disk error the dword is left alone and L
; is 1. A chain that points at itself fails.
_fat_next:
    push    hl
    call    fat_ld32                ;cluster into BCDE
    push    de
    push    bc
    ex      de,hl
    call    fat_sthl
    defw    pack_sv
    pop     hl
    push    hl
    call    fat_sthl
    defw    pack_sv+2
    pop     bc
    pop     de
    call    get_fat                 ;NC: link unreadable or bad
    pop     hl
    jp      NC,fat_next_fail        ;leave the caller's dword
    ld      a,(pack_sv)
    cp      e                       ;next vs this, byte 0
    jp      NZ,fat_next_store       ;link moved
    ld      a,(pack_sv+1)
    cp      d                       ;next vs this, byte 1
    jp      NZ,fat_next_store       ;link moved
    ld      a,(pack_sv+2)
    cp      c                       ;next vs this, byte 2
    jp      NZ,fat_next_store       ;link moved
    ld      a,(pack_sv+3)
    cp      b                       ;next vs this, byte 3
    jp      Z,fat_next_fail         ;chain points at itself
fat_next_store:
    call    fat_st32                ;store the next cluster
    ld      hl,0
    ret
fat_next_fail:
    ld      hl,1
    ret

; Allocate one cluster by the next-free scan (create_chain).
; HL points at the little-endian cluster to link after. 0 starts
; a new chain. On success the new cluster number replaces that
; dword and L is 0. On failure the dword is unchanged and L is 1.
; The new cluster is marked end-of-chain, then linked from the
; previous one. This is not a search for a hole, so several calls
; can fragment the file. If the second FAT copy cannot be written
; the call still succeeds: the first FAT already holds the link.
_fat_alloc:
    push    hl
    call    fat_ld32                ;cluster to extend
    call    create_chain            ;NC: no free cluster
    pop     hl
    jp      NC,fat_alloc_fail       ;leave the caller's dword
    call    fat_st32                ;store the new cluster
    ld      hl,0
    ret
fat_alloc_fail:
    ld      hl,1
    ret

; Free a whole chain.
; HL points at the little-endian start cluster. The walk stops at
; 0 or at a link that is not a real cluster (end mark, bad mark,
; or a number past n_fatent). L=0 and carry set on success.
_fat_free:
    call    fat_ld32                ;start cluster
    call    remove_chain            ;walk until 0 or a non-cluster
    ld      hl,0
    ret     C                       ;C: chain freed
    inc     l
    ret

; First sector of a cluster.
; HL points at a little-endian cluster. On success that same
; dword is overwritten with the LBA, database + (cluster-2)*csize,
; and L is 0. On failure the dword is unchanged and L is 1.
; A cluster below 2, or at or past n_fatent, fails.
_fat_clst2sect:
    push    hl
    call    fat_ld32                ;cluster into BCDE
    call    clst2sect               ;NC: no LBA
    pop     hl
    jp      NC,fat_c2s_fail         ;leave the caller's dword
    call    fat_st32                ;store the LBA
    ld      hl,0
    ret
fat_c2s_fail:
    ld      hl,1
    ret

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

; Round *HL bytes up to whole clusters. csize is 2^n.
; Out: that count, or 0 if csize is 0, bytes is 0, or the sum wraps.
; Shift is 9+log2(csize) and at most 16, so the mask fits in 16 bits.
_fat_clusters:
    push    hl
    ld      a,(_cpm_fat_vol+1)
    or      a
    jp      Z,fc_z1                 ;csize is 0
    ld      b,9
fc_log:
    rrca                            ;walk the one bit of csize
    jp      C,fc_have               ;that bit is the shift count
    inc     b
    jp      fc_log
fc_have:
    ld      c,b                     ;C = shift
    ld      hl,0
fc_mask:
    add     hl,hl                   ;mask = (mask<<1) + 1
    inc     hl                      ;(1<<shift)-1
    dec     b
    jp      NZ,fc_mask              ;mask bits left
    push    hl                      ;mask
    push    bc                      ;shift in C
    ld      hl,4
    add     hl,sp                   ;saved pointer
    ld      a,(hl+)
    ld      h,(hl)
    ld      l,a
    call    fat_ld32                ;BCDE = bytes
    ld      a,b
    or      c
    or      d
    or      e
    jp      Z,fc_z3                 ;file size is 0
    ld      hl,2
    add     hl,sp                   ;mask
    ld      a,e
    add     a,(hl+)                 ;bytes + (cluster-1) mask
    ld      e,a
    ld      a,d
    adc     a,(hl)
    ld      d,a
    ld      a,c
    adc     a,0
    ld      c,a
    ld      a,b
    adc     a,0
    ld      b,a
    jp      C,fc_z3                 ;round-up wrapped
fc_shr:
    or      a                       ;clear C; count >>= 1 via rra
    ld      a,b
    rra
    ld      b,a
    ld      a,c
    rra
    ld      c,a
    ld      a,d
    rra
    ld      d,a
    ld      a,e
    rra
    ld      e,a
    ld      hl,0
    add     hl,sp
    dec     (hl)                    ;shift--
    jp      NZ,fc_shr               ;shifts left
    pop     hl
    pop     hl
    pop     hl
    jp      fat_st32
fc_z3:
    ld      bc,0
    ld      de,0
    pop     hl
    pop     hl
    pop     hl
    jp      fat_st32
fc_z1:
    ld      bc,0
    ld      de,0
    pop     hl
    jp      fat_st32


; HL = HL - BC. No borrow in. C is the borrow. Z is set when the
; result is 0. A, BC, and DE stay.
fat_subhlbc:
    push    de
    ld      d,a
    ld      a,l
    sub     c
    ld      l,a
    ld      a,h
    sbc     a,b
    ld      h,a
    jp      C,fat_subhlbc_c
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

; DE rotated left through C. A and Z stay. C is the bit shifted out.
fat_rlde:
    push    af
    ld      a,e
    rla
    ld      e,a
    ld      a,d
    rla
    ld      d,a
    jp      C,fat_rlde_c
    pop     af
    jp      NC,fat_rlde_ret
    ccf
fat_rlde_ret:
    ret

fat_rlde_c:
    pop     af
    scf
    ret

; Absolute ld hl,(nn) is a 10-byte synthetic here. call + defw is 5
; bytes and keeps AF, BC, and DE. The +test image has to stay in 64K.
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

; Absolute ld (nn),hl. Same size reason. HL stays the stored word.
PUBLIC  fat_sthl
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
