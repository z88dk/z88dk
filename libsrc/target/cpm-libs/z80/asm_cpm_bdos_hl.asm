
; ===============================================================
; 2015
; ===============================================================
; 
; int cpm_bdos_hl(unsigned int func,unsigned int arg)
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_cpm_bdos_hl

asm_cpm_bdos_hl:

   ; enter :  c = bdos function
   ;         de = argument
   ;
   ; exit  : hl = sign extended register A (returned by cpm)

IF __SDCC

   push ix
   push iy
   
   call 0x0005
   
   pop iy
   pop ix

ELSE

   call 0x0005

ENDIF

   ld l,a
   rla
   sbc a,a
   ld h,a
   
   ret
