;
;       Amstrad CPC library
;
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2007       **
; ******************************************************
;
;       void __LIB__ __CALLEE__ cpc_Uncrunch(int src, int dst);
;
;       $Id: cpc_Uncrunch_callee.asm $
;

        SECTION   smc_clib
        PUBLIC    cpc_Uncrunch_callee
        PUBLIC    _cpc_Uncrunch_callee
        PUBLIC    asm_cpc_Uncrunch
		
        EXTERN cpc_DisableFirmware
        EXTERN cpc_EnableFirmware
		

        INCLUDE "target/cpc/def/cpcfirm.def"
		

.cpc_Uncrunch_callee
._cpc_Uncrunch_callee

   pop hl
   pop de
   ex (sp),hl
	
	
.asm_cpc_Uncrunch
; datos necesarios que vienen en la pila:
; ORIGEN	HL
; DESTINO	DE

	;Ojo, para que el pucrunch funcione hay que coger y quitar el salto de las interrupciones.
	push hl
	call cpc_DisableFirmware
	pop hl
	
   push   de         ; destination pointer to 2nd register 
   exx            ; set 
   pop   de 

   
   push   hl 
   push   de 
   push   bc 
   push   af 

   exx 

        ; read the header self-modifying the 
        ; parameters straight into the code 
        ; skip useless data 
 
   
   ld bc,6
   add hl,bc

   ld   a, (hl)         ; starting escape 
   inc   hl 
   ld   (esc+1), a 

   inc   hl         ; skip useless data 
   inc   hl 

   ld   a, (hl)         ; number of escape bits 
   inc   hl 
   ld   (escb0+1), a 
   ld   (escb1+1), a 

   ld   b, a         ; 8 - escape bits 
   ld   a, 8 
   sub   b 
   ld   (noesc+1), a 

   ld   a, (hl)         ; maxGamma + 1 
   inc   hl 
   ld   (mg+1), a 

   ld   b, a         ; 8 - maxGamma 
   ld   a, 9 
   sub   b 
   ld   (longrle+1), a 

   ld   a, (hl)         ; (1 << maxGamma) 
   inc   hl 
   ld   (mg1+1), a 

   add   a, a         ; (2 << maxGamma) - 1 
   dec   a 
   ld   (mg21+1), a 

   ld   a, (hl)         ; extra lz77_0 position bits 
   inc   hl 
   ld   (elzpb+1), a 

   inc   hl         ; skip useless data 
   inc   hl 

   ld   e, (hl)         ; RLE table length 
   ld   (rlet+1), hl      ; RLE table pointer 
   inc   hl 
   ld   d, 0 
   add   hl, de 

   ld   c, $80         ; start decompression 
   jp   loop_u 

.newesc
   ld   a, (esc+1)      ; save old escape code 
   ld   d, a 

.escb0
   ld   b, 2         ; ** parameter 
   xor   a         ; get new escape code 
   call   get_bits 
   ld   (esc+1), a 

   ld   a, d 

.noesc 
  ld   b, 6         ; ** parameter 
   call   get_bits      ; get more bits to complete a byte 

   exx            ; output the byte 
   ld   (de), a 
   inc   de 
   exx 

.loop_u 
  xor   a 
.escb1   
	ld   b, 2         ; ** parameter 
   call   get_bits      ; get escape code 
.esc   
	cp   0         ; ** parameter 
   jp   nz, noesc 

   call   get_gamma      ; get length 
   exx 
   ld   b, 0 
   ld   c, a 
   exx 

   cp   1 
   jp   nz, lz77_0      ; lz77_0 

   xor   a 
   call   get_bit 
   jp   nc, lz77_0_2      ; 2-byte lz77_0 

   call   get_bit 
   jp   nc, newesc      ; escaped literal byte 

   call   get_gamma      ; get length 
   exx 
   ld   b, 1 
   ld   c, a 
   exx 

.mg1   
	cp   64         ; ** parameter 
   jp   c, chrcode      ; short RLE, get bytecode 

.longrle   
	ld   b, 2         ; ** parameter 
   call   get_bits      ; complete length LSB 
   ex   af, af' 

   call   get_gamma      ; length MSB 
   exx 
   ld   b, a 
   ex   af, af' 
   ld   c, a 
   exx 

.chrcode   
  call   get_gamma      ; get byte to repeat 

   push   hl 
.rlet   
	ld   hl, $0000      ; ** parameter 
   ld   d, 0 
   ld   e, a 
   add   hl, de 

   cp   32 
   ld   a, (hl) 
   pop   hl 
   jp   c, dorle 

   ld   a, e         ; get 3 more bits to complete the 
   ld   b, 3         ; byte 
   call   get_bits 

.dorle   
exx            ; output the byte n times 
   inc   c 
.dorlei
   ld   (de), a 
   inc   de 
   dec   c 
   jp   nz, dorlei 
   dec   b 
   jp   nz, dorlei 
   exx 
   jp   loop_u 

.lz77_0
   call   get_gamma      ; offset MSB 
.mg21
   cp   127         ; ** parameter 

   ; ret   z 

   jp   z, fin         ; EOF, return 

   dec   a         ; (1...126 -> 0...125) 
.elzpb
   ld   b, 0         ; ** parameter 
   call   get_bits      ; complete offset MSB 

.lz77_0_2
   ex   af, af' 
   ld   b, 8         ; offset LSB 
   call   get_bits 
   cpl            ; xor'ed by the compressor 

   exx            ; combine them into offset 
   ld   l, a 
   ex   af, af' 
   ld   h, a 
   inc   hl 

   xor   a         ; CF = 0 

   push   de         ; (current output position) - (offset) 
   ex   de, hl 
   sbc   hl, de 
   pop   de 

   inc   bc 

   ldir            ; copy 
   exx 
   jp   loop_u 

;## Get a bit from the source stream. 
;## Return    CF = result 
.get_bit  
   sla   c         ; shift next bit into CF 
   ret   nz 
   ld   c, (hl)         ; get next byte 
   inc   hl         ; increase source stream pointer 
   rl   c         ; shift next bit into CF, bit0 = 1 
   ret 

;## Get multiple bits from the source stream. 
;## In        B = number of bits to get 
;## Return    A = result 
.get_bits  
   dec   b 
   ret   m 
   sla   c         ; shift next bit into CF 
   jp   nz, gb1 
   ld   c, (hl)         ; get next byte 
   inc   hl         ; increase source stream pointer 
   rl   c         ; shift next bit into CF, bit0 = 1 
.gb1
   rla            ; rotate next bit into A 
   jp   get_bits 

;## Get an Elias Gamma coded value from the source stream. 
;## Return    A = result 
.get_gamma  
   ld   b, 1 
.mg  
 ld   a, 7         ; ** parameter 
.gg1
  call   get_bit         ; get bits until 0-bit or max 
   jr   nc, gg2 
   inc   b 
   cp   b 
   jp   nz, gg1 
.gg2
   ld   a, 1         ; get the actual value 
   dec   b 
   jp   get_bits 

.fin 
   ; Restauramos los registros dobles y vuelta limpia 
   exx 
   pop   af 
   pop   bc 
   pop   de 
   pop   hl 
   exx 
	jp cpc_EnableFirmware
	
	