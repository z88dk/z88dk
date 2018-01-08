; char *getenv(const char *name)

INCLUDE "config_private.inc"

SECTION code_env

PUBLIC asm_env_getenv

EXTERN asm_env_getenv_ex

asm_env_getenv:

   ; Search for name among environment variables and return value if found.
   ; Must hold exclusive access to environment file while searching it.
   ; Use supplied buffer to hold file window.
   ;
   ; enter : hl = char *name
   ;         de = buf
   ;         bc = bufsz > 0
   ;
   ;         disk io block
   ;
   ;         ix+12 = jp read
   ;         ix+ 9 = jp size
   ;         ix+ 6 = jp seek
   ;         ix+ 3 = jp close
   ;         ix+ 0 = jp open
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
   ; uses  : af, bc, de, hl, bc', de', hl'

   exx
   
   ld hl,0                     ; use global env file
   ld de,__ENV_GETENV_BUF      ; use static buffer for value string
   ld bc,__ENV_GETENV_BUFSZ

   exx
   
   jp asm_env_getenv_ex
