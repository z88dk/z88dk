; unsigned char glob_dos(const char *s, const char *pattern)

SECTION code_string

PUBLIC asm_glob_fat

EXTERN asm_toupper, asm_tolower

asm_glob_fat:

   ; match string to glob pattern (fat style)
   ; matching is case insensitive
   ;
   ; glob pattern can contain:
   ;
   ;   * = match zero or more characters
   ;   ? = match one character
   ;
   ; enter : hl = char *s
   ;         de = char *pattern
   ;
   ; exit  : success if matched
   ;
   ;            carry reset
   ;
   ;         fail if no match
   ;
   ;            carry set
   ;
   ; uses  : af, de, hl

match:

   ; match pattern

   ld a,(de)                   ; next pattern char
   
   cp '*'
   jr z, pattern_star
   
   cp '?'
   jr z, pattern_one
   
   call asm_toupper
   
IF __CPU_INTEL__
   call asm_tolower
ELSE
   bit 5,(hl)
   call nz, asm_tolower
ENDIF
	

   cp (hl)                     ; match a literal with caseless compare

   scf
   ret nz                      ; carry indicates no match
   
   or a
   ret z                       ; if both string and pattern reach end, it's a match
   
   ; advance past literal
   
   inc de
   inc hl
   
   jr match

   ; ?

pattern_one:

   inc de                      ; advance pattern

   ld a,(hl)
   or a
   
   scf
   ret z                       ; does not match if end of string reached
   
   inc hl
   jr match

   ; *

pattern_star:

   ; matches to zero or more string characters but not .
   
   inc de                      ; advance pattern past *
   
loop:

   push de
   push hl
   
   call match
   
   pop hl
   pop de
   
   ret nc                      ; if there is a match
   
   ld a,(hl)
   or a
   
   scf
   ret z                       ; does not match if end of string reached (aready tried matching zero length)
   
   inc hl
   jr loop
