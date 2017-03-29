; ========================================================================
; 
; void *sms_ldir_vram_to_vram_unsafe(void *dst, void *src, unsigned int n)
;
; memcpy within vram unsafe; ; VRAM addresses are assumed to be stable.
;
; ========================================================================

SECTION code_clib
SECTION code_crt_common

PUBLIC asm_sms_ldir_vram_to_vram_unsafe

asm_sms_ldir_vram_to_vram_unsafe:

   ; memcpy within vram
   ;
   ; enter : hl = void *src in vram
   ;         de = void *dst in vram
   ;         bc = unsigned int n > 0
   ;
   ; exit  : hl = void *src, &byte after last read
   ;         de = void *dst, &byte after last written
   ;
   ; uses  : af, bc, de, hl, af'
   
loop:

   ld a,l
   out ($bf),a
   ld a,h
   out ($bf),a
    
   in a,($be)
   ex af,af'
    
   ld a,e
   out ($bf),a
   ld a,d
   or $40
   out ($bf),a
    
   ex af,af'
   out ($be),a
    
   inc de
    
   cpi
   jp pe, loop
    
   ret
