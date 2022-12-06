; void outp_callee(uint port, uchar byte)
; 09.2005 aralbrec
;
; 8080 version originally written in 1982 by William C. Colley III

SECTION code_clib
PUBLIC outp_callee
PUBLIC _outp_callee
PUBLIC asm_outp

.outp_callee
._outp_callee

   pop hl
   pop de
   pop bc
   push hl

.asm_outp

   ; bc = port
   ; e = byte

IF __CPU_R2KA__|__CPU_R3K__

   ld h,b
   ld l,c
   ld a,e
   defb 0d3h ; ioi
   ld (hl),a

ELIF __CPU_INTEL__

   ld l,0xd3  ; out
   ld h,c     ; port
   shld _iotmp
   lxi h,_iotmp + 2
   ld (hl),0xc9  ;ret
   ld a,e        ; byte
   jp _iotmp

ELSE

   out (c),e

ENDIF

   ret

SECTION bss_clib

._iotmp   defs  3
