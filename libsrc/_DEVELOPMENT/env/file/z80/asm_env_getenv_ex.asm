; char *getenv_ex(char *envfile, char *name, char *vbuf, size_t vbufsz)

INCLUDE "config_private.inc"

SECTION code_env

PUBLIC asm_env_getenv_ex

EXTERN error_einval_zc, error_ebadf_zc, error_zc
EXTERN l_jpix_00, l_jpix_03, l_jpix_06, l_jpix_09, l_jpix_12, l_minu_bc_hl
EXTERN asm_env_qualify_name, asm_env_find_name_value

asm_env_getenv_ex:

   ; Search for name among environment variables and return value in value_buf if found.
   ; Must hold exclusive access to environment file while searching it.
   ; Use supplied buffer to hold file window.
   ;
   ; enter : hl = char *name
   ;         de = buf
   ;         bc = bufsz > 0
   ;
   ;         hl'= char *env_filename (0 to use system environment)
   ;         de'= value_buf (0 to return size of value string found)
   ;         bc'= value_bufsz not including terminating 0
   ;
   ;         disk io block
   ;
   ;         ix+12 = jp read (read bc>0 bytes to address hl, carry if error)
   ;         ix+ 9 = jp size (return dehl = file size, carry if error)
   ;         ix+ 6 = jp seek (seek to position bc, carry if error)
   ;         ix+ 3 = jp close (close file)
   ;         ix+ 0 = jp open (open file, hl = char *filename, CREAT|READ|WRITE|EXCL, carry if error)
   ;
   ; exit  : if successful value_buf != 0
   ;
   ;            hl = char *value (value string truncated to size)
   ;            carry reset
   ;
   ;         if successful value_buf == 0
   ;
   ;            hl = length of value string not including terminating 0
   ;            carry reset
   ;
   ;         if unsuccessful
   ;
   ;            hl = 0
   ;            carry set, errno = EBADF if disk error EINVAL if bad name
   ;
   ; uses  : all except ix

   ; qualify name string
   
   push hl
   
   call asm_env_qualify_name
   
   pop hl
   jp nc, error_einval_zc      ; if name disqualified

   ; close env file on exit
   
   call setup_stack
   
   push af
   push hl
   
   ld a,(ix-1)
   or (ix-2)
   
   call nz, l_jpix_03          ; close env file
   
   pop hl
   pop af
   
   ret

setup_stack:

   ; set up stack
   
   exx

   push bc                     ; value_bufsz
   push de                     ; value_buf
   
   exx
   
   push bc                     ; bufsz
   push de                     ; buf
   push hl                     ; char *name
   
   exx

   ; open env file
   
   ld a,h
   or l
   jr nz, open_env_file
   
   ld hl,__ENV_FILE            ; use global env file

open_env_file:

   ld (ix-1),h
   ld (ix-2),l                 ; store env filename in disk io block
   
   call l_jpix_00              ; jp open
   jr nc, size_env_file        ; if open successful

   xor a                       ; ensure file is not closed at exit
   ld (ix-1),a
   ld (ix-2),a
   
open_failed:

   pop hl
   pop hl
   
   jp error_ebadf_zc - 3

size_env_file:

   ; gather size of env file
   
   call l_jpix_09              ; dehl = size of env file
   jr c, open_failed

   ld a,d
   or e
   jr nz, cap_env_size
   
   ld a,h
   and l
   inc a
   jr nz, env_find_name

cap_env_size:

   ld hl,0xfffe                ; hl = size of env file, max 65534

env_find_name:

   ; locate name in env file
   
   exx
   pop de                      ; de'= char *name
   exx
   
   pop de                      ; de = buf
   pop bc                      ; bc = bufsz
   
   ; stack = value_bufsz, value_buf
   
   call asm_env_find_name_value
   jp nc, error_zc - 2         ; if not found
   
   ; hl = file offset to start of line
   ; bc = file offset to start of value string
   ; de = length of value string
   ; iy = file offset to next line
   ; stack = value_bufsz, value_buf
   
   ; destination buffer = 0 indicates return of value string length
   
   pop hl
   
   ld a,h
   or l
   jr nz, seek_env_file
   
   pop hl
   ex de,hl
   ret                         ; return length of value string

seek_env_file:

   push hl
   push de

   ; bc = file offset to start of value string
   ; stack = value_bufsz, value_buf, length of value string

   call l_jpix_06              ; seek to bc
   jp c, error_ebadf_zc - 3    ; if seek error
   
   ; compute min(value_bufsz,value_string_len)
   
   pop bc                      ; bc = len value string
   pop hl
   ex (sp),hl                  ; hl = value_bufsz
   
   call l_minu_bc_hl
   
   ld c,l
   ld b,h

   ; read value string into destination buffer
   
   pop hl
   
   ; hl = value_buf
   ; bc = num bytes to read from value string
   
   push hl
   push bc
   
   ld a,b
   or c
   
   call nz, l_jpix_12          ; read bc bytes into address hl
   
   pop bc
   pop hl
   
   jp c, error_ebadf_zc        ; if read error
   
   push hl
   
   add hl,bc
   
   xor a
   ld (hl),a                   ; zero terminate string
   
   pop hl                      ; hl = value_buf
   ret
