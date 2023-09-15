include(__link__.m4)

#ifndef __IM2_H__
#define __IM2_H__

#include <stdint.h>

__DPROTO(`b,c,d,e,h,l,iyl,iyh',`b,c,d,e,iyl,iyh',void,,im2_init,void *im2_table_address)
__DPROTO(`b,c,iyl,iyh',`b,c,iyl,iyh',void,*,im2_install_isr,uint8_t vector,void *isr)
__DPROTO(`iyl,iyh',`iyl,iyh',void,*,im2_create_generic_isr,uint8_t num_callbacks,void *address)
__DPROTO(`iyl,iyh',`iyl,iyh',void,*,im2_create_generic_isr_8080,uint8_t num_callbacks,void *address)
__DPROTO(`iyl,iyh',`iyl,iyh',void,,im2_append_generic_callback,uint8_t vector,void *callback)
__DPROTO(`iyl,iyh',`iyl,iyh',void,,im2_prepend_generic_callback,uint8_t vector,void *callback)
__DPROTO(`iyl,iyh',`iyl,iyh',int,,im2_remove_generic_callback,uint8_t vector,void *callback)

#ifdef __CLANG

#define IM2_DEFINE_ISR(name)       error clang does not support IM2_DEFINE_ISR;
#define IM2_DEFINE_ISR_8080(name)  error clang does not support IM2_DEFINE_ISR_8080;

#endif

#define IM2_DEFINE_ISR(name)  void name(void) __naked \
{ \
__asm__("\tEXTERN\tasm_im2_push_registers\n" \
"\tEXTERN\tasm_im2_pop_registers\n" \
"\n" \
"\tcall\tasm_im2_push_registers\n" \
"\tcall\t__im2_isr_" #name "\n" \
"\tcall\tasm_im2_pop_registers\n" \
"\n" \
"\tei\n" \
"\treti\n" \
); \
} \
void _im2_isr_##name(void)

#define IM2_DEFINE_ISR_8080(name)  void name(void) __naked \
{ \
__asm__("\tEXTERN\tasm_im2_push_registers_8080\n" \
"\tEXTERN\tasm_im2_pop_registers_8080\n" \
"\n" \
"\tcall\tasm_im2_push_registers_8080\n" \
"\tcall\t__im2_isr_8080_" #name "\n" \
"\tcall\tasm_im2_pop_registers_8080\n" \
"\n" \
"\tei\n" \
"\treti\n" \
); \
} \
void _im2_isr_8080_##name(void)

#if __SPECTRUM || __ZXNEXT

#define IM2_DEFINE_ISR_WITH_BASIC(name)  void name(void) __naked \
{ \
__asm__("\tEXTERN\tasm_im2_push_registers\n" \
"\tEXTERN\tasm_im2_pop_registers\n" \
"\n" \
"\tcall\tasm_im2_push_registers\n" \
"\tcall\t__im2_isr_" #name "\n" \
"\tcall\tasm_im2_pop_registers\n" \
"\n" \
"\tpush iy\n" \
"\tld iy,0x5c3a\n" \
"\tcall 0x0038\n" \
"\tpop iy\n" \
"\treti\n" \
); \
} \
void _im2_isr_##name(void)


#endif


#endif
