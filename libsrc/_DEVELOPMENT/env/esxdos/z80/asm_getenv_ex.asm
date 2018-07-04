; char *getenv_ex(const char *filename, const char *name)

INCLUDE "config_private.inc"

SECTION code_env

PUBLIC asm_getenv_ex

EXTERN __ENV_GETENV_VALUE, __ENV_BUF
EXTERN asm_env_getenv, error_zc

asm_getenv_ex:

   ; Search for "name = value" pair in global environment
   ;
   ; enter : hl = char *name
   ;         de = char *filename
   ;
   ; exit  : success if valsz != 0
   ;
   ;            hl = char *val, zero terminated value written into buffer
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = 0
   ;            carry set
   ;
   ; uses  : af, bc, de, hl, bc', de', hl', ix
   
   push de
   
   ld de,__ENV_GETENV_VALUE    ; static memory to hold value returned
   ld bc,__ENV_GETENV_VALSZ
   
   exx
   
   pop hl
   
   ld a,'*'
   ld b,__esx_mode_read | __esx_mode_open_exist
   
IF __SDCC_IY

   push hl
   pop iy
   
ELSE

   push hl
   pop ix
   
ENDIF

   rst __ESX_RST_SYS
   defb __ESX_F_OPEN
   
   jp c, error_zc              ; if failed to open env file
   
   ld e,a                      ; e = file handle
   
   ld hl,__ENV_BUF             ; disk buffer
   ld bc,__ENV_BUFSZ

   push de                     ; save file handle

   exx
   
   call asm_env_getenv

   pop de                      ; e = file handle
   
   push af
   push hl
   
   ld a,e
   
   rst __ESX_RST_SYS
   defb __ESX_F_CLOSE
   
   pop hl
   pop af
   
   ret
