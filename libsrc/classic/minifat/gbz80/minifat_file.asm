;
; Shared file-layer helpers for the gbz80 mini-FAT calls.
; Outline is ChaN ff.c (f_open, f_read, f_write, f_sync, f_lseek,
; follow_path, validate): 80cc stack-pointer order, caller cleans.
; The delivered code calls this core. It is not the 80cc listing.
;
; Copyright (c) October 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib
EXTERN  fat_ldhl
EXTERN  fat_sthl

PUBLIC  mf_ensure
PUBLIC  mf_drive
PUBLIC  mf_follow
PUBLIC  mf_fil_check
PUBLIC  mf_bind
PUBLIC  mf_trunc
PUBLIC  mf_sync_fil
PUBLIC  mf_place
PUBLIC  mf_transfer
PUBLIC  mf_flush
PUBLIC  mf_bump_id
PUBLIC  mf_publish
PUBLIC  mf_save_dir
PUBLIC  mf_mark_arc
PUBLIC  mf_cwd_reset
PUBLIC  mf_cwd_apply
PUBLIC  mf_fill_info
PUBLIC  mf_ok
PUBLIC  mf_err
PUBLIC  mf_sector_for_fptr
PUBLIC  mf_cache_prepare
PUBLIC  mf_copy
PUBLIC  mf_subhlbc
PUBLIC  fat_dp
PUBLIC  fat_fp
PUBLIC  fat_path
PUBLIC  fat_mode
PUBLIC  fat_noname
PUBLIC  fat_trail
PUBLIC  fat_attr
PUBLIC  fat_kind
PUBLIC  fat_here
PUBLIC  fat_parent
PUBLIC  fat_dirsec
PUBLIC  fat_dirofs
PUBLIC  fat_name11
PUBLIC  fat_hold
PUBLIC  fat_file_valid
PUBLIC  fat_file_dirty
PUBLIC  fat_want
PUBLIC  fat_user
PUBLIC  fat_left
PUBLIC  fat_out
PUBLIC  fat_write
PUBLIC  fat_csect
PUBLIC  fat_off
PUBLIC  fat_remain
PUBLIC  fat_seek
PUBLIC  fat_cfo
PUBLIC  fat_zeros

EXTERN  fat_mount
EXTERN  dir_sdi
EXTERN  dir_find
EXTERN  get_fat
EXTERN  create_chain
EXTERN  remove_chain
EXTERN  clst2sect
EXTERN  clst_from_off
EXTERN  fat_move_window
EXTERN  fat_sync_window
EXTERN  ide_read_sector
EXTERN  ide_write_sector
EXTERN  _cpm_fat_vol
EXTERN  fat_cwd
EXTERN  fat_found_sclust
EXTERN  fat_found_size
EXTERN  dir_ptr
EXTERN  dir_sect
EXTERN  dir_ofs
EXTERN  fat_wflag
EXTERN  fatwin

SECTION bss_compiler

PUBLIC  fat_fs
PUBLIC  fat_mount_id
PUBLIC  fat_cwd_str

fat_fs:             defs 2
fat_mount_id:       defs 2
fat_cwd_str:        defs 64
fat_fp:             defs 2
fat_dp:             defs 2
fat_path:           defs 2
fat_mode:           defs 1
fat_noname:         defs 1
fat_trail:          defs 1
fat_attr:           defs 1
fat_kind:           defs 1
fat_here:           defs 4
fat_parent:         defs 4
fat_dirsec:         defs 4
fat_dirofs:         defs 2
fat_name11:         defs 11
fat_hold:           defs 4
fat_filewin:        defs 512
fat_file_sect:      defs 4
fat_file_valid:     defs 1
fat_file_dirty:     defs 1
fat_file_own:       defs 2
fat_want:           defs 4
fat_user:           defs 2
fat_left:           defs 2
fat_out:            defs 2
fat_write:          defs 1
fat_csect:          defs 1
fat_off:            defs 2
fat_remain:         defs 4
fat_seek:           defs 4
fat_cfo:            defs 8
fat_zeros:          defs 16

SECTION code_lib

mf_ok:
    ld      hl,0
    scf
    ret

mf_err:
    ld      l,a
    ld      h,0
    or      a
    ret

; HL = 0, or a path. C: HL moved past an optional "0:" prefix.
mf_drive:
    ld      a,h
    or      l
    jp      Z,mf_drive_bad
    ld      a,(hl)
    cp      '0'
    jp      C,mf_drive_ok
    cp      '9'+1
    jp      NC,mf_drive_ok
    inc     hl
    ld      c,a
    ld      a,(hl)
    cp      ':'
    jp      NZ,mf_drive_back
    inc     hl
    ld      a,c
    cp      '0'
    jp      Z,mf_drive_ok
mf_drive_bad:
    ld      hl,FR_INVALID_DRIVE
    or      a
    ret
mf_drive_back:
    dec     hl
mf_drive_ok:
    scf
    ret

mf_bump_id:
    call    fat_ldhl
    defw    fat_mount_id
    inc     hl
    ld      a,h
    or      l
    jp      NZ,mf_bump_st
    inc     hl
mf_bump_st:
    call    fat_sthl
    defw    fat_mount_id
    ret

mf_publish:
    call    fat_ldhl
    defw    fat_fs
    ld      a,h
    or      l
    ret     Z
    ld      a,(_cpm_fat_vol)
    ld      (hl),a
    inc     hl
    ld      (hl),0
    inc     hl
    ld      de,(fat_mount_id)
    ld      (hl),e
    inc     hl
    ld      (hl),d
    ret

mf_cwd_reset:
    ld      hl,fat_cwd_str
    ld      (hl),'0'
    inc     hl
    ld      (hl),':'
    inc     hl
    ld      (hl),'/'
    inc     hl
    ld      (hl),0
    ret

; Mount when a volume is registered and not yet mounted.
mf_ensure:
    ld      a,(_cpm_fat_vol)
    or      a
    jp      NZ,mf_ok
    call    fat_ldhl
    defw    fat_fs
    ld      a,h
    or      l
    jp      Z,mf_ensure_off
    call    fat_mount
    jp      NC,mf_ensure_fail
    call    mf_bump_id
    call    mf_publish
    call    mf_cwd_reset
    xor     a
    ld      (fat_file_valid),a
    ld      (fat_file_dirty),a
    jp      mf_ok
mf_ensure_fail:
    ld      a,l
    cp      19
    jp      Z,mf_ensure_par
    ld      hl,FR_NO_FILESYSTEM
    or      a
    ret
mf_ensure_par:
    ld      hl,FR_INVALID_PARAMETER
    or      a
    ret
mf_ensure_off:
    ld      hl,FR_NOT_ENABLED
    or      a
    ret

; C if A is 0, '/' or '\'.
mf_at_end:
    ld      a,(hl)
    or      a
    jp      Z,mf_at_yes
    cp      '/'
    jp      Z,mf_at_yes
    cp      $5C
    jp      Z,mf_at_yes
    or      a
    ret
mf_at_yes:
    scf
    ret

mf_skip_slash:
    ld      a,(hl)
    cp      '/'
    jp      Z,mf_skip1
    cp      $5C
    ret     NZ
mf_skip1:
    inc     hl
    jp      mf_skip_slash

mf_fold:
    cp      'a'
    ret     C
    cp      'z'+1
    ret     NC
    sub     32
    ret

; C if A may sit in an 8.3 body.
mf_okchar:
    cp      '0'
    jp      C,mf_ok_sym
    cp      '9'+1
    jp      C,mf_ok_yes
    cp      'A'
    jp      C,mf_ok_no
    cp      'Z'+1
    jp      C,mf_ok_yes
    cp      'a'
    jp      C,mf_ok_no
    cp      'z'+1
    jp      C,mf_ok_yes
mf_ok_sym:
    cp      '_'
    jp      Z,mf_ok_yes
    cp      '-'
    jp      Z,mf_ok_yes
    cp      '!'
    jp      Z,mf_ok_yes
    cp      '#'
    jp      Z,mf_ok_yes
    cp      '$'
    jp      Z,mf_ok_yes
    cp      '%'
    jp      Z,mf_ok_yes
    cp      '&'
    jp      Z,mf_ok_yes
mf_ok_no:
    or      a
    ret
mf_ok_yes:
    scf
    ret

; Parse one component at HL into fat_name11.
; C and A = 0 normal, 1 ".", 2 "..". HL is the next character.
; NC and HL = FR_INVALID_NAME, or A = 0 and NC if there is no component.
mf_comp:
    ld      a,(hl)
    or      a
    jp      Z,mf_comp_none
    cp      '/'
    jp      Z,mf_comp_none
    cp      $5C
    jp      Z,mf_comp_none
    cp      '.'
    jp      NZ,mf_comp_name
    inc     hl
    ld      a,(hl)
    cp      '.'
    jp      NZ,mf_comp_one
    inc     hl
    call    mf_at_end
    jp      NC,mf_badname
    ld      a,2
    scf
    ret
mf_comp_one:
    call    mf_at_end
    jp      NC,mf_badname
    ld      a,1
    scf
    ret
mf_comp_none:
    xor     a
    or      a
    ret
mf_badname:
    ld      hl,FR_INVALID_NAME
    or      a
    ret
mf_comp_name:
    push    hl
    ld      hl,fat_name11
    ld      b,11
    ld      a,' '
mf_cfill:
    ld      (hl),a
    inc     hl
    dec     b
    jp      nz,mf_cfill
    pop     hl
    ld      de,fat_name11
    ld      b,8
mf_cn:
    ld      a,(hl)
    call    mf_at_end
    jp      C,mf_comp_done
    cp      '.'
    jp      Z,mf_cdot
    call    mf_okchar
    jp      NC,mf_badname
    call    mf_fold
    ld      (de),a
    inc     de
    inc     hl
    dec     b
    jp      nz,mf_cn
    ld      a,(hl)
    call    mf_at_end
    jp      C,mf_comp_done
    cp      '.'
    jp      NZ,mf_badname
mf_cdot:
    inc     hl
    ld      de,fat_name11+8
    ld      b,3
mf_ce:
    ld      a,(hl)
    call    mf_at_end
    jp      C,mf_comp_done
    cp      '.'
    jp      Z,mf_badname
    call    mf_okchar
    jp      NC,mf_badname
    call    mf_fold
    ld      (de),a
    inc     de
    inc     hl
    dec     b
    jp      nz,mf_ce
    ld      a,(hl)
    call    mf_at_end
    jp      NC,mf_badname
mf_comp_done:
    xor     a
    scf
    ret

; Directory at fat_here, name in fat_name11.
; C: found. NC: HL = FR_NO_FILE or FR_DISK_ERR.
mf_lookup_here:
    ld      de,(fat_here)
    ld      bc,(fat_here+2)
    ld      hl,0
    call    dir_sdi
    jp      NC,mf_lu_disk
    ld      hl,fat_name11
    call    dir_find
    ret     C
    ld      hl,FR_NO_FILE
    or      a
    ret
mf_lu_disk:
    ld      hl,FR_DISK_ERR
    or      a
    ret

mf_save_dir:
    call    fat_ldhl
    defw    dir_sect
    call    fat_sthl
    defw    fat_dirsec
    call    fat_ldhl
    defw    dir_sect+2
    call    fat_sthl
    defw    fat_dirsec+2
    call    fat_ldhl
    defw    dir_ofs
    call    fat_sthl
    defw    fat_dirofs
    call    fat_ldhl
    defw    dir_ptr
    ld      de,DIR_Attr
    add     hl,de
    ld      a,(hl)
    ld      (fat_attr),a
    ret

mf_take_found:
    call    fat_ldhl
    defw    fat_found_sclust
    call    fat_sthl
    defw    fat_here
    call    fat_ldhl
    defw    fat_found_sclust+2
    call    fat_sthl
    defw    fat_here+2
    ret

; ".." from fat_here. Root stays root.
mf_dotdot:
    ld      a,(fat_here)
    ld      hl,fat_here+1
    or      (hl)
    inc     hl
    or      (hl)
    inc     hl
    or      (hl)
    jp      Z,mf_dot_root
    ld      hl,fat_name11
    ld      (hl),'.'
    inc     hl
    ld      (hl),'.'
    inc     hl
    ld      b,9
    ld      a,' '
mf_ddsp:
    ld      (hl),a
    inc     hl
    dec     b
    jp      nz,mf_ddsp
    call    mf_lookup_here
    jp      NC,mf_dot_root
    call    mf_take_found
    scf
    ret
mf_dot_root:
    ld      hl,0
    call    fat_sthl
    defw    fat_here
    call    fat_sthl
    defw    fat_here+2
    scf
    ret

mf_nopath:
    ld      hl,FR_NO_PATH
    or      a
    ret

mf_noname:
    ld      a,AM_DIR
    ld      (fat_attr),a
    ld      a,1
    ld      (fat_noname),a
    jp      mf_ok

; Follow HL. See ff.c follow_path.
; C: object is in fat_here / fat_found_* / fat_attr. fat_noname is 1
;    when the path is the directory itself.
; NC and HL = FR_NO_FILE: parent is open (dir_sdi of fat_parent) and
;    fat_name11 is the missing 8.3. Other codes are hard failures.
mf_follow:
    call    fat_sthl
    defw    fat_path
    xor     a
    ld      (fat_noname),a
    ld      (fat_trail),a
    call    mf_drive
    ret     NC
    ld      a,(hl)
    cp      '/'
    jp      Z,mf_abs
    cp      $5C
    jp      Z,mf_abs
    ld      de,(fat_cwd)
    ld      bc,(fat_cwd+2)
    jp      mf_sethere
mf_abs:
    ld      de,0
    ld      bc,0
    call    mf_skip_slash
mf_sethere:
    ld      (fat_here),de
    ld      (fat_here+2),bc
    ld      a,(hl)
    or      a
    jp      Z,mf_noname
mf_floop:
    ld      de,(fat_here)
    ld      (fat_parent),de
    ld      de,(fat_here+2)
    ld      (fat_parent+2),de
    call    mf_comp
    ret     NC
    ld      (fat_kind),a
    ld      a,(hl)
    cp      '/'
    jp      Z,mf_saw_slash
    cp      $5C
    jp      NZ,mf_no_slash
mf_saw_slash:
    call    mf_skip_slash
    ld      a,1
    ld      (fat_trail),a
    jp      mf_more
mf_no_slash:
    xor     a
    ld      (fat_trail),a
mf_more:
    ld      a,(hl)
    or      a
    jp      Z,mf_last
    ld      a,(fat_kind)
    or      a
    jp      Z,mf_mid_name
    cp      1
    jp      Z,mf_floop
    push    hl
    call    mf_dotdot
    pop     hl
    jp      mf_floop
mf_mid_name:
    push    hl
    call    mf_lookup_here
    jp      NC,mf_mid_err
    call    mf_save_dir
    ld      a,(fat_attr)
    and     AM_DIR
    jp      Z,mf_mid_np
    call    mf_take_found
    pop     hl
    jp      mf_floop
mf_mid_np:
    pop     de
    jp      mf_nopath
mf_mid_err:
    pop     de
mf_mid_miss:
    ld      a,l
    cp      FR_NO_FILE
    jp      NZ,mf_ret_hl
    jp      mf_nopath
mf_last:
    ld      a,(fat_kind)
    or      a
    jp      Z,mf_last_name
    cp      1
    jp      Z,mf_noname
    call    mf_dotdot
    jp      mf_noname
mf_last_name:
    call    mf_lookup_here
    jp      NC,mf_last_miss
    call    mf_save_dir
    call    mf_take_found
    ld      a,(fat_trail)
    or      a
    jp      Z,mf_ok
    ld      a,(fat_attr)
    and     AM_DIR
    jp      Z,mf_nopath
    jp      mf_noname
mf_last_miss:
    ld      a,l
    cp      FR_NO_FILE
    jp      NZ,mf_ret_hl
    ld      a,(fat_trail)
    or      a
    jp      NZ,mf_nopath
    ld      hl,FR_NO_FILE
    or      a
    ret

mf_ret_hl:
    or      a
    ret

; HL = FIL or 0. C when the object belongs to this mount and err is 0.
mf_fil_check:
    ld      a,h
    or      l
    jp      Z,mf_fil_bad
    call    fat_sthl
    defw    fat_fp
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      a,d
    or      e
    jp      Z,mf_fil_bad
    call    fat_ldhl
    defw    fat_mount_id
    or      a
    push    bc
    ld      bc,de
    call    mf_subhlbc
    pop     bc
    jp      NZ,mf_fil_bad
    ld      a,(_cpm_fat_vol)
    or      a
    jp      Z,mf_fil_bad
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_ERR
    add     hl,de
    ld      a,(hl)
    or      a
    jp      NZ,mf_err
    jp      mf_ok
mf_fil_bad:
    ld      hl,FR_INVALID_OBJECT
    or      a
    ret

mf_mark_arc:
    call    fat_ldhl
    defw    dir_ptr
    ld      de,DIR_Attr
    add     hl,de
    ld      (hl),AM_ARC
    ld      a,1
    ld      (fat_wflag),a
    ld      a,AM_ARC
    ld      (fat_attr),a
    ret

; Fill FIL from fat_found_*, fat_dirsec, fat_attr, fat_mode.
mf_bind:
    call    fat_ldhl
    defw    fat_fp
    ld      b,FIL_BYTES
    xor     a
mf_bz:
    ld      (hl),a
    inc     hl
    dec     b
    jp      nz,mf_bz
    call    fat_ldhl
    defw    fat_fp
    ld      de,(fat_mount_id)
    ld      (hl),e
    inc     hl
    ld      (hl),d
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_FLAG
    add     hl,de
    ld      a,(fat_mode)
    ld      (hl),a
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_ATTR
    add     hl,de
    ld      a,(fat_attr)
    ld      (hl),a
    ld      hl,fat_found_size
    ld      de,(fat_fp)
    ld      a,e
    add     a,FIL_SIZE
    ld      e,a
    ld      a,d
    adc     a,0
    ld      d,a
    ld      bc,4
    call    mf_copy
    ld      hl,fat_found_sclust
    ld      de,(fat_fp)
    ld      a,e
    add     a,FIL_SCLUST
    ld      e,a
    ld      a,d
    adc     a,0
    ld      d,a
    ld      bc,4
    call    mf_copy
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_SCLUST
    add     hl,de
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    inc     hl
    ld      c,(hl)
    inc     hl
    ld      b,(hl)
    call    fat_ldhl
    defw    fat_fp
    push    de
    ld      de,FIL_CLUST
    add     hl,de
    pop     de
    ld      (hl),e
    inc     hl
    ld      (hl),d
    inc     hl
    ld      (hl),c
    inc     hl
    ld      (hl),b
    ld      hl,fat_dirsec
    ld      de,(fat_fp)
    ld      a,e
    add     a,FIL_DIRSEC
    ld      e,a
    ld      a,d
    adc     a,0
    ld      d,a
    ld      bc,4
    call    mf_copy
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_DIROFS
    add     hl,de
    ld      de,(fat_dirofs)
    ld      (hl),e
    inc     hl
    ld      (hl),d
    jp      mf_ok

; Drop the chain FIL still names, then publish a zero length.
mf_trunc:
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_SCLUST
    add     hl,de
    ld      de,fat_hold
    ld      bc,4
    call    mf_copy
    call    mf_load_dir
    jp      NC,mf_trunc_disk
    call    mf_zero_alloc
    ld      a,(fat_hold)
    ld      hl,fat_hold+1
    or      (hl)
    inc     hl
    or      (hl)
    inc     hl
    or      (hl)
    jp      Z,mf_trunc_mod
    ld      de,(fat_hold)
    ld      bc,(fat_hold+2)
    call    remove_chain
    jp      NC,mf_trunc_disk
mf_trunc_mod:
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_FLAG
    add     hl,de
    ld      a,(hl)
    or      FA_MODIFIED
    ld      (hl),a
    jp      mf_ok
mf_trunc_disk:
    ld      hl,FR_DISK_ERR
    or      a
    ret

mf_zero_alloc:
    call    fat_ldhl
    defw    dir_ptr
    ld      de,DIR_ClusHI
    add     hl,de
    xor     a
    ld      (hl),a
    inc     hl
    ld      (hl),a
    call    fat_ldhl
    defw    dir_ptr
    ld      de,DIR_ClusLO
    add     hl,de
    xor     a
    ld      (hl),a
    inc     hl
    ld      (hl),a
    call    fat_ldhl
    defw    dir_ptr
    ld      de,DIR_FileSize
    add     hl,de
    ld      b,4
    xor     a
mf_za4:
    ld      (hl),a
    inc     hl
    dec     b
    jp      nz,mf_za4
    call    fat_ldhl
    defw    dir_ptr
    ld      de,DIR_Attr
    add     hl,de
    ld      (hl),AM_ARC
    ld      a,1
    ld      (fat_wflag),a
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_ATTR
    add     hl,de
    ld      (hl),AM_ARC
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_FPTR
    add     hl,de
    xor     a
    ld      b,16
mf_zf:
    ld      (hl),a
    inc     hl
    dec     b
    jp      nz,mf_zf
    ret

mf_load_dir:
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_DIRSEC
    add     hl,de
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    inc     hl
    ld      c,(hl)
    inc     hl
    ld      b,(hl)
    call    fat_move_window
    ret     NC
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_DIROFS
    add     hl,de
    ld      e,(hl)
    inc     hl
    ld      a,(hl)
    and     1
    ld      d,a
    ld      hl,fatwin
    add     hl,de
    call    fat_sthl
    defw    dir_ptr
    scf
    ret

mf_write_entry:
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_SCLUST
    add     hl,de
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    inc     hl
    ld      c,(hl)
    inc     hl
    ld      b,(hl)
    push    bc
    call    fat_ldhl
    defw    dir_ptr
    ld      bc,DIR_ClusLO
    add     hl,bc
    ld      (hl),e
    inc     hl
    ld      (hl),d
    pop     bc
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT32
    jp      Z,mf_we_hi
    ld      bc,0
mf_we_hi:
    call    fat_ldhl
    defw    dir_ptr
    ld      de,DIR_ClusHI
    add     hl,de
    ld      (hl),c
    inc     hl
    ld      (hl),b
    call    fat_ldhl
    defw    dir_ptr
    ld      de,DIR_FileSize
    add     hl,de
    ex      de,hl
    call    fat_ldhl
    defw    fat_fp
    ld      bc,FIL_SIZE
    add     hl,bc
    ld      bc,4
    call    mf_copy
    call    fat_ldhl
    defw    dir_ptr
    ld      de,DIR_Attr
    add     hl,de
    ld      a,(hl)
    or      AM_ARC
    ld      (hl),a
    ret

mf_sync_fil:
    call    mf_flush
    ret     NC
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_FLAG
    add     hl,de
    ld      a,(hl)
    and     FA_MODIFIED
    jp      Z,mf_ok
    call    mf_load_dir
    jp      NC,mf_sync_disk
    call    mf_write_entry
    ld      a,1
    ld      (fat_wflag),a
    call    fat_sync_window
    jp      NC,mf_sync_disk
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_FLAG
    add     hl,de
    ld      a,(hl)
    and     FA_MODE_MASK
    ld      (hl),a
    jp      mf_ok
mf_sync_disk:
    ld      hl,FR_DISK_ERR
    or      a
    ret

mf_flush:
    ld      a,(fat_file_dirty)
    or      a
    jp      Z,mf_flush_ok
    ld      de,(fat_file_sect)
    ld      bc,(fat_file_sect+2)
    ld      hl,fat_filewin
    call    ide_write_sector
    jp      NC,mf_flush_disk
    xor     a
    ld      (fat_file_dirty),a
    call    fat_ldhl
    defw    fat_file_own
    ld      a,h
    or      l
    jp      Z,mf_flush_ok
    ld      de,FIL_FLAG
    add     hl,de
    ld      a,(hl)
    and     $7F
    ld      (hl),a
mf_flush_ok:
    scf
    ret
mf_flush_disk:
    ld      hl,FR_DISK_ERR
    or      a
    ret

; C if BCDE is the sector in the cache.
mf_same_sect:
    ld      a,(fat_file_valid)
    or      a
    jp      Z,mf_same_no
    ld      a,(fat_file_sect)
    cp      e
    ret     NZ
    ld      a,(fat_file_sect+1)
    cp      d
    ret     NZ
    ld      a,(fat_file_sect+2)
    cp      c
    ret     NZ
    ld      a,(fat_file_sect+3)
    cp      b
    ret
mf_same_no:
    or      1
    ret

; fat_remain = size - fptr. C if fptr > size.
mf_size_minus_fptr:
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_SIZE
    add     hl,de
    ld      de,fat_hold
    ld      bc,4
    call    mf_copy
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_FPTR
    add     hl,de
    or      a
    ld      a,(fat_hold)
    sbc     a,(hl)
    ld      (fat_remain),a
    inc     hl
    ld      a,(fat_hold+1)
    sbc     a,(hl)
    ld      (fat_remain+1),a
    inc     hl
    ld      a,(fat_hold+2)
    sbc     a,(hl)
    ld      (fat_remain+2),a
    inc     hl
    ld      a,(fat_hold+3)
    sbc     a,(hl)
    ld      (fat_remain+3),a
    ret

; C if BCDE is the folded end mark $0FFFFFFF.
mf_is_eoc:
    ld      a,b
    cp      $0F
    jp      NZ,mf_eoc_no
    ld      a,c
    and     d
    and     e
    inc     a
    jp      NZ,mf_eoc_no
    scf
    ret
mf_eoc_no:
    or      a
    ret

mf_store_clust:
    push    de
    push    bc
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_CLUST
    add     hl,de
    pop     bc
    pop     de
    ld      (hl),e
    inc     hl
    ld      (hl),d
    inc     hl
    ld      (hl),c
    inc     hl
    ld      (hl),b
    ret

mf_store_sclust:
    push    de
    push    bc
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_SCLUST
    add     hl,de
    pop     bc
    pop     de
    ld      (hl),e
    inc     hl
    ld      (hl),d
    inc     hl
    ld      (hl),c
    inc     hl
    ld      (hl),b
    call    mf_store_clust
    ret

; Sector LBA of fil->fptr. fat_write selects stretch on a cluster edge.
; C: BCDE = LBA. NC and HL = 0: disk full. NC and HL != 0: FRESULT.
mf_sector_for_fptr:
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_FPTR
    add     hl,de
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    inc     hl
    ld      c,(hl)
    inc     hl
    ld      b,(hl)
    ld      a,e
    ld      (fat_off),a
    ld      a,d
    and     1
    ld      (fat_off+1),a
    ld      e,d
    ld      d,c
    ld      c,b
    ld      b,0
    ld      a,c
    or      a
    rra
    ld      c,a
    ld      a,d
    rra
    ld      d,a
    ld      a,e
    rra
    ld      e,a
    ld      a,(_cpm_fat_vol+1)
    dec     a
    and     e
    ld      (fat_csect),a
    ld      a,(fat_off)
    ld      hl,fat_off+1
    or      (hl)
    jp      NZ,mf_sec_same
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_FPTR
    add     hl,de
    ld      a,(hl)
    inc     hl
    or      (hl)
    inc     hl
    or      (hl)
    inc     hl
    or      (hl)
    jp      NZ,mf_sec_next
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_SCLUST
    add     hl,de
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    inc     hl
    ld      c,(hl)
    inc     hl
    ld      b,(hl)
    ld      a,b
    or      c
    or      d
    or      e
    jp      NZ,mf_sec_have
    ld      a,(fat_write)
    or      a
    jp      Z,mf_sec_int
    ld      de,0
    ld      bc,0
    call    create_chain
    jp      NC,mf_sec_full
    call    mf_store_sclust
    jp      mf_sec_lba
mf_sec_next:
    ld      a,(fat_csect)
    or      a
    jp      NZ,mf_sec_same
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_CLUST
    add     hl,de
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    inc     hl
    ld      c,(hl)
    inc     hl
    ld      b,(hl)
    push    bc
    push    de
    call    get_fat
    jp      NC,mf_sec_popdisk
    call    mf_is_eoc
    jp      NC,mf_sec_popnew
    pop     de
    pop     bc
    ld      a,(fat_write)
    or      a
    jp      Z,mf_sec_int
    call    create_chain
    jp      NC,mf_sec_full
    call    mf_store_clust
    jp      mf_sec_lba
mf_sec_popdisk:
    pop     de
    pop     bc
    ld      hl,FR_DISK_ERR
    or      a
    ret
mf_sec_popnew:
    pop     hl
    pop     hl
    call    mf_store_clust
    jp      mf_sec_lba
mf_sec_have:
    call    mf_store_clust
    jp      mf_sec_lba
mf_sec_same:
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_CLUST
    add     hl,de
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    inc     hl
    ld      c,(hl)
    inc     hl
    ld      b,(hl)
    ld      a,b
    or      c
    or      d
    or      e
    jp      Z,mf_sec_int
mf_sec_lba:
    call    clst2sect
    jp      NC,mf_sec_int
    ld      a,(fat_csect)
    add     a,e
    ld      e,a
    ld      a,d
    adc     a,0
    ld      d,a
    ld      a,c
    adc     a,0
    ld      c,a
    ld      a,b
    adc     a,0
    ld      b,a
    scf
    ret
mf_sec_full:
    ld      hl,0
    or      a
    ret
mf_sec_int:
    ld      hl,FR_INT_ERR
    or      a
    ret

; C if this sector still holds bytes below the current size.
mf_need_read:
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_FPTR
    add     hl,de
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    inc     hl
    ld      c,(hl)
    inc     hl
    ld      b,(hl)
    ld      e,0
    ld      a,d
    and     $FE
    ld      d,a
    ld      (fat_hold),de
    ld      (fat_hold+2),bc
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_SIZE
    add     hl,de
    or      a
    ld      a,(fat_hold)
    sub     (hl)
    inc     hl
    ld      a,(fat_hold+1)
    sbc     a,(hl)
    inc     hl
    ld      a,(fat_hold+2)
    sbc     a,(hl)
    inc     hl
    ld      a,(fat_hold+3)
    sbc     a,(hl)
    ret

mf_cache_prepare:
    ld      (fat_want),de
    ld      (fat_want+2),bc
    call    mf_same_sect
    jp      NZ,mf_cache_miss
    call    fat_ldhl
    defw    fat_file_own
    ld      de,(fat_fp)
    or      a
    push    bc
    ld      bc,de
    call    mf_subhlbc
    pop     bc
    jp      Z,mf_cache_hit
    ld      a,(fat_file_dirty)
    or      a
    jp      Z,mf_cache_hit
mf_cache_miss:
    call    mf_flush
    ret     NC
    ld      de,(fat_want)
    ld      bc,(fat_want+2)
    call    mf_need_read
    jp      NC,mf_cache_zero
    ld      de,(fat_want)
    ld      bc,(fat_want+2)
    ld      hl,fat_filewin
    call    ide_read_sector
    jp      NC,mf_flush_disk
    jp      mf_cache_arm
mf_cache_zero:
    ld      hl,fat_filewin
    ld      (hl),0
    ld      de,fat_filewin+1
    ld      bc,511
    call    mf_copy
mf_cache_arm:
    ld      hl,fat_want
    ld      de,fat_file_sect
    ld      bc,4
    call    mf_copy
    ld      a,1
    ld      (fat_file_valid),a
    xor     a
    ld      (fat_file_dirty),a
mf_cache_hit:
    call    fat_ldhl
    defw    fat_fp
    call    fat_sthl
    defw    fat_file_own
    scf
    ret

; Position fil->clust for the current fptr.
mf_place:
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_FPTR
    add     hl,de
    ld      a,(hl)
    inc     hl
    or      (hl)
    inc     hl
    or      (hl)
    inc     hl
    or      (hl)
    jp      NZ,mf_place_mid
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_SCLUST
    add     hl,de
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    inc     hl
    ld      c,(hl)
    inc     hl
    ld      b,(hl)
    call    mf_store_clust
    jp      mf_ok
mf_place_mid:
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_SCLUST
    add     hl,de
    ld      de,fat_cfo
    ld      bc,4
    call    mf_copy
    call    mf_place_src
    ld      hl,fat_cfo+4
    ld      (hl),e
    inc     hl
    ld      (hl),d
    inc     hl
    ld      (hl),c
    inc     hl
    ld      (hl),b
    ld      hl,fat_cfo
    call    clst_from_off
    jp      NC,mf_sec_int
    call    mf_store_clust
    jp      mf_ok

; BCDE = fptr, or fptr-1 when fptr is the cluster-aligned end.
mf_place_src:
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_FPTR
    add     hl,de
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    inc     hl
    ld      c,(hl)
    inc     hl
    ld      b,(hl)
    push    bc
    push    de
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_SIZE
    add     hl,de
    pop     de
    pop     bc
    ld      a,(hl)
    cp      e
    jp      NZ,mf_place_use
    inc     hl
    ld      a,(hl)
    cp      d
    jp      NZ,mf_place_use
    inc     hl
    ld      a,(hl)
    cp      c
    jp      NZ,mf_place_use
    inc     hl
    ld      a,(hl)
    cp      b
    jp      NZ,mf_place_use
    call    mf_aligned
    jp      NC,mf_place_use
    ld      a,e
    sub     1
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
mf_place_use:
    ret

; C if fptr is a multiple of the cluster size.
mf_aligned:
    ld      a,(_cpm_fat_vol+1)
    ld      l,a
    ld      h,0
    add     hl,hl
    add     hl,hl
    add     hl,hl
    add     hl,hl
    add     hl,hl
    add     hl,hl
    add     hl,hl
    add     hl,hl
    add     hl,hl
    dec     hl
    ld      a,e
    and     l
    ld      l,a
    ld      a,d
    and     h
    or      l
    jp      NZ,mf_al_no
    scf
    ret
mf_al_no:
    or      a
    ret

; Copy fat_left bytes. fat_write = 1 grows the file.
; *fat_out accumulates the count. Short write is FR_OK.
mf_transfer:
    call    fat_ldhl
    defw    fat_out
    ld      a,h
    or      l
    jp      Z,mf_tr_loop
    xor     a
    ld      (hl),a
    inc     hl
    ld      (hl),a
mf_tr_loop:
    call    fat_ldhl
    defw    fat_left
    ld      a,h
    or      l
    jp      Z,mf_tr_done
    ld      a,(fat_write)
    or      a
    jp      NZ,mf_tr_room
    call    mf_size_minus_fptr
    jp      C,mf_tr_done
    ld      a,(fat_remain)
    ld      hl,fat_remain+1
    or      (hl)
    inc     hl
    or      (hl)
    inc     hl
    or      (hl)
    jp      Z,mf_tr_done
mf_tr_room:
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_FPTR
    add     hl,de
    ld      a,(hl)
    ld      (fat_off),a
    inc     hl
    ld      a,(hl)
    and     1
    ld      (fat_off+1),a
    call    fat_ldhl
    defw    fat_off
    ld      de,512
    or      a
    ex      de,hl
    push    bc
    ld      bc,de
    call    mf_subhlbc
    pop     bc
    ex      de,hl
    call    fat_ldhl
    defw    fat_left
    push    hl
    or      a
    push    bc
    ld      bc,de
    call    mf_subhlbc
    pop     bc
    pop     hl
    jp      NC,mf_tr_clipr
    ld      e,l
    ld      d,h
mf_tr_clipr:
    ld      a,(fat_write)
    or      a
    jp      NZ,mf_tr_go
    ld      a,(fat_remain+2)
    ld      hl,fat_remain+3
    or      (hl)
    jp      NZ,mf_tr_go
    call    fat_ldhl
    defw    fat_remain
    or      a
    push    bc
    ld      bc,de
    call    mf_subhlbc
    pop     bc
    jp      NC,mf_tr_go
    ld      de,(fat_remain)
mf_tr_go:
    ld      (fat_hold),de
    push    de
    call    mf_sector_for_fptr
    jp      C,mf_tr_prep
    pop     de
    jp      mf_tr_stop
mf_tr_prep:
    call    mf_cache_prepare
    pop     de
    ld      (fat_hold),de
    jp      NC,mf_tr_seterr
    call    fat_ldhl
    defw    fat_off
    ld      bc,fat_filewin
    add     hl,bc
    ld      a,(fat_write)
    or      a
    jp      NZ,mf_tr_w
    ld      bc,(fat_hold)
    ld      de,(fat_user)
    call    mf_copy
    ld      (fat_user),de
    jp      mf_tr_adv
mf_tr_w:
    ld      de,hl
    call    fat_ldhl
    defw    fat_user
    ld      bc,(fat_hold)
    call    mf_copy
    call    fat_sthl
    defw    fat_user
    ld      a,1
    ld      (fat_file_dirty),a
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_FLAG
    add     hl,de
    ld      a,(hl)
    or      FA_DIRTY
    ld      (hl),a
mf_tr_adv:
    ld      bc,(fat_hold)
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_FPTR
    add     hl,de
    ld      a,(hl)
    add     a,c
    ld      (hl),a
    inc     hl
    ld      a,(hl)
    adc     a,b
    ld      (hl),a
    inc     hl
    ld      a,(hl)
    adc     a,0
    ld      (hl),a
    inc     hl
    ld      a,(hl)
    adc     a,0
    ld      (hl),a
    call    fat_ldhl
    defw    fat_left
    or      a
    call    mf_subhlbc
    call    fat_sthl
    defw    fat_left
    call    fat_ldhl
    defw    fat_out
    ld      a,h
    or      l
    jp      Z,mf_tr_size
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ex      de,hl
    add     hl,bc
    ex      de,hl
    ld      (hl),d
    dec     hl
    ld      (hl),e
mf_tr_size:
    ld      a,(fat_write)
    or      a
    jp      Z,mf_tr_loop
    call    mf_size_minus_fptr
    jp      NC,mf_tr_loop
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_FPTR
    add     hl,de
    ld      de,fat_hold
    ld      bc,4
    call    mf_copy
    ld      hl,fat_hold
    ld      de,(fat_fp)
    ld      a,e
    add     a,FIL_SIZE
    ld      e,a
    ld      a,d
    adc     a,0
    ld      d,a
    ld      bc,4
    call    mf_copy
    jp      mf_tr_loop
mf_tr_stop:
    ld      a,h
    or      l
    jp      Z,mf_tr_done
mf_tr_seterr:
    ld      a,l
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_ERR
    add     hl,de
    ld      (hl),a
    ld      l,a
    ld      h,0
    or      a
    ret
mf_tr_done:
    ld      a,(fat_write)
    or      a
    jp      Z,mf_ok
    call    fat_ldhl
    defw    fat_fp
    ld      de,FIL_FLAG
    add     hl,de
    ld      a,(hl)
    or      FA_MODIFIED
    ld      (hl),a
    jp      mf_ok

; Apply a chdir path to fat_cwd_str. HL is the path text.
; C on success. The cluster is the caller's job.
mf_cwd_apply:
    call    fat_sthl
    defw    fat_path
    call    mf_drive
    ret     NC
    ld      a,(hl)
    cp      '/'
    jp      Z,mf_cwd_abs
    cp      $5C
    jp      NZ,mf_cwd_rel
mf_cwd_abs:
    call    mf_cwd_reset
    call    mf_skip_slash
mf_cwd_rel:
    ld      a,(hl)
    or      a
    jp      Z,mf_ok
mf_cwd_loop:
    call    mf_comp
    ret     NC
    ld      (fat_kind),a
    ld      a,(hl)
    cp      '/'
    jp      Z,mf_cwd_sk
    cp      $5C
    jp      NZ,mf_cwd_kind
mf_cwd_sk:
    call    mf_skip_slash
mf_cwd_kind:
    ld      a,(fat_kind)
    or      a
    jp      Z,mf_cwd_name
    cp      2
    jp      Z,mf_cwd_pop
    jp      mf_cwd_next
mf_cwd_pop:
    push    hl
    call    mf_cwd_pop1
    pop     hl
mf_cwd_next:
    ld      a,(hl)
    or      a
    jp      NZ,mf_cwd_loop
    jp      mf_ok
mf_cwd_name:
    push    hl
    call    mf_cwd_push
    jp      NC,mf_cwd_namerr
    pop     hl
    jp      mf_cwd_next
mf_cwd_namerr:
    pop     de
    ret

mf_cwd_pop1:
    ld      hl,fat_cwd_str
mf_cwd_pend:
    ld      a,(hl)
    or      a
    jp      Z,mf_cwd_pback
    inc     hl
    jp      mf_cwd_pend
mf_cwd_pback:
    dec     hl
    ld      a,(hl)
    cp      '/'
    jp      NZ,mf_cwd_pback
    ld      de,fat_cwd_str+2
    ld      a,l
    cp      e
    jp      NZ,mf_cwd_pcut
    ld      a,h
    cp      d
    jp      NZ,mf_cwd_pcut
    inc     hl
mf_cwd_pcut:
    ld      (hl),0
    scf
    ret

mf_cwd_push:
    ld      hl,fat_cwd_str
mf_cwd_pend2:
    ld      a,(hl)
    or      a
    jp      Z,mf_cwd_pat
    inc     hl
    jp      mf_cwd_pend2
mf_cwd_pat:
    dec     hl
    ld      a,(hl)
    cp      '/'
    jp      Z,mf_cwd_copy
    inc     hl
    ld      (hl),'/'
    inc     hl
mf_cwd_copy:
    inc     hl
    ld      de,fat_name11
    ld      b,8
mf_cwd_b:
    ld      a,(de)
    cp      ' '
    jp      Z,mf_cwd_dot
    call    mf_cwd_put
    ret     NC
    inc     de
    dec     b
    jp      nz,mf_cwd_b
mf_cwd_dot:
    ld      de,fat_name11+8
    ld      a,(de)
    cp      ' '
    jp      Z,mf_cwd_nul
    ld      a,'.'
    call    mf_cwd_put
    ret     NC
    ld      b,3
mf_cwd_e:
    ld      a,(de)
    cp      ' '
    jp      Z,mf_cwd_nul
    call    mf_cwd_put
    ret     NC
    inc     de
    dec     b
    jp      nz,mf_cwd_e
mf_cwd_nul:
    ld      (hl),0
    scf
    ret

mf_cwd_put:
    push    de
    ld      de,fat_cwd_str+63
    or      a
    push    bc
    ld      bc,de
    call    mf_subhlbc
    pop     bc
    add     hl,de
    pop     de
    jp      NC,mf_cwd_long
    ld      (hl),a
    inc     hl
    scf
    ret
mf_cwd_long:
    ld      hl,FR_NOT_ENOUGH_CORE
    or      a
    ret

; HL = FILINFO. The directory entry is dir_ptr. Spaces leave the 8.3.
mf_fill_info:
    call    fat_sthl
    defw    fat_user
    call    fat_ldhl
    defw    dir_ptr
    ld      de,DIR_FileSize
    add     hl,de
    ld      de,(fat_user)
    ld      bc,4
    call    mf_copy
    call    fat_ldhl
    defw    dir_ptr
    ld      de,DIR_WrtDate
    add     hl,de
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    call    fat_ldhl
    defw    fat_user
    ld      bc,FI_DATE
    add     hl,bc
    ld      (hl),e
    inc     hl
    ld      (hl),d
    call    fat_ldhl
    defw    dir_ptr
    ld      de,DIR_WrtTime
    add     hl,de
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    call    fat_ldhl
    defw    fat_user
    ld      bc,FI_TIME
    add     hl,bc
    ld      (hl),e
    inc     hl
    ld      (hl),d
    call    fat_ldhl
    defw    dir_ptr
    ld      de,DIR_Attr
    add     hl,de
    ld      a,(hl)
    call    fat_ldhl
    defw    fat_user
    ld      de,FI_ATTR
    add     hl,de
    ld      (hl),a
    call    fat_ldhl
    defw    fat_user
    ld      de,FI_NAME
    add     hl,de
    ex      de,hl
    call    fat_ldhl
    defw    dir_ptr
    ld      b,8
mf_fn8:
    ld      a,(hl)
    inc     hl
    cp      ' '
    jp      Z,mf_fn8n
    cp      $05
    jp      NZ,mf_fn8s
    ld      a,b
    cp      8
    ld      a,$05
    jp      NZ,mf_fn8s
    ld      a,$E5
mf_fn8s:
    ld      (de),a
    inc     de
mf_fn8n:
    dec     b
    jp      nz,mf_fn8
    ld      c,0
    ld      b,3
mf_fn3:
    ld      a,(hl)
    inc     hl
    cp      ' '
    jp      Z,mf_fn3n
    push    af
    ld      a,c
    or      a
    jp      NZ,mf_fn3d
    ld      a,'.'
    ld      (de),a
    inc     de
    ld      c,1
mf_fn3d:
    pop     af
    ld      (de),a
    inc     de
mf_fn3n:
    dec     b
    jp      nz,mf_fn3
    xor     a
    ld      (de),a
    jp      mf_ok

; BC bytes from HL to DE. A count of 0 copies nothing.
mf_copy:
    ld      a,b
    or      c
    ret     Z
mf_copy_lp:
    ld      a,(hl)
    ld      (de),a
    inc     hl
    inc     de
    dec     bc
    ld      a,b
    or      c
    jp      NZ,mf_copy_lp
    ret


; HL = HL - BC. No borrow in. C is the borrow. Z is set when the
; result is 0. A, BC, and DE stay.
mf_subhlbc:
    push    de
    ld      d,a
    ld      a,l
    sub     c
    ld      l,a
    ld      a,h
    sbc     a,b
    ld      h,a
    jp      C,mf_subhlbc_c
    ld      a,h
    or      l
    ld      a,d
    pop     de
    ret

mf_subhlbc_c:
    ld      a,h
    or      l
    scf
    ld      a,d
    pop     de
    ret
