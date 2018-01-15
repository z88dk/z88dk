; int setenv(char *name, char *val, int overwrite)

SECTION code_env

PUBLIC asm_esxdos_setenv

EXTERN asm_env_setenv, l_swap_ixiy
EXTERN __ef_esxdos_disk_block_push, __ef_esxdos_disk_block_pop

asm_esxdos_setenv:

   ; Replace name=value pair in environment file.
   ; Must hold exclusive access to environment file while searching it.
   ; Use supplied buffer to hold file window.
   ;
   ; enter :  a = overwrite (non-zero = yes)
   ;         de = buf
   ;         bc = bufsz > 0
   ;         hl = char *name
   ;         bc'= char *val
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
   ; uses  : af, bc, de, hl, f', bc', de', hl', ix, iy

   call __ef_esxdos_disk_block_push
   call l_swap_ixiy                  ; iy = & disk io block on stack
   call __ef_esxdos_disk_block_push  ; ix = & disk io block on stack
   
   call asm_env_setenv
   
   call __ef_esxdos_disk_block_pop   ; pop disk io block from stack
   call __ef_esxdos_disk_block_pop   ; pop disk io block from stack
   ret
