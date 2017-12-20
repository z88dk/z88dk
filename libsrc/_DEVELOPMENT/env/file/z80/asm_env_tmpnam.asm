; char *tmpnam(char *s)

INCLUDE "config_private.inc"

SECTION code_env

PUBLIC asm_env_tmpnam

EXTERN __ENV_TMPNAM, __TMP_DIR
EXTERN error_zc, l_small_utoh, l_jpix_00, l_jpix_03
EXTERN asm_strcpy, asm_random_uniform_xor_32
EXTERN asm_im2_push_registers, asm_im2_pop_registers

asm_env_tmpnam:

   ; Return pointer to a temporary filename.
   ; File is created with 0 size and must be deleted by caller when done.
   ;
   ; enter : hl = char *s = buffer to write filename into, NULL = use static buffer instead
   ;
   ;         disk io block
   ;
   ;         ix+3 = jp close
   ;         ix+0 = jp open  (carry if fail, NOEXIST|READ|WRITE)
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
   ; uses  : af, bc, de, hl, bc', de', hl'

   ; if s == NULL use static storage
   
   ld a,h
   or l
   jr nz, set_filename
   
   ld hl,__ENV_TMPNAM

set_filename:

   ld (ix-1),h
   ld (ix-2),l

   ex de,hl
   
randomize:

   ; randomize tmp filenames
   
   exx
   
   ld hl,(__SYSVAR_FRAMES)
   ld a,r
   ld e,a                      ; dehl'= 32-bit seed
   
   ld bc,0xffff                ; max number of attempts
   
   exx
   
   ; construct tmp filename

tmpnam_loop:

   push de

   ld hl,__TMP_DIR
   call asm_strcpy             ; copy tmp dir prefix
   
   ex de,hl

   ld (hl),'t'                 ; filename "/dir/tmp..."
   inc hl
   ld (hl),'m'
   inc hl
   ld (hl),'p'
   inc hl
   
   exx
   
   ld a,b
   or c
   jp z, error_zc - 1          ; if exhausted max number of attempts

   dec bc
   
   call asm_random_uniform_xor_32
   
   push hl
   
   ld a,e                      ; try to avoid frequent repeats caused by
   xor l                       ; reducing 32-bits down to 16-bits
   ld l,e
   
   ld a,d
   xor h
   ld h,a
   
   ex (sp),hl                  ; stack = random number

   exx
   
   pop de
   ex de,hl
   
   scf
   call l_small_utoh           ; filename "tmpXXXX"
   
   xor a
   ld (de),a
   
   ; attempt to create file
    
   call asm_im2_push_registers
   
   call l_jpix_00              ; create file, NO_EXIST, WRITE
   jr nc, successful
   
   call asm_im2_pop_registers
   
   pop de
   jr tmpnam_loop
   
successful:

   ; close file and return filename
   
   call l_jpix_03              ; close file

   call asm_im2_pop_registers 
   pop hl                      ; hl = char *filename

   or a
   ret
