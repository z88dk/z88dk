; char *tmpnam(char *template)

INCLUDE "config_private.inc"

SECTION code_env

PUBLIC asm_env_tmpnam

EXTERN __ENV_TMPNAM
EXTERN __ENV_TMPNAM_TEMPLATE, __ENV_TMPNAM_TEMPLATE_XXXX_OFFSET

EXTERN error_znc, l_utoh, l_ret
EXTERN asm_strlen, asm_strcmp, asm_strcpy
EXTERN asm_random_uniform_xor_32

asm_env_tmpnam:

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
   
   ld a,h
   or l
   
   jr nz, locate_substring

   ld hl,__ENV_TMPNAM_TEMPLATE
   ld de,__ENV_TMPNAM
   
   call asm_strcpy
   
   push hl                     ; save template
   
   ld hl,__ENV_TMPNAM + __ENV_TMPNAM_TEMPLATE_XXXX_OFFSET
   push hl                     ; save last4
   
   jr randomize

locate_substring:

   push hl                     ; save template
   
   ld e,l
   ld d,h
   
   call asm_strlen             ; hl = strlen(template)
   
   ld bc,4
   sbc hl,bc
   
   jp c, error_znc - 1         ; if filename too short
   
   add hl,de                   ; hl points at last four chars in template
   
   push hl                     ; save last4
   
   ld de,xxxx_s
   call asm_strcmp
   
   jp nz, error_znc - 2        ; if last four chars do not match pattern

randomize:

   ; stack = template, last4

   ld a,r
   ld e,a
   ld l,a
   
   ld bc,__ENV_TMPMAX_TRY      ; max number of attempts

name_loop:

   ;    bc = attempts remaining
   ;  dehl = 32-bit seed
   ; stack = template, last4

   ld a,b
   or c
   
   jp z, error_znc - 2         ; if max attempts exhausted
   
   dec bc                      ; attempts--
   
   call asm_random_uniform_xor_32
   
   push hl
   
   ld a,e
   xor l
   ld l,e
   
   ld a,d
   xor h
   ld h,a
   
   ex (sp),hl
   exx

   ;   bc' = attempts remaining
   ; dehl' = seed
   ; stack = template, last4, random number
   
   pop hl                      ; hl = random number
   pop de                      ; de = last4
   push de
   
   scf
   call l_utoh                 ; write four hex digits to last4
   
   pop de
   pop hl                      ; hl = template
   
   push hl
   push de
   
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
   
   jp c, l_ret - 2             ; if open failed exit with hl = template
   
   rst __ESX_RST_SYS
   defb __ESX_F_CLOSE
   
   ;   bc' = attempts remaining
   ; dehl' = seed
   ; stack = template, last4
   
   exx
   jr name_loop

xxxx_s:

   defm "XXXX", 0
