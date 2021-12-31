
; ===============================================================
; Dec 2021 feilipu
; ===============================================================
; 
; BSD
; void *rawmemchr(const void *mem, int c)
;
; Matches a character pointed to by mem.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_rawmemchr

asm_rawmemchr:

   ; enter : hl = void *mem
   ;          a = int c
   ;
   ; exit  : hl = pointer to char c
   ;
   ; uses  : af, bc, hl
   
   ld bc,0

IF __CPU_INTEL__ || __CPU_GBZ80__
loop:
   cp (hl)
   jr Z,matched
   inc hl

   dec c
   jr NZ,loop
   dec b
   jr NZ,loop

matched:

ELSE
   cpir
   dec hl

ENDIF
   ret
