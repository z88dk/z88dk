
; ===============================================================
; Dec 2013
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

IF __CPU_8085__
   dec bc
ENDIF

loop:
IF __CPU_INTEL__ || __CPU_GBZ80__
   ld a,(de)
IF __CPU_GBZ80__
   ld (hl+),a
ELSE
   ld (hl),a
   inc hl
ENDIF
   inc de
   dec bc
IF __CPU_8085__
   jp NK,loop
   inc bc
   xor a
ELSE
   ld a,b
   or c
   jp NZ,loop
ENDIF

IF __CPU_GBZ80__
   ld (hl+),a	;write terminating zero
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
