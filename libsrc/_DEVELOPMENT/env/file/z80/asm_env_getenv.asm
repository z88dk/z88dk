; char *getenv(const char *name)

SECTION code_env

PUBLIC asm_env_getenv

EXTERN __ENV_GETENV_BUFSZ, __ENV_GETENV_BUF
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

   exx
   
   ld hl,0                     ; use global env file
   ld de,__ENV_GETENV_BUF      ; use static buffer for value string
   ld bc,__ENV_GETENV_BUFSZ

   exx
   
   jp asm_env_getenv_ex
