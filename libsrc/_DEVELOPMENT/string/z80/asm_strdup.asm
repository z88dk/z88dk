
; ===============================================================
; Dec 2013 / Dec 2021 feilipu
; ===============================================================
; 
; char *strdup(const char * s)
;
; Copy string s into an allocated block of memory and return
; a pointer to the newly allocated block.  User must deallocate
; the returned ptr with free().
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_strdup
PUBLIC asm0_strdup

EXTERN asm_strlen, asm_malloc, error_enomem_zc

asm_strdup:

   ; enter: hl = char *s
   ;
   ; exit : 
   ;        success
   ;
   ;           carry reset
   ;           hl = char *str (dup), must deallocate with free()
   ;           de = ptr to terminating 0 at end of str (dup)
   ;
   ;        fail (insufficient memory)
   ;
   ;           carry set, errno = enomem
   ;           hl = 0
   ;           de = char *s
   ;           bc = strlen(s)+1
   ;
   ; uses : af, bc, de, hl

   push hl                     ; save char *s
   
   call asm_strlen             ; hl = length

asm0_strdup:
   inc hl                      ; include space for NUL

   push hl
   call asm_malloc             ; malloc(hl bytes)
   pop bc                      ; bc = length

   pop de                      ; de = char *s
   ret C                       ; malloc error

   push hl                     ; save char *str (dup)

IF __CPU_INTEL || __CPU_GBZ80__
   dec bc
   inc b
   inc c
loop:
   ld a,(de)
   inc de
IF __CPU_GBZ80__
   ld (hl+),a
ELSE
   ld (hl),a
   inc hl
ENDIF

   dec c
   jr NZ,loop
   dec b
   jr NZ,loop

   ; ensure terminating NUL written, strndup requires it

IF __CPU_GBZ80__
   ld (hl+),a
ELSE
   ld (hl),a
   inc hl
ENDIF

ELSE
   ex de,hl
   ldir

   ; ensure terminating NUL written, strndup requires it

   dec de
   xor a
   ld (de),a
ENDIF

   pop hl
   ret
