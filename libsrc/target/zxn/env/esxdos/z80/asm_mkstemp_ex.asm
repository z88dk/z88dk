; unsigned char mkstemp_ex(char *template)
; returns file descriptor instead of FILE*

INCLUDE "config_private.inc"

SECTION code_env

PUBLIC asm_mkstemp_ex

EXTERN asm_env_mkstemp

defc asm_mkstemp_ex = asm_env_mkstemp

   ; Create a temporary file using a filename formed by replacing the
   ; last four 'XXXX' in the supplied filename with random characters.
   ;
   ; Open the file for rw and return a file descriptor.
   ;
   ; enter : hl = char *template
   ;              (extension: if 0, make a temp file in the system's tmp dir)
   ;
   ; exit  : success
   ;
   ;            hl = file handle
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : af, bc, de, hl, bc', de', hl', ix
