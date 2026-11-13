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
EXTERN  fat_ldhl
EXTERN  fat_sthl
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
    call    fat_sthl
    defw    pack_sv            ;8.3; dir_sdi clobbers fat_work
    call    fat_ldhl
    defw    dir_sclust+2
    ld      bc,hl
    call    fat_ldhl
    defw    dir_sclust
    ld      de,hl
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
    ld      de,DIR_Attr
    add     hl,de
    ld      a,(hl)
    and     AM_VOL
    jp      NZ,df_next              ;volume label or LFN
    call    fat_ldhl
    defw    dir_ptr
    ld      de,hl
    call    fat_ldhl
    defw    pack_sv
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
    jr      NZ,df_cmp               ;ten bytes still to match
    call    fat_ldhl
    defw    dir_ptr
    ld      de,DIR_ClusLO
    add     hl,de
    ld      a,(hl+)
    ld      h,(hl)
    ld      l,a                     ;ff ld_16 DIR_FstClusLO
    call    fat_sthl
    defw    fat_found_sclust
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT32                ;fs_type
    ld      hl,0
    jr      NZ,df_hi                ;FAT16 cluster is 16 bits
    call    fat_ldhl
    defw    dir_ptr
    ld      de,DIR_ClusHI
    add     hl,de
    ld      a,(hl+)
    ld      h,(hl)
    ld      l,a                     ;ff ld_16 DIR_FstClusHI
df_hi:
    call    fat_sthl
    defw    fat_found_sclust+2
    call    fat_ldhl
    defw    dir_ptr
    ld      de,DIR_FileSize
    add     hl,de
    ld      de,hl
    ld      a,(de)
    inc     de
    ld      l,a
    ld      a,(de)
    inc     de
    ld      h,a
    call    fat_sthl
    defw    fat_found_size
    ld      a,(de)
    inc     de
    ld      l,a
    ld      a,(de)
    ld      h,a
    call    fat_sthl
    defw    fat_found_size+2
    ld      hl,0
    scf                             ;C: found
    ret
df_next:
    call    dir_next                ;C: another dirent
    jp      C,df_loop               ;keep scanning
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
