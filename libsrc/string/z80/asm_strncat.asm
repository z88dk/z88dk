
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
   jr Z,zero_n

asm0_strncat:
   push de                     ; save dst

   push bc
   ex de,hl
   call __str_locate_nul       ; a = 0
   ex de,hl
   pop bc

loop:                          ; append src to dst

IF __CPU_INTEL__ || __CPU_GBZ80__
   ld a,(hl)
   and a
   jr Z,done

   ld (de),a
   inc hl
   inc de

   dec bc
   ld a,b
   or c
   jr NZ,loop

ELSE
   cp (hl)
   jr Z,done

   ldi
   jp PE,loop

ENDIF

   scf

done:
   ld (de),a                   ; terminate dst

   pop hl
   ret

zero_n:
   ld hl,de

   scf
   ret
