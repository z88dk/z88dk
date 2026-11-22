#ifndef _SPRITES_H
#define _SPRITES_H

#ifndef NULL
#define NULL  ((void *)0)
#endif

#define MAX_SPRITES  20

#define PLAYER       0

#define ST_ALL       254  // all but the player!

#define ST_PLAYER    1
#define ST_BULLET    2
#define ST_EBULLET   4
#define ST_ENEMY     8
#define ST_EXPLO     16
#define ST_HIT       32

#define OBJ_USED     255

// usually fullscreen; define it in your main

extern struct sp1_Rect cr;

struct ssprites
{
   struct sp1_ss *s;
   // position
	int x;
	int y;
   // movement
	int ix;
	int iy;

	unsigned char frame;
	unsigned char delay;

   unsigned char type;
	unsigned char *sprite;
   unsigned char alive;
   struct ssprites *n;
};

extern struct ssprites sprites[MAX_SPRITES];

// lists

extern struct ssprites *sp_free;
extern struct ssprites *sp_used;

// shared iterators

extern struct ssprites *sp_iter, *sp_iter2;

// if there are items to garbage collect

extern int sp_collect;

extern void          init_sprites(void);
extern unsigned char add_sprite(void);
extern void          collect_sprites(void);
extern void          destroy_type_sprite(unsigned char type);
extern int           add_explo(int x, int y);
extern void          add_enemy(int x, int y, unsigned char *sprite);
extern void          remove_sprite(struct ssprites *s);
extern void          add_bullet(unsigned char type, unsigned char x, unsigned char y);

#endif
