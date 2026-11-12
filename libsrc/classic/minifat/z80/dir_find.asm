;
; dir_find: find an 8.3 name in the current directory.
; A pointer argument is __z88dk_fastcall (HL).
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

PUBLIC  dir_find
PUBLIC  _dir_find

EXTERN  _cpm_fat_vol
EXTERN  dir_next
EXTERN  dir_ptr
EXTERN  dir_sclust
EXTERN  dir_sdi
EXTERN  fat_found_sclust
EXTERN  fat_found_size
EXTERN  pack_sv

; A is folded to A-Z. Other bytes stay as they are.
fat_fold:
    cp      'a'                     ;vs 'a'
    ret     c                       ;below 'a'
    cp      'z'+1                   ;vs 'z'+1
    ret     nc                      ;above 'z'
    sub     32
    ret

; ff.c dir_find (no LFN). 0x00 ends the table; 0xE5 is deleted.
; Skip the volume bit. A long name is attribute $0F, so that test
; covers it. Disk $05 compares as $E5. Both sides are folded A-Z.
; IN: HL -> 11-byte 8.3
; OUT C and L=0, H=0: found, fat_found_* and dir_ptr filled. L=1: miss.
_dir_find:
dir_find:
    ld      (pack_sv),hl            ;8.3; dir_sdi clobbers fat_work
    ld      de,(dir_sclust)
    ld      bc,(dir_sclust+2)
    ld      hl,0
    call    dir_sdi                 ;rewind to the first dirent
    ld      hl,1
    ret     NC                      ;directory did not open
df_loop:
    ld      hl,(dir_ptr)
    ld      a,(hl)
    or      a                       ;0x00 = end of directory
    jr      Z,df_miss               ;0x00 ends the table
    cp      $E5                     ;deleted
    jr      Z,df_next               ;deleted entry
    ld      bc,DIR_Attr
    add     hl,bc
    ld      a,(hl)
    and     AM_VOL
    jr      NZ,df_next              ;volume label or long name
    ld      de,(dir_ptr)
    ld      hl,(pack_sv)
    ld      a,(de)
    cp      $05                     ;KANJI: stored $05 is the character $E5
    jr      NZ,df_cmp1              ;lead byte is not $05
    ld      a,$E5
df_cmp1:
    call    fat_fold                ;fold the on-disk byte
    ld      c,a
    ld      a,(hl)
    call    fat_fold                ;fold the wanted byte
    cp      c                       ;folded first byte
    jr      NZ,df_next              ;first byte differs
    inc     de
    inc     hl
    ld      b,10
df_cmp:
    ld      a,(de)
    call    fat_fold                ;fold the on-disk byte
    ld      c,a
    ld      a,(hl)
    call    fat_fold                ;fold the wanted byte
    cp      c                       ;folded name byte
    jr      NZ,df_next              ;name byte differs
    inc     de
    inc     hl
    djnz    df_cmp                  ;rest of the 8.3
    ld      hl,(dir_ptr)
    push    hl
    ld      bc,DIR_ClusHI
    add     hl,bc
    ld      e,(hl+)
    ld      d,(hl)                  ;clus hi
    ld      hl,(dir_ptr)
    ld      bc,DIR_ClusLO
    add     hl,bc
    ld      a,(hl+)
    ld      (fat_found_sclust),a
    ld      a,(hl)
    ld      (fat_found_sclust+1),a
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT32                ;fs_type vs FAT32
    jr      Z,df_hi                 ;keep the FAT32 cluster high word
    ld      de,0
df_hi:
    ld      (fat_found_sclust+2),de
    ld      hl,(dir_ptr)
    ld      bc,DIR_FileSize
    add     hl,bc
    ld      de,fat_found_size
    ld      bc,4
    ldir
    pop     hl
    ld      hl,0
    scf
    ret
df_next:
    call    dir_next                ;next dirent
    jp      C,df_loop               ;another entry is in range
df_miss:
    ld      hl,1
    or      a
    ret
