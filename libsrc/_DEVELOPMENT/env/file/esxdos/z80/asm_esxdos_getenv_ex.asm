; char *getenv(const char *name)

SECTION code_env

PUBLIC asm_esxdos_getenv_ex

EXTERN asm_env_getenv_ex
EXTERN __ef_esxdos_disk_block_push, __ef_esxdos_disk_block_pop

asm_esxdos_getenv_ex:

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
   ; uses  : af, bc, de, hl, f', bc', de', hl', ix

   call __ef_esxdos_disk_block_push  ; ix = & disk io block on stack
   
   call asm_env_getenv_ex
   
   call __ef_esxdos_disk_block_pop   ; pop disk io block from stack
   ret
