
; ===============================================================
; Dec 2013 / Dec 2021 feilipu
; ===============================================================
; 
; char *stpncpy(char * restrict s1, const char * restrict s2, size_t n)
;
; Copy at most n chars from string s2 to string s1, return address
; of first NUL char written to s1 or &s1[n] if no NUL is written.
;
; If strlen(s2) < n, s1 is padded with 0 bytes such that n
; chars are always written to s1.
;
; Note that s1 will not be 0 terminated if strlen(s2) >= n.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_stpncpy

asm_stpncpy:

   ; enter : de = char *s1 = dst
   ;         hl = char *s2 = src
   ;         bc = size_t n
   ;
   ; exit  : hl = address in s1 of first NUL written or &s1[n

   ;         bc = 0
   ;         z flag set if NUL was written to s1
   ;
   ; uses  : af, bc, de, hl

   ld a,b
   or c
   jr Z,exit

IF __CPU_INTEL__ || __CPU_GBZ80__

   dec bc
   inc b
   inc c

   ; copy src to dst
loop:
   xor a
   cp (hl)
   jr Z,copied

   ld a,(hl+)
   ld (de+),a

   dec c
   jr NZ,loop
   dec b
   jr NZ,loop

copied:
   ld hl,de                     ; save addr of first NUL in s1
   xor a
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

   push hl                    ; save addr of first NUL in s1
   ldir
   pop hl

ENDIF

   ret

done:
   jr NZ,exit                 ; if last char was not NUL
   dec de                     ; move back to NUL

exit:
   ex de,hl
   ret
