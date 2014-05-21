
#ifndef _DRIVER_DRIVER_ZX_H
#define _DRIVER_DRIVER_ZX_H

#ifdef __SDCC

// SDCC

extern void                      cons_cls_00(void);
extern void                      cons_scroll_00(uint16_t rows);

#else

// SCCZ80

extern void __LIB__              cons_cls_00(void);
extern void __LIB__ __FASTCALL__ cons_scroll_00(uint16_t rows);

#endif


#endif
