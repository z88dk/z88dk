#include <arch/zx/sp1.h>
#include <stdlib.h>
#include "gfx.h"
#include "sprites.h"

struct ssprites sprites[MAX_SPRITES];

// lists

struct ssprites *sp_free;
struct ssprites *sp_used;

// shared iterators

struct ssprites *sp_iter;
struct ssprites *sp_iter2;

// if there are items to garbage collect

int sp_collect = 0;

void
init_sprites(void)
{
   unsigned char i;
   
   // to be run ONCE
   
   sprites[PLAYER].s = sp1_CreateSpr(SP1_DRAW_MASK2LB, SP1_TYPE_2BYTE, 3, 16, 0);
   sp1_AddColSpr(sprites[PLAYER].s, SP1_DRAW_MASK2, 0, 64, 0);
   sp1_AddColSpr(sprites[PLAYER].s, SP1_DRAW_MASK2RB, 0, 0, 0);

   sprites[PLAYER].sprite = NULL;
   sprites[PLAYER].alive = 1;
   sprites[PLAYER].n = NULL;
   sprites[PLAYER].type = ST_PLAYER;

   // init our lists

   sp_used = sprites;
   sp_free = sprites + 1;

   for (i = 1; i < MAX_SPRITES - 1; ++i)
   {
        sprites[i].n = sprites + i + 1;
        sprites[i].alive = 0;
   }

   sprites[MAX_SPRITES - 1].n = NULL;
   sprites[MAX_SPRITES - 1].alive = 0;
}

unsigned char
add_sprite(void)
{
   struct ssprites *t;
   
   if (!sp_free)
      return 0;
   
   // always one is in use: the player!
   
   t = sp_used;
   sp_used = sp_free;
   sp_free = sp_free->n;
   sp_used->n = t;
   sp_used->alive = 1;
   
   return 1;
}

void
collect_sprites(void)
{
   struct ssprites *t, *tp;
   
   if (!sp_collect)
        return;

   // current, previous
   for (t = tp = sp_used; t && sp_collect;)
   {
      if (!t->alive)
      {
         if (t == sp_used)
         {
            tp = sp_free;
            sp_free = sp_used;
            sp_used = sp_used->n;
            sp_free->n = tp;
            t = tp = sp_used;
            --sp_collect;
            continue;
         }
         else
         {
            tp->n = t->n;
            t->n = sp_free;
            sp_free = t;
            t = tp->n;
            --sp_collect;
            continue;
         }
      }
      tp = t;
      t = t->n;
   }
}

void
destroy_type_sprite(unsigned char type)
{
   struct ssprites *t;

   if (!sp_used)
      return;

   for (t = sp_used; t; t = t->n)
   {
      if (t->alive && t->type & type)
      {
         sp1_MoveSprAbs(t->s, &cr, NULL, 0, 34, 0, 0);
         sp1_DeleteSpr(t->s);
         t->alive = 0;
         sp_collect++;
      }
   }
}

int
add_explo(int x, int y)
{
   if (!add_sprite())
      return 0;

   sp_used->s = sp1_CreateSpr(SP1_DRAW_MASK2LB, SP1_TYPE_2BYTE, 3, 16, 2);
   sp1_AddColSpr(sp_used->s, SP1_DRAW_MASK2, 0, 64, 2);
   sp1_AddColSpr(sp_used->s, SP1_DRAW_MASK2RB, 0, 0, 2);
   sp_used->type = ST_EXPLO;
   sp_used->frame = 0;
   sp_used->delay = 0;
   sp_used->x = x;
   sp_used->y = y;
   sp_used->sprite = NULL; //explosion;

   sp1_MoveSprPix(sp_used->s, &cr, sp_used->sprite, 8 + sp_used->x, 8 + sp_used->y);
   return 1;
}

void
add_enemy(int x, int y, unsigned char *sprite)
{
   // not really a explosion, but saves some bytes as they're the same size

   if(!add_explo(x, y))
      return;

   sp_used->type = ST_ENEMY;
   sp_used->sprite = sprite;
   sp_used->alive = 1;
   sp_used->delay = rand() % 15;
   sp_used->x = x;
   sp_used->y = y;

   sp1_MoveSprPix(sp_used->s, &cr, sp_used->sprite + sp_used->frame * 8 * 12, 8 + sp_used->x, 8 + sp_used->y);
}

void
remove_sprite(struct ssprites *s)
{
   sp1_MoveSprAbs(s->s, &cr, NULL, 0, 34, 0, 0);
   sp1_DeleteSpr(s->s);
   s->alive = 0;
   ++sp_collect;
}

void
add_bullet(unsigned char type, unsigned char x, unsigned char y)
{
   if(!add_sprite())
      return;

   sp_used->s = sp1_CreateSpr(SP1_DRAW_MASK2LB, SP1_TYPE_2BYTE, 2, 8, 1);
   sp1_AddColSpr(sp_used->s, SP1_DRAW_MASK2RB, 0, 0, 1);
   sp_used->type = type;
   sp_used->frame = 0;
   sp_used->delay = 0;

   sp_used->x = x;
   sp_used->y = y;

   // player bullet
   if (type == ST_BULLET)
   {
      sp_used->sprite = impact;
      sp_used->iy = -6;
   }
   else
   {
      // ENEMY BULLET
      sp_used->sprite = impact + 4 * 8;
      sp_used->iy = 6;
   }

   sp1_MoveSprPix(sp_used->s, &cr, sp_used->sprite, sp_used->x, sp_used->y);
}
