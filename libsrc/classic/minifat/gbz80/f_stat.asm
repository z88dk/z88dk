;
; f_stat. Outline is ChaN ff.c f_stat: mount, follow, reject a bare
; directory origin, fill FILINFO from the entry. fno at sp+2, path at sp+4.
;
; ld hl,sp+n is native and forces Z = 0.
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib
EXTERN  fat_ldhl

PUBLIC  _f_stat
PUBLIC  f_stat

EXTERN  mf_ensure
EXTERN  mf_follow
EXTERN  mf_fill_info
EXTERN  mf_ok
EXTERN  mf_err
EXTERN  fat_path
EXTERN  fat_user
EXTERN  fat_noname

; Call. The FILINFO pointer is at sp+2. The path is at sp+4.
; The caller removes the arguments.
; Return. HL = FRESULT and H = 0. Carry is set only on the mf_ok path.
; Clobber. AF, BC, DE, HL.
; Writes. Success fills a non-null FILINFO from the directory entry.
; Failure stores 0 at the name when that pointer is not 0.
_f_stat:
f_stat:
    ld      hl,sp+2
    ld      e,(hl+)
    ld      d,(hl)
    ld      (fat_user),de
    inc     hl
    ld      e,(hl+)
    ld      d,(hl)
    ld      (fat_path),de
    call    mf_ensure
    jr      NC,fs_bad                       ; the volume is not mounted
    call    fat_ldhl
    defw    fat_path
    call    mf_follow
    jr      NC,fs_bad                       ; follow failed
    ld      a,(fat_noname)
    or      a
    jr      NZ,fs_name                      ; the path names the directory itself
    call    fat_ldhl
    defw    fat_user
    ld      a,h
    or      l
    jp      Z,mf_ok                         ; the FILINFO pointer is 0
    jp      mf_fill_info                    ; mf_fill_info ends at mf_ok
; a bare directory origin is FR_INVALID_NAME
fs_name:
    ld      a,FR_INVALID_NAME
    jr      fs_clr
; L is the FRESULT from mount or from follow
fs_bad:
    ld      a,l
fs_clr:
    ld      e,a                             ; hold the FRESULT in E
    call    fat_ldhl
    defw    fat_user
    ld      a,h
    or      l
    jr      Z,fs_ret                        ; the FILINFO pointer is 0
    ld      bc,FI_NAME
    add     hl,bc
    ld      (hl),0                          ; set the name to an empty string
fs_ret:
    ld      a,e
    jp      mf_err
