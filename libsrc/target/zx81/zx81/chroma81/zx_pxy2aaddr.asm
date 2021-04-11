; uchar *zx_pxy2aaddr(uchar xcoord, uchar ycoord)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC zx_pxy2aaddr
PUBLIC _zx_pxy2aaddr

EXTERN asm_zx_pxy2aaddr

.zx_pxy2aaddr
._zx_pxy2aaddr

   pop af
   pop de
   pop hl
   push hl
   push de
   push af
   
   ld h,e
   jp asm_zx_pxy2aaddr
