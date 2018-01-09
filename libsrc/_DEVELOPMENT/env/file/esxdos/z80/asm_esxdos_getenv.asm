; char *getenv(const char *name)

SECTION code_env

PUBLIC asm_esxdos_getenv

EXTERN asm_env_getenv
EXTERN __ef_esxdos_disk_block_push, __ef_esxdos_disk_block_pop

asm_esxdos_getenv:

   ; Search for name among environment variables and return value if found.
   ; Must hold exclusive access to environment file while searching it.
   ; Use supplied buffer to hold file window.
   ;
   ; enter : hl = char *name
   ;         de = buf
   ;         bc = bufsz > 0
   ;
   ; exit  : if successful
   ;
   ;            hl = char *value (value string truncated to size)
   ;            carry reset
   ;
   ;         if unsuccessful
   ;
   ;            hl = 0
   ;            carry set, errno = EBADF if disk error EINVAL if bad name
   ;
   ; uses  : af, bc, de, hl, f', bc', de', hl', ix

   call __ef_esxdos_disk_block_push  ; ix = & disk io block on stack
   
   call asm_env_getenv
   
   call __ef_esxdos_disk_block_pop   ; pop disk io block from stack
   ret
