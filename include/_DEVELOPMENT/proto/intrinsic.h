include(__link__.m4)

#ifndef _INTRINSIC_H
#define _INTRINSIC_H

#ifdef __SDCC

#define intrinsic_label(name)  { extern void intrinsic_label_##name(void) __preserves_regs(a,b,c,d,e,h,l); intrinsic_label_##name(); }
#define intrinsic_load16(address)  ((unsigned int)intrinsic_load16_##address())
#define intrinsic_store16(address,value)  ((unsigned int)(intrinsic_store16_address_##address(),intrinsic_store16_value_##value()))

#define intrinsic_in8(port)  ((unsigned char)intrinsic_in8_port_##port())
#define intrinsic_out8(port,value)  ((unsigned char)(intrinsic_out8_port_##port(),intrinsic_out8_value_##value()))
#define intrinsic_in16(port)  ((unsigned char)intrinsic_in16_port_##port())
#define intrinsic_out16(port,value)  ((unsigned char)(intrinsic_out16_port_##port(),intrinsic_out16_value_##value()))

#else

#define intrinsic_label(name)  asm("name:");
#define intrinsic_load16(address)  ((unsigned int)intrinsic_load16_##address())
#define intrinsic_store16(address,value)  ((unsigned int)(intrinsic_store16_address_##address(),intrinsic_store16_value_##value()))

#define intrinsic_in8(port)  ((unsigned char)intrinsic_in8_port_##port())
#define intrinsic_out8(port,value)  ((unsigned char)(intrinsic_out8_port_##port(),intrinsic_out8_value_##value()))
#define intrinsic_in16(port)  ((unsigned char)intrinsic_in16_port_##port())
#define intrinsic_out16(port,value)  ((unsigned char)(intrinsic_out16_port_##port(),intrinsic_out16_value_##value()))

#endif

__OPROTO(`a,b,c,d,e,h,l',`a,b,c,d,e,h,l',void,,intrinsic_di,void)
__OPROTO(`a,b,c,d,e,h,l',`a,b,c,d,e,h,l',void,,intrinsic_ei,void)
__OPROTO(`a,b,c,d,e,h,l',`a,b,c,d,e,h,l',void,,intrinsic_halt,void)
__OPROTO(`a,b,c,d,e,h,l',`a,b,c,d,e,h,l',void,,intrinsic_reti,void)
__OPROTO(`a,b,c,d,e,h,l',`a,b,c,d,e,h,l',void,,intrinsic_retn,void)
__OPROTO(`a,b,c,d,e,h,l',`a,b,c,d,e,h,l',void,,intrinsic_im_0,void)
__OPROTO(`a,b,c,d,e,h,l',`a,b,c,d,e,h,l',void,,intrinsic_im_1,void)
__OPROTO(`a,b,c,d,e,h,l',`a,b,c,d,e,h,l',void,,intrinsic_im_2,void)
__OPROTO(`a,b,c,d,e,h,l',`a,b,c,d,e,h,l',void,,intrinsic_nop,void)
__OPROTO(`a,b,c,d,e,h,l',`a,b,c,d,e,h,l',void,,intrinsic_push_af,void)
__OPROTO(`a,b,c,d,e,h,l',`a,b,c,d,e,h,l',void,,intrinsic_push_bc,void)
__OPROTO(`a,b,c,d,e,h,l',`a,b,c,d,e,h,l',void,,intrinsic_push_de,void)
__OPROTO(`a,b,c,d,e,h,l',`a,b,c,d,e,h,l',void,,intrinsic_push_hl,void)
__OPROTO(`a,b,c,d,e,h,l',`a,b,c,d,e,h,l',void,,intrinsic_push_ix,void)
__OPROTO(`a,b,c,d,e,h,l',`a,b,c,d,e,h,l',void,,intrinsic_push_iy,void)
__OPROTO(`b,c,d,e,h,l',`b,c,d,e,h,l',void,,intrinsic_pop_af,void)
__OPROTO(`a,d,e,h,l',`a,d,e,h,l',void,,intrinsic_pop_bc,void)
__OPROTO(`a,b,c,h,l',`a,b,c,h,l',void,,intrinsic_pop_de,void)
__OPROTO(`a,b,c,d,e',`a,b,c,d,e',void,,intrinsic_pop_hl,void)
__OPROTO(`a,b,c,d,e,h,l',`a,b,c,d,e,h,l',void,,intrinsic_pop_ix,void)
__OPROTO(`a,b,c,d,e,h,l',`a,b,c,d,e,h,l',void,,intrinsic_pop_iy,void)

__OPROTO(`a,b,c,d,e,h,l',`a,b,c,d,e,h,l',void,,intrinsic_ex_de_hl,void)
__OPROTO(`a',`a',void,,intrinsic_exx,void)

__DPROTO(`b,c,d,e,h,l',`b,c,d,e,h,l',unsigned int,,intrinsic_swap_endian_16,unsigned int n)
__DPROTO(`a,b,c,d,e,h,l',`a,b,c,d,e,h,l',unsigned long,,intrinsic_swap_endian_32,unsigned long n)

#endif
