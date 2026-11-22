; unsigned char glob(const char *s, const char *pattern)

SECTION code_string

PUBLIC asm_glob

asm_glob:

   ; match string to glob pattern (unix style)
   ; case matters
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
   
   cp (hl)                     ; match a literal

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
