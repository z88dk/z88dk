
; ===============================================================
; 2015
; ===============================================================
; 
; int cpm_bdos(unsigned int func,unsigned int arg)
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_cpm_bdos

; enter :  c = bdos function
;         de = argument
;
; exit  : registers set by cpm

IF __SDCC

asm_cpm_bdos:

   push ix
   push iy
   
   call 0x0005
   
   pop iy
   pop ix
   
   ret

ELSE

defc asm_cpm_bdos = 0x0005

ENDIF
