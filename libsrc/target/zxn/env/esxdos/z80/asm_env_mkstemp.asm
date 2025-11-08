; unsigned char mkstemp(char *template)

INCLUDE "config_private.inc"

SECTION code_env

PUBLIC asm_env_mkstemp

EXTERN __ENV_MKSNAM
EXTERN __ENV_TMPNAM_TEMPLATE, __ENV_TMPNAM_TEMPLATE_XXXX_OFFSET

EXTERN error_mc, l_utoh, l_inc_sp
EXTERN asm_strlen, asm_strcmp, asm_strcpy
EXTERN asm_random_uniform_xor_32

asm_env_mkstemp:

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
   
   ld a,h
   or l
   
   jr nz, locate_substring

   ld hl,__ENV_TMPNAM_TEMPLATE
   ld de,__ENV_MKSNAM
   
   call asm_strcpy
   
   push hl                     ; save template
   
   ld hl,__ENV_MKSNAM + __ENV_TMPNAM_TEMPLATE_XXXX_OFFSET
   push hl                     ; save last4
   
   jr randomize

locate_substring:

   push hl                     ; save template
   
   ld e,l
   ld d,h
   
   call asm_strlen             ; hl = strlen(template)
   
   ld bc,4
   sbc hl,bc
   
   jp c, error_mc - 1          ; if filename too short
   
   add hl,de                   ; hl points at last four chars in template
   
   push hl                     ; save last4
   
   ld de,xxxx_s
   call asm_strcmp
   
   jp nz, error_mc - 2         ; if last four chars do not match pattern

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
   
   jp z, error_mc - 2          ; if max attempts exhausted
   
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
   ld b,__esx_mode_read | __esx_mode_write | __esx_mode_creat_noexist

IF __SDCC_IY

   push hl
   pop iy
   
ELSE

   push hl
   pop ix
   
ENDIF

   rst __ESX_RST_SYS
   defb __ESX_F_OPEN
   
   ld l,a
   ld h,0
   
   jp nc, l_inc_sp - 4         ; if temp file successfully created
   
   ;   bc' = attempts remaining
   ; dehl' = seed
   ; stack = template, last4
   
   exx
   jr name_loop

xxxx_s:

   defm "XXXX", 0
