; char *getenv_ex(char *envfile, char *name, char *vbuf, size_t vbufsz)

INCLUDE "config_private.inc"
INCLUDE "__ENV_DEFINES.inc"

SECTION code_env

PUBLIC asm_env_getenv_ex

EXTERN error_einval_zc, error_ebadf_zc, error_zc
EXTERN l_jpix_00, l_jpix_03, l_jpix_06, l_jpix_09, l_jpix_12, l_minu_bc_hl
EXTERN asm_env_qualify_name, asm_env_find_name_value

asm_env_getenv_ex:

   ; Search for name among environment variables and return value in vbuf if found.
   ; Must hold exclusive access to environment file while searching it.
   ; Use supplied buffer to hold file window.
   ;
   ; enter : hl = char *name
   ;         de = buf
   ;         bc = bufsz > 0
   ;
   ;         hl'= char *env_filename (0 to use system environment)
   ;         de'= vbuf (0 to return size of value string found)
   ;         bc'= vbufsz not including terminating 0
   ;
   ;         disk io block
   ;
   ;         ix+12 = jp read
   ;         ix+ 9 = jp size
   ;         ix+ 6 = jp seek
   ;         ix+ 3 = jp close
   ;         ix+ 0 = jp open
   ;
   ; exit  : if successful vbuf != 0
   ;
   ;            hl = char *value (value string truncated to size)
   ;            carry reset
   ;
   ;         if successful vbuf == 0
   ;
   ;            hl = length of value string not including terminating 0
   ;            carry reset
   ;
   ;         if unsuccessful
   ;
   ;            hl = 0
   ;            carry set, errno = EBADF if disk error EINVAL if bad name
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   ; qualify name string
   
   push hl
   
   call asm_env_qualify_name
   
   pop hl
   jp nc, error_einval_zc      ; if name disqualified

   ; open env file
   
   exx
   
   ld a,h
   or l
   jr nz, open_env_file
   
   ld hl,__ENV_FILE            ; use global env file

open_env_file:

   ld (ix-1),h
   ld (ix-2),l                 ; store env filename in disk io block

   ld a,ENV_OPEN_EXIST | ENV_OPEN_R
   call l_jpix_00              ; jp open

   jp c, error_ebadf_zc        ; if open failed
   
   ; close env file on exit
   
   call size_env_file
   
   push af
   
   call l_jpix_03              ; jp close
   
   pop af
   ret

size_env_file:

   ; gather size of env file

   exx

   push hl                     ; save name
   
   call l_jpix_09              ; hl = size of env file (capped)
   jp c, error_ebadf_zc - 1    ; if size failed

env_find_name:

   ; locate name in env file
   
   exx
   
   pop hl
   push bc
   push de
   ex de,hl                    ; de'= char *name
   
   exx

   ; de = buf
   ; bc = bufsz
   ; hl = env file size
   ; de'= char *name
   ; stack = vbufsz, vbuf
   
   call asm_env_find_name_value
   jp nc, error_zc - 2         ; if not found
   
   ; hl = file offset to start of line
   ; bc = file offset to start of value string
   ; de = length of value string
   ; iy = file offset to next line
   ; stack = vbufsz, vbuf
   
   ; vbuf == 0 indicates return of value string length
   
   pop hl
   
   ld a,h
   or l
   jr nz, seek_env_file
   
   pop hl

   ex de,hl
   ret                         ; return length of value string

seek_env_file:

   push hl
   
   ; bc = file offset to start of value string
   ; de = length of value string
   ; stack = vbufsz, vbuf

   call l_jpix_06              ; seek to bc
   jp c, error_ebadf_zc - 2    ; if seek error
   
   ; compute min(vbufsz,value_string_len)
   
   pop hl
   ex (sp),hl                  ; hl = value_bufsz
   
   ld c,e
   ld b,d                      ; bc = length of value string
   
   call l_minu_bc_hl
   
   ld c,l
   ld b,h

   ; read value string into destination buffer
   
   pop hl
   
   ; hl = vbuf
   ; bc = num bytes to read from value string
   
   ld a,b
   or c
   
   call nz, l_jpix_12          ; read bc bytes into address hl
   jp c, error_ebadf_zc        ; if read error
   
   push hl
   
   add hl,bc
   
   xor a
   ld (hl),a                   ; zero terminate string
   
   pop hl                      ; hl = vbuf
   ret
