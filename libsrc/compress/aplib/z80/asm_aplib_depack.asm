; ===============================================================
; Z80 aPLib decompression library
; version 1.2
; 1/12/2008
; Maxim (http://www.smspower.org/maxim)
; based on code by Dan Weiss (Dwedit) - see readme.txt
; ===============================================================
; 
; void aplib_depack(void *dst, void *src)
;
; Decompress the compressed block at address src to address dst.
;
; ===============================================================

SECTION code_clib
SECTION code_compress_aplib

PUBLIC asm_aplib_depack

EXTERN __aplib_var_bits, __aplib_var_byte
EXTERN __aplib_var_LWM, __aplib_var_R0

EXTERN __aplib_getbit, __aplib_getbitbc, __aplib_getgamma

_apbranch2:

   ;use a gamma code * 256 for offset, another gamma code for length

   call __aplib_getgamma
   dec bc
   dec bc
   ld a,(__aplib_var_LWM)
   or a
   jr nz,_ap_not_LWM
  
   ;bc = 2? ; Maxim: I think he means 0
  
   ld a,b
   or c
   jr nz,_ap_not_zero_gamma
  
   ;if gamma code is 2, use old R0 offset, and a new gamma code for length
  
   call __aplib_getgamma
   push hl
      ld h,d
      ld l,e
      push bc
         ld bc,(__aplib_var_R0)
         sbc hl,bc
      pop bc
      ldir
   pop hl
   jr _ap_finishup

_ap_not_zero_gamma:

   dec bc

 _ap_not_LWM:
 
   ;do I even need this code? ; Maxim: seems so, it's broken without it
   ;bc=bc*256+(hl), lazy 16bit way
  
   ld b,c
   ld c,(hl)
   inc hl
   ld (__aplib_var_R0),bc
   push bc
      call __aplib_getgamma
      ex (sp),hl
      
      ;bc = len, hl=offs
      
      push de
         ex de,hl
         
         ;some comparison junk for some reason
         ; Maxim: optimised to use add instead of sbc
         
         ld hl,-32000
         add hl,de
         jr nc, l0
         inc bc
l0:      ld hl,-1280
         add hl,de
         jr nc, l1
         inc bc
l1:      ld hl,-128
         add hl,de
         jr c, l2
         inc bc
         inc bc
         
l2:      ;bc = len, de = offs, hl=junk

      pop hl
      push hl
         or a
         sbc hl,de
      pop de
      
      ;hl=dest-offs, bc=len, de = dest
    
      ldir
   pop hl
   
_ap_finishup:

   ld a,1
   ld (__aplib_var_LWM),a
   jr _aploop
   
_apbranch1:   ; Maxim: moved this one closer to where it's jumped from to allow jr to work and save 2 bytes

   ldi
   xor a
   ld (__aplib_var_LWM),a
   jr _aploop

asm_aplib_depack:

   ; enter : hl = void *src
   ;         de = void *dst
   ;
   ; uses  : af, bc, de, hl

   ldi
   xor a
   ld (__aplib_var_LWM),a
   inc a
   ld (__aplib_var_bits),a

_aploop:

   call __aplib_getbit
   jr z, _apbranch1
   call __aplib_getbit
   jr z, _apbranch2
   call __aplib_getbit
   jr z, _apbranch3

   ;LWM = 0

   xor a
   ld (__aplib_var_LWM),a
   
   ;get an offset
   
   ld bc,0
   call __aplib_getbitbc
   call __aplib_getbitbc
   call __aplib_getbitbc
   call __aplib_getbitbc
   ld a,b
   or c
   jr nz,_apbranch4

   ;  xor a  ;write a 0 ; Maxim: a is zero already (just failed nz test), optimise this line away

   ld (de),a
   inc de
   jr _aploop
   
_apbranch4:

   ex de,hl   ;write a previous bit (1-15 away from dest)
   push hl
      sbc hl,bc
      ld a,(hl)
   pop hl
   ld (hl),a
   inc hl
   ex de,hl
   jr _aploop
   
_apbranch3:

   ;use 7 bit offset, length = 2 or 3
   ;if a zero is encountered here, it's EOF
  
   ld c,(hl)
   inc hl
   rr c
   ret z
   ld b,2
   jr nc, m0
   inc b
   
m0:    ;LWM = 1

   ld a,1
   ld (__aplib_var_LWM),a

   push hl
      ld a,b
      ld b,0

      ;R0 = c

      ld (__aplib_var_R0),bc
      ld h,d
      ld l,e
      or a
      sbc hl,bc
      ld c,a
      ldir
   pop hl
   jr _aploop
