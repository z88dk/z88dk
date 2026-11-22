;
; dir_create registers one 8.3 name in the current directory.
; $00 ends the table and is a free slot. $E5 is a deleted slot.
; Both of those slots can be reused.
; A lead byte of $E5 is stored as $05.
; Only a FAT32 chain grows. A FAT16 root stays a fixed size.
; A FAT16 subdirectory stays a fixed size.
;
; 8085 reads a stacked argument with ld de,sp+n and ld hl,(de).
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

; Call. HL points at the 11-byte name. This is __z88dk_fastcall.
; Return. Success is L = 0 and carry set. H is 0.
; Return. Failure is L = 1 and carry clear. H is 0.
; Writes. The new directory entry and fat_wflag.
; Clobber. AF, BC, DE, HL.
_dir_create:
dir_create:
    ld      (pack_sv),hl        ;keep the 11-byte name
    ld      hl,(dir_sclust+2)
    ld      bc,hl
    ld      hl,(dir_sclust)
    ex      de,hl
    ld      hl,0
    call    dir_sdi             ;rewind to the first entry
    ld      hl,1
    ret     NC                  ;the directory did not open
dc_loop:
    ld      hl,(dir_ptr)
    ld      a,(hl)
    or      a                   ;$00 ends the table
    jr      Z,dc_fill           ;$00 is a free slot
    cp      $E5                 ;deleted entry
    jr      Z,dc_fill           ;$E5 is a deleted slot and can be reused
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
    call    dir_next            ;advance to the next entry
    jr      C,dc_resume         ;dir_next found another entry
    jr      Z,dc_at_end         ;dir_next reached a clean end
    jr      dc_full             ;a disk error does not stretch
dc_resume:
    ld      de,sp+10
    ex      de,hl
    ld      sp,hl
    jr      dc_loop
dc_at_end:
    call    dir_stretch         ;grow a FAT32 chain only
    jr      C,dc_stretched      ;the new cluster is ready
dc_full:
    ld      de,sp+10
    ex      de,hl
    ld      sp,hl
    ld      hl,1
    or      a                   ;L = 1 and carry clear
    ret
dc_stretched:
    ld      de,sp+10
    ex      de,hl
    ld      sp,hl
    jr      dc_loop
dc_fill:
    ld      hl,(dir_ptr)
    ld      b,32                ;one directory entry is 32 bytes
    xor     a
dc_z:
    ld      (hl+),a
    dec     b
    jp      NZ,dc_z             ;the rest of the directory entry
    ld      hl,(dir_ptr)
    ex      de,hl
    ld      hl,(pack_sv)
    ld      bc,11               ;the 11-byte name
    call    fat_copy                       ; copy the 11-byte name
    ld      hl,(dir_ptr)
    ld      a,(hl)
    cp      $E5                 ;a lead $E5 cannot be stored as itself
    jr      NZ,dc_stored        ;the lead byte is not $E5
    ld      (hl),$05            ;store $05 when the lead byte would be $E5
dc_stored:
    ld      a,1
    ld      (fat_wflag),a
    ld      hl,0
    scf                         ;L = 0 and carry set
    ret

; Call. The 10-byte cursor snapshot is at sp+2.
; Call. The order is sector high, sector, cluster high, cluster, offset.
; Return. Carry set means one new cluster is linked and cleared.
; Return. Carry clear means the directory stays the same size.
; Clobber. AF, BC, DE, HL.
dir_stretch:
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT32            ;fs_type against FAT32
    jr      Z,ds_32             ;only a FAT32 chain grows
; A FAT16 root and a FAT16 subdirectory stay a fixed size.
ds_no:
    or      a                   ;Carry clear. Do not stretch.
    ret
ds_32:
    ld      de,sp+2             ;8085 loads each snapshot word with ld de,sp+n and ld hl,(de).
    ld      hl,(de)
    ld      a,(dir_sect+2)
    cp      l                   ;snapshot sect high vs now
    jr      NZ,ds_no            ;sector changed
    ld      a,(dir_sect+3)
    cp      h                   ;snapshot sect high vs now
    jr      NZ,ds_no            ;sector changed
    ld      de,sp+4
    ld      hl,(de)
    ld      a,(dir_sect)
    cp      l                   ;snapshot sect low vs now
    jr      NZ,ds_no            ;sector changed
    ld      a,(dir_sect+1)
    cp      h                   ;snapshot sect low vs now
    jr      NZ,ds_no            ;sector changed
    ld      de,sp+6
    ld      hl,(de)
    ld      a,(dir_clust+2)
    cp      l                   ;snapshot clust high vs now
    jr      NZ,ds_no            ;cluster changed
    ld      a,(dir_clust+3)
    cp      h                   ;snapshot clust high vs now
    jr      NZ,ds_no            ;cluster changed
    ld      de,sp+8
    ld      hl,(de)
    ld      a,(dir_clust)
    cp      l                   ;snapshot clust low vs now
    jr      NZ,ds_no            ;cluster changed
    ld      a,(dir_clust+1)
    cp      h                   ;snapshot clust low vs now
    jr      NZ,ds_no            ;cluster changed
    ld      de,sp+10
    ld      hl,(de)
    ld      a,(dir_ofs)
    cp      l                   ;snapshot ofs vs now
    jr      NZ,ds_moved         ;the offset changed
    ld      a,(dir_ofs+1)
    cp      h                   ;snapshot ofs vs now
    jr      Z,ds_no             ;the cursor did not move
ds_moved:
    ld      a,(dir_ofs)
    or      a
    jr      NZ,ds_no            ;the offset is not on a sector boundary
    ld      a,(dir_ofs+1)
    or      a                   ;8085 clears carry so rra shifts the sector index.
    rra
    ld      hl,_cpm_fat_vol+1
    ld      l,(hl)
    dec     l
    and     l
    jr      NZ,ds_no            ;the offset is not on a cluster boundary
    ld      hl,(dir_clust+2)
    ld      bc,hl
    ld      hl,(dir_clust)
    ex      de,hl
    call    get_fat             ;read the link at the end of the chain
    ret     NC                  ;the cluster is bad or the FAT was not read
    ld      a,b
    cp      $0F                 ;high nibble of an end mark
    jr      NZ,ds_no            ;the link is not end-of-chain
    ld      a,c
    and     d
    and     e
    inc     a
    jr      NZ,ds_no            ;the link is not $0FFFFFFF
    ld      hl,(dir_clust+2)
    ld      bc,hl
    ld      hl,(dir_clust)
    ex      de,hl
    call    create_chain        ;link one cluster and clear it
    ret     NC                  ;the stretch did not allocate
    ld      hl,de
    ld      (dir_clust),hl
    ld      hl,bc
    ld      (dir_clust+2),hl
    call    clst2sect           ;sector of the new cluster
    ret     NC                  ;the new cluster has no sector
    ld      hl,de
    ld      (dir_sect),hl
    ld      hl,bc
    ld      (dir_sect+2),hl
    call    fat_move_window     ;read the new directory sector
    ret     NC                  ;the new sector was not read
    ld      hl,fatwin
    ld      (dir_ptr),hl        ;dir_ptr aims at the first $00 byte
    scf                         ;Carry set. The new cluster is linked.
    ret
