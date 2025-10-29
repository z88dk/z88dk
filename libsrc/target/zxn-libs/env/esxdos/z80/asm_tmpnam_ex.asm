; char *tmpnam(char *template)

SECTION code_env

PUBLIC asm_tmpnam_ex

EXTERN asm_env_tmpnam

defc asm_tmpnam_ex = asm_env_tmpnam

   ; Return a filename that is not the same as an existing filename.
   ;
   ; enter : hl = char *template
   ;              (extension: if 0, make a temp file in the system's tmp dir)
   ;
   ; exit  : success
   ;
   ;            hl = char *filename
   ;            carry set
   ;
   ;         fail
   ;
   ;            hl = 0
   ;            carry reset
   ;
   ; uses  : af, bc, de, hl, bc', de', hl', ix
