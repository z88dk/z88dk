;
; Shared file-layer helpers for the Z80 mini-FAT calls.
; The outline is ChaN ff.c for f_open, f_read, f_write, f_sync, and f_lseek.
; The outline also covers follow_path and validate.
; Argument order is the 80cc stack-pointer order.
; In that outline the caller cleans the stack.
; The delivered code calls this core.
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

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

; FATFS object for this volume. 0 means no object.
fat_fs:             defs 2
; Mount id copied into FIL_ID. 0 means no mount.
fat_mount_id:       defs 2
; Current directory text. A reset stores "0:/".
fat_cwd_str:        defs 64
; FIL used by the file calls.
fat_fp:             defs 2
; DIR pointer for the directory calls.
fat_dp:             defs 2
; Path text for the walk.
fat_path:           defs 2
; Open mode stored into FIL_FLAG.
fat_mode:           defs 1
; 1 when the path names the directory itself.
fat_noname:         defs 1
; 1 when a separator follows the last component.
fat_trail:          defs 1
; Attribute from the found directory entry.
fat_attr:           defs 1
; Component kind. 0 is a name, 1 is dot, and 2 is dot-dot.
fat_kind:           defs 1
; Cluster of the directory being walked.
fat_here:           defs 4
; Cluster of the parent directory.
fat_parent:         defs 4
; Sector of the found directory entry.
fat_dirsec:         defs 4
; Byte offset of the found directory entry.
fat_dirofs:         defs 2
; Folded 8.3 name padded with spaces.
fat_name11:         defs 11
; Scratch dword for a cluster or a size.
fat_hold:           defs 4
; File sector cache. One sector is 512 bytes.
fat_filewin:        defs 512
; LBA of the sector in the file cache.
fat_file_sect:      defs 4
; 1 when the file cache holds a sector.
fat_file_valid:     defs 1
; 1 when the file cache must be written.
fat_file_dirty:     defs 1
; FIL that owns the file cache. 0 means none.
fat_file_own:       defs 2
; LBA requested for the file cache.
fat_want:           defs 4
; User buffer for the byte copy.
fat_user:           defs 2
; Bytes still requested by the transfer.
fat_left:           defs 2
; Pointer to the caller's byte count, or 0 when absent.
fat_out:            defs 2
; 1 when the transfer may grow the file.
fat_write:          defs 1
; Sector number inside the current cluster.
fat_csect:          defs 1
; Byte offset inside the current sector.
fat_off:            defs 2
; File size minus fptr.
fat_remain:         defs 4
; Seek or expand length.
fat_seek:           defs 4
; Start cluster and offset for the cluster walk.
fat_cfo:            defs 8
; Scratch block for f_expand. The block is 16 bytes.
fat_zeros:          defs 16

SECTION code_lib

; Return success.
; Call. No arguments.
; Return. HL is 0. Carry is set.
; Clobber. HL and flags. A, BC, and DE stay.
mf_ok:
    ld      hl,0
    scf
    ret

; Return a failure.
; Call. A is the FRESULT.
; Return. L is A. H is 0. The or a clears carry.
; Clobber. HL and flags. A, BC, and DE stay.
mf_err:
    ld      l,a
    ld      h,0
    or      a
    ret

; Skip an optional drive prefix.
; Call. HL is 0 or a path.
; Return. Carry set means HL is past an optional "0:" prefix.
; Return. Carry clear means HL is FR_INVALID_DRIVE.
; Only drive 0 is valid. Any other digit and colon is rejected.
; A digit with no colon stays in the path.
; Clobber. AF, C, and HL. B and DE stay.
mf_drive:
    ld      a,h
    or      l
    jr      Z,mf_drive_bad          ;null path
    ld      a,(hl)
    cp      '0'
    jr      C,mf_drive_ok           ;byte is below 0, so it is not a drive
    cp      '9'+1
    jr      NC,mf_drive_ok          ;byte is above 9, so it is not a drive
    inc     hl
    ld      c,a
    ld      a,(hl)
    cp      ':'
    jr      NZ,mf_drive_back        ;digit is not followed by a colon
    inc     hl
    ld      a,c
    cp      '0'
    jr      Z,mf_drive_ok           ;drive 0 is the only drive
; Null path, or a drive other than 0.
mf_drive_bad:
    ld      hl,FR_INVALID_DRIVE
    or      a
    ret
; The digit is part of the name. Point at it again.
mf_drive_back:
    dec     hl
; The path is usable.
mf_drive_ok:
    scf
    ret

; Advance the mount id. The stored id is never 0.
; Call. No arguments.
; Return. HL is the new id.
; Writes. fat_mount_id.
; Clobber. AF and HL. BC and DE stay.
mf_bump_id:
    ld      hl,(fat_mount_id)
    inc     hl
    ld      a,h
    or      l
    jr      NZ,mf_bump_st           ;id did not wrap to 0
    inc     hl
; Store the id. A wrapped 0 was moved to 1.
mf_bump_st:
    ld      (fat_mount_id),hl
    ret

; Copy the volume into the FATFS object.
; Call. No arguments.
; Return. A null fat_fs returns HL 0 and carry clear.
; Return. Otherwise the object receives the type, drive 0, and the mount id.
; Carry stays clear. The stores do not change flags from the null test.
; Writes. FATFS type, drive, and id.
; Clobber. AF, DE, and HL. BC stays.
mf_publish:
    ld      hl,(fat_fs)
    ld      a,h
    or      l
    ret     Z                       ;no FATFS object
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

; Set the directory text to the root.
; Call. No arguments.
; Return. fat_cwd_str holds "0:/" and a terminating 0. HL points at that 0.
; Writes. fat_cwd_str.
; Clobber. HL. AF, BC, and DE stay.
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

; Mount when fat_fs is set and the volume type is still 0.
; Call. No arguments.
; Return. Carry set means HL is 0.
; Return. No FATFS object returns FR_NOT_ENABLED with carry clear.
; Return. A failed mount returns L as 1, 3, 13, or 19 with carry clear.
; 1 is a sector error. 3 is not ready. 13 is no filesystem.
; 19 is a cluster size of 64 KiB or more.
; Writes. A new mount updates the id, the object, the directory text, and the cache flags.
; Clobber. AF, BC, DE, and HL.
mf_ensure:
    ld      a,(_cpm_fat_vol)
    or      a
    jp      NZ,mf_ok                ;volume type is already set
    ld      hl,(fat_fs)
    ld      a,h
    or      l
    jr      Z,mf_ensure_off         ;no FATFS object
    call    fat_mount
    jr      NC,mf_ensure_fail       ;mount failed
    call    mf_bump_id
    call    mf_publish
    call    mf_cwd_reset
    xor     a
    ld      (fat_file_valid),a
    ld      (fat_file_dirty),a
    jp      mf_ok                   ;mount succeeded
; Mount failed. L is already 1, 3, 13, or 19.
mf_ensure_fail:
    ld      a,l                     ;L is 1, 3, 13, or 19
    jp      mf_err                  ;pass that L to mf_err
; No FATFS object is registered.
mf_ensure_off:
    ld      hl,FR_NOT_ENABLED
    or      a
    ret

; Test one path byte for the end of a component.
; Call. HL points at the byte.
; Return. Carry set means the byte is 0, slash, or backslash.
; Return. Carry clear means A is some other byte.
; Clobber. AF. BC, DE, and HL stay.
mf_at_end:
    ld      a,(hl)
    or      a
    jr      Z,mf_at_yes             ;path byte is 0
    cp      '/'
    jr      Z,mf_at_yes             ;path byte is slash
    cp      $5C
    jr      Z,mf_at_yes             ;path byte is backslash
    or      a
    ret
; The byte ends the component.
mf_at_yes:
    scf
    ret

; Move past a run of separators.
; Call. HL points at a path byte.
; Return. HL is past every slash and backslash. Carry is not a result.
; Clobber. AF and HL. BC and DE stay.
mf_skip_slash:
    ld      a,(hl)
    cp      '/'
    jr      Z,mf_skip1              ;slash
    cp      $5C
    ret     NZ                      ;not a separator. Flags come from the compare with backslash
; Consume this separator and keep scanning.
mf_skip1:
    inc     hl
    jr      mf_skip_slash           ;more separators may follow

; Fold one letter to upper case.
; Call. A is a byte.
; Return. A is folded from a-z to A-Z. Any other byte stays.
; Clobber. AF. BC, DE, and HL stay.
mf_fold:
    cp      'a'
    ret     C                       ;below a
    cp      'z'+1
    ret     NC                      ;above z
    sub     32                      ;fold a lower-case letter to upper case
    ret

; Test one byte for an 8.3 body.
; Call. A is a byte.
; Return. Carry set means the byte may sit in the body.
; Return. Carry clear rejects the byte.
; Clobber. AF. BC, DE, and HL stay.
mf_okchar:
    cp      '0'
    jr      C,mf_ok_sym             ;below 0, so test the marks
    cp      '9'+1
    jr      C,mf_ok_yes             ;digit
    cp      'A'
    jr      C,mf_ok_no              ;gap before A
    cp      'Z'+1
    jr      C,mf_ok_yes             ;upper-case letter
    cp      'a'
    jr      C,mf_ok_no              ;gap before a
    cp      'z'+1
    jr      C,mf_ok_yes             ;lower-case letter
; The byte is below 0 or above z. Test the allowed marks.
mf_ok_sym:
    cp      '_'
    jr      Z,mf_ok_yes             ;underscore is allowed
    cp      '-'
    jr      Z,mf_ok_yes             ;hyphen is allowed
    cp      '!'
    jr      Z,mf_ok_yes             ;exclamation is allowed
    cp      '#'
    jr      Z,mf_ok_yes             ;hash is allowed
    cp      '$'
    jr      Z,mf_ok_yes             ;dollar is allowed
    cp      '%'
    jr      Z,mf_ok_yes             ;percent is allowed
    cp      '&'
    jr      Z,mf_ok_yes             ;ampersand is allowed
; The byte cannot sit in an 8.3 body.
mf_ok_no:
    or      a
    ret
; The byte can sit in an 8.3 body.
mf_ok_yes:
    scf
    ret

; Parse one path component into an 8.3 name.
; Call. HL points at the component.
; Return. Carry set and A = 0 means fat_name11 holds the folded name. HL is the next byte.
; Return. Carry set and A = 1 means dot. A = 2 means dot-dot.
; Return. Carry clear and HL = FR_INVALID_NAME rejects the component.
; Return. Carry clear and A = 0 means there is no component. HL stays on that byte.
; Writes. A normal name fills fat_name11 with spaces in the gaps.
; Clobber. AF, BC, DE, and HL.
mf_comp:
    ld      a,(hl)
    or      a
    jp      Z,mf_comp_none          ;end of the path
    cp      '/'
    jp      Z,mf_comp_none          ;slash, so there is no component
    cp      $5C
    jp      Z,mf_comp_none          ;backslash, so there is no component
    cp      '.'
    jr      NZ,mf_comp_name         ;not a dot name
    inc     hl
    ld      a,(hl)
    cp      '.'
    jr      NZ,mf_comp_one          ;second byte is not dot
    inc     hl
    call    mf_at_end
    jp      NC,mf_badname           ;dot-dot does not end the component
    ld      a,2
    scf
    ret
; A single dot must end the component.
mf_comp_one:
    call    mf_at_end
    jp      NC,mf_badname           ;dot does not end the component
    ld      a,1
    scf
    ret
; There is no component at this byte.
mf_comp_none:
    xor     a
    or      a
    ret
; The component is not a legal 8.3 name.
mf_badname:
    ld      hl,FR_INVALID_NAME
    or      a
    ret
; Fold one 8.3 name into fat_name11.
mf_comp_name:
    push    hl
    ld      hl,fat_name11
    ld      b,11
    ld      a,' '
; Pad the 11-byte name with spaces.
mf_cfill:
    ld      (hl),a
    inc     hl
    djnz    mf_cfill                ;pad bytes remain
    pop     hl
    ld      de,fat_name11
    ld      b,8
; Take the next body byte, up to 8.
mf_cn:
    ld      a,(hl)
    call    mf_at_end
    jr      C,mf_comp_done          ;body has ended
    cp      '.'
    jr      Z,mf_cdot               ;extension dot
    call    mf_okchar
    jr      NC,mf_badname           ;body byte is not legal
    call    mf_fold
    ld      (de),a
    inc     de
    inc     hl
    djnz    mf_cn                   ;body bytes remain
    ld      a,(hl)
    call    mf_at_end
    jr      C,mf_comp_done          ;name ended after the body
    cp      '.'
    jr      NZ,mf_badname           ;body is longer than 8 and has no dot
; The dot starts the extension.
mf_cdot:
    inc     hl
    ld      de,fat_name11+8
    ld      b,3
; Take the next extension byte, up to 3.
mf_ce:
    ld      a,(hl)
    call    mf_at_end
    jr      C,mf_comp_done          ;extension has ended
    cp      '.'
    jr      Z,mf_badname            ;a second dot is illegal
    call    mf_okchar
    jr      NC,mf_badname           ;extension byte is not legal
    call    mf_fold
    ld      (de),a
    inc     de
    inc     hl
    djnz    mf_ce                   ;extension bytes remain
    ld      a,(hl)
    call    mf_at_end
    jr      NC,mf_badname           ;extension is longer than 3
; The name fits. A is 0 and carry is set.
mf_comp_done:
    xor     a
    scf
    ret

; Find fat_name11 in the directory at fat_here.
; Call. fat_here is the directory cluster. fat_name11 is the 8.3 name.
; Return. Carry set means the name was found and HL is 0.
; Return. Carry clear and HL = FR_NO_FILE means the name is absent.
; Return. Carry clear and HL = FR_DISK_ERR means the sector was not read.
; Clobber. AF, BC, DE, and HL.
mf_lookup_here:
    ld      de,(fat_here)
    ld      bc,(fat_here+2)
    ld      hl,0
    call    dir_sdi
    jr      NC,mf_lu_disk           ;directory did not open
    ld      hl,fat_name11
    call    dir_find
    ret     C                       ;name was found
    jr      NZ,mf_lu_disk           ;directory sector was not read
    ld      hl,FR_NO_FILE
    or      a
    ret
; The directory sector was not read.
mf_lu_disk:
    ld      hl,FR_DISK_ERR
    or      a
    ret

; Remember the found directory entry.
; Call. dir_sect, dir_ofs, and dir_ptr describe the entry.
; Return. fat_dirsec, fat_dirofs, and fat_attr copy that entry.
; The add computes dir_ptr plus DIR_Attr.
; Carry at the return is that add.
; Writes. fat_dirsec, fat_dirofs, and fat_attr.
; Clobber. AF, DE, and HL. BC stays.
mf_save_dir:
    ld      hl,(dir_sect)
    ld      (fat_dirsec),hl
    ld      hl,(dir_sect+2)
    ld      (fat_dirsec+2),hl
    ld      hl,(dir_ofs)
    ld      (fat_dirofs),hl
    ld      hl,(dir_ptr)
    ld      de,DIR_Attr
    add     hl,de                   ;dir_ptr plus DIR_Attr
    ld      a,(hl)
    ld      (fat_attr),a
    ret

; Copy the found cluster into fat_here.
; Call. fat_found_sclust holds the cluster.
; Return. fat_here matches that cluster.
; Writes. fat_here.
; Clobber. HL. AF, BC, and DE stay.
mf_take_found:
    ld      hl,(fat_found_sclust)
    ld      (fat_here),hl
    ld      hl,(fat_found_sclust+2)
    ld      (fat_here+2),hl
    ret

; Move fat_here to its parent. The root stays the root.
; Call. fat_here is the current directory.
; Return. Carry is set. fat_here is the parent, or 0 at the root.
; A failed lookup of dot-dot also becomes the root.
; Writes. fat_here. The lookup name is dot-dot padded with spaces.
; Clobber. AF, BC, DE, and HL.
mf_dotdot:
    ld      a,(fat_here)
    ld      hl,fat_here+1
    or      (hl)
    inc     hl
    or      (hl)
    inc     hl
    or      (hl)
    jr      Z,mf_dot_root           ;already at the root
    ld      hl,fat_name11
    ld      (hl),'.'
    inc     hl
    ld      (hl),'.'
    inc     hl
    ld      b,9
    ld      a,' '
; Pad the rest of the dot-dot name with spaces.
mf_ddsp:
    ld      (hl),a
    inc     hl
    djnz    mf_ddsp                 ;pad bytes remain
    call    mf_lookup_here
    jr      NC,mf_dot_root          ;dot-dot was not found, so use the root
    call    mf_take_found
    scf
    ret
; Use cluster 0. The root has no parent entry.
mf_dot_root:
    ld      hl,0
    ld      (fat_here),hl
    ld      (fat_here+2),hl
    scf
    ret

; Return FR_NO_PATH. A parent or a trailing separator failed.
mf_nopath:
    ld      hl,FR_NO_PATH
    or      a
    ret

; The path names the directory itself. fat_noname becomes 1.
mf_noname:
    ld      a,AM_DIR
    ld      (fat_attr),a
    ld      a,1
    ld      (fat_noname),a
    jp      mf_ok                   ;the path names the directory itself

; Walk one path.
; Call. HL is the path text.
; Return. Carry set leaves the object cluster in fat_here.
; fat_noname is 1 when the path names that directory itself.
; Return. Carry clear and HL = FR_NO_FILE means only the final name is missing.
; fat_parent is that directory. fat_name11 is the missing 8.3 name.
; Return. Any other carry-clear exit leaves the FRESULT in HL.
; A missing parent is FR_NO_PATH. It is not a missing final name.
; A middle dot stays in the directory. A middle dot-dot moves to the parent.
; A final dot or dot-dot uses the directory-itself exit.
; The 8.3 name is folded to A-Z.
; A path byte of $E5 is not a legal 8.3 character.
; A stored first byte of $05 compares as $E5.
; Clobber. AF, BC, DE, and HL.
mf_follow:
    ld      (fat_path),hl
    xor     a
    ld      (fat_noname),a
    ld      (fat_trail),a
    call    mf_drive
    ret     NC                      ;HL is already FR_INVALID_DRIVE
    ld      a,(hl)
    cp      '/'
    jr      Z,mf_abs                ;path starts at the root
    cp      $5C
    jr      Z,mf_abs                ;path starts at the root
    ld      de,(fat_cwd)
    ld      bc,(fat_cwd+2)
    jr      mf_sethere              ;use the current directory cluster
; Start at the root and skip the leading separators.
mf_abs:
    ld      de,0
    ld      bc,0
    call    mf_skip_slash
; Remember this directory cluster.
mf_sethere:
    ld      (fat_here),de
    ld      (fat_here+2),bc
    ld      a,(hl)
    or      a
    jp      Z,mf_noname             ;empty path names the directory itself
; Save the parent and parse the next component.
mf_floop:
    ld      de,(fat_here)
    ld      (fat_parent),de
    ld      de,(fat_here+2)
    ld      (fat_parent+2),de
    call    mf_comp
    ret     NC                      ;HL is already FR_INVALID_NAME
    ld      (fat_kind),a
    ld      a,(hl)
    cp      '/'
    jr      Z,mf_saw_slash          ;a separator follows this component
    cp      $5C
    jr      NZ,mf_no_slash          ;this component is final
; A separator follows, so this component is not final.
mf_saw_slash:
    call    mf_skip_slash
    ld      a,1
    ld      (fat_trail),a
    jr      mf_more                 ;the separator flag is stored
; No separator follows, so this component is final.
mf_no_slash:
    xor     a
    ld      (fat_trail),a
; Choose a middle component or the final component.
mf_more:
    ld      a,(hl)
    or      a
    jr      Z,mf_last               ;no further component
    ld      a,(fat_kind)
    or      a
    jr      Z,mf_mid_name           ;middle component is a real name
    cp      1
    jr      Z,mf_floop              ;middle dot stays in this directory
    push    hl
    call    mf_dotdot
    pop     hl
    jp      mf_floop                ;dot-dot updated the directory
; Look up a name that still has another component after it.
mf_mid_name:
    push    hl
    call    mf_lookup_here
    jr      NC,mf_mid_err           ;middle name was not found
    call    mf_save_dir
    ld      a,(fat_attr)
    and     AM_DIR
    jr      Z,mf_mid_np             ;middle name is not a directory
    call    mf_take_found
    pop     hl
    jp      mf_floop                ;child directory is now fat_here
; A middle name is not a directory, so the parent path fails.
mf_mid_np:
    pop     de
    jp      mf_nopath               ;a middle name must be a directory
; The middle lookup failed.
mf_mid_err:
    pop     de
; A missing middle name is FR_NO_PATH. A disk error stays.
mf_mid_miss:
    ld      a,l
    cp      FR_NO_FILE
    jp      NZ,mf_ret_hl            ;keep a disk error
    jp      mf_nopath               ;a missing middle name is FR_NO_PATH
; Dispatch the final component.
mf_last:
    ld      a,(fat_kind)
    or      a
    jr      Z,mf_last_name          ;final component is a real name
    cp      1
    jp      Z,mf_noname             ;final dot names this directory
    call    mf_dotdot
    jp      mf_noname               ;final dot-dot names the parent
; Look up the final 8.3 name.
mf_last_name:
    call    mf_lookup_here
    jr      NC,mf_last_miss         ;final name was not found
    call    mf_save_dir
    call    mf_take_found
    ld      a,(fat_trail)
    or      a
    jp      Z,mf_ok                 ;found, and no separator follows
    ld      a,(fat_attr)
    and     AM_DIR
    jp      Z,mf_nopath             ;trailing separator on a file
    jp      mf_noname               ;trailing separator on a directory
; A missing final name is FR_NO_FILE unless a separator follows it.
mf_last_miss:
    ld      a,l
    cp      FR_NO_FILE
    jp      NZ,mf_ret_hl            ;keep a disk error
    ld      a,(fat_trail)
    or      a
    jp      NZ,mf_nopath            ;trailing separator on a missing name
    ld      hl,FR_NO_FILE
    or      a
    ret

; Keep the FRESULT already in HL and clear carry.
mf_ret_hl:
    or      a
    ret

; Accept a FIL that still belongs to this mount.
; Call. HL is a FIL pointer, or 0.
; Return. Carry set means HL is 0. The id matches and FIL_ERR is 0.
; Return. A null pointer, a zero id, a stale id, or no volume returns FR_INVALID_OBJECT.
; Return. A non-zero FIL_ERR returns that byte in L with carry clear.
; FIL_ID is offset 0. FIL_FLAG is offset 2 and is not read. FIL_ERR is offset 3.
; Writes. A non-null HL is stored in fat_fp before the tests.
; Clobber. AF, DE, and HL. BC stays.
mf_fil_check:
    ld      a,h
    or      l
    jr      Z,mf_fil_bad            ;no FIL pointer
    ld      (fat_fp),hl
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      a,d
    or      e
    jr      Z,mf_fil_bad            ;FIL_ID is 0
    ld      hl,(fat_mount_id)
    or      a
    sbc     hl,de
    jr      NZ,mf_fil_bad           ;FIL_ID is not the mount id
    ld      a,(_cpm_fat_vol)
    or      a
    jr      Z,mf_fil_bad            ;no volume is registered
    ld      hl,(fat_fp)
    ld      de,FIL_ERR
    add     hl,de
    ld      a,(hl)
    or      a
    jp      NZ,mf_err               ;FIL_ERR is already the FRESULT
    jp      mf_ok                   ;FIL matches this mount and FIL_ERR is 0
; Return FR_INVALID_OBJECT.
mf_fil_bad:
    ld      hl,FR_INVALID_OBJECT
    or      a
    ret

; Set the archive bit on the directory entry.
; Call. dir_ptr points at the entry.
; Return. The attribute becomes AM_ARC. fat_wflag and fat_attr match it.
; The add computes dir_ptr plus DIR_Attr.
; Carry at the return is that add.
; Writes. The attribute byte, fat_wflag, and fat_attr.
; Clobber. AF, DE, and HL. BC stays.
mf_mark_arc:
    ld      hl,(dir_ptr)
    ld      de,DIR_Attr
    add     hl,de                   ;dir_ptr plus DIR_Attr
    ld      (hl),AM_ARC
    ld      a,1
    ld      (fat_wflag),a
    ld      a,AM_ARC
    ld      (fat_attr),a
    ret

; Fill the FIL from the found entry and the open mode.
; Call. fat_fp is the FIL. The found size, cluster, sector, offset, attribute, and mode are set.
; Return. Carry set means HL is 0. The FIL is bound to this mount.
; Writes. The FIL from FIL_ID through FIL_DIROFS. The pointer and error start at 0.
; Clobber. AF, BC, DE, and HL.
mf_bind:
    ld      hl,(fat_fp)
    ld      b,FIL_BYTES
    xor     a
; Clear the next FIL byte.
mf_bz:
    ld      (hl),a
    inc     hl
    djnz    mf_bz                   ;FIL bytes remain
    ld      hl,(fat_fp)
    ld      de,(fat_mount_id)
    ld      (hl),e
    inc     hl
    ld      (hl),d
    ld      hl,(fat_fp)
    ld      de,FIL_FLAG
    add     hl,de
    ld      a,(fat_mode)
    ld      (hl),a
    ld      hl,(fat_fp)
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
    ldir
    ld      hl,fat_found_sclust
    ld      de,(fat_fp)
    ld      a,e
    add     a,FIL_SCLUST
    ld      e,a
    ld      a,d
    adc     a,0
    ld      d,a
    ld      bc,4
    ldir
    ld      hl,(fat_fp)
    ld      de,FIL_SCLUST
    add     hl,de
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    inc     hl
    ld      c,(hl)
    inc     hl
    ld      b,(hl)
    ld      hl,(fat_fp)
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
    ldir
    ld      hl,(fat_fp)
    ld      de,FIL_DIROFS
    add     hl,de
    ld      de,(fat_dirofs)
    ld      (hl),e
    inc     hl
    ld      (hl),d
    jp      mf_ok                   ;FIL fields are filled

; Clear the file length and free its chain.
; Call. fat_fp is the FIL.
; Return. Carry set means HL is 0. FA_MODIFIED is set.
; Return. Carry clear means HL is FR_DISK_ERR.
; The directory entry is cleared in the window before remove_chain runs.
; A start cluster of 0 does not free a chain.
; This path does not sync the window.
; Writes. The directory entry, fat_wflag, and the FIL length and flag.
; Clobber. AF, BC, DE, and HL.
mf_trunc:
    ld      hl,(fat_fp)
    ld      de,FIL_SCLUST
    add     hl,de
    ld      de,fat_hold
    ld      bc,4
    ldir
    call    mf_load_dir
    jr      NC,mf_trunc_disk        ;directory sector was not read
    call    mf_zero_alloc
    ld      a,(fat_hold)
    ld      hl,fat_hold+1
    or      (hl)
    inc     hl
    or      (hl)
    inc     hl
    or      (hl)
    jr      Z,mf_trunc_mod          ;start cluster is 0, so there is no chain
    ld      de,(fat_hold)
    ld      bc,(fat_hold+2)
    call    remove_chain
    jr      NC,mf_trunc_disk        ;chain was not freed
; The entry is clear. Set FA_MODIFIED.
mf_trunc_mod:
    ld      hl,(fat_fp)
    ld      de,FIL_FLAG
    add     hl,de
    ld      a,(hl)
    or      FA_MODIFIED
    ld      (hl),a
    jp      mf_ok                   ;length is 0 and the chain step finished
; The window was not read, or the chain was not freed.
mf_trunc_disk:
    ld      hl,FR_DISK_ERR
    or      a
    ret

; Zero the entry cluster and the file length.
; Call. dir_ptr is the entry. fat_fp is the FIL.
; Return. The entry cluster and size are 0. The attribute is AM_ARC.
; The 16 bytes from FIL_FPTR are 0. That span is the pointer, size, and both clusters.
; Writes. The entry, fat_wflag, FIL_ATTR, and those 16 bytes.
; Clobber. AF, BC, DE, and HL.
mf_zero_alloc:
    ld      hl,(dir_ptr)
    ld      de,DIR_ClusHI
    add     hl,de
    xor     a
    ld      (hl),a
    inc     hl
    ld      (hl),a
    ld      hl,(dir_ptr)
    ld      de,DIR_ClusLO
    add     hl,de
    xor     a
    ld      (hl),a
    inc     hl
    ld      (hl),a
    ld      hl,(dir_ptr)
    ld      de,DIR_FileSize
    add     hl,de
    ld      b,4
    xor     a
; Clear the next size byte.
mf_za4:
    ld      (hl),a
    inc     hl
    djnz    mf_za4                  ;size bytes remain
    ld      hl,(dir_ptr)
    ld      de,DIR_Attr
    add     hl,de
    ld      (hl),AM_ARC
    ld      a,1
    ld      (fat_wflag),a
    ld      hl,(fat_fp)
    ld      de,FIL_ATTR
    add     hl,de
    ld      (hl),AM_ARC
    ld      hl,(fat_fp)
    ld      de,FIL_FPTR
    add     hl,de
    xor     a
    ld      b,16
; Clear the next byte of the pointer and the clusters.
mf_zf:
    ld      (hl),a
    inc     hl
    djnz    mf_zf                   ;pointer and cluster bytes remain
    ret

; Load the FIL directory entry into the window.
; Call. fat_fp holds the entry sector and offset.
; Return. Carry set means dir_ptr addresses that entry.
; Return. Carry clear means the sector was not read. HL is not a FRESULT.
; Clobber. AF, BC, DE, and HL.
mf_load_dir:
    ld      hl,(fat_fp)
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
    ret     NC                      ;sector was not read. HL is not a FRESULT
    ld      hl,(fat_fp)
    ld      de,FIL_DIROFS
    add     hl,de
    ld      e,(hl)
    inc     hl
    ld      a,(hl)
    and     1                       ;keep the offset inside the 512-byte sector
    ld      d,a
    ld      hl,fatwin
    add     hl,de
    ld      (dir_ptr),hl
    scf
    ret

; Copy the FIL cluster and size into the directory entry.
; Call. dir_ptr is the entry. fat_fp holds the cluster and the size.
; Return. The entry holds that cluster, that size, and the archive bit.
; A volume that is not FAT32 stores 0 in the high cluster word.
; This path does not set fat_wflag.
; Writes. The directory entry in the window.
; Clobber. AF, BC, DE, and HL.
mf_write_entry:
    ld      hl,(fat_fp)
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
    ld      hl,(dir_ptr)
    ld      bc,DIR_ClusLO
    add     hl,bc
    ld      (hl),e
    inc     hl
    ld      (hl),d
    pop     bc
    ld      a,(_cpm_fat_vol)
    cp      FS_FAT32
    jr      Z,mf_we_hi              ;FAT32 keeps the high cluster word
    ld      bc,0
; Store the high cluster word. A type other than FAT32 stored 0.
mf_we_hi:
    ld      hl,(dir_ptr)
    ld      de,DIR_ClusHI
    add     hl,de
    ld      (hl),c
    inc     hl
    ld      (hl),b
    ld      hl,(dir_ptr)
    ld      de,DIR_FileSize
    add     hl,de
    ex      de,hl
    ld      hl,(fat_fp)
    ld      bc,FIL_SIZE
    add     hl,bc
    ld      bc,4
    ldir
    ld      hl,(dir_ptr)
    ld      de,DIR_Attr
    add     hl,de
    ld      a,(hl)
    or      AM_ARC
    ld      (hl),a
    ret

; Flush the file cache and write a modified directory entry.
; Call. fat_fp is the FIL.
; Return. Carry set means HL is 0.
; Return. Carry clear means HL is FR_DISK_ERR.
; Every call flushes the file cache first.
; The call writes the directory entry only when FA_MODIFIED is set.
; This call does not free the chain.
; A successful entry write clears FA_MODIFIED and FA_DIRTY.
; Writes. The directory entry, fat_wflag, and FIL_FLAG.
; Clobber. AF, BC, DE, and HL.
mf_sync_fil:
    call    mf_flush
    ret     NC                      ;file cache was not written. HL is FR_DISK_ERR
    ld      hl,(fat_fp)
    ld      de,FIL_FLAG
    add     hl,de
    ld      a,(hl)
    and     FA_MODIFIED
    jp      Z,mf_ok                 ;directory entry is not modified
    call    mf_load_dir
    jr      NC,mf_sync_disk         ;directory sector was not read
    call    mf_write_entry
    ld      a,1
    ld      (fat_wflag),a
    call    fat_sync_window
    jr      NC,mf_sync_disk         ;window was not written
    ld      hl,(fat_fp)
    ld      de,FIL_FLAG
    add     hl,de
    ld      a,(hl)
    and     FA_MODE_MASK
    ld      (hl),a
    jp      mf_ok                   ;directory entry is on the disk
; The cache, the directory sector, or the window write failed.
mf_sync_disk:
    ld      hl,FR_DISK_ERR
    or      a
    ret

; Write the file cache when it is dirty.
; Call. No arguments.
; Return. Carry set means the file cache is clean.
; Return. Carry clear means HL is FR_DISK_ERR.
; A clean cache does not write. A dirty cache writes fat_file_sect.
; The owning FIL loses FA_DIRTY after a successful write.
; Writes. fat_file_dirty and the owner's FIL_FLAG.
; Clobber. AF, BC, DE, and HL.
mf_flush:
    ld      a,(fat_file_dirty)
    or      a
    jr      Z,mf_flush_ok           ;file cache is already clean
    ld      de,(fat_file_sect)
    ld      bc,(fat_file_sect+2)
    ld      hl,fat_filewin
    call    ide_write_sector
    jr      NC,mf_flush_disk        ;file sector was not written
    xor     a
    ld      (fat_file_dirty),a
    ld      hl,(fat_file_own)
    ld      a,h
    or      l
    jr      Z,mf_flush_ok           ;no FIL owns the cache
    ld      de,FIL_FLAG
    add     hl,de
    ld      a,(hl)
    and     $7F                     ;clear the FA_DIRTY bit
    ld      (hl),a
; The file cache needs no write.
mf_flush_ok:
    scf
    ret
; The file sector was not written.
mf_flush_disk:
    ld      hl,FR_DISK_ERR
    or      a
    ret

; Compare BCDE with the cached file sector.
; Call. BCDE is an LBA.
; Return. Z means the cache holds that sector.
; Return. NZ means it does not. Carry is not a result.
; Clobber. AF. BC, DE, and HL stay.
mf_same_sect:
    ld      a,(fat_file_valid)
    or      a
    jr      Z,mf_same_no            ;file cache is not valid
    ld      a,(fat_file_sect)
    cp      e
    ret     NZ                      ;LBA byte 0 differs
    ld      a,(fat_file_sect+1)
    cp      d
    ret     NZ                      ;LBA byte 1 differs
    ld      a,(fat_file_sect+2)
    cp      c
    ret     NZ                      ;LBA byte 2 differs
    ld      a,(fat_file_sect+3)
    cp      b
    ret                             ;Z when the high LBA byte matches
; The file cache does not hold a sector.
mf_same_no:
    or      1                       ;force NZ. The cache holds no sector
    ret

; Subtract fptr from the file size.
; Call. fat_fp is the FIL.
; Return. fat_remain is that difference. Carry set means fptr is above the size.
; Writes. fat_remain and fat_hold.
; Clobber. AF, BC, DE, and HL.
mf_size_minus_fptr:
    ld      hl,(fat_fp)
    ld      de,FIL_SIZE
    add     hl,de
    ld      de,fat_hold
    ld      bc,4
    ldir
    ld      hl,(fat_fp)
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

; Test a cluster link for the folded end mark.
; Call. BCDE is the link.
; Return. Carry set means the link is $0FFFFFFF.
; Return. Carry clear means it is not.
; Clobber. AF. BC, DE, and HL stay.
mf_is_eoc:
    ld      a,b
    cp      $0F                     ;high byte of the folded end mark
    jr      NZ,mf_eoc_no            ;high byte is not $0F
    ld      a,c
    and     d
    and     e
    inc     a
    jr      NZ,mf_eoc_no            ;link is not $0FFFFFFF
    scf
    ret
; The link is not the folded end mark.
mf_eoc_no:
    or      a
    ret

; Store BCDE into FIL_CLUST.
; Call. BCDE is the cluster. fat_fp is the FIL.
; Return. FIL_CLUST holds that cluster.
; The add computes the FIL address plus FIL_CLUST.
; Carry at the return is that add.
; Writes. FIL_CLUST.
; Clobber. HL and flags. A, BC, and DE stay.
mf_store_clust:
    push    de
    push    bc
    ld      hl,(fat_fp)
    ld      de,FIL_CLUST
    add     hl,de                   ;FIL address plus FIL_CLUST
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

; Store BCDE into FIL_SCLUST and FIL_CLUST.
; Call. BCDE is the cluster. fat_fp is the FIL.
; Return. Both fields hold that cluster.
; Carry at the return comes from the add in mf_store_clust.
; Writes. FIL_SCLUST and FIL_CLUST.
; Clobber. HL and flags. A, BC, and DE stay.
mf_store_sclust:
    push    de
    push    bc
    ld      hl,(fat_fp)
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

; Resolve the sector LBA for the current fptr.
; Call. fat_fp is the FIL. fat_write is 1 when a missing cluster may be created.
; Return. Carry set means BCDE is that LBA.
; Return. Carry clear and HL = 0 means create_chain failed.
; The caller treats HL = 0 as a full disk.
; Return. Carry clear and HL = FR_DISK_ERR means the FAT entry was not read.
; Return. Carry clear and HL = FR_INT_ERR means the offset has no sector.
; Writes. fat_off, fat_csect, and on a stretch the FIL cluster fields.
; Clobber. AF, BC, DE, and HL.
mf_sector_for_fptr:
    ld      hl,(fat_fp)
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
    and     1                       ;keep the offset inside the 512-byte sector
    ld      (fat_off+1),a
    ld      e,d
    ld      d,c
    ld      c,b
    ld      b,0
    srl     c
    rr      d
    rr      e
    ld      a,(_cpm_fat_vol+1)
    dec     a                       ;csize minus 1 is the sector mask
    and     e                       ;select the sector inside the cluster
    ld      (fat_csect),a
    ld      a,(fat_off)
    ld      hl,fat_off+1
    or      (hl)
    jp      NZ,mf_sec_same          ;fptr is inside a sector
    ld      hl,(fat_fp)
    ld      de,FIL_FPTR
    add     hl,de
    ld      a,(hl)
    inc     hl
    or      (hl)
    inc     hl
    or      (hl)
    inc     hl
    or      (hl)
    jr      NZ,mf_sec_next          ;fptr is not 0
    ld      hl,(fat_fp)
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
    jr      NZ,mf_sec_have          ;start cluster is present
    ld      a,(fat_write)
    or      a
    jp      Z,mf_sec_int            ;a read of an empty file has no cluster
    ld      de,0
    ld      bc,0
    call    create_chain
    jr      NC,mf_sec_full          ;create_chain failed
    call    mf_store_sclust
    jr      mf_sec_lba              ;the new start cluster has an LBA
; fptr is on a sector boundary after the start of the file.
mf_sec_next:
    ld      a,(fat_csect)
    or      a
    jr      NZ,mf_sec_same          ;still inside this cluster
    ld      hl,(fat_fp)
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
    jr      NC,mf_sec_popdisk       ;FAT entry was not read
    call    mf_is_eoc
    jr      NC,mf_sec_popnew        ;link is not the end mark
    pop     de
    pop     bc
    ld      a,(fat_write)
    or      a
    jp      Z,mf_sec_int            ;a read hit the end of the chain
    call    create_chain
    jr      NC,mf_sec_full          ;create_chain failed
    call    mf_store_clust
    jr      mf_sec_lba              ;the new cluster has an LBA
; The FAT entry was not read. Drop the saved cluster.
mf_sec_popdisk:
    pop     de
    pop     bc
    ld      hl,FR_DISK_ERR
    or      a
    ret
; The link is the next cluster. Drop the saved cluster.
mf_sec_popnew:
    pop     hl
    pop     hl
    call    mf_store_clust
    jr      mf_sec_lba              ;the next cluster has an LBA
; The file already has a start cluster.
mf_sec_have:
    call    mf_store_clust
    jr      mf_sec_lba              ;the start cluster has an LBA
; Stay on the cluster already stored in the FIL.
mf_sec_same:
    ld      hl,(fat_fp)
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
    jp      Z,mf_sec_int            ;stored cluster is 0
; Add the sector-in-cluster to the cluster LBA.
mf_sec_lba:
    call    clst2sect
    jr      NC,mf_sec_int           ;cluster has no sector
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
; create_chain failed. Return HL 0 so the caller sees a full disk.
mf_sec_full:
    ld      hl,0
    or      a
    ret
; Return FR_INT_ERR.
; A sector path found no cluster. A failed place walk uses this exit too.
mf_sec_int:
    ld      hl,FR_INT_ERR
    or      a
    ret

; Test whether this sector still holds file bytes.
; Call. fat_fp is the FIL.
; Return. Carry set means the sector starts below the file size.
; Return. Carry clear means the sector starts at or past the size.
; Writes. fat_hold receives the sector-aligned fptr.
; Clobber. AF, BC, DE, and HL.
mf_need_read:
    ld      hl,(fat_fp)
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
    and     $FE                     ;align fptr down to a 512-byte sector
    ld      d,a
    ld      (fat_hold),de
    ld      (fat_hold+2),bc
    ld      hl,(fat_fp)
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

; Make the file cache hold the LBA in BCDE.
; Call. BCDE is the LBA. fat_fp is the FIL.
; Return. Carry set means fat_filewin holds that sector.
; Return. Carry clear means HL is FR_DISK_ERR.
; A sector at or past the file size is filled with 0 and is not read.
; Writes. fat_want, the cache sector, the valid and dirty flags, and the owner.
; Clobber. AF, BC, DE, and HL.
mf_cache_prepare:
    ld      (fat_want),de
    ld      (fat_want+2),bc
    call    mf_same_sect
    jr      NZ,mf_cache_miss        ;cached LBA differs
    ld      hl,(fat_file_own)
    ld      de,(fat_fp)
    or      a
    sbc     hl,de
    jr      Z,mf_cache_hit          ;this FIL already owns the cache
    ld      a,(fat_file_dirty)
    or      a
    jr      Z,mf_cache_hit          ;cache is clean, so another FIL may use it
; The cache must be flushed and filled for this LBA.
mf_cache_miss:
    call    mf_flush
    ret     NC                      ;file cache was not written. HL is FR_DISK_ERR
    ld      de,(fat_want)
    ld      bc,(fat_want+2)
    call    mf_need_read
    jr      NC,mf_cache_zero        ;sector starts at or past the file size
    ld      de,(fat_want)
    ld      bc,(fat_want+2)
    ld      hl,fat_filewin
    call    ide_read_sector
    jp      NC,mf_flush_disk        ;sector was not read
    jr      mf_cache_arm            ;the sector is in the cache
; The sector starts at or past the file size. Fill it with 0.
mf_cache_zero:
    ld      hl,fat_filewin
    ld      (hl),0
    ld      de,fat_filewin+1
    ld      bc,511                  ;one sector is 512 bytes
    ldir
; Remember the LBA and mark the cache valid and clean.
mf_cache_arm:
    ld      hl,fat_want
    ld      de,fat_file_sect
    ld      bc,4
    ldir
    ld      a,1
    ld      (fat_file_valid),a
    xor     a
    ld      (fat_file_dirty),a
; This FIL now owns the cached sector.
mf_cache_hit:
    ld      hl,(fat_fp)
    ld      (fat_file_own),hl
    scf
    ret

; Point FIL_CLUST at the cluster for the current fptr.
; Call. fat_fp is the FIL.
; Return. Carry set means HL is 0.
; Return. Carry clear means HL is FR_INT_ERR.
; A failed chain walk returns FR_INT_ERR, not FR_DISK_ERR.
; A zero fptr copies the start cluster.
; Clobber. AF, BC, DE, and HL.
mf_place:
    ld      hl,(fat_fp)
    ld      de,FIL_FPTR
    add     hl,de
    ld      a,(hl)
    inc     hl
    or      (hl)
    inc     hl
    or      (hl)
    inc     hl
    or      (hl)
    jr      NZ,mf_place_mid         ;fptr is not 0
    ld      hl,(fat_fp)
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
    jp      mf_ok                   ;fptr 0 uses the start cluster
; fptr is not 0, so walk the chain.
mf_place_mid:
    ld      hl,(fat_fp)
    ld      de,FIL_SCLUST
    add     hl,de
    ld      de,fat_cfo
    ld      bc,4
    ldir
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
    jp      NC,mf_sec_int           ;the chain walk failed
    call    mf_store_clust
    jp      mf_ok                   ;FIL_CLUST now matches fptr

; Choose the byte offset for the cluster walk.
; Call. fat_fp is the FIL.
; Return. BCDE is fptr. When fptr equals the size and is cluster aligned, BCDE is fptr minus 1.
; Clobber. AF, BC, DE, and HL.
mf_place_src:
    ld      hl,(fat_fp)
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
    ld      hl,(fat_fp)
    ld      de,FIL_SIZE
    add     hl,de
    pop     de
    pop     bc
    ld      a,(hl)
    cp      e
    jr      NZ,mf_place_use         ;size byte 0 differs from fptr
    inc     hl
    ld      a,(hl)
    cp      d
    jr      NZ,mf_place_use         ;size byte 1 differs from fptr
    inc     hl
    ld      a,(hl)
    cp      c
    jr      NZ,mf_place_use         ;size byte 2 differs from fptr
    inc     hl
    ld      a,(hl)
    cp      b
    jr      NZ,mf_place_use         ;size byte 3 differs from fptr
    call    mf_aligned
    jr      NC,mf_place_use         ;fptr is not on a cluster boundary
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
; BCDE is the offset the walk should use.
mf_place_use:
    ret

; Test fptr against the cluster size.
; Call. DE is the low word of fptr. The cluster size fits in that word.
; Return. Carry set means fptr is a multiple of the cluster size.
; Return. Carry clear means it is not.
; Clobber. AF and HL. BC and DE stay.
mf_aligned:
    ld      a,(_cpm_fat_vol+1)
    ld      l,a
    ld      h,0
    add     hl,hl                   ;shift csize left. Nine shifts reach bytes.
    add     hl,hl
    add     hl,hl
    add     hl,hl
    add     hl,hl
    add     hl,hl
    add     hl,hl
    add     hl,hl
    add     hl,hl
    dec     hl                      ;mask is the cluster size in bytes minus 1
    ld      a,e
    and     l
    ld      l,a
    ld      a,d
    and     h
    or      l
    jr      NZ,mf_al_no             ;low word is not a cluster multiple
    scf
    ret
; fptr is not a multiple of the cluster size.
mf_al_no:
    or      a
    ret

; Copy fat_left bytes through the file cache.
; Call. fat_fp is the FIL. fat_user is the buffer. fat_left is the request.
; fat_out points at the caller's count, or it is 0. fat_write is 1 for a write.
; Return. Carry set means HL is 0.
; When fat_out is not 0, that word receives the bytes moved.
; A short read stops at the file size and returns FR_OK.
; A short write stops when create_chain fails and returns FR_OK.
; Return. Carry clear means HL is the FRESULT and FIL_ERR receives that byte.
; The partial count already stored at fat_out stays in place.
; A write that reaches the clean exit sets FA_MODIFIED, even for 0 bytes.
; Writes. fat_left, the word at fat_out, fptr, and on a write the size and flags.
; Clobber. AF, BC, DE, and HL.
mf_transfer:
    ld      hl,(fat_out)
    ld      a,h
    or      l
    jr      Z,mf_tr_loop            ;no count pointer
    xor     a
    ld      (hl),a
    inc     hl
    ld      (hl),a
; Move the next chunk, or stop when the request is done.
mf_tr_loop:
    ld      hl,(fat_left)
    ld      a,h
    or      l
    jp      Z,mf_tr_done            ;the request is complete
    ld      a,(fat_write)
    or      a
    jr      NZ,mf_tr_room           ;a write may pass the current size
    call    mf_size_minus_fptr
    jp      C,mf_tr_done            ;fptr is already past the size
    ld      a,(fat_remain)
    ld      hl,fat_remain+1
    or      (hl)
    inc     hl
    or      (hl)
    inc     hl
    or      (hl)
    jp      Z,mf_tr_done            ;no bytes remain in the file
; Limit this chunk to the sector, the request, and the bytes left.
mf_tr_room:
    ld      hl,(fat_fp)
    ld      de,FIL_FPTR
    add     hl,de
    ld      a,(hl)
    ld      (fat_off),a
    inc     hl
    ld      a,(hl)
    and     1                       ;keep the offset inside the 512-byte sector
    ld      (fat_off+1),a
    ld      hl,(fat_off)
    ld      de,512                  ;one sector is 512 bytes
    or      a
    ex      de,hl
    sbc     hl,de
    ex      de,hl
    ld      hl,(fat_left)
    push    hl
    or      a
    sbc     hl,de
    pop     hl
    jr      NC,mf_tr_clipr          ;the request does not fit in this sector
    ld      e,l
    ld      d,h
; The chunk is the space left in the sector or the request.
mf_tr_clipr:
    ld      a,(fat_write)
    or      a
    jr      NZ,mf_tr_go             ;a write is not clipped to the file size
    ld      a,(fat_remain+2)
    ld      hl,fat_remain+3
    or      (hl)
    jr      NZ,mf_tr_go             ;more than 65535 bytes remain in the file
    ld      hl,(fat_remain)
    or      a
    sbc     hl,de
    jr      NC,mf_tr_go             ;the chunk fits in the bytes left
    ld      de,(fat_remain)
; fat_hold is the number of bytes in this chunk.
mf_tr_go:
    ld      (fat_hold),de
    push    de
    call    mf_sector_for_fptr
    jr      C,mf_tr_prep            ;the LBA is ready
    pop     de
    jp      mf_tr_stop              ;the sector was not resolved
; The sector is in the file cache.
mf_tr_prep:
    call    mf_cache_prepare
    pop     de
    ld      (fat_hold),de
    jp      NC,mf_tr_seterr         ;the cache fill failed. HL is the FRESULT
    ld      hl,(fat_off)
    ld      bc,fat_filewin
    add     hl,bc
    ld      a,(fat_write)
    or      a
    jr      NZ,mf_tr_w              ;a write copies into the cache
    ld      bc,(fat_hold)
    ld      de,(fat_user)
    ldir
    ld      (fat_user),de
    jr      mf_tr_adv               ;the read chunk is in the user buffer
; Copy from the user buffer into the cache.
mf_tr_w:
    ld      de,hl
    ld      hl,(fat_user)
    ld      bc,(fat_hold)
    ldir
    ld      (fat_user),hl
    ld      a,1
    ld      (fat_file_dirty),a
    ld      hl,(fat_fp)
    ld      de,FIL_FLAG
    add     hl,de
    ld      a,(hl)
    or      FA_DIRTY
    ld      (hl),a
; Advance fptr, fat_left, and the caller's count.
mf_tr_adv:
    ld      bc,(fat_hold)
    ld      hl,(fat_fp)
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
    ld      hl,(fat_left)
    or      a
    sbc     hl,bc
    ld      (fat_left),hl
    ld      hl,(fat_out)
    ld      a,h
    or      l
    jr      Z,mf_tr_size            ;no count pointer
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ex      de,hl
    add     hl,bc
    ex      de,hl
    ld      (hl),d
    dec     hl
    ld      (hl),e
; Grow the file size when fptr has moved past it.
mf_tr_size:
    ld      a,(fat_write)
    or      a
    jp      Z,mf_tr_loop            ;a read does not grow the size
    call    mf_size_minus_fptr
    jp      NC,mf_tr_loop           ;fptr is still within the size
    ld      hl,(fat_fp)
    ld      de,FIL_FPTR
    add     hl,de
    ld      de,fat_hold
    ld      bc,4
    ldir
    ld      hl,fat_hold
    ld      de,(fat_fp)
    ld      a,e
    add     a,FIL_SIZE
    ld      e,a
    ld      a,d
    adc     a,0
    ld      d,a
    ld      bc,4
    ldir
    jp      mf_tr_loop              ;the size now follows fptr
; HL 0 is a short write. Any other HL is a failure.
mf_tr_stop:
    ld      a,h
    or      l
    jr      Z,mf_tr_done            ;HL 0 is a full disk, so stop cleanly
; Store the FRESULT in FIL_ERR and return it.
mf_tr_seterr:
    ld      a,l
    ld      hl,(fat_fp)
    ld      de,FIL_ERR
    add     hl,de
    ld      (hl),a
    ld      l,a
    ld      h,0
    or      a
    ret
; The move stopped cleanly. A write sets FA_MODIFIED.
mf_tr_done:
    ld      a,(fat_write)
    or      a
    jp      Z,mf_ok                 ;a read does not set FA_MODIFIED
    ld      hl,(fat_fp)
    ld      de,FIL_FLAG
    add     hl,de
    ld      a,(hl)
    or      FA_MODIFIED
    ld      (hl),a
    jp      mf_ok                   ;a write sets FA_MODIFIED

; Apply a path to the directory text.
; Call. HL is the path text.
; Return. Carry set means HL is 0. fat_cwd_str is the new text.
; Return. Carry clear means HL is the FRESULT. The text may already have changed.
; The cluster update is the caller's job.
; Writes. fat_cwd_str, fat_path, fat_kind, and fat_name11.
; Clobber. AF, BC, DE, and HL.
mf_cwd_apply:
    ld      (fat_path),hl
    call    mf_drive
    ret     NC                      ;HL is already FR_INVALID_DRIVE
    ld      a,(hl)
    cp      '/'
    jr      Z,mf_cwd_abs            ;path starts at the root
    cp      $5C
    jr      NZ,mf_cwd_rel           ;path is relative
; Replace the directory text from the root.
mf_cwd_abs:
    call    mf_cwd_reset
    call    mf_skip_slash
; Append to the current directory text.
mf_cwd_rel:
    ld      a,(hl)
    or      a
    jp      Z,mf_ok                 ;no path bytes remain
; Apply one component to the directory text.
mf_cwd_loop:
    call    mf_comp
    ret     NC                      ;HL is already FR_INVALID_NAME
    ld      (fat_kind),a
    ld      a,(hl)
    cp      '/'
    jr      Z,mf_cwd_sk             ;a separator follows
    cp      $5C
    jr      NZ,mf_cwd_kind          ;no separator follows
; Skip the separators after this component.
mf_cwd_sk:
    call    mf_skip_slash
; Dispatch dot, dot-dot, or a real name.
mf_cwd_kind:
    ld      a,(fat_kind)
    or      a
    jr      Z,mf_cwd_name           ;component is a real name
    cp      2
    jr      Z,mf_cwd_pop            ;component is dot-dot
    jr      mf_cwd_next             ;dot leaves the text unchanged
; Remove the last text component.
mf_cwd_pop:
    push    hl
    call    mf_cwd_pop1
    pop     hl
; Continue while path bytes remain.
mf_cwd_next:
    ld      a,(hl)
    or      a
    jr      NZ,mf_cwd_loop          ;more path bytes remain
    jp      mf_ok                   ;the directory text is updated
; Append the folded 8.3 name.
mf_cwd_name:
    push    hl
    call    mf_cwd_push
    jr      NC,mf_cwd_namerr        ;the name does not fit in the text
    pop     hl
    jr      mf_cwd_next             ;the name was appended
; The text does not fit. HL is already the FRESULT.
mf_cwd_namerr:
    pop     de
    ret

; Cut the last component from the directory text.
; Call. No arguments.
; Return. Carry is set. fat_cwd_str ends at the previous slash, and the root stays "0:/".
; Writes. fat_cwd_str.
; Clobber. AF, DE, and HL. BC stays.
mf_cwd_pop1:
    ld      hl,fat_cwd_str
; Find the terminating 0.
mf_cwd_pend:
    ld      a,(hl)
    or      a
    jr      Z,mf_cwd_pback          ;found the terminating 0
    inc     hl
    jr      mf_cwd_pend             ;keep scanning for the terminating 0
; Walk back to the previous slash.
mf_cwd_pback:
    dec     hl
    ld      a,(hl)
    cp      '/'
    jr      NZ,mf_cwd_pback         ;this byte is not a slash
    ld      de,fat_cwd_str+2
    ld      a,l
    cp      e
    jr      NZ,mf_cwd_pcut          ;this slash is not the root slash
    ld      a,h
    cp      d
    jr      NZ,mf_cwd_pcut          ;this slash is not the root slash
    inc     hl
; Cut the text at this slash.
mf_cwd_pcut:
    ld      (hl),0
    scf
    ret

; Append fat_name11 to the directory text.
; Call. fat_name11 holds the folded name.
; Return. Carry set means the name was appended and terminated.
; Return. Carry clear means HL is FR_NOT_ENOUGH_CORE.
; Writes. fat_cwd_str.
; Clobber. AF, BC, DE, and HL.
mf_cwd_push:
    ld      hl,fat_cwd_str
; Find the terminating 0 before appending.
mf_cwd_pend2:
    ld      a,(hl)
    or      a
    jr      Z,mf_cwd_pat            ;found the terminating 0
    inc     hl
    jr      mf_cwd_pend2            ;keep scanning for the terminating 0
; Point at the end of the directory text.
mf_cwd_pat:
    dec     hl
    ld      a,(hl)
    cp      '/'
    jr      Z,mf_cwd_copy           ;the text already ends with a slash
    inc     hl
    ld      (hl),'/'
    inc     hl
; Copy the body and then the extension.
mf_cwd_copy:
    inc     hl
    ld      de,fat_name11
    ld      b,8
; Copy the next body character.
mf_cwd_b:
    ld      a,(de)
    cp      ' '
    jr      Z,mf_cwd_dot            ;body padding starts
    call    mf_cwd_put
    ret     NC                      ;the text does not fit
    inc     de
    djnz    mf_cwd_b                ;body characters remain
; Insert a dot when the extension is not blank.
mf_cwd_dot:
    ld      de,fat_name11+8
    ld      a,(de)
    cp      ' '
    jr      Z,mf_cwd_nul            ;the extension is blank
    ld      a,'.'
    call    mf_cwd_put
    ret     NC                      ;the text does not fit
    ld      b,3
; Copy the next extension character.
mf_cwd_e:
    ld      a,(de)
    cp      ' '
    jr      Z,mf_cwd_nul            ;extension padding starts
    call    mf_cwd_put
    ret     NC                      ;the text does not fit
    inc     de
    djnz    mf_cwd_e                ;extension characters remain
; Terminate the directory text.
mf_cwd_nul:
    ld      (hl),0
    scf
    ret

; Store one character unless the text is full.
; Call. HL points at the next free byte. A is the character.
; Return. Carry set means the character is stored and HL has advanced.
; Return. Carry clear means HL is FR_NOT_ENOUGH_CORE.
; The room test restores HL. Its carry matches the subtract.
; Writes. One byte of fat_cwd_str on success.
; Clobber. AF, DE, and HL. BC stays.
mf_cwd_put:
    push    de
    ld      de,fat_cwd_str+63
    or      a
    sbc     hl,de
    add     hl,de                   ;restore HL. Carry still matches the subtract
    pop     de
    jr      NC,mf_cwd_long          ;no free byte remains before the terminating 0
    ld      (hl),a
    inc     hl
    scf
    ret
; The 64-byte text has no free character.
mf_cwd_long:
    ld      hl,FR_NOT_ENOUGH_CORE
    or      a
    ret

; Fill a FILINFO from the directory entry at dir_ptr.
; Call. HL is the FILINFO pointer.
; Return. Carry set means HL is 0.
; The size, the attribute, and the 8.3 name are copied. Spaces leave the name.
; A first body byte of $05 is copied as $E5.
; Writes. The FILINFO. fat_user keeps the pointer.
; Clobber. AF, BC, DE, and HL.
mf_fill_info:
    ld      (fat_user),hl
    ld      hl,(dir_ptr)
    ld      de,DIR_FileSize
    add     hl,de
    ld      de,(fat_user)
    ld      bc,4
    ldir
    ld      hl,(dir_ptr)
    ld      de,DIR_WrtDate
    add     hl,de
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      hl,(fat_user)
    ld      bc,FI_DATE
    add     hl,bc
    ld      (hl),e
    inc     hl
    ld      (hl),d
    ld      hl,(dir_ptr)
    ld      de,DIR_WrtTime
    add     hl,de
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      hl,(fat_user)
    ld      bc,FI_TIME
    add     hl,bc
    ld      (hl),e
    inc     hl
    ld      (hl),d
    ld      hl,(dir_ptr)
    ld      de,DIR_Attr
    add     hl,de
    ld      a,(hl)
    ld      hl,(fat_user)
    ld      de,FI_ATTR
    add     hl,de
    ld      (hl),a
    ld      hl,(fat_user)
    ld      de,FI_NAME
    add     hl,de
    ex      de,hl
    ld      hl,(dir_ptr)
    ld      b,8
; Copy the next body character and skip spaces.
mf_fn8:
    ld      a,(hl)
    inc     hl
    cp      ' '
    jr      Z,mf_fn8n               ;skip a space in the body
    cp      $05
    jr      NZ,mf_fn8s              ;not a stored $05
    ld      a,b
    cp      8
    ld      a,$05                   ;ld does not change the flags from the compare
    jr      NZ,mf_fn8s              ;not the first body byte, so keep $05
    ld      a,$E5                   ;a stored first byte of $05 is shown as $E5
; Store this body character.
mf_fn8s:
    ld      (de),a
    inc     de
; Advance to the next body byte.
mf_fn8n:
    djnz    mf_fn8                  ;body bytes remain
    ld      c,0
    ld      b,3
; Copy the next extension character and skip spaces.
mf_fn3:
    ld      a,(hl)
    inc     hl
    cp      ' '
    jr      Z,mf_fn3n               ;skip a space in the extension
    push    af
    ld      a,c
    or      a
    jr      NZ,mf_fn3d              ;the dot is already stored
    ld      a,'.'
    ld      (de),a
    inc     de
    ld      c,1
; Store this extension character.
mf_fn3d:
    pop     af
    ld      (de),a
    inc     de
; Advance to the next extension byte.
mf_fn3n:
    djnz    mf_fn3                  ;extension bytes remain
    xor     a
    ld      (de),a
    jp      mf_ok                   ;FILINFO name is terminated
