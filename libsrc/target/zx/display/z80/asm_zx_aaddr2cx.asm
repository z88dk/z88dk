
; ===============================================================
; Jun 2007
; ===============================================================
;
; uchar zx_aaddr2cx(void *attraddr)
;
; Attribute address to character x coordinate. 
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_aaddr2cx

asm_zx_aaddr2cx:

   ; enter : hl = valid attribute address
   ;
   ; exit  : l = character x coordinate of attr square
   ;
   ; uses  : af, l

   ld a,l
   and $1f
   ld l,a

IF __SCCZ80
   ld h,0
ENDIF

   ret
