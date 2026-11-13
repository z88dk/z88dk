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
; Mini-FAT12/16/32 (8080).
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
; clst2sect, sync_window, get_fat, put_fat, create_chain, remove_chain,
; dir_sdi, dir_next. mount, dir_find, dir_create, dir_zap, and the
; C dword calls are the next files in this directory. fat_sync stays
; here because move_window and create_chain call fat_sync_window.
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
PUBLIC  fat_move_window             ;flush dirty, read LBA into fatwin
PUBLIC  get_fat                     ;next cluster from FAT entry
PUBLIC  put_fat                     ;store next cluster in FAT
PUBLIC  clst_from_off               ;cluster containing file offset
PUBLIC  create_chain                ;allocate and link a new cluster
PUBLIC  remove_chain                ;free a cluster chain
PUBLIC  dir_sdi                     ;seek directory to byte offset
PUBLIC  dir_next                    ;next 32-byte dirent (no stretch)

PUBLIC  cc_zero
PUBLIC  fat_clst_ok
PUBLIC  fat_copy
PUBLIC  fat_ld32
PUBLIC  fat_rlde
PUBLIC  fat_st32
PUBLIC  fat_subhlbc


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

; ff.c ld_32 / st_32 as *(DWORD *). Byte stream through HL. Last byte
; has no post-increment: HL at offset +3. Streamed callers inc hl to
; the next dword. BCDE is E LSB.
fat_ld32:
    ld      e,(hl+)
    ld      d,(hl+)
    ld      c,(hl+)
    ld      b,(hl)
    ret

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
    jr      C,clst2sect_ov          ;cluster < 2
    ld      hl,de                   ;DEHL = clst-2
    ld      de,bc
    ld      a,(_cpm_fat_vol+1)      ;csize is 2^n
clst2sect_mul:
    or      a                       ;csize >> 1; rra leaves Z stale
    rra
    or      a                       ;rra does not set Z
    jr      Z,clst2sect_base        ;no csize bits left
    add     hl,hl                   ;(clst-2)<<1; high half is rl de
    call    fat_rlde
    jr      C,clst2sect_ov          ;csize*(clst-2) wrapped
    jr      clst2sect_mul
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
    jr      C,clst2sect_ov          ;database + off wrapped
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

_fat_sync:
fat_sync_window:
    ld      a,(fat_wflag)
    or      a
    jr      Z,fat_sync_ok           ;nothing dirty
    ld      hl,(fat_winsect+2)
    ld      bc,hl
    ld      hl,(fat_winsect)
    ex      de,hl
    ld      hl,fatwin               ;high RAM FAT window
    call    ide_write_sector        ;C: OK; HL += 512
    ld      hl,1
    ret     NC                      ;leave flag dirty
    ld      a,(_cpm_fat_vol+24)     ;n_fats
    cp      2                       ;mirror only when n_fats is 2
    jr      C,fat_sync_clear        ;n_fats < 2
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
    jr      C,fat_sync_clear        ;winsect < fatbase
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
    jr      NC,fat_sync_clear       ;not in FAT #1
    ld      hl,(fat_winsect+2)
    ld      bc,hl                   ;park winsect high
    ld      hl,(fat_winsect)
    ld      de,(_cpm_fat_vol+20)
    add     hl,de                   ;winsect.lo + fatsz.lo
    ex      de,hl                   ;DE = winsect.lo + fatsz.lo
    ld      hl,(_cpm_fat_vol+22)
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
    ld      hl,(fat_fsi_lba)
    ld      a,h
    or      l
    ld      hl,(fat_fsi_lba+2)
    or      h
    or      l
    ret     Z                       ;no FSInfo LBA
    xor     a
    ld      (fat_fsi_dirty),a
    ld      hl,(fat_fsi_lba+2)
    ld      bc,hl
    ld      hl,(fat_fsi_lba)
    ex      de,hl
    call    fat_move_window         ;C: FSInfo sector in fatwin
    jr      NC,fat_fsi_again        ;read failed; mark dirty again
    ld      a,(_cpm_fat_vol+25)
    or      a
    jr      Z,fat_fsi_unk           ;free_valid clear
    ld      hl,(_cpm_fat_vol+28)
    ex      de,hl
    ld      hl,(_cpm_fat_vol+30)
    ld      bc,hl
    jr      fat_fsi_free
fat_fsi_unk:
    ld      de,$FFFF
    ld      bc,$FFFF
fat_fsi_free:
    ld      hl,fatwin+488
    call    fat_st32                ;FSI_Free_Count
    ld      hl,(fat_last_clst)
    ex      de,hl
    ld      hl,(fat_last_clst+2)
    ld      bc,hl
    ld      a,b
    or      c
    or      d
    jr      NZ,fat_fsi_nxt          ;hint is above 65535
    ld      a,e
    cp      2                       ;hint below 2 is unknown
    jr      NC,fat_fsi_nxt          ;hint >= 2
    ld      de,$FFFF
    ld      bc,$FFFF
fat_fsi_nxt:
    ld      hl,fatwin+492
    call    fat_st32                ;FSI_Nxt_Free
    ld      hl,(fat_fsi_lba+2)
    ld      bc,hl
    ld      hl,(fat_fsi_lba)
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
    ld      hl,(fat_winsect)
    ld      a,l
    cp      e                       ;winsect vs LBA, byte 0
    jr      NZ,fat_move_do          ;different sector
    ld      a,h
    cp      d                       ;winsect vs LBA, byte 1
    jr      NZ,fat_move_do          ;different sector
    ld      hl,(fat_winsect+2)
    ld      a,l
    cp      c                       ;winsect vs LBA, byte 2
    jr      NZ,fat_move_do          ;different sector
    ld      a,h
    cp      b                       ;winsect vs LBA, byte 3
    jr      NZ,fat_move_do          ;different sector
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
    ld      (fat_winsect),hl
    ld      hl,bc
    ld      (fat_winsect+2),hl
    xor     a
    ld      (fat_wflag),a
    scf                             ;C: fatwin holds this LBA
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
    jr      Z,fat_fatent32          ;FAT32 slot is 4 bytes
    ; FAT16: pff/ff WORD array. sect = fatbase + clst/256; off = (BYTE)clst*2
    ld      l,e
    ld      h,0
    add     hl,hl                   ;off = (BYTE)clst * 2  (< 512)
    push    hl
    ld      e,d
    ld      d,c
    ld      c,b
    ld      b,0                     ;BCDE = clst >> 8
    jr      fat_fatent_sec
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
    jr      C,fat12_range_lo
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
    jr      NC,fat12_load_fail
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
    jr      NZ,fat12_same           ;not byte 255 or 511
    ld      a,h
    or      a
    jr      Z,fat12_off255          ;offset 255, still this sector
    ld      de,fatwin
    add     hl,de
    ld      c,(hl)                  ;first byte at offset 511
    push    bc
    ld      hl,(fat_winsect)
    inc     hl
    ld      a,h
    or      l
    jr      NZ,fat12_span_lba
    ld      hl,(fat_winsect+2)
    inc     hl
    ld      b,h
    ld      c,l
    ld      hl,0
    jr      fat12_span_go
fat12_span_lba:
    ld      de,hl
    ld      hl,(fat_winsect+2)
    ld      b,h
    ld      c,l
    ex      de,hl
fat12_span_go:
    ld      de,hl
    call    fat_move_window
    jr      NC,fat12_span_err
    ld      a,(fatwin)              ;second byte at offset 0
    pop     bc
    ld      e,c
    ld      d,a
    jr      fat12_par
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
    jr      Z,fat12_even
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
    jr      NZ,get_fat12_ok
    ld      a,e
    cp      $F7                     ;FAT12 bad cluster $FF7
    jp      Z,get_fat_bad
    cp      $F8                     ;FAT12 EOC $FF8..$FFF
    jr      C,get_fat12_ok
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
    jr      Z,fat12_st_even
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
    call    fat12_shr1
    add     hl,de                   ;byte offset. FAT12 cluster fits in DE
    ld      a,l
    cp      255
    jr      NZ,fat12_st_same
    ld      a,h
    and     1
    jr      NZ,fat12_st_span        ;offset ends on byte 511 of its sector
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
    jr      fat12_st_dirty
fat12_st_span:
    ld      hl,(fat_winsect)
    ld      a,h
    or      l
    jr      Z,fat12_st_backhi
    dec     hl
    ex      de,hl
    ld      hl,(fat_winsect+2)
    ld      bc,hl
    jr      fat12_st_back
fat12_st_backhi:
    ld      de,$FFFF
    ld      hl,(fat_winsect+2)
    dec     hl
    ld      bc,hl
fat12_st_back:
    call    fat_move_window         ;first sector, still clean
    jr      NC,fat12_st_pop
    pop     hl
    push    hl
    ld      a,l
    ld      (fatwin+511),a
    ld      a,1
    ld      (fat_wflag),a           ;flush this byte before the window moves
    ld      hl,(fat_winsect)
    inc     hl
    ld      a,h
    or      l
    jr      Z,fat12_st_fwdhi
    ex      de,hl
    ld      hl,(fat_winsect+2)
    ld      bc,hl
    jr      fat12_st_fwd
fat12_st_fwdhi:
    ld      de,0
    ld      hl,(fat_winsect+2)
    inc     hl
    ld      bc,hl
fat12_st_fwd:
    call    fat_move_window         ;writes the first sector, then the second
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
    call    get_fat                 ;old link; NC is bad or unread
    ld      a,0
    jr      NC,put_fat12_old        ;treat a bad entry as in use
    ld      a,b
    or      c
    or      d
    or      e
    ld      a,0
    jr      NZ,put_fat12_old
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
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT32                ;fs_type
    jr      Z,get_fat32             ;FAT32 dword
    ld      e,(hl+)
    ld      d,(hl)                  ;ff ld_16
    ld      a,d
    cp      $FF                     ;high byte of the FAT16 link
    jr      NZ,get_fat16ok          ;not an $FFxx link
    ld      a,e
    cp      $F7                     ;FAT16 bad cluster
    jr      Z,get_fat_bad           ;$FFF7 is bad, not a link
    cp      $F8                     ;FAT16 EOC $FFF8..$FFFF
    jr      C,get_fat16ok           ;link below $FFF8
    ld      de,$FFFF
    ld      bc,$0FFF                ;fold to EOC32 for callers
    scf                             ;C: FAT16 end of chain
    ret
get_fat16ok:
    ld      bc,0
    scf                             ;C: link in DE, high half 0
    ret
get_fat32:
    ld      e,(hl+)                 ;low
    ld      d,(hl+)
    ld      c,(hl+)
    ld      a,(hl)
    and     $0F                     ;ff ld_32 & 0x0FFFFFFF
    ld      b,a
    cp      $0F                     ;masked high byte
    jr      NZ,get_fat32ok          ;not an EOC pattern
    ld      a,c
    inc     a
    jr      NZ,get_fat32ok          ;high mid-byte not $FF
    ld      a,d
    inc     a
    jr      NZ,get_fat32ok          ;low mid-byte not $FF
    ld      a,e
    cp      $F7                     ;FAT32 bad cluster $0FFFFFF7
    jr      Z,get_fat_bad           ;$0FFFFFF7 is bad, not a link
    cp      $F8                     ;low byte vs EOC
    jr      C,get_fat32ok           ;link below $0FFFFFF8
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
    jr      Z,put_fat_cold          ;free count is not live
    push    de
    push    hl
    call    fat_win_is_free         ;Z: old FAT entry is free
    ld      a,0
    jr      NZ,put_fat_old          ;old entry is in use
    inc     a
put_fat_old:
    pop     hl
    pop     de
    jr      put_fat_adj
put_fat_cold:
    xor     a
put_fat_adj:
    push    af                      ;A = 1 if old entry was free
    push    de                      ;src for new-free test
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT32                ;fs_type
    jr      Z,put_fat32             ;keep the FAT32 high nibble
    ld      a,(de+)                 ;ff st_16
    ld      (hl+),a
    ld      a,(de)
    ld      (hl),a
put_fat_wrote:
    pop     de
    pop     af
    ld      c,a                     ;old free
    ld      a,(_cpm_fat_vol+25)
    or      a
    jr      Z,put_fat_dirty         ;free count is not live
    push    bc
    call    fat_src_is_free         ;Z: new link is free
    pop     bc
    ld      a,c
    jr      Z,put_fat_new0          ;new value is a free entry
    or      a
    jr      Z,put_fat_dirty         ;used -> used
    call    fat_nfree_dec           ;free -> used
    jr      put_fat_dirty
put_fat_new0:
    or      a
    jr      NZ,put_fat_dirty        ;free -> free
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
    jr      put_fat_wrote

; Z if FAT entry at HL is free (ff ld_16==0 / ld_32&0x0FFFFFFF==0).
; Preserves HL. put_fat cache and f_getfree window scan.
fat_win_is_free:
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT32                ;fs_type
    jr      Z,fat_win_free32        ;FAT32 free is a 28-bit zero
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
    ld      hl,(_cpm_fat_vol+28)
    inc     hl
    ld      (_cpm_fat_vol+28),hl
    ld      a,h
    or      l
    jr      Z,fat_nfree_inc_hi      ;free_clst low half wrapped
    jp      fat_fsi_mark
fat_nfree_inc_hi:
    ld      hl,(_cpm_fat_vol+30)
    inc     hl
    ld      (_cpm_fat_vol+30),hl
    jp      fat_fsi_mark

fat_nfree_dec:
    ld      hl,(_cpm_fat_vol+28)
    ld      a,h
    or      l
    push    hl
    ld      hl,(_cpm_fat_vol+30)
    or      h
    or      l
    pop     hl
    ret     Z                       ;free count is already 0
    ld      a,h
    or      l
    jr      NZ,fat_nfree_dec_lo     ;low half still nonzero
    ld      hl,(_cpm_fat_vol+30)
    dec     hl
    ld      (_cpm_fat_vol+30),hl
    ld      hl,(_cpm_fat_vol+28)
fat_nfree_dec_lo:
    dec     hl
    ld      (_cpm_fat_vol+28),hl
    jp      fat_fsi_mark

; IN: HL -> {sclust:4, fptr:4} LE
; OUT C: BCDE = cluster containing fptr
; Cluster index is (fptr >> 9) / csize. Sequential CP/M I/O hits
; clst_cache_* so we do not re-walk from sclust.
clst_from_off:
    call    fat_ld32                ;sclust into BCDE
    push    hl
    ex      de,hl
    ld      (fat_work),hl           ;sclust
    ld      hl,bc
    ld      (fat_work+2),hl
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
    jr      Z,cfo_div               ;log2(csize) is in B
    inc     b
    jr      cfo_log
cfo_div:
    ld      a,b
    or      a
    jr      Z,cfo_ci                ;cluster index needs no shift
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
    ld      a,c
    or      a
    jp      NZ,cfo_bad              ;cluster index does not fit in 16 bits
    ld      a,(_cpm_fat_vol+6)
    ld      hl,_cpm_fat_vol+7
    or      (hl)
    jr      NZ,cfo_ci_ok            ;n_fatent above 65535
    ld      hl,(_cpm_fat_vol+4)
    ld      bc,de
    call    fat_subhlbc             ;n_fatent - index
    jp      C,cfo_bad               ;index is past the FAT
    jp      Z,cfo_bad
cfo_ci_ok:
    ex      de,hl
    ld      (fat_work+4),hl         ;want_ci — kept for the cache store
    ld      hl,clst_cache_sclust
    ld      a,(fat_work)
    cp      (hl)                    ;cached sclust byte 0
    jr      NZ,cfo_from0            ;cache is another chain
    inc     hl
    ld      a,(fat_work+1)
    cp      (hl)                    ;cached sclust byte 1
    jr      NZ,cfo_from0            ;cache is another chain
    inc     hl
    ld      a,(fat_work+2)
    cp      (hl)                    ;cached sclust byte 2
    jr      NZ,cfo_from0            ;cache is another chain
    inc     hl
    ld      a,(fat_work+3)
    cp      (hl)                    ;cached sclust byte 3
    jr      NZ,cfo_from0            ;cache is another chain
    ld      hl,(fat_work+4)
    ld      bc,hl
    ld      hl,(clst_cache_ci)
    call    fat_subhlbc                   ;cache_ci - want_ci
    jr      Z,cfo_cached            ;cached index is this offset
    jr      NC,cfo_from0            ;want is behind the cache
    ld      hl,(clst_cache_ci)
    ld      bc,hl
    ld      hl,(fat_work+4)
    call    fat_subhlbc                   ;steps still to walk
    ld      (fat_work+8),hl         ;steps from cached cluster
    ld      hl,(clst_cache_clst+2)
    ld      bc,hl
    ld      hl,(clst_cache_clst)
    ex      de,hl
    jr      cfo_loop
cfo_from0:
    ld      hl,(fat_work+4)
    ld      (fat_work+8),hl         ;steps from sclust
    ld      hl,(fat_work+2)
    ld      bc,hl
    ld      hl,(fat_work)
    ex      de,hl
cfo_loop:
    ld      a,(fat_work+8)
    ld      hl,fat_work+9
    or      (hl)
    jr      Z,cfo_have              ;walk finished
    call    get_fat                 ;NC: chain broke
    ret     NC                      ;FAT read failed
    ld      a,b
    cp      $0F                     ;EOC high byte
    jr      NZ,cfo_store            ;link is not end of chain
    ld      a,c
    and     d
    and     e
    inc     a
    jr      Z,cfo_bad               ;EOC before the file offset
cfo_store:
    ld      hl,(fat_work+8)
    dec     hl
    ld      (fat_work+8),hl
    jr      cfo_loop
cfo_cached:
    ld      hl,(clst_cache_clst+2)
    ld      bc,hl
    ld      hl,(clst_cache_clst)
    ex      de,hl
cfo_have:
    ex      de,hl
    ld      (clst_cache_clst),hl
    ex      de,hl                   ;DE = cluster low (clst2sect wants BCDE)
    ld      hl,bc
    ld      (clst_cache_clst+2),hl
    ld      hl,(fat_work)
    ld      (clst_cache_sclust),hl
    ld      hl,(fat_work+2)
    ld      (clst_cache_sclust+2),hl
    ld      hl,(fat_work+4)
    ld      (clst_cache_ci),hl
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
    jr      NZ,fco_hi               ;high bytes set: check n_fatent
    ld      a,e
    cp      2                       ;cluster low vs 2
    jr      C,fco_bad               ;cluster < 2
fco_hi:
    ld      hl,(_cpm_fat_vol+4)
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
    jr      C,fco_bad               ;cluster >= n_fatent
    or      c
    or      h
    or      l
    jr      Z,fco_bad               ;cluster == n_fatent
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
    ld      (fat_work+10),hl
    ld      hl,de
    ld      (fat_work+8),hl
    xor     a
    ld      (fat_work+7),a          ;wrap flag
    ld      a,b
    or      c
    or      d
    or      e
    jr      Z,cc_hint               ;0 starts a new chain
    inc     de
    ld      a,d
    or      e
    jr      NZ,cc_mark              ;clst+1 did not wrap
    inc     bc
    jr      cc_mark
cc_hint:
    ld      hl,(fat_last_clst+2)
    ld      bc,hl
    ld      hl,(fat_last_clst)
    ex      de,hl
    call    fat_clst_ok             ;C: last-clst hint is not a cluster
    jr      NC,cc_mark              ;hint is a real cluster
cc_from2:
    ld      de,2
    ld      bc,0
cc_mark:
    ld      hl,de
    ld      (fat_work),hl           ;search origin
    ld      hl,bc
    ld      (fat_work+2),hl
cc_scan:
    ld      hl,bc
    ld      (fat_work+14),hl
    ld      hl,de
    ld      (fat_work+12),hl
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
    jp      C,cc_wrap               ;candidate >= n_fatent
    or      c
    or      h
    or      l
    jp      Z,cc_wrap               ;candidate >= n_fatent
    ld      hl,(fat_work+14)
    ld      bc,hl
    ld      hl,(fat_work+12)
    ex      de,hl
    ld      a,(fat_work+7)
    or      a
    jr      Z,cc_look               ;have not wrapped yet
    ld      hl,(fat_work)           ;wrapped: stop on return to origin
    ld      a,e
    cp      l                       ;candidate vs origin, byte 0
    jr      NZ,cc_look              ;not back at the origin
    ld      a,d
    cp      h                       ;candidate vs origin, byte 1
    jr      NZ,cc_look              ;not back at the origin
    ld      hl,(fat_work+2)
    ld      a,c
    cp      l                       ;candidate vs origin, byte 2
    jr      NZ,cc_look              ;not back at the origin
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
    ld      hl,(fat_work+14)
    ld      bc,hl
    ld      hl,(fat_work+12)
    ex      de,hl
    call    cc_wipe                 ;zero data before the FAT link is published
    ret     NC                      ;zero-fill failed; FAT unchanged
    ld      hl,(fat_work+14)
    ld      bc,hl
    ld      hl,(fat_work+12)
    ex      de,hl
    ld      hl,cc_eoc
    call    put_fat                 ;mark the new cluster EOC
    ret     NC                      ;EOC store failed
    ld      a,(fat_work+8)
    ld      hl,fat_work+9
    or      (hl+)
    or      (hl+)
    or      (hl)
    jr      Z,cc_ok                 ;no previous cluster to link
    push    bc
    push    de
    ld      hl,(fat_work+10)
    ld      bc,hl
    ld      hl,(fat_work+8)
    ex      de,hl
    ld      hl,fat_work+12
    call    put_fat                 ;link previous to this cluster
    pop     de
    pop     bc
    ret     NC                      ;back-link failed
cc_ok:
    ld      hl,(fat_work+14)
    ld      (fat_last_clst+2),hl
    ld      hl,(fat_work+12)
    ld      (fat_last_clst),hl
    call    fat_fsi_mark            ;next-free hint changed
    call    fat_sync_window         ;FAT#1 has the link; a failed mirror stays dirty
cc_ret_cl:
    ld      hl,(fat_work+14)        ;mirror failure still returns the cluster
    ld      bc,hl
    ld      hl,(fat_work+12)
    ex      de,hl
    scf                             ;C: new cluster, even if mirror failed
    ret
cc_next:
    ld      hl,(fat_work+14)
    ld      bc,hl
    ld      hl,(fat_work+12)
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
    jr      NZ,cc_fail              ;already wrapped once
    ld      a,1
    ld      (fat_work+7),a
    ld      a,(fat_work)            ;origin == 2 means the whole volume was seen
    cp      2                       ;origin low vs 2
    jr      NZ,cc_wrap2             ;origin is not cluster 2
    ld      a,(fat_work+1)
    or      a
    jr      NZ,cc_wrap2             ;origin byte 1
    ld      a,(fat_work+2)
    or      a
    jr      NZ,cc_wrap2             ;origin byte 2
    ld      a,(fat_work+3)
    or      a
    jr      Z,cc_fail               ;search started at 2; disk full
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
    jr      Z,cc_wipe_bad           ;csize is 0
    push    bc
    push    de
    call    clst2sect               ;C: LBA of the new cluster
    jr      C,cc_wipe_lba           ;have an LBA
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
    jr      C,cc_wipe_clr           ;window is clean
    pop     af
    pop     de
    pop     bc
    or      a                       ;NC: flush failed
    ret
cc_wipe_clr:
    ld      hl,$FFFF
    ld      (fat_winsect),hl
    ld      (fat_winsect+2),hl
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
    jr      C,cc_wipe_adv           ;advance to the next sector
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
    jr      Z,cc_wipe_ok            ;csize sectors written
    push    af
    inc     de
    ld      a,d
    or      e
    jr      NZ,cc_wipe_push         ;LBA low did not wrap
    inc     bc
cc_wipe_push:
    pop     af
    push    bc
    push    de
    push    af
    jr      cc_wipe_wr
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
    ld      (fat_work),hl           ;32-bit step
    ld      (fat_work+2),hl
rc_loop:
    ld      hl,(fat_work)
    inc     hl
    ld      (fat_work),hl
    ld      a,h
    or      l
    jr      NZ,rc_cmp               ;step low half did not wrap
    ld      hl,(fat_work+2)
    inc     hl
    ld      (fat_work+2),hl
rc_cmp:
    push    bc
    push    de
    ld      hl,(fat_work+2)
    ld      bc,hl
    ld      hl,(fat_work)
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
    jr      NC,rc_fail              ;step >= n_fatent
    ld      hl,bc
    ld      (fat_work+10),hl
    ld      hl,de
    ld      (fat_work+8),hl
    call    get_fat                 ;NC: link unreadable or bad
    ret     NC                      ;stop; earlier frees stay written
    ex      de,hl
    ld      (fat_work+12),hl        ;next
    ld      hl,bc
    ld      (fat_work+14),hl
    ld      hl,(fat_work+10)
    ld      bc,hl
    ld      hl,(fat_work+8)
    ex      de,hl
    ld      hl,cc_zero
    call    put_fat                 ;store a free entry
    ret     NC                      ;free store failed
    ld      hl,(fat_work+14)
    ld      bc,hl
    ld      hl,(fat_work+12)
    ex      de,hl
    ld      a,b
    or      c
    or      d
    or      e
    jr      Z,rc_done               ;next link is 0
    ld      hl,_cpm_fat_vol+4       ;next >= n_fatent ends the walk
    ld      a,e
    sub     (hl+)                   ;next - n_fatent
    ld      a,d
    sbc     (hl+)
    ld      a,c
    sbc     (hl+)
    ld      a,b
    sbc     a,(hl)
    jr      C,rc_loop               ;next is still a cluster
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
    ld      hl,(_cpm_fat_vol+2)
    ld      a,l
    and     $F0
    ld      l,a
    ld      a,h
    cp      8                       ;2048 entries * 32 = 65536
    jr      C,frm_mul               ;fewer than 2048 root entries
    ld      hl,0
    scf                             ;C: end is 65536 bytes
    jr      frm_clamp
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
    jr      NZ,frm_keep             ;span is not a 16-bit sector count
    ld      hl,(_cpm_fat_vol+12)
    ld      bc,hl
    ld      hl,(_cpm_fat_vol+16)
    call    fat_subhlbc                   ;database - dirbase (sectors)
    jr      C,frm_keep              ;dirbase above database
    jr      Z,frm_keep              ;database == dirbase
    ld      a,h
    or      a
    jr      NZ,frm_keep             ;>= 256 sectors
    ld      a,l
    cp      128                     ;sectors vs 128
    jr      NC,frm_keep             ;>= 128 sectors is >= 64K bytes
    ld      h,l
    ld      l,0
    add     hl,hl                   ;span << 9, fits in 16 bits
    pop     af
    pop     de                      ;DE = count end
    jr      C,frm_span              ;count was 64K: span is tighter
    ld      bc,de
    push    hl
    call    fat_subhlbc                   ;span - count
    pop     hl
    jr      C,frm_clear             ;span is shorter than the entry end
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
    ld      (dir_ofs),hl
    ld      a,b
    or      c
    or      d
    or      e
    jr      NZ,dsdi_chain_save      ;start cluster is not 0
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT32                ;fs_type
    jr      NZ,dsdi_root16          ;FAT16 static root
    ld      hl,(_cpm_fat_vol+12)
    ex      de,hl
    ld      hl,(_cpm_fat_vol+14)
    ld      bc,hl
    jp      dsdi_chain_save
dsdi_root16:
    ex      de,hl                   ;DE = ofs; HL = 0
    ld      (dir_sclust),hl
    ld      (dir_sclust+2),hl
    ld      (dir_clust),hl          ;static FAT16 root
    ld      (dir_clust+2),hl
    push    de                      ;ofs
    call    fat_root16_max          ;C: every 16-bit ofs is inside
    jr      C,dsdi_root16_in        ;2048 entries: any 16-bit ofs
    ld      bc,hl                   ;max
    pop     hl                      ;ofs
    ld      de,hl
    call    fat_subhlbc                   ;ofs - root byte end
    jp      NC,dsdi_end             ;unsigned ofs >= max
    ex      de,hl                   ;HL = ofs
    jr      dsdi_root
dsdi_root16_in:
    pop     hl
dsdi_root:
    ld      a,h                     ;offset >> 9
    or      a                       ;clear C; ofs >> 9 via rra
    rra
    ld      e,a
    ld      d,0
    ld      hl,(_cpm_fat_vol+12)    ;dirbase LBA
    add     hl,de                   ;dirbase + sector in the root
    ld      (dir_sect),hl
    ld      hl,(_cpm_fat_vol+14)
    ld      de,0
    ld      a,l
    adc     a,e
    ld      l,a
    ld      a,h
    adc     a,d
    ld      h,a
    ld      (dir_sect+2),hl
    ld      a,(dir_ofs)
    ld      e,a
    ld      a,(dir_ofs+1)
    and     1
    ld      d,a
    ld      hl,fatwin
    add     hl,de
    ld      (dir_ptr),hl
    ld      hl,(dir_sect+2)
    ld      bc,hl
    ld      hl,(dir_sect)
    ex      de,hl
    call    fat_move_window         ;C from the root-sector read
    ret
dsdi_chain_save:
    ld      hl,bc
    ld      (dir_sclust+2),hl
    ex      de,hl
    ld      (dir_sclust),hl
    ld      hl,(dir_sclust)         ;copy sclust; Z80 twin uses ldir
    ld      (fat_work),hl
    ld      hl,(dir_sclust+2)
    ld      (fat_work+2),hl         ;sclust; fptr follows
    ld      hl,(dir_ofs)
    ld      (fat_work+4),hl
    ld      hl,0
    ld      (fat_work+6),hl         ;fptr 32-bit
    ld      hl,fat_work
    call    clst_from_off           ;NC: ofs is past the chain
    ret     NC                      ;offset not in this directory
    ld      hl,de
    ld      (dir_clust),hl          ;cluster containing ofs
    ld      hl,bc
    ld      (dir_clust+2),hl
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
    jr      NC,dsdi_sec             ;LBA low did not wrap
    inc     bc
dsdi_sec:
    ld      (dir_sect),hl
    ex      de,hl                   ;DE = LBA low for ide
    ld      hl,bc
    ld      (dir_sect+2),hl
    call    fat_move_window         ;C: directory sector in fatwin
    ret     NC                      ;directory sector unread
    ld      a,(dir_ofs)
    ld      e,a
    ld      a,(dir_ofs+1)
    and     1
    ld      d,a
    ld      hl,fatwin
    add     hl,de
    ld      (dir_ptr),hl
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
    ld      hl,(dir_ofs)
    ld      bc,32
    add     hl,bc                   ;ofs + 32
    jr      C,dir_next_end          ;ofs wrap: 2048 dirents (LFN-heavy dirs)
    ld      a,l
    or      a
    jr      NZ,dir_next_same        ;ofs % 512 != 0
    ld      a,h
    and     1
    jr      Z,dir_next_sect         ;crossed a 512-byte boundary
dir_next_same:
    ld      (dir_ofs),hl
    ld      hl,(dir_ptr)
    ld      de,32
    add     hl,de
    ld      (dir_ptr),hl
    scf                             ;C: next dirent is in this sector
    ret
dir_next_sect:
    ld      (dir_ofs),hl
    ld      hl,(dir_clust)
    ld      a,h
    or      l
    ld      hl,(dir_clust+2)
    or      h
    or      l
    jr      NZ,dir_next_dyn         ;clustered directory, not the root
    call    fat_root16_max          ;C: 2048-entry root has no 16-bit end
    jr      C,dir_next_inc          ;2048 entries: ofs still inside
    ld      bc,hl                   ;max
    ld      hl,(dir_ofs)
    call    fat_subhlbc                   ;ofs - root byte end
    jp      NC,dir_next_end         ;unsigned ofs >= max
dir_next_inc:
    ld      hl,(dir_sect)
    inc     hl
    ld      (dir_sect),hl
    ld      a,h
    or      l
    jr      NZ,dir_next_win         ;sect low did not wrap
    ld      hl,(dir_sect+2)
    inc     hl
    ld      (dir_sect+2),hl
    jr      dir_next_win
dir_next_dyn:
    ld      a,(dir_ofs+1)
    or      a                       ;clear C; rra is ofs / 512
    rra                             ;ofs / 512
    ld      hl,_cpm_fat_vol+1
    ld      l,(hl)                  ;csize
    dec     l
    and     l                       ;(ofs/512) & (csize-1)
    jr      NZ,dir_next_inc         ;still in this cluster
    ld      hl,(dir_clust+2)
    ld      bc,hl
    ld      hl,(dir_clust)
    ex      de,hl
    call    get_fat                 ;NC: next link unreadable
    jp      NC,dir_next_io          ;FAT read failed
    ld      a,b
    cp      $0F                     ;EOC high byte
    jr      NZ,dir_next_got         ;link is a cluster number
    ld      a,c
    and     d
    and     e
    inc     a
    jr      Z,dir_next_end          ;EOC
dir_next_got:
    ld      a,e
    sub     2                       ;next cluster - 2
    ld      a,d
    sbc     a,0
    ld      a,c
    sbc     a,0
    ld      a,b
    sbc     a,0
    jp      C,dir_next_io           ;cluster < 2
    ld      hl,de
    ld      (dir_clust),hl
    ld      hl,bc
    ld      (dir_clust+2),hl
    call    clst2sect               ;NC: next cluster has no LBA
    jp      NC,dir_next_io          ;no sector for the next cluster
    ld      hl,de
    ld      (dir_sect),hl
    ld      hl,bc
    ld      (dir_sect+2),hl
dir_next_win:
    ld      hl,(dir_sect+2)
    ld      bc,hl
    ld      hl,(dir_sect)
    ex      de,hl
    call    fat_move_window         ;C: next directory sector in fatwin
    jp      NC,dir_next_io          ;directory sector unread
    ld      hl,fatwin               ;ofs % 512 == 0
    ld      (dir_ptr),hl
    scf                             ;C: dir_ptr at the new sector
    ret
dir_next_end:
    xor     a                       ;NC+Z: end of the directory
    ret

dir_next_io:
    ld      a,1
    or      a                       ;NC+NZ: disk or chain error
    ret


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

; DE rotated left through C. A and Z stay. C is the bit shifted out.
fat_rlde:
    push    af
    ld      a,e
    rla
    ld      e,a
    ld      a,d
    rla
    ld      d,a
    jr      C,fat_rlde_c
    pop     af
    jr      NC,fat_rlde_ret
    ccf
fat_rlde_ret:
    ret

fat_rlde_c:
    pop     af
    scf
    ret
