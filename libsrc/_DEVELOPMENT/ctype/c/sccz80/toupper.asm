
; int toupper(int c)

SECTION code_clib
SECTION code_ctype

PUBLIC toupper

EXTERN asm_toupper

toupper:

   inc h
   dec h
   ret nz

   ld a,l
   call asm_toupper
   
   ld l,a
   ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _toupper
defc _toupper = toupper
ENDIF

