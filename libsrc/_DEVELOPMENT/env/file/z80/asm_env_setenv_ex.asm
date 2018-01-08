; int setenv(char *envfile, char *name, char *val, int overwrite)

INCLUDE "config_private.inc"
INCLUDE "__ENV_DEFINES.inc"

SECTION code_env

PUBLIC asm_env_setenv_ex

EXTERN error_einval_mc, error_ebadf_mc, error_eio_mc, error_znc
EXTERN l_jpix_00, l_jpix_03, l_jpix_06, l_jpix_09, l_jpix_15, l_jpix_18
EXTERN asm_strlen, l_swap_ixiy
EXTERN asm_env_qualify_name, asm_env_find_name_value, asm_env_tmpnam, asm_env_copy_file

asm_env_setenv_ex:

   ; Replace name=value pair in environment file.
   ; Must hold exclusive access to environment file while searching it.
   ; Use supplied buffer to hold file window.
   ;
   ; enter :  a = overwrite (non-zero = yes)
   ;         de = buf
   ;         bc = bufsz > 0
   ;         hl = char *name
   ;
   ;         hl'= char *env_filename (0 to use system environment)
   ;         bc'= char *val
   ;
   ;         disk io block for env file
   ;
   ;         ix+15 = jp write
   ;         ix+12 = jp read
   ;         ix+ 9 = jp size
   ;         ix+ 6 = jp seek
   ;         ix+ 3 = jp close
   ;         ix+ 0 = jp open
   ;
   ;         disk io block for tmp file
   ;
   ;         iy+18 = jp unlink
   ;         iy+15 = jp write
   ;         iy+12 = jp read
   ;         iy+ 9 = jp size
   ;         iy+ 6 = jp seek
   ;         iy+ 3 = jp close
   ;         iy+ 0 = jp open
   ;
   ; exit  : if successful
   ;
   ;            hl = 0
   ;            carry reset
   ;
   ;         if unsuccessful
   ;
   ;            hl = -1
   ;            carry set, errno = EBADF if disk error
   ;
   ;         if unsuccessful and env file corrupted
   ;
   ;            hl = -1
   ;            carry set, errno = EIO (tmp file holding old env file not removed)
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   ; store overwrite flag
   
   or a
   jr z, set_flags
   ld a,$80

set_flags:

   ld (ix-4),a                 ; bit 7 set indicates overwrite, other bits no files need closing
   ld (iy-4),1                 ; identify iy disk io block
   
   ; qualify name string
   
   push hl
   
   call asm_env_qualify_name
   
   exx
   
   pop de
   jp nc, error_einval_mc      ; if name disqualified

   ; close files on exit
   
   call unsetenv

   push af

   bit 0,(ix-4)                ; if set, ix and iy are swapped
   call nz, l_swap_ixiy
   
   ; ix = disk io env file
   ; iy = disk io tmp file
   
   ld a,(ix-4)                 ; a = close flags
   
   call l_swap_ixiy
   
   bit 2,a
   call nz, l_jpix_03          ; close tmp file
   
   bit 3,a
   call nz, l_jpix_18          ; remove tmp file
   
   call l_swap_ixiy
   
   bit 1,a
   call nz, l_jpix_03          ; close env file
   
   pop af
   ret

unsetenv:

   ; de'= buf
   ; bc'= bufsz
   ;
   ; hl = char *env_filename (0 to use system environment)
   ; de = char *name
   ; bc = char *val
   ;
   ; ix = disk io block env file
   ; iy = disk io block tmp file

   ; open env file
   
   ld a,h
   or l
   jr nz, open_env_file
   
   ld hl,__ENV_FILE            ; use global env file

open_env_file:

   ld (ix-1),h
   ld (ix-2),l                 ; store env filename in disk io block
   
   ld a,ENV_OPEN_EXIST | ENV_OPEN_R | ENV_OPEN_W
   call l_jpix_00              ; jp open
   
   jp c, error_ebadf_mc        ; if open failed

   set 1,(ix-4)                ; close env file on exit

   ; gather size of env file

size_env_file:
   
   call l_jpix_09              ; hl = size of env file (capped)
   jp c, error_ebadf_mc        ; if size failed

   ; locate name in env file

env_find_name:

   ; hl = env filesize
   ; de = char *name
   ; bc = char *val
   ; de'= buf
   ; bc'= bufsz
   ; ix = disk io env file
   ; iy = disk io tmp file
   
   push bc
   push de
   push hl
   exx
   pop hl
   
   ; de = buf
   ; bc = bufsz
   ; hl = env filesize
   ; de'= char *name
   ; ix = disk io env file
   ; iy = disk io tmp file
   ; stack = char *val, char *name
   
   push bc
   push de
   push hl
   push iy
   
   ; stack = val, name, bufsz, buf, env filesize, disk io tmp

   call asm_env_find_name_value

   ex (sp),iy                  ; iy = disk io tmp
   pop bc                      ; bc = file offset next line
   pop de                      ; de = env filesize
   
   ; hl = file offset to start of line
   ; bc = file offset next line
   ; de = env filesize
   ; iy = disk io tmp file
   ; ix = disk io env file
   ; stack = val, name, bufsz, buf

   jp nc, append_name_value    ; if not found, append new name=value pair to end of env file 
   
   call l_swap_ixiy
   
   bit 7,(iy-4)                ; overwrite flag set?
   jr nz, create_tmpfile

   pop hl
   jp error_znc - 3            ; return success, existing name=value pair is unchanged
   
   ; create tmp file

create_tmpfile:

   ; hl = file offset to start of line
   ; bc = file offset next line
   ; de = env filesize
   ; ix = disk io tmp file
   ; iy = disk io env file
   ; stack = val, name, bufsz, buf

   push de
   push bc
   push hl
   
   ld hl,0
   call asm_env_tmpnam
   
   ld (ix-1),h
   ld (ix-2),l
   
   pop bc                      ; bc = offset start of line
   pop de                      ; de = offset next line
   pop hl                      ; hl = env filesize
   
   exx
   
   pop de                      ; de'= buf
   pop bc                      ; bc'= bufsz
   
   exx
   jp c, error_ebadf_mc - 2

   set 3,(iy-4)                ; remove tmp file on exit (flags in env disk io block)

open_tmp_file:
   
   ; open tmp file
   
   ld a,ENV_OPEN_EXIST | ENV_OPEN_R | ENV_OPEN_W
   call l_jpix_00              ; jp open
   
   jp c, error_ebadf_mc - 2

   call l_swap_ixiy
   set 2,(ix-4)                ; close tmp file on exit

   ; copy first part of env file to tmp file

copy_before_line:

   ; ix = disk io env file
   ; iy = disk io tmp file
   ; bc = offset to start of line
   ; de = offset to next line
   ; hl = env filesize
   ; de'= buf
   ; bc'= bufsz
   ; stack = val, name

   sbc hl,de                   ; carry is reset

   ; ix = disk io env file
   ; iy = disk io tmp file
   ; bc = offset to start of line
   ; de = offset to next line
   ; hl = num bytes after next line
   ; de'= buf
   ; bc'= bufsz
   ; stack = val, name

   ld a,b
   or c
   jr z, copy_complete_0
   
   push bc
   
   exx
   
   pop hl                      ; hl'= offset to start of line
   push bc                     ; save bufsz
   
   call asm_env_copy_file      ; copy hl bytes using de,bc as buffer
   
   pop bc                      ; bc'= bufsz
   
   exx
   jp c, error_ebadf_mc - 2    ; if copy error

copy_complete_0:

   ; write new name=value pair 
   
   ; ix = disk io env file
   ; iy = disk io tmp file
   ; de = offset to next line
   ; hl = num bytes after next line
   ; de'= buf
   ; bc'= bufsz
   ; stack = val, name

   call l_swap_ixiy
   
   ex (sp),hl
   ex de,hl
   pop af
   ex (sp),hl
   ex de,hl
   push af
   
   ; iy = disk io env file
   ; ix = disk io tmp file
   ; hl = name
   ; de = val
   ; de'= buf
   ; bc'= bufsz
   ; stack = offset to next line, num bytes after next line

   call write_name_value_pair
   
   pop hl
   pop de
   
   jp c, error_ebadf_mc        ; if error writing pair
   
   call l_swap_ixiy

   ; copy second part of env file to tmp file

copy_after_line:

   ; ix = disk io env file
   ; iy = disk io tmp file
   ; de = offset to next line
   ; hl = num bytes after next line
   ; de'= buf
   ; bc'= bufsz

   ld a,h
   or l
   jr z, copy_complete_1
   
   ld c,e
   ld b,d                      ; bc = offset to next line
   
   call l_jpix_06              ; seek to next line in env file
   jp c, error_ebadf_mc        ; if seek error
   
   push hl
   
   exx
   
   pop hl                      ; hl'= num bytes after next line
   push bc                     ; save bufsz
   
   call asm_env_copy_file      ; copy hl bytes using de,bc as buffer
   
   pop bc                      ; bc'= bufsz
   
   exx
   jp c, error_ebadf_mc        ; if copy error
   
copy_complete_1:

   ; re-open env file for writing
   
   ; ix = disk io env file
   ; iy = disk io tmp file
   ; de'= buf
   ; bc'= bufsz

   res 1,(ix-4)                ; no close of env file on exit
   
   call l_jpix_03              ; close env file
   jp c, error_ebadf_mc        ; if close error
   
   ld a,ENV_OPEN_CREAT_TRUNC | ENV_OPEN_W
   call l_jpix_00              ; jp open
   
   jp c, error_ebadf_mc        ; if truncate failed

   res 3,(ix-4)                ; do not remove tmp file on exit
   set 1,(ix-4)                ; close env file on exit
   
rewind_tmp_file:

   ; ix = disk io env file
   ; iy = disk io tmp file
   ; de'= buf
   ; bc'= bufsz
   
   call l_swap_ixiy

   ; rewind tmp file
   
   ; iy = disk io env file
   ; ix = disk io tmp file
   ; de'= buf
   ; bc'= bufsz
   
   ld bc,0

   call l_jpix_06              ; seek offset 0 in tmp file  
   jp c, error_eio_mc          ; if error env file is corrupted
   
   ; find length of tmp file

   call l_jpix_09              ; hl = length of tmp file
   jp c, error_eio_mc          ; if error env file is corrupted
   
   ; copy tmp file to env file
   
   push hl
   
   exx
   
   pop hl                      ; hl = length of tmp file
   call asm_env_copy_file      ; copy tmp file to env file
   
   jp c, error_eio_mc          ; if error env file is corrupted
   
   set 3,(iy-4)                ; remove tmp file on exit
   jp error_znc

;

append_name_value:

   ; name=value pair not found so append to env file

   pop hl
   pop hl
   
   ; de = env filesize
   ; iy = disk io tmp file
   ; ix = disk io env file
   ; stack = val, name

   ld c,e
   ld b,d
   
   call l_jpix_06              ; seek to end of env file
   jp c, error_ebadf_mc - 2    ; if seek error
   
   pop hl
   pop de

   ; hl = name
   ; de = val
   ; iy = disk io tmp file
   ; ix = disk io env file

write_name_value_pair:

   push hl
   
   call asm_strlen
   
   ld c,l
   ld b,h                      ; bc = strlen(name)
   
   pop hl
   
   call l_jpix_15              ; write name to file
   jp c, error_ebadf_mc        ; if write error
   
   ld hl,equals_s
   ld bc,equals_s_len
   
   call l_jpix_15              ; write name to file
   jp c, error_eio_mc          ; if write error file is corrupt
   
   ld a,d
   or e
   jp z, error_znc             ; if val is NULL
   
   ld l,e
   ld h,d
   
   call asm_strlen
   
   ld c,l
   ld b,h                      ; bc = strlen(val)
   
   ex de,hl
   
   ld a,b
   or c
   call nz, l_jpix_15          ; write val to file
   
   jp c, error_eio_mc          ; if write error file is corrupt
   
   ld hl,terminator_s
   ld bc,1
   
   call l_jpix_15              ; write line terminator
   
   jp nc, error_znc
   jp error_eio_mc

; strings

terminator_s     : defb '\n'
equals_s         : defm " = "
defc equal_s_len = 3
