
; ===============================================================
; Jan 2014 / Dec 2021 feilipu
; ===============================================================
; 
; char *_memlwr(void *p, size_t n)
;
; Change letters in buffer p to lower case.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm__memlwr

EXTERN asm_tolower

asm__memlwr:

   ; enter : hl = void *p
   ;         bc = size_t n
   ;
   ; exit  : hl = void *p
   ;         bc = 0
   ;
   ; uses  : af, bc

   ld a,b
   or c
   ret Z

   push hl

IF __CPU_INTEL__ || __CPU_GBZ80__

   dec bc
   inc b
   inc c

loop:
   ld a,(hl)
   call asm_tolower
   ld (hl+),a

   dec c
   jr NZ,loop
   dec b
   jr NZ,loop

ELSE

loop:
   ld a,(hl)
   call asm_tolower
   ld (hl),a

   cpi                         ; hl++, bc--
   jp pe,loop

ENDIF

   pop hl
   ret
