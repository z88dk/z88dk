
; ===============================================================
; Jan 2014
; ===============================================================
; 
; char *_memupr(void *p, size_t n)
;
; Change letters in buffer p to upper case.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm__memupr

EXTERN asm_toupper

asm__memupr:

   ; enter : hl = void *p
   ;         bc = size_t n
   ;
   ; exit  : hl = void *p
   ;         bc = 0
   ;
   ; uses  : af, bc

   ld a,b
   or c
   ret z
   
   push hl

loop:

   ld a,(hl)
   call asm_toupper
   ld (hl),a
   
IF __CPU_GBZ80__
   inc hl
   dec bc
   ld a,b
   or c
   jp nz,loop
ELSE
   cpi                         ; hl++, bc--
   jp pe, loop
ENDIF

   pop hl
   ret
