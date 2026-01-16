; ===============================================================
; Jan 2007
; ===============================================================
; 
; char *strrstr(const char *s, const char *w)
;
; Return ptr in s to last occurrence of substring w.
; If w has zero length, terminator in s is returned.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_strrstr

EXTERN error_zc

asm_strrstr:

   ; enter : hl = char *s
   ;         de = char *w = substring
   ;
   ; exit  : de = char *w = substring
   ;
   ;         found
   ;
   ;            carry reset
   ;            hl = ptr in s to substring w
   ;
   ;         not found
   ;
   ;            carry set
   ;            hl = 0
   ;
   ; uses  : af, bc, de, hl
   
   ; first find end of s and len(s)

   xor a
   ld c,a
   ld b,a
IF __CPU_INTEL__ || __CPU_GBZ80__
   EXTERN __z80asm__cpir
   call __z80asm__cpir
ELSE
   cpir
ENDIF
   dec hl

   ; de = char *w
   ; hl = & terminating 0 in s
   ; bc = -(length of s) - 1

   ; degenerate case

   ld a,(de)
   or a
   ret Z

loop1:
   dec hl
   inc bc

   ld a,b
   or c

   jp Z,error_zc               ; if no match

   ld a,(de)
   cp (hl)

   jr NZ,loop1

   push hl                     ; save s
   push de                     ; save w

loop2:
   inc de

   ld a,(de)
   or a

   jr Z,match
   inc hl

   cp (hl)
   jr Z,loop2

   pop de
   pop hl

   jr loop1

match:

   pop de
   pop hl
   
   ret
