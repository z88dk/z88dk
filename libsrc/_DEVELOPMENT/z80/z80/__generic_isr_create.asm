
SECTION code_clib
SECTION code_z80

PUBLIC __generic_isr_create

__generic_isr_create:

   ; copy generic isr to destination address
   ; follow that with an array of callback functions initialized to zero
   
   ; enter : hl = address of generic isr function
   ;         de = destination address
   ;          a = number of callbacks
   ;
   ; exit  : hl = address following isr created
   ;
   ; uses  : af, bc, de, hl
   
   ld bc,16                    ; size of both generic isr types
   ldir                        ; copy generic isr to dest address
   
   add a,a
   inc a                       ; num callbacks++ for zero terminator
   ld c,a
   
   ld l,e
   ld h,d
   inc de
   ld (hl),b
   ldir
   
   ex de,hl
   ret
