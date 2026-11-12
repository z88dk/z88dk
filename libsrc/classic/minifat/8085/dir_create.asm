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
EXTERN  fat_copy
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
    ld      hl,(dir_sclust+2)
    ld      bc,hl
    ld      hl,(dir_sclust)
    ex      de,hl
    ld      hl,0
    call    dir_sdi                 ;rewind to the first dirent
    ld      hl,1
    ret     NC                      ;directory did not open
dc_loop:
    ld      hl,(dir_ptr)
    ld      a,(hl)
    or      a                       ;free: 0x00 or 0xE5
    jr      Z,dc_fill               ;0x00 slot
    cp      $E5                     ;deleted mark
    jr      Z,dc_fill               ;reusable slot
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
    call    dir_next                ;C: a later dirent
    jr      NC,dc_at_end            ;no free slot in this chain
    ld      hl,10
    add     hl,sp
    ld      sp,hl
    jr      dc_loop
dc_at_end:
    call    dir_stretch             ;C: FAT32 grew a cluster
    jr      C,dc_stretched          ;new cluster is zeroed
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
    jr      dc_loop
dc_fill:
    ld      hl,(dir_ptr)
    ld      b,32
    xor     a
dc_z:
    ld      (hl+),a
    dec     b
    jp      NZ,dc_z                 ;32-byte slot
    ld      hl,(dir_ptr)
    ex      de,hl
    ld      hl,(pack_sv)
    ld      bc,11
    call    fat_copy                ;11-byte name; byte copy, not ldir
    ld      hl,(dir_ptr)
    ld      a,(hl)
    cp      $E5                     ;KANJI lead byte is stored as $05
    jr      NZ,dc_stored            ;lead byte is not $E5
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
    jr      Z,ds_32                 ;FAT32 may grow
ds_no:
    or      a                       ;NC: FAT16 does not stretch
    ret
ds_32:
    ld      de,sp+2
    ld      hl,(de)
    ld      a,(dir_sect+2)
    cp      l                       ;snapshot sect high vs now
    jr      NZ,ds_no                ;sector changed
    ld      a,(dir_sect+3)
    cp      h                       ;snapshot sect high vs now
    jr      NZ,ds_no                ;sector changed
    ld      de,sp+4
    ld      hl,(de)
    ld      a,(dir_sect)
    cp      l                       ;snapshot sect low vs now
    jr      NZ,ds_no                ;sector changed
    ld      a,(dir_sect+1)
    cp      h                       ;snapshot sect low vs now
    jr      NZ,ds_no                ;sector changed
    ld      de,sp+6
    ld      hl,(de)
    ld      a,(dir_clust+2)
    cp      l                       ;snapshot clust high vs now
    jr      NZ,ds_no                ;cluster changed
    ld      a,(dir_clust+3)
    cp      h                       ;snapshot clust high vs now
    jr      NZ,ds_no                ;cluster changed
    ld      de,sp+8
    ld      hl,(de)
    ld      a,(dir_clust)
    cp      l                       ;snapshot clust low vs now
    jr      NZ,ds_no                ;cluster changed
    ld      a,(dir_clust+1)
    cp      h                       ;snapshot clust low vs now
    jr      NZ,ds_no                ;cluster changed
    ld      de,sp+10
    ld      hl,(de)
    ld      a,(dir_ofs)
    cp      l                       ;snapshot ofs vs now
    jr      NZ,ds_moved             ;ofs moved
    ld      a,(dir_ofs+1)
    cp      h                       ;snapshot ofs vs now
    jr      Z,ds_no                 ;ofs unchanged
ds_moved:
    ld      a,(dir_ofs)
    or      a
    jr      NZ,ds_no                ;ofs not on a sector edge
    ld      a,(dir_ofs+1)
    or      a                       ;clear C; ofs >> 9 via rra
    rra
    ld      hl,_cpm_fat_vol+1
    ld      l,(hl)
    dec     l
    and     l
    jr      NZ,ds_no                ;not the first sector of the cluster
    ld      hl,(dir_clust+2)
    ld      bc,hl
    ld      hl,(dir_clust)
    ex      de,hl
    call    get_fat                 ;NC: link unreadable
    ret     NC                      ;FAT read failed
    ld      a,b
    cp      $0F                     ;EOC high byte
    jr      NZ,ds_no                ;link is not end of chain
    ld      a,c
    and     d
    and     e
    inc     a
    jr      NZ,ds_no                ;not end of chain
    ld      hl,(dir_clust+2)
    ld      bc,hl
    ld      hl,(dir_clust)
    ex      de,hl
    call    create_chain            ;allocate the next cluster
    ret     NC                      ;no free cluster
    ld      hl,de
    ld      (dir_clust),hl
    ld      hl,bc
    ld      (dir_clust+2),hl
    call    clst2sect               ;NC: new cluster has no LBA
    ret     NC                      ;no sector for the new cluster
    ld      hl,de
    ld      (dir_sect),hl
    ld      hl,bc
    ld      (dir_sect+2),hl
    call    fat_move_window         ;C: first sector of the new cluster
    ret     NC                      ;new directory sector unread
    ld      hl,fatwin
    ld      (dir_ptr),hl
    scf                             ;C: dir_ptr at the new 0x00
    ret
