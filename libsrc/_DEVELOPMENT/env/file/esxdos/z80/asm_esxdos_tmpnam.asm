; char *tmpnam(char *s)

SECTION code_env

PUBLIC asm_esxdos_tmpnam

EXTERN asm_env_tmpnam
EXTERN __ef_esxdos_disk_block_push, __ef_esxdos_disk_block_pop

asm_esxdos_tmpnam:

   ; Return pointer to a temporary filename.
   ; File is created with 0 size and must be deleted by caller when done.
   ;
   ; enter : hl = char *s = buffer to write filename into, NULL = use static buffer instead
   ;
   ; exit  : if successful
   ;
   ;            hl = char *tmpnam
   ;            carry reset
   ;
   ;          if failed
   ;
   ;            hl = 0
   ;            carry set
   ;
   ; uses  : af, bc, de, hl, f', bc', de', hl', ix

   call __ef_esxdos_disk_block_push  ; ix = & disk io block on stack
   
   call asm_env_tmpnam
   
   call __ef_esxdos_disk_block_pop   ; pop disk io block from stack
   ret
