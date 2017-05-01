include(__link__.m4)

#ifndef _IM2_H
#define _IM2_H

#include <stdint.h>

__DPROTO(`b,c,d,e,h,l',`b,c,d,e',void,,im2_init,void *im2_table_address)
__DPROTO(`b,c',`b,c',void,*,im2_install_isr,uint8_t vector,void *isr)
__DPROTO(,,void,*,im2_create_generic_isr,uint8_t num_callbacks,void *address)
__DPROTO(,,void,*,im2_create_generic_isr_8080,uint8_t num_callbacks,void *address)
__DPROTO(,,void,,im2_append_generic_callback,uint8_t vector,void *callback)
__DPROTO(,,void,,im2_prepend_generic_callback,uint8_t vector,void *callback)
__DPROTO(,,int,,im2_remove_generic_callback,uint8_t vector,void *callback)

#endif
