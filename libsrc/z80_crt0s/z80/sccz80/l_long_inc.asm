;       Small C+ Z88 Support Library
;
;	Increment long on hl
;	Kept little endian
;
;       djm 26/2/2000
;       aralbrec 01/2007

                SECTION   code_crt0_sccz80
PUBLIC    l_long_inc

.l_long_inc

   inc (hl)
   ret nz
   inc hl
   inc (hl)
   ret nz
   inc hl
   inc (hl)
   ret nz
   inc hl
   inc (hl)
   ret
