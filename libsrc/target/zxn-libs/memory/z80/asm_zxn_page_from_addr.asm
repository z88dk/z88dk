; ===============================================================
; 2017
; ===============================================================
; 
; unsigned char zxn_page_from_addr(uint32_t addr)
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zxn_page_from_addr
PUBLIC asm_zxn_page_from_addr_nocheck

EXTERN error_mc

asm_zxn_page_from_addr:

   ; return page number from linear address
   ;
   ; enter : dehl = address
   ;
   ; exit  : success
   ;
   ;            l = 8k page number 0-255
   ;            carry reset
   ;
   ;         fail
   ;
   ;            l = -1
   ;            carry set
   ;
   ; uses  : af, hl

   inc d
   dec d
   jp nz, error_mc
   
   ld a,e
   cp 255/8+1
   jp nc, error_mc
   
   ; page number is in range

asm_zxn_page_from_addr_nocheck:

   ; ahl = address

   rl h
   rla
   rl h
   rla
   rl h
   rla
   
   ld l,a
IF __SCCZ80
   ld h,0
ENDIF
   ret
