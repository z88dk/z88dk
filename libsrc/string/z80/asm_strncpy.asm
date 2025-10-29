
; ===============================================================
; Dec 2013 / Dec 2021 feilipu
; ===============================================================
; 
; char *strncpy(char * restrict s1, const char * restrict s2, size_t n)
;
; Copy at most n chars from string s2 to string s1, return s1.
; If strlen(s2) < n, s1 is padded with 0 bytes such that n
; chars are always written to s1.
;
; Note that s1 will not be 0 terminated if strlen(s2) >= n.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_strncpy

asm_strncpy:

   ; enter : de = char *s1 = dst
   ;         hl = char *s2 = src
   ;         bc = size_t n
   ;
   ; exit  : hl = char *s1 = dst
   ;         de = & s1[n] = dst + n
   ;         bc = 0
   ;
   ; uses  : af, bc, de, hl

   push de                     ; save dst

   ld a,b
   or c
   jr Z,done

   ; first copy src to dst

IF __CPU_INTEL__ || __CPU_GBZ80__

   dec bc
   inc b
   inc c

loop:
   ld a,(hl+)
   ld (de),a
   and a
   jr Z,copied

   inc de

   dec c
   jr NZ,loop
   dec b
   jr NZ,loop

   jr done                      ; reached max number of chars

copied:
   ; now pad with zeroes

zeroloop:
   ld (de+),a

   dec c
   jr NZ,zeroloop
   dec b
   jr NZ,zeroloop

ELSE

   xor a

loop:
   cp (hl)
   ldi
   jp PO,done                  ; reached max number of chars
   jr NZ,loop

   ; now pad with zeroes

   ld hl,de
   dec hl
   ldir

ENDIF

done:
   pop hl
   ret
