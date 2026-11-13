;
; dir_create: register an 8.3 name. FAT32 may stretch the chain.
; A pointer argument is __z88dk_fastcall (HL).
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

PUBLIC  dir_create
PUBLIC  _dir_create

EXTERN  _cpm_fat_vol
EXTERN  clst2sect
EXTERN  create_chain
EXTERN  dir_clust
EXTERN  dir_next
EXTERN  dir_ofs
EXTERN  dir_ptr
EXTERN  dir_sclust
EXTERN  dir_sdi
EXTERN  dir_sect
EXTERN  fat_move_window
EXTERN  fat_wflag
EXTERN  fatwin
EXTERN  get_fat
EXTERN  pack_sv

; ff.c dir_alloc(n=1) + dir_register SFN. Reuses 0x00 or 0xE5.
; FAT32 stretches one cluster when the chain is at end. FAT16 does not.
; IN: HL -> 11-byte 8.3
_dir_create:
dir_create:
    ld      (pack_sv),hl            ;8.3; dir_sdi clobbers fat_work
    ld      de,(dir_sclust)
    ld      bc,(dir_sclust+2)
    ld      hl,0
    call    dir_sdi                 ;rewind to the first dirent
    ld      hl,1
    ret     NC                      ;directory did not open
dc_loop:
    ld      hl,(dir_ptr)
    ld      a,(hl)
    or      a                       ;free: 0x00 or 0xE5
    jr      Z,dc_fill               ;0x00 is a free slot
    cp      $E5                     ;vs deleted mark
    jr      Z,dc_fill               ;$E5 is a free slot
    ld      hl,(dir_ofs)
    push    hl
    ld      hl,(dir_clust)
    push    hl
    ld      hl,(dir_clust+2)
    push    hl
    ld      hl,(dir_sect)
    push    hl
    ld      hl,(dir_sect+2)
    push    hl
    call    dir_next                ;next dirent
    jr      C,dc_resume
    jr      Z,dc_at_end             ;clean end: stretch or fail
    jr      dc_full                 ;disk error: do not stretch
dc_resume:
    ld      hl,10
    add     hl,sp
    ld      sp,hl
    jr      dc_loop
dc_at_end:
    call    dir_stretch             ;grow a FAT32 directory
    jr      C,dc_stretched          ;new cluster is ready
dc_full:
    ld      hl,10
    add     hl,sp
    ld      sp,hl
    ld      hl,1
    or      a
    ret
dc_stretched:
    ld      hl,10
    add     hl,sp
    ld      sp,hl
    jr      dc_loop
dc_fill:
    ld      hl,(dir_ptr)
    ld      b,32
    xor     a
dc_z:
    ld      (hl+),a
    djnz    dc_z                    ;rest of the 32-byte dirent
    ld      de,(dir_ptr)
    ld      hl,(pack_sv)
    ld      bc,11
    ldir
    ld      hl,(dir_ptr)
    ld      a,(hl)
    cp      $E5                     ;KANJI lead byte is stored as $05
    jr      NZ,dc_stored            ;lead byte is not $E5
    ld      (hl),$05
dc_stored:
    ld      a,1
    ld      (fat_wflag),a
    ld      hl,0
    scf
    ret

; FAT32 only. dir_create's 10-byte cursor snapshot is at SP+2:
; sect+2, sect, clust+2, clust, ofs. Carry set: one new cluster is
; zeroed and linked, and dir_ptr aims at its first 0x00 byte.
; Offset wrap, a moved cluster or sector, and a non-EOC link do not stretch.
dir_stretch:
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT32                ;fs_type vs FAT32
    jr      Z,ds_32                 ;FAT32 may grow the chain
ds_no:
    or      a
    ret
ds_32:
    ld      hl,2
    add     hl,sp
    ld      a,(dir_sect+2)
    cp      (hl)                    ;saved sect +2
    jr      NZ,ds_no                ;sector changed
    inc     hl
    ld      a,(dir_sect+3)
    cp      (hl)                    ;saved sect +3
    jr      NZ,ds_no                ;sector changed
    inc     hl
    ld      a,(dir_sect)
    cp      (hl)                    ;saved sect +0
    jr      NZ,ds_no                ;sector changed
    inc     hl
    ld      a,(dir_sect+1)
    cp      (hl)                    ;saved sect +1
    jr      NZ,ds_no                ;sector changed
    inc     hl
    ld      a,(dir_clust+2)
    cp      (hl)                    ;saved clust +2
    jr      NZ,ds_no                ;cluster changed
    inc     hl
    ld      a,(dir_clust+3)
    cp      (hl)                    ;saved clust +3
    jr      NZ,ds_no                ;cluster changed
    inc     hl
    ld      a,(dir_clust)
    cp      (hl)                    ;saved clust +0
    jr      NZ,ds_no                ;cluster changed
    inc     hl
    ld      a,(dir_clust+1)
    cp      (hl)                    ;saved clust +1
    jr      NZ,ds_no                ;cluster changed
    inc     hl
    ld      a,(dir_ofs)
    cp      (hl)                    ;saved ofs +0
    jr      NZ,ds_moved             ;offset changed
    inc     hl
    ld      a,(dir_ofs+1)
    cp      (hl)                    ;saved ofs +1
    jr      Z,ds_no                 ;cursor did not move
ds_moved:
    ld      a,(dir_ofs)
    or      a
    jr      NZ,ds_no                ;not on a sector boundary
    ld      a,(dir_ofs+1)
    srl     a
    ld      hl,_cpm_fat_vol+1
    ld      l,(hl)
    dec     l
    and     l
    jr      NZ,ds_no                ;not on a cluster boundary
    ld      de,(dir_clust)
    ld      bc,(dir_clust+2)
    call    get_fat                 ;link at the end of the chain
    ret     NC                      ;bad cluster or unreadable
    ld      a,b
    cp      $0F                     ;top nibble vs $0F
    jr      NZ,ds_no                ;link is not end-of-chain
    ld      a,c
    and     d
    and     e
    inc     a
    jr      NZ,ds_no                ;link is not $0FFFFFFF
    ld      de,(dir_clust)
    ld      bc,(dir_clust+2)
    call    create_chain            ;append one cluster
    ret     NC                      ;stretch did not allocate
    ld      (dir_clust),de
    ld      (dir_clust+2),bc
    call    clst2sect               ;LBA of the new cluster
    ret     NC                      ;new cluster has no LBA
    ld      (dir_sect),de
    ld      (dir_sect+2),bc
    call    fat_move_window         ;new directory sector into fatwin
    ret     NC                      ;new sector not read
    ld      hl,fatwin
    ld      (dir_ptr),hl
    scf
    ret
