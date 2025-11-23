; uchar __FASTCALL__ inp(uint port)
;
; 8080 version originally written in 1982 by William C. Colley III

IF __CPU_INTEL__

SECTION code_clib
PUBLIC inp
PUBLIC _inp

EXTERN iotmp

.inp
._inp

   ; port in l
   ld h,l         ; port
   ld l,0xdb      ; in
   ld (iotmp),hl
   ld hl,iotmp+2
   ld (hl),0xc9   ; ret
   call iotmp
   ld h,0
   ld l,a         ; return byte in hl
   ret

ENDIF

