
; ===============================================================
; Dec 2013
; ===============================================================
; 
; char *strncat(char * restrict s1, const char * restrict s2, size_t n)
;
; Append at most n chars from string s2 to the end of string s1,
; return s1.  s1 is always terminated with a 0.
;
; The maximum length of s1 will be strlen(s1) + n + 1
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_strncat
PUBLIC asm0_strncat

EXTERN __str_locate_nul

asm_strncat:

   ; enter : hl = char *s2 = src
   ;         de = char *s1 = dst
   ;         bc = size_t n
   ;
   ; exit  : hl = char *s1 = dst
   ;         de = ptr in s1 to terminating 0
   ;         carry set if all of s2 not appended
   ;
   ; uses  : af, bc, de, hl

   ld a,b
   or c
   jp Z, zero_n

asm0_strncat:

   push de                     ; save dst

   push bc
   ex de,hl
   call __str_locate_nul       ; a = 0
   ex de,hl
   pop bc

IF __CPU_8085__
   dec bc
ENDIF

loop:                          ; append src to dst
IF __CPU_INTEL__ || __CPU_GBZ80__
   ld a,(hl)
   and a
   jp Z,done
   ld (de),a
   inc hl
   inc de
   dec bc

IF __CPU_8085__
   jp NK,loop
ELSE
   ld a,b
   or c
   jp NZ,loop
ENDIF

ELSE
   cp (hl)
   jr z, done
      
   ldi
   jp pe, loop
ENDIF

   scf

done:                          ; terminate dst
IF __CPU_8085__
   inc bc
ENDIF

   ld (de),a

   pop hl
   ret

zero_n:

   ld hl,de

   scf
   ret
