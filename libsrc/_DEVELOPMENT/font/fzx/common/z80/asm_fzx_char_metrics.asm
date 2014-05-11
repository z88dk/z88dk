
; ===============================================================
; aralbrec - Nov 2013
; ===============================================================
;
; int fzx_char_metrics(struct fzx_cmetric *m, uchar c)
;
; Fill the struct "m" with metrics for character c.
;
; ===============================================================

PUBLIC asm_fzx_char_metrics

EXTERN __fzx_char_metrics, error_zc, _fzx

asm_fzx_char_metrics:

   ; enter : de = struct fzx_cmetric *m
   ;          a = char
   ;
   ; exit  : ix = struct fzx_font *
   ;         
   ;         carry flag set if char unprintable
   ;         hl = 0
   ;
   ;         carry flag reset if successful
   ;         hl = non-zero
   ;
   ; uses  : af, bc, de, hl, ix
   
   ld ix,(_fzx + 0)            ; current font
   
   call __fzx_char_metrics     ; get glyph metrics
   jp c, error_zc              ; if char is unprintable
   
   dec hl
   dec hl
   push hl                     ; save struct fzx_char *
   
   ld l,a                      ; l = shift_width_1
   
   ld a,b
   rlca
   rlca
   and $03                     ; a = kern
   
   ld (de),a
   inc de
   
   ld a,l
   and $0f
   inc a                       ; a = width
   
   ld (de),a
   inc de
   
   ld a,l
   rrca
   rrca
   rrca
   rrca
   and $0f                     ; a = shift
   
   ld (de),a
   inc de
   
   pop hl                      ; hl = struct fzx_char *
   
   ld a,b
   and $3f                     ; strip kern
   ld b,a                      ; bc = bitmap offset
   
   add hl,bc                   ; hl = bitmap address
   
   ex de,hl
   ld (hl),e
   inc hl
   ld (hl),d
   
   ret
