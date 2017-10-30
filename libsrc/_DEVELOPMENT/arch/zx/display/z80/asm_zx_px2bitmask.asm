
; ===============================================================
; Jun 2007
; ===============================================================
;
; uchar zx_px2bitmask(uchar x)
;
; Return bitmask corresponding to pixel x coordinate.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_px2bitmask

asm_zx_px2bitmask:

   ; enter :  l = pixel x coordinate
   ;
   ; exit  :  l = 8-bit bitmask
   ;
   ; uses  : af, hl
   
   ld a,l
   and $07
   
   add a,mask_table & 0xff
   ld l,a
   adc a,mask_table / 256
   sub l
   ld h,a
   
   ld l,(hl)

IF __SCCZ80
   ld h,0
ENDIF

   ret

mask_table:

   defb $80, $40, $20, $10, $08, $04, $02, $01  
