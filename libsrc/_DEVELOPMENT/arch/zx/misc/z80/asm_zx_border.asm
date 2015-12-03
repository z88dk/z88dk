
; ===============================================================
; 2014
; ===============================================================
; 
; void zx_border(uchar colour)
;
; Set border colour and avoid audible click.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_border

EXTERN __sound_bit_state

asm_zx_border:

   ; enter :  l = border colour 0..7
   ;
   ; uses  : af, hl
   
   ld a,l
   and $07
   ld l,a
   
   ld a,(__sound_bit_state)
   and $f8
   or l
   ld (__sound_bit_state),a
   
   out ($fe),a
   ret
