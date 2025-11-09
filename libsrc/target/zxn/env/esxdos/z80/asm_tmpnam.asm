; char *tmpnam(char *s)

INCLUDE "config_private.inc"

SECTION code_env

PUBLIC asm_tmpnam

EXTERN __ENV_TMPNAM_TEMPLATE
EXTERN asm_env_tmpnam, asm_strcpy

asm_tmpnam:

   ; Return an unused filename in the /tmp directory
   ;
   ; enter : hl = char *s (0 = use internal static memory)
   ;
   ; exit  : success
   ;
   ;            hl = char *s (or internal filename)
   ;            carry set
   ;
   ;         fail
   ;
   ;            hl = 0
   ;            carry reset
   ;
   ; uses  : af, bc, de, hl, bc', de', hl', ix
   
   ld a,h
   or l
   
   jp z, asm_env_tmpnam        ; if using internal memory
   
   ex de,hl                    ; de = char *s
   ld hl,__ENV_TMPNAM_TEMPLATE
   
   call asm_strcpy             ; hl = char *s
   
   jp asm_env_tmpnam
