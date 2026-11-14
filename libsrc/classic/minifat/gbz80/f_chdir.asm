;
; f_chdir. Outline is ChaN ff.c f_chdir. A file is FR_NO_PATH.
; The cluster is fat_cwd. The text is fat_cwd_str. path at sp+2.
;
; ld hl,sp+n is native and forces Z = 0.
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib
EXTERN  fat_ldhl
EXTERN  fat_sthl

PUBLIC  _f_chdir
PUBLIC  f_chdir

EXTERN  mf_ensure
EXTERN  mf_follow
EXTERN  mf_cwd_apply
EXTERN  mf_ok
EXTERN  mf_err
EXTERN  fat_path
EXTERN  fat_noname
EXTERN  fat_attr
EXTERN  fat_here
EXTERN  fat_cwd

; Call. The path is at sp+2. The caller removes it.
; Return. HL = FRESULT and H = 0. Carry is set only on the mf_ok path.
; Clobber. AF, BC, DE, HL.
; Writes. Success stores the cluster in fat_cwd and the text in fat_cwd_str.
_f_chdir:
f_chdir:
    ld      hl,sp+2
    ld      e,(hl+)
    ld      d,(hl)
    ld      (fat_path),de
    call    mf_ensure
    ret     NC                              ; the volume is not mounted. HL holds the FRESULT
    call    fat_ldhl
    defw    fat_path
    call    mf_follow
    jr      NC,fh_miss                      ; follow failed
    ld      a,(fat_noname)
    or      a
    jr      NZ,fh_ok                        ; the path names the directory itself
    ld      a,(fat_attr)
    and     AM_DIR                          ; directory attribute
    jr      NZ,fh_ok                        ; the entry is a directory
    ld      a,FR_NO_PATH                    ; a file returns FR_NO_PATH
    jp      mf_err
; the path names a directory
fh_ok:
    call    fat_ldhl
    defw    fat_path
    call    mf_cwd_apply
    ret     NC                              ; the path text was rejected. HL holds the FRESULT
    call    fat_ldhl
    defw    fat_here
    call    fat_sthl
    defw    fat_cwd
    call    fat_ldhl
    defw    fat_here+2
    call    fat_sthl
    defw    fat_cwd+2
    jp      mf_ok
; follow failed. FR_NO_FILE becomes FR_NO_PATH
fh_miss:
    ld      a,l
    cp      FR_NO_FILE
    jp      NZ,mf_err                       ; keep a code other than FR_NO_FILE
    ld      a,FR_NO_PATH
    jp      mf_err
