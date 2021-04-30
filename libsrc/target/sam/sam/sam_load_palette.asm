
    MODULE sam_load_palette

    PUBLIC sam_load_palette
    PUBLIC _sam_load_palette

    EXTERN  SAM_PALETTE_VALUES

; void sam_load_palette(unsigned char *data) __smallc;

; Writes the whole palette in one go
sam_load_palette:
_sam_load_palette:
   ld      hl,2
   add     hl,sp
   ld      a,(hl)
   inc     hl
   ld      h,(hl)
   ld      l,a
; Parameters: hl = location
   push    hl
   ld      bc,15
   add     hl,bc
   ld      bc,$10f8
   otdr
   pop     hl
   ld      de,SAM_PALETTE_VALUES
   ld      bc,16
   ldir
   ret

