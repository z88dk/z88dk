; uchar __FASTCALL__ inp(uint port)
; 09.2005 aralbrec
;
; 8080 version originally written in 1982 by William C. Colley III

SECTION code_clib
PUBLIC inp
PUBLIC _inp

.inp
._inp

IF __CPU_R2KA__|__CPU_R3K__

   defb 0d3h ; ioi
   ld a,(hl)
   ld h,0
   ld l,a

ELIF __CPU_8080__

   ; port in l
   ld h,l         ; port
   ld l,0xdb      ; in
   shld _iotmp
   lxi h,_iotmp + 2
   ld (hl),0xc9   ; ret
   call _iotmp
   ld h,0
   ld l,a         ; return byte in hl

ELSE

   ld c,l
   ld b,h
   in l,(c)
   ld h,0

ENDIF

   ret

SECTION bss_clib

._iotmp   defs  3
