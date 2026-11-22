; void outp_callee(uint port, uchar byte)
;
; 8080 version originally written in 1982 by William C. Colley III

IF __CPU_INTEL__

SECTION code_clib
PUBLIC outp_callee
PUBLIC _outp_callee
PUBLIC asm_outp

EXTERN iotmp

.outp_callee
._outp_callee

   pop hl
   pop de
   pop bc
   push hl

.asm_outp

   ; bc = port
   ; e = byte


   ld l,0xd3  ; out
   ld h,c     ; port
   ld (iotmp),hl
   ld hl,iotmp + 2
   ld (hl),0xc9  ;ret
   ld a,e        ; byte
   jp iotmp
   ret

ENDIF

