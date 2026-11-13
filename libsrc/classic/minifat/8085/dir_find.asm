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
; OUT C and L=0, H=0: found, fat_found_* and dir_ptr filled.
; NC+Z and L=1: the name is not there. NC+NZ and L=1: the sector was not read.
_dir_find:
dir_find:
    ld      (pack_sv),hl            ;8.3; dir_sdi clobbers fat_work
    ld      hl,(dir_sclust+2)
    ld      bc,hl
    ld      hl,(dir_sclust)
    ex      de,hl
    ld      hl,0
    call    dir_sdi                 ;rewind to the first dirent
    ld      hl,1
    ret     NC                      ;directory did not open
df_loop:
    ld      hl,(dir_ptr)
    ld      a,(hl)
    or      a                       ;0x00 = end of directory
    jr      Z,df_miss               ;0x00 ends the directory
    cp      $E5                     ;deleted
    jr      Z,df_next               ;deleted slot
    ld      de,hl+DIR_Attr
    ld      a,(de)
    and     AM_VOL
    jr      NZ,df_next              ;volume label or LFN
    ld      hl,(dir_ptr)
    ex      de,hl
    ld      hl,(pack_sv)
    ld      a,(de)
    cp      $05                     ;KANJI: stored $05 is the character $E5
    jr      NZ,df_cmp1              ;lead byte is not stored $05
    ld      a,$E5
df_cmp1:
    call    fat_fold                ;fold the disk byte
    ld      c,a
    ld      a,(hl)
    call    fat_fold                ;fold the name byte
    cp      c                       ;folded bytes
    jr      NZ,df_next              ;first byte differs
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
    jr      NZ,df_next              ;name differs
    inc     de
    inc     hl
    dec     b
    jp      NZ,df_cmp               ;ten bytes still to match
    ld      hl,(dir_ptr)
    ld      de,hl+DIR_ClusLO
    ld      hl,(de)                 ;ff ld_16 DIR_FstClusLO
    ld      (fat_found_sclust),hl
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT32                ;fs_type
    ld      hl,0
    jr      NZ,df_hi                ;FAT16 cluster is 16 bits
    ld      hl,(dir_ptr)
    ld      de,hl+DIR_ClusHI
    ld      hl,(de)                 ;ff ld_16 DIR_FstClusHI
df_hi:
    ld      (fat_found_sclust+2),hl
    ld      hl,(dir_ptr)
    ld      de,hl+DIR_FileSize
    ld      hl,(de)
    ld      (fat_found_size),hl
    inc     de
    inc     de
    ld      hl,(de)
    ld      (fat_found_size+2),hl
    ld      hl,0
    scf                             ;C: found
    ret
df_next:
    call    dir_next                ;C: another dirent
    jr      C,df_loop               ;keep scanning
    jr      NZ,df_io                ;sector was not read
df_miss:
    ld      hl,1
    xor     a                       ;NC+Z: name is not in this directory
    ret
df_io:
    ld      hl,1
    ld      a,1
    or      a                       ;NC+NZ: directory sector was not read
    ret
