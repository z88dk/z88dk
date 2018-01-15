; int unsetenv(char *name)

SECTION code_env

PUBLIC asm_env_unsetenv

EXTERN asm_env_unsetenv_ex

asm_env_unsetenv:

   ; Remove name=value pair from environment file.
   ; Must hold exclusive access to environment file while searching it.
   ; Use supplied buffer to hold file window.
   ;
   ; enter : hl = char *name
   ;         de = buf
   ;         bc = bufsz > 0
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

   exx
   
   ld hl,0                     ; use system environment file
   
   exx
   
   jp asm_env_unsetenv_ex
