; void __FASTCALL__ adt_ListCreateS(struct adt_List *)
; 11.2006 aralbrec

XLIB adt_ListCreateS

; initialize a struct adt_List

.adt_ListCreateS

   ld e,l
   ld d,h
   inc de
   ld (hl),0
   ld bc,8
   ldir
   ret
