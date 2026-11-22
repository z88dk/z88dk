
#ifndef ARCH_ZXN_SPRITE_H
#define ARCH_ZXN_SPRITE_H

#include <sys/compiler.h>
#include <stdint.h>


struct sprite
{
   // Sprite attribute 0
   uint8_t x;
   // Sprite attribute 1
   uint8_t y;

   // Sprite attribute 2
   uint8_t xmsb:1;      // Bit 0
   uint8_t rotate:1;
   uint8_t ymirror:1;
   uint8_t xmirror:1;
   uint8_t palette_offset:4;

   // Sprite attribute 3
   uint8_t pattern:6;
   uint8_t extended:1;
   uint8_t visible:1;

   // Sprite attribute 4
   uint8_t  ymsb:1;
   uint8_t  yscale:2;
   uint8_t  xscale:2;
   uint8_t  composite_or_unified:1;
   // If set uses second half of pattern
   uint8_t  sprite_4bit_high:1;
   uint8_t  sprite_is_4bit:1;
};

extern void __LIB__  sprite_init(struct sprite *s);
extern void __LIB__  sprite_set_x(struct sprite *s, uint16_t x);
extern void __LIB__  sprite_set_y(struct sprite *s, uint16_t y);
extern void __LIB__  sprite_set_pattern_number(struct sprite *s, uint8_t pattern_number);
extern void __LIB__  sprite_set_xmirror(struct sprite *s);
extern void __LIB__  sprite_unset_xmirror(struct sprite *s);
extern void __LIB__  sprite_set_ymirror(struct sprite *s);
extern void __LIB__  sprite_unset_ymirror(struct sprite *s);
extern void __LIB__  sprite_set_rotate(struct sprite *s);
extern void __LIB__  sprite_unset_rotate(struct sprite *s);
extern void __LIB__  sprite_set_visible(struct sprite *s);
extern void __LIB__  sprite_unset_visible(struct sprite *s);
extern void __LIB__  sprite_set_xscale(struct sprite *s, uint8_t scale);
extern void __LIB__  sprite_set_yscale(struct sprite *s, uint8_t scale);
extern void __LIB__  sprite_set_palette_offset(struct sprite *s, uint8_t offset);
extern void __LIB__  sprite_set_4bit_high(struct sprite *s);
extern void __LIB__  sprite_unset_4bit_high(struct sprite *s);
extern void __LIB__  sprite_set_4bit(struct sprite *s);
extern void __LIB__  sprite_unset_4bit(struct sprite *s);
extern void __LIB__  sprite_set_unified(struct sprite *s);
extern void __LIB__  sprite_set_composite(struct sprite *s);
extern void __LIB__  sprite_update(uint8_t spnum, struct sprite *s);

#endif