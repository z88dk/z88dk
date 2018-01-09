; int unsetenv_ex(char *envfile, char *name)

INCLUDE "config_private.inc"
INCLUDE "__ENV_DEFINES.inc"

SECTION code_env

PUBLIC asm_env_unsetenv_ex

EXTERN __ENV_FILE
EXTERN error_einval_mc, error_ebadf_mc, error_eio_mc, error_znc
EXTERN asm_env_qualify_name, asm_env_find_name_value, asm_env_tmpnam, asm_env_copy_file
EXTERN l_jpix_00, l_jpix_03, l_jpix_06, l_jpix_09, l_jpix_18, l_swap_ixiy

asm_env_unsetenv_ex:

   ; Remove name=value pair from environment file.
   ; Must hold exclusive access to environment file while searching it.
   ; Use supplied buffer to hold file window.
   ;
   ; enter : hl = char *name
   ;         de = buf
   ;         bc = bufsz > 0
   ;
   ;         hl'= char *env_filename (0 to use system environment)
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
   ; exit  : if successful (removed or not present)
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

   ; qualify name string
   
   push hl
   
   call asm_env_qualify_name
   
   exx
   
   pop de
   jp nc, error_einval_mc      ; if name disqualified

   ; close files on exit
   
   ld (ix-4),0                 ; no files need closing
   ld (iy-4),1                 ; identify iy disk io block
   
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

   ; open env file
   
   ld a,h
   or l
   jr nz, open_env_file
   
   ld hl,__ENV_FILE            ; use global env file

open_env_file:

   ld (ix-1),h
   ld (ix-2),l                 ; store env filename in disk io block
   
   ld a,ENV_OPEN_EXIST | ENV_OPEN_R
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
   ; de'= buf
   ; bc'= bufsz
   ; ix = disk io env file
   ; iy = disk io tmp file
   
   push hl
   exx
   pop hl
   
   ; de = buf
   ; bc = bufsz
   ; hl = env filesize
   ; de'= char *name
   ; ix = disk io env file
   ; iy = disk io tmp file
   
   push bc
   push de
   push hl
   push iy
   
   ; stack = bufsz, buf, env filesize, disk io tmp

   call asm_env_find_name_value

   ex (sp),iy                  ; iy = disk io tmp
   pop bc                      ; bc = file offset next line
   pop de                      ; de = env filesize
   
   jp nc, error_znc - 2        ; if not found

   ; hl = file offset to start of line
   ; bc = file offset next line
   ; de = env filesize
   ; iy = disk io tmp file
   ; ix = disk io env file
   ; stack = bufsz, buf

   call l_swap_ixiy

   ; create tmp file

create_tmpfile:

   ; hl = file offset to start of line
   ; bc = file offset next line
   ; de = env filesize
   ; ix = disk io tmp file
   ; iy = disk io env file
   ; stack = bufsz, buf

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
   jp c, error_ebadf_mc

   set 3,(iy-4)                ; remove tmp file on exit (flags in env disk io block)

open_tmp_file:
   
   ; open tmp file
   
   ld a,ENV_OPEN_EXIST | ENV_OPEN_R | ENV_OPEN_W
   call l_jpix_00              ; jp open
   
   jp c, error_ebadf_mc

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

   sbc hl,de                   ; carry is reset

   ; ix = disk io env file
   ; iy = disk io tmp file
   ; bc = offset to start of line
   ; de = offset to next line
   ; hl = num bytes after next line
   ; de'= buf
   ; bc'= bufsz
   
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
   jp c, error_ebadf_mc        ; if copy error

copy_complete_0:

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
