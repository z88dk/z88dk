; ===================================================================
; SMS aPLib decompression library
; version 1.2
; 1/12/2008
; Maxim (http://www.smspower.org/maxim)
; based on code by Dan Weiss (Dwedit) - see readme.txt
; ===================================================================
; 
; void sms_aplib_vram_depack(void *dst, void *src)
;
; Decompress the compressed block at address src to vram address dst.
; VRAM addresses are assumed to be stable.
;
; ===================================================================

SECTION code_clib
SECTION code_compress_aplib

PUBLIC asm_sms_aplib_depack_vram

EXTERN __aplib_var_bits, __aplib_var_byte
EXTERN __aplib_var_LWM, __aplib_var_R0

EXTERN __aplib_getbit, __aplib_getbitbc, __aplib_getgamma
EXTERN asm_sms_ldir_vram_to_vram, asm_sms_set_vram_write_de, asm_sms_set_vram_read_hl

ap_VRAMToDE_write:

   push af
   call asm_sms_set_vram_write_de
   pop af
   ret
   
ap_VRAMToHL_read:

   push af
   call asm_sms_set_vram_read_hl
   pop af
   ret
      
ap_VRAM_ldi_src_to_dest:

   call ap_VRAMToDE_write
   push bc
      ld c,$be
      outi
   pop bc
   dec bc
   inc de
   ret

ap_VRAM_ldir_dest_to_dest:

  ; This may be a major speed bottleneck
  ; possibly could take some stack space for a buffer? but that'd need a lot more code space
  ; if it uses overlapping source/dest then a buffer will break it

   push af
   call asm_sms_ldir_vram_to_vram
   pop af
   ret
   
_vram_apbranch2:

   ;use a gamma code * 256 for offset, another gamma code for length

   call __aplib_getgamma
   dec bc
   dec bc
   ld a,(__aplib_var_LWM)
   or a
   jr nz,_vram_ap_not_LWM

   ;bc = 2? ; Maxim: I think he means 0
   
   ld a,b
   or c
   jr nz,_vram_ap_not_zero_gamma

   ;if gamma code is 2, use old R0 offset, and a new gamma code for length

   call __aplib_getgamma
   push hl
      ld h,d
      ld l,e
      push bc
         ld bc,(__aplib_var_R0)
         sbc hl,bc
      pop bc
      call ap_VRAM_ldir_dest_to_dest
   pop hl
   jr _vram_ap_finishup

_vram_ap_not_zero_gamma:

   dec bc

_vram_ap_not_LWM:

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
         jr nc, m0
         inc bc
m0:      ld hl,-1280
         add hl,de
         jr nc, m1
         inc bc
m1:      ld hl,-128
         add hl,de
         jr c, m2
         inc bc
         inc bc

m2:      ;bc = len, de = offs, hl=junk

      pop hl
      push hl
         or a
         sbc hl,de
      pop de
      
      ;hl=dest-offs, bc=len, de = dest
    
      call ap_VRAM_ldir_dest_to_dest
   pop hl
   
_vram_ap_finishup:

  ld a,1
  ld (__aplib_var_LWM),a
  jr _vram_aploop

_vram_apbranch1:    ; Maxim: moved this one closer to where it's jumped from to allow jr to work and save 2 bytes

  call ap_VRAM_ldi_src_to_dest
  xor a
  ld (__aplib_var_LWM),a
  jr _vram_aploop

asm_sms_aplib_depack_vram:

   ; enter : hl = void *src
   ;         de = void *dst (in vram)
   ;
   ; uses  : af, bc, de, hl, af'
   ;
   ; VRAM addresses are assumed to be stable (ie. di/ei around it)
   
   call ap_VRAM_ldi_src_to_dest   ; first byte is always uncompressed
   xor a
   ld (__aplib_var_LWM),a
   inc a
   ld (__aplib_var_bits),a

_vram_aploop:

   call __aplib_getbit
   jr z, _vram_apbranch1
   call __aplib_getbit
   jr z, _vram_apbranch2
   call __aplib_getbit
   jr z, _vram_apbranch3
   
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
   jr nz,_vram_apbranch4
   
 ;  xor a  ;write a 0 ; Maxim: a is zero already (just failed nz test), optimise this line away

_WriteAToVRAMAndLoop:

   call ap_VRAMToDE_write
   out ($be),a
   inc de
   jr _vram_aploop
   
_vram_apbranch4:
 
   ex de,hl   ;write a previous bit (1-15 away from dest)
   push hl
      sbc hl,bc
      call ap_VRAMToHL_read
      in a,($be)
   pop hl
   ex de,hl
   jr _WriteAToVRAMAndLoop
   
_vram_apbranch3:

   ;use 7 bit offset, length = 2 or 3
   ;if a zero is encountered here, it's EOF

   ld c,(hl)
   inc hl
   rr c
   ret z
   ld b,2
   jr nc, n0
   inc b

n0: ;LWM = 1

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
      call ap_VRAM_ldir_dest_to_dest
   pop hl
   jr _vram_aploop
