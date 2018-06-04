include(__link__.m4)

#ifndef __INTRINSIC_H__
#define __INTRINSIC_H__

#ifdef __SDCC

// disable warnings connected to intrinsics

#pragma disable_warning 84
#pragma disable_warning 112

#endif

#ifdef __CLANG

#define intrinsic_label(name)  { extern void intrinsic_label_##name(void); intrinsic_label_##name(); }
#define intrinsic_load16(address)  ((unsigned int)intrinsic_load16_##address())
#define intrinsic_store16(address,value)  ((unsigned int)(intrinsic_store16_address_##address(),intrinsic_store16_value_##value()))

extern void intrinsic_ldi(void*,void*,unsigned char);
extern void intrinsic_outi(void*,unsigned char,unsigned char);

#else

#define intrinsic_label(name)  { extern void intrinsic_label_##name(void) __preserves_regs(a,b,c,d,e,h,l); intrinsic_label_##name(); }
#define intrinsic_load16(address)  ((unsigned int)intrinsic_load16_##address())
#define intrinsic_store16(address,value)  ((unsigned int)(intrinsic_store16_address_##address(),intrinsic_store16_value_##value()))

extern void intrinsic_ldi(void*,void*) __z88dk_callee;
#define intrinsic_ldi_helper(dst,src,num)  { intrinsic_ldi(dst,src); intrinsic_ldi_num_##num(); }
#define intrinsic_ldi(dst,src,num)  intrinsic_ldi_helper(dst,src,num)

extern void intrinsic_outi(void*) __z88dk_fastcall;
#define intrinsic_outi_helper(src,port,num)  { intrinsic_outi(src); intrinsic_outi_port_##port(); intrinsic_outi_num_##num(); }
#define intrinsic_outi(src,port,num)  intrinsic_outi_helper(src,port,num)

extern void intrinsic_ini(void*) __z88dk_fastcall;
#define intrinsic_ini_helper(dst,port,num)  { intrinsic_ini(dst); intrinsic_ini_port_##port(); intrinsic_ini_num_##num(); }
#define intrinsic_ini(dst,port,num)  intrinsic_ini_helper(dst,port,num)

#endif

__OPROTO(`a,b,c,d,e,h,l',`a,b,c,d,e,h,l',void,,intrinsic_stub,void)

__OPROTO(`a,b,c,d,e,h,l',`a,b,c,d,e,h,l',void,,intrinsic_di,void)
__OPROTO(`a,b,c,d,e,h,l',`a,b,c,d,e,h,l',void,,intrinsic_ei,void)
__OPROTO(`a,b,c,d,e,h,l',`a,b,c,d,e,h,l',void,,intrinsic_halt,void)
__OPROTO(`a,b,c,d,e,h,l',`a,b,c,d,e,h,l',void,,intrinsic_reti,void)
__OPROTO(`a,b,c,d,e,h,l',`a,b,c,d,e,h,l',void,,intrinsic_retn,void)
__OPROTO(`a,b,c,d,e,h,l',`a,b,c,d,e,h,l',void,,intrinsic_im_0,void)
__OPROTO(`a,b,c,d,e,h,l',`a,b,c,d,e,h,l',void,,intrinsic_im_1,void)
__OPROTO(`a,b,c,d,e,h,l',`a,b,c,d,e,h,l',void,,intrinsic_im_2,void)
__OPROTO(`a,b,c,d,e,h,l',`a,b,c,d,e,h,l',void,,intrinsic_nop,void)

__OPROTO(`a,b,c',`a,b,c',void,,intrinsic_ex_de_hl,void)
__OPROTO(`a',`a',void,,intrinsic_exx,void)

__OPROTO(`a,b,c,d,e',`a,b,c,d,e',void,*,intrinsic_return_bc,void)
__OPROTO(`a,b,c,d,e',`a,b,c,d,e',void,*,intrinsic_return_de,void)

__DPROTO(`b,c,d,e',`b,c,d,e',unsigned int,,intrinsic_swap_endian_16,unsigned int n)
__DPROTO(`b,c',`b,c',unsigned long,,intrinsic_swap_endian_32,unsigned long n)
__DPROTO(`a,b,c',`a,b,c',unsigned long,,intrinsic_swap_word_32,unsigned long n)

#ifdef __Z180

__OPROTO(`a,b,c,d,e,h,l',`a,b,c,d,e,h,l',void,,intrinsic_slp,void)

#endif

#endif
