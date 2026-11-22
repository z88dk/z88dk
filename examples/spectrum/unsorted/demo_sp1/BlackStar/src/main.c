#include <arch/zx.h>
#include <stdlib.h>
#include <string.h>
#include <arch/zx/sp1.h>
#include <alloc/balloc.h>
#include <input.h>
#include <intrinsic.h>
#include <compress/zx7.h>

#include "gfx.h"
#include "int.h"
#include "mus.h"
#include "ntropic.h"
#include "playfx.h"
#include "sprites.h"

// scratch ram at 0x5e24 before program

extern unsigned char TEMPMEM[1024];   // address placement defined in main.asm

// convenient globals for speed

int i, j, k;
unsigned int key;
unsigned char *pt;

// describe the full screen

#define ORIGINX  0
#define ORIGINY  0
#define WIDTH    256
#define HEIGHT   192

struct sp1_Rect cr = { 0, 0, 32, 24 };

#define HORDE_MOVE  62

// sp1 print string context

struct sp1_pss ps0;

// keys

unsigned int keys[3] = { 'o', 'p', ' ' };

JOYFUNC joyfunc;
udk_t   joy_k;

const char *redefine_texts[4] = {
   "\x14\x45" " LEFT:",
   "RIGHT:",
   " FIRE:"
};

// game variables
// (yes globals because of performance and z88dk!)

unsigned char cooldown;
unsigned char wave;
unsigned int  score;
unsigned char lives;
unsigned char invulnerable;
unsigned int  hi_score = 1500;

void
pad_numbers(unsigned char *s, unsigned int limit, long number)
{
   s += limit;
   *s = 0;

   // not a fast method since there are two 32-bit divisions in the loop
   // better would be ultoa or ldivu which would do one division or if
   // the library is so configured, they would do special case base 10 code.
   
   while (limit--)
   {
      *--s = (number % 10) + '0';
      number /= 10;
   }
}

void
run_redefine_keys(void)
{
   struct sp1_Rect r = { 10, 2, 30, 10 };

   sp1_ClearRectInv(&r, INK_BLACK | PAPER_BLACK, 32, SP1_RFLAG_TILE | SP1_RFLAG_COLOUR);

   sp1_SetPrintPos(&ps0, 10, 10);
   sp1_PrintString(&ps0, "\x14\x47" "REDEFINE KEYS");

   for (i = 0; i < 3; ++i)
   {
      sp1_SetPrintPos(&ps0, 12 + i, 11);
      sp1_PrintString(&ps0, redefine_texts[i]);
      sp1_UpdateNow();

      in_wait_key();
      keys[i] = in_inkey();
      in_wait_nokey();

      // nope!
      if (keys[i] < 32)
      {
         --i;
         continue;
      }

      // space is not visible, make it so
      if (keys[i] == 32)
      {
         sp1_SetPrintPos(&ps0, 12 + i, 18);
         sp1_PrintString(&ps0, "\x14\x46" "SPACE");
      }
      else
         sp1_PrintAtInv(12 + i, 18, BRIGHT | INK_YELLOW, keys[i]);
      
      sp1_UpdateNow();
      playfx(FX_SELECT);
   }

   // some delay so the player can see last pressed key
   for (i = 0; i < 16; ++i)
      wait();
}

void
draw_menu(void)
{
   unsigned char buffer[16];
   struct sp1_Rect r = { 10, 2, 30, 10 };

   // clear the screen first to avoid attribute artifacts
   sp1_ClearRectInv(&cr, BRIGHT | INK_BLACK | PAPER_BLACK, 32, SP1_RFLAG_TILE | SP1_RFLAG_COLOUR);
   sp1_UpdateNow();

   // this will wait for vsync
   wait();
   dzx7_standard(menu, (void *)0x4000);
   // sp1_Validate(&cr);  // not necessary since there was just an update

   sp1_SetPrintPos(&ps0, 10, 5);
   sp1_PrintString(&ps0, "\x14\x47" "Code, Graphics & sound");
   sp1_SetPrintPos(&ps0, 11, 3);
   sp1_PrintString(&ps0, "\x14\x46" "Juan J. Martinez, @reidrac");
   sp1_SetPrintPos(&ps0, 14, 10);
   sp1_PrintString(&ps0, "\x14\x03" "Made in ~48h");
   sp1_SetPrintPos(&ps0, 15, 7);
   sp1_PrintString(&ps0, "for bitbitjam 2015");

   sp1_SetPrintPos(&ps0, 19, 9);
   sp1_PrintString(&ps0, "\x14\x47" "PRESS ANY KEY!");

   sp1_SetPrintPos(&ps0, 23, 8);
   sp1_PrintString(&ps0, "\x14\x01\x7f" "2015 usebox.net");
   sp1_UpdateNow();

   // will play until a key is pressed
   dzx7_standard(song1, TEMPMEM);
   ntropic_play(TEMPMEM, 1);

   // avoid the player pressing one of the options and triggering the
   // associated code
   in_wait_nokey();

   sp1_ClearRectInv(&r, INK_BLACK | PAPER_BLACK, 32, SP1_RFLAG_TILE | SP1_RFLAG_COLOUR);

   sp1_SetPrintPos(&ps0, 11, 11);
   sp1_PrintString(&ps0, "\x14\x47" "1 KEYBOARD"
               "\x0b\x0b\x06\x0b" "2 KEMPSTON"
               "\x0b\x0b\x06\x0b" "3 SINCLAIR"
               "\x0b\x0b\x06\x0b" "4 REDEFINE"
               );

   // the hiscore
   sp1_SetPrintPos(&ps0, 7, 13);
   sp1_PrintString(&ps0, "\x14\x47" "HI");

   buffer[0] = 0x14;
   buffer[1] = BRIGHT | INK_YELLOW | PAPER_BLACK;
   pad_numbers(buffer + 2, 5, hi_score);

   sp1_SetPrintPos(&ps0, 7, 15);
   sp1_PrintString(&ps0, buffer);

   // will update in the main loop
}

const unsigned char intro_text[] =
   "An anomaly has been detected\x0d"
   "at the border of the system!\x0d\x0d"
   "Hostile spaceships are jumping\x0d"
   "through a wormhole.\x0d\x0d"
   "The Kingdom of Heavens must be\x0d"
   "protected at all costs!\x0d\x0d"
   "Deploy the Black Star!";

void
run_intro(void)
{
   unsigned char buffer[2];

   // clear the screen
   sp1_ClearRectInv(&cr, INK_BLACK | PAPER_BLACK, 32, SP1_RFLAG_TILE | SP1_RFLAG_COLOUR);
   sp1_UpdateNow();

   // the menu key may be is still pressed
   in_wait_nokey();

   // wait for vsync
   wait();
   dzx7_standard(warning, (void *)0x4000);
   // sp1_Validate(&cr);  // unnecessary since there was just an update

   // copy attributes to our temp memory area
   memcpy(TEMPMEM, (void *)0x5800, 768);

   // WARNING! effect
   for (i = 0; i < 3; ++i)
   {
      memcpy((void *)0x5800, TEMPMEM, 768);

      playfx(FX_ALARM);

      for (j = 0; j < 8; ++j)
         wait();

      memset((void *)0x5800, 0, 768);

      for (j = 0; j < 8; ++j)
         wait();

      if (in_inkey())
         goto skip_intro;
   }

   sp1_ClearRectInv(&cr, INK_BLACK | PAPER_BLACK, 32, SP1_RFLAG_TILE | SP1_RFLAG_COLOUR);
   sp1_UpdateNow();

   sp1_SetPrintPos(&ps0, 6, 0);

   buffer[1] = 0;
   for (pt = intro_text; *pt; ++pt)
   {
      buffer[0] = *pt;

      sp1_PrintString(&ps0, buffer);

      wait();
      sp1_UpdateNow();

      if (*pt > 32)
         playfx(FX_MOVE);

      if (in_inkey())
         goto skip_intro;
   }

   for (i = 0; i < 64 && !in_inkey(); ++i)
      wait();

skip_intro:
   sp1_ClearRectInv(&cr, INK_BLACK | PAPER_BLACK, 32, SP1_RFLAG_TILE | SP1_RFLAG_COLOUR);
   sp1_UpdateNow();

   // in case a key was pressed to skip the intro
   in_wait_nokey();
}

// for a space invaders alike movement

unsigned char horde_move_x;
char horde_inc_x;
char horde_ix;
char horde_iy;
unsigned char horde_move_y;
unsigned char horde_delay;
char horde_delay_base;
char horde_count;
unsigned char not_clean;

void
update_horde(void)
{
   if (horde_count && !horde_delay--)
   {
      horde_delay = horde_delay_base;

      horde_move_x += horde_inc_x;
      if (horde_move_x > HORDE_MOVE || horde_move_x == 0)
      {
         horde_inc_x = -horde_inc_x;
         horde_ix = -horde_ix;
         horde_iy += 8;
         ++horde_move_y;
         playfx(FX_MOVE);
         playfx(FX_MOVE);

         // classic space invaders behaviour; faster as it goes down
         switch (horde_move_y)
         {
            case 2:
            case 4:
            case 8:
               horde_delay_base -= 2;
               break;
         }

         if (horde_delay_base < 0)
            horde_delay_base = 0;
      }
      else
      {
         if (horde_iy)
            horde_iy -= 4;
         horde_move_x += horde_inc_x;
         playfx(FX_MOVE);
      }
   }
}

void
update_score(void)
{
   unsigned char buffer[16];

   // in case anyone pokes around ;)
   if (lives > 3)
      lives = 3;

   sp1_SetPrintPos(&ps0, 0, 0);
   sp1_PrintString(&ps0, "\x14\x47" "SCORE");

   buffer[0] = 0x14;
   buffer[1] = BRIGHT | INK_YELLOW | PAPER_BLACK;
   pad_numbers(buffer + 2, 5, score);

   sp1_SetPrintPos(&ps0, 0, 6);
   sp1_PrintString(&ps0, buffer);

   sp1_SetPrintPos(&ps0, 0, 14);
   sp1_PrintString(&ps0, "\x14\x47" "HI");

   buffer[0] = 0x14;
   buffer[1] = BRIGHT | INK_YELLOW | PAPER_BLACK;
   pad_numbers(buffer + 2, 5, hi_score);

   sp1_SetPrintPos(&ps0, 0, 16);
   sp1_PrintString(&ps0, buffer);

   pad_numbers(buffer + 2, 2, wave);

   sp1_SetPrintPos(&ps0, 0, 25);
   sp1_PrintString(&ps0, "\x14\x47" "WAVE");

   sp1_SetPrintPos(&ps0, 0, 30);
   sp1_PrintString(&ps0, buffer);

   // the lives are drawn in the BG tiles, we remove the lives used
   for (i = 3; i > lives; --i)
      sp1_PrintAtInv(1, i - 1, PAPER_BLACK, 32);
}

void
update_player(void)
{
   if (invulnerable && invulnerable & 1)
      sp1_MoveSprAbs(sprites[PLAYER].s, &cr, NULL, 0, 34, 0, 0);
   else
      sp1_MoveSprPix(sprites[PLAYER].s, &cr, sprites[PLAYER].sprite + sprites[PLAYER].frame * 8 * 12, 8 + sprites[PLAYER].x, 8 + sprites[PLAYER].y);
}

// this is game dependent, and that's why it is here instead of sprites.h

void
update_sprites(void)
{
   for (sp_iter = sp_used; sp_iter; sp_iter = sp_iter->n)
   {
      if (!sp_iter->alive)
         continue;

      switch(sp_iter->type)
      {
         default:
            break;

         case ST_BULLET:

            sp_iter->x += sp_iter->ix;
            sp_iter->y += sp_iter->iy;

            // out of screen
            if(sp_iter->x < ORIGINX || sp_iter->x > WIDTH
                  || sp_iter->y + 8 < ORIGINY || sp_iter->y > HEIGHT)
            {
               remove_sprite(sp_iter);
               // no drawing required
               break;
            }

            // enemy check
            for (sp_iter2 = sp_used; sp_iter2; sp_iter2 = sp_iter2->n)
               if (sp_iter2->type == ST_ENEMY && sp_iter2->alive
                     && sp_iter->x + 4 < sp_iter2->x + 16
                     && sp_iter2->x < sp_iter->x + 4
                     && sp_iter->y + 4 < sp_iter2->y + 16
                     && sp_iter2->y < sp_iter->y + 4)
               {
                  score += 25;
                  if (score > hi_score)
                     hi_score = score;

                  update_score();

                  // convert into an explosion
                  sp_iter2->sprite = explosion;
                  sp_iter2->frame = 0;
                  sp_iter2->delay = 0;
                  sp_iter2->type = ST_EXPLO;

                  playfx(FX_EXPLO);

                  // remove the bullet
                  remove_sprite(sp_iter);

                  // one less enemy
                  --horde_count;
               }

            // draw only if it didn't hit anything
            if (sp_iter->alive)
               sp1_MoveSprPix(sp_iter->s, &cr, sp_iter->sprite, 8 + sp_iter->x, 8 + sp_iter->y);
            
            break;

         case ST_EBULLET:

            sp_iter->y += sp_iter->iy;

            // out of screen
            if (sp_iter->y > HEIGHT)
            {
               remove_sprite(sp_iter);
               // no drawing required
               break;
            }

            // player check
            if (!invulnerable && sp_iter->x + 4 < sprites[PLAYER].x + 16
                  && sprites[PLAYER].x < sp_iter->x + 4
                  && sp_iter->y + 4 < sprites[PLAYER].y + 16
                  && sprites[PLAYER].y < sp_iter->y + 4)
            {
               // convert into an explosion
               sp_iter->sprite = impact + 2 * 4 * 8;
               sp_iter->frame = 0;
               sp_iter->delay = 0;
               sp_iter->type = ST_HIT;

               playfx(FX_EXPLO);

               if (!invulnerable)
               {
                  // we hit the player, kill him!
                  --lives;
                  update_score();
                  invulnerable = 10;
               }
               
               continue;
            }

            sp1_MoveSprPix(sp_iter->s, &cr, sp_iter->sprite, 8 + sp_iter->x, 8 + sp_iter->y);
            break;

         case ST_ENEMY:

            if (!horde_delay)
            {
               if (!horde_iy)
                  sp_iter->x += horde_ix;
               else
                  sp_iter->y += horde_iy;

               // change frame
               sp_iter->frame = !sp_iter->frame;

               if (sp_iter->sprite == bomber)
               {
                  if (!sp_iter->delay--)
                  {
                     sp_iter->delay = 15 + rand() % 15;
                     add_bullet(ST_EBULLET, sp_iter->x + 4, sp_iter->y + 16);
                  }
               }
            }

            // player check
            if (!invulnerable && sp_iter->x < sprites[PLAYER].x + 16
                  && sprites[PLAYER].x < sp_iter->x + 16
                  && sp_iter->y < sprites[PLAYER].y + 16
                  && sprites[PLAYER].y < sp_iter->y + 16)
            {
               // convert into an explosion
               sp_iter->sprite = explosion;
               sp_iter->frame = 0;
               sp_iter->delay = 0;
               sp_iter->type = ST_EXPLO;

               // one less enemy
               --horde_count;

               playfx(FX_EXPLO);

               if (!invulnerable)
               {
                  // we hit the player, kill him!
                  --lives;
                  update_score();
                  invulnerable = 10;
               }
               
               continue;
            }

            // out of screen?
            if (sp_iter->y > HEIGHT)
            {
               // one less enemy
               --horde_count;

               // repeat the wave
               not_clean = 1;

               remove_sprite(sp_iter);
               // no drawing required
               break;
            }

            sp1_MoveSprPix(sp_iter->s, &cr, sp_iter->sprite + sp_iter->frame * 8 * 12, 8 + sp_iter->x, 8 + sp_iter->y);
            break;

         case ST_EXPLO:
            // first frame must be half frame longer
            if (sp_iter->delay < 2)
               sp_iter->delay++;
            else
            {
               sp_iter->delay = 1;
               sp_iter->frame++;
               if (sp_iter->frame == 3)
               {
                  // we're done!
                  remove_sprite(sp_iter);
                  break;
               }
            }
            
            sp1_MoveSprPix(sp_iter->s, &cr, sp_iter->sprite + sp_iter->frame * 8 * 12 , 8 + sp_iter->x, 8 + sp_iter->y);
            break;

         case ST_HIT:
            // first frame must be half frame longer
            if (sp_iter->delay < 2)
               sp_iter->delay++;
            else
            {
               sp_iter->delay = 0;
               sp_iter->frame++;
               if (sp_iter->frame == 2)
               {
                  // we're done!
                  remove_sprite(sp_iter);
                  break;
               }
            }
            sp1_MoveSprPix(sp_iter->s, &cr, sp_iter->sprite + sp_iter->frame * 4 * 8 , 8 + sp_iter->x, 8 + sp_iter->y);
            break;
      }
   }

   // update the lists
   collect_sprites();
}

// very simple way to schedule enemies
unsigned char wave_delay;

void
update_script(void)
{
   unsigned char mod;

   // there's a wave already
   if (horde_count)
      return;

   // wait between waves
   if (wave_delay--)
      return;

   // only if the player killed all aliens in the wave
   if (!not_clean)
   {
      ++wave;
      update_score();
      wait();
      sp1_UpdateNow();
   }
   not_clean = 0;

   // don't play the sound for the first wave
   if (wave > 1)
      playfx(FX_SELECT);

   wave_delay = 16;

   horde_move_x = 0;
   horde_inc_x = 1;
   horde_ix = 4;
   horde_iy = 0;
   horde_move_y = 0;
   horde_delay = 0;
   horde_delay_base = 6;
   horde_count = 0;

   mod = wave & 0x7;  // 0-7
   switch(mod)
   {
      case 1:
         for (j = 0; j < 2; ++j)
            for (i = 0; i < 5; ++i)
            {
               add_enemy(24 * i, j * 20, flyer);
               ++horde_count;
            }
         break;
      case 2:
         horde_move_x = HORDE_MOVE + 1;
         horde_inc_x = -1;
         horde_ix = -4;
         for (j = 0; j < 3; ++j)
            for (i = 0; i < 3 - j; ++i)
            {
               add_enemy(236 - 24 * i, j * 20, !i && !j ? bomber : flyer);
               ++horde_count;
               add_enemy(236 - 120 + 24 * i, j * 20, !i && !j ? bomber : flyer);
               ++horde_count;
            }
         break;
      case 3:
         horde_delay_base = 3;
         for (j = 0; j < 3; ++j)
            for (i = 0; i < 5; ++i)
            {
               add_enemy(24 * i, j * 20, !j ? bomber : flyer);
               ++horde_count;
            }
         break;
      case 4:
         horde_delay_base = 3;
         horde_move_x = HORDE_MOVE + 1;
         horde_inc_x = -1;
         horde_ix = -4;
         k = 1;
         for (j = 0; j < 4; ++j)
            for (i = 0; i < 5; ++i)
            {
               if (i & 1)
                  continue;

               if (k)
                  add_enemy(220 - 24 * i, j * 20, bomber);
               else
                  add_enemy(220 - 24 * i, j * 20, flyer);
               k = !k;

               ++horde_count;
            }
         break;
      case 5:
         horde_delay_base = 3;

         for (i = 0; i < 6; ++i)
         {
            add_enemy(- 8 + 24 * i, 0, bomber);
            ++horde_count;
         }

         for (j = 0; j < 2; ++j)
            for (i = 0; i < 4; ++i)
            {
               add_enemy(-8 + 24 + 24 * i, 20 + j * 20, flyer);
               ++horde_count;
            }

            add_enemy(-8 + 24 + 24 + 12, 60, flyer);
            ++horde_count;
         break;
      case 6:
         horde_delay_base = 2;

         for (i = 0; i < 5; ++i)
         {
            add_enemy(24 * i, 0, bomber);
            ++horde_count;
         }
         for (i = 0; i < 4; ++i)
         {
            add_enemy(12 + 24 * i, 20, flyer);
            ++horde_count;
         }
         for (i = 0; i < 5; ++i)
         {
            add_enemy(24 * i, 40, flyer);
            ++horde_count;
         }
         break;
      case 7:
         horde_move_x = HORDE_MOVE + 1;
         horde_inc_x = -1;
         horde_ix = -4;
         horde_delay_base = 2;

         for (i = 0; i < 5; ++i)
         {
            add_enemy(220 - 24 * i, 0, bomber);
            ++horde_count;
         }
         for (i = 0; i < 5; ++i)
         {
            add_enemy(220 - 24 * i, 40, flyer);
            ++horde_count;
         }
         for (i = 0; i < 4; ++i)
         {
            add_enemy(220 - 12 - 24 * i, 80, bomber);
            ++horde_count;
         }
         break;
      // this is 8
      case 0:
         horde_delay_base = 1;

         for (i = 0; i < 3; ++i)
         {
            add_enemy(24 + 24 * i, 0, flyer);
            ++horde_count;
         }
         for (i = 0; i < 5; ++i)
         {
            add_enemy(24 * i, 40, bomber);
            ++horde_count;
         }
         for (i = 0; i < 4; ++i)
         {
            add_enemy(12 + 24 * i, 80, flyer);
            ++horde_count;
         }
         break;
   }

   if (wave > 8)
      horde_delay_base = 0;
}

void
run_play()
{
   sp1_ClearRectInv(&cr, BRIGHT | INK_WHITE | PAPER_BLACK, 32, SP1_RFLAG_TILE | SP1_RFLAG_COLOUR);
   sp1_UpdateNow();

   sp1_SetPrintPos(&ps0, 0, 0);
   sp1_PrintString(&ps0, ptiles);

   // setup the game
   sprites[PLAYER].x = 15 * 8;
   sprites[PLAYER].y = 20 * 8;
   sprites[PLAYER].frame = 0;
   sprites[PLAYER].delay = 0;
   sprites[PLAYER].sprite = player;
   update_player();

   horde_count = 0;
   wave_delay = 0;
   wave = 0;
   score = 0;
   lives = 3;
   invulnerable = 0;
   update_score();

   while(1)
   {
      // TODO: pause/resume

      if (in_inkey() == 12)
         // exit current game
         break;

      key = (joyfunc)(&joy_k);
      if (key & IN_STICK_LEFT && !(key & IN_STICK_RIGHT))
      {
         if (sprites[PLAYER].x - 4 > ORIGINX)
         {
            sprites[PLAYER].x -= 4;
            sprites[PLAYER].frame = 2;
            sprites[PLAYER].delay = 4;
            update_player();
         }
      }

      if (key & IN_STICK_RIGHT && !(key & IN_STICK_LEFT))
      {
         if (sprites[PLAYER].x + 16 + 8 + 4 < WIDTH)
         {
            sprites[PLAYER].x += 4;
            sprites[PLAYER].frame = 1;
            sprites[PLAYER].delay = 4;
            update_player();
         }
      }

      if (cooldown > 0)
         --cooldown;

      if (key & IN_STICK_FIRE && !cooldown)
      {
         // fire rate
         cooldown = 10;
         add_bullet(ST_BULLET, sprites[PLAYER].x + 4, sprites[PLAYER].y - 2);

         playfx(FX_FIRE);
      }

      // change the frame to normal?
      if (sprites[PLAYER].delay)
      {
         if (!--sprites[PLAYER].delay)
         {
            sprites[PLAYER].frame = 0;
            update_player();
         }
      }

      update_horde();
      update_sprites();
      update_script();

      if (invulnerable > 0)
      {
         // will be 0, but in case of "the unexpected"
         if (lives <= 0)
         {
            // GAME OVER

            // some noise
            playfx(FX_EXPLO);
            playfx(FX_EXPLO);
            playfx(FX_EXPLO);

            // we don't want the player to miss the game over music
            in_wait_nokey();

            sp1_SetPrintPos(&ps0, 11, 8);
            sp1_PrintString(&ps0, "\x14\x46" "G A M E  O V E R");
            sp1_UpdateNow();

            dzx7_standard(song2, TEMPMEM);
            ntropic_play(TEMPMEM, 0);

            for (i = 0; i < 32; ++i)
               wait();

            // leave the game
            break;
         }

         --invulnerable;
         update_player();
      }

      wait();
      intrinsic_halt();   // inline halt without impeding optimizer
      sp1_UpdateNow();
   }

   destroy_type_sprite(ST_ALL);
   collect_sprites();

   // the player sprite is never destroyed, so hide it
   sp1_MoveSprAbs(sprites[PLAYER].s, &cr, NULL, 0, 34, 0, 0);
   sp1_UpdateNow();

   sp1_ClearRectInv(&cr, BRIGHT | INK_BLACK | PAPER_BLACK, 32, SP1_RFLAG_TILE | SP1_RFLAG_COLOUR);
   sp1_UpdateNow();
}

unsigned char block_of_ram[5000];

int
main(void)
{
   unsigned char idle = 0;

   // the crt has disabled interrupts before main is called
   
   // z88dk tracks the border colour so that beeper audio does not change the border colour while playing.
   // (this project contains a 3rd party ntropic player that does not obey z88dk convention so we set the border to same colour)
   zx_border(INK_BLACK);

   // set up the block memory allocator with one queue
   // max size requested by sp1 will be 24 bytes or block size of 25 (+1 for overhead)
   balloc_reset(0);                                              // make queue 0 empty
   balloc_addmem(0, sizeof(block_of_ram)/25, 24, block_of_ram);  // add free memory from bss section
   balloc_addmem(0, 8, 24, (void *)0xd101);                      // another eight from an unused area

   // interrupt mode 2
   setup_int();

   // sp1.lib
   sp1_Initialize(SP1_IFLAG_MAKE_ROTTBL | SP1_IFLAG_OVERWRITE_TILES | SP1_IFLAG_OVERWRITE_DFILE, INK_BLACK | PAPER_BLACK, ' ');
   // sp1_Validate(&cr);  // not necessary since sp1_Initialize will not mark screen for update
   
   ps0.bounds = &cr;
   ps0.flags = SP1_PSSFLAG_INVALIDATE;
   ps0.visit = 0;

   intrinsic_ei();

   // setup our font
   pt = font;
   for (i = 0; i < 96; ++i, pt += 8)
      sp1_TileEntry(32 + i, pt);

   // setup the bg tiles
   pt = tiles;
   for (i = 0; i < TILES_LEN; ++i, pt += 8)
      sp1_TileEntry(TILES_BASE + i, pt);

   init_sprites();

   draw_menu();

   srand(tick);  // 256 different games are possible

   while(1)
   {
      key = in_inkey();
      if (key)
      {
         if (key == '4')
         {
            playfx(FX_SELECT);

            in_wait_nokey();
            run_redefine_keys();
            idle = 0;
            draw_menu();
         }
         if (key == '1' || key == '2' || key == '3')
         {
            playfx(FX_SELECT);

            joy_k.left  = in_key_scancode(keys[0]);
            joy_k.right = in_key_scancode(keys[1]);
            // we don't use up/down in this game
            joy_k.down  = in_key_scancode(keys[0]);
            joy_k.up    = in_key_scancode(keys[1]);
            joy_k.fire  = in_key_scancode(keys[2]);

            if (key == '1')
               joyfunc = (JOYFUNC)in_stick_keyboard;
            if (key == '2')
               joyfunc = (JOYFUNC)in_stick_kempston;
            if (key == '3')
               joyfunc = (JOYFUNC)in_stick_sinclair1;

            // run game
            run_intro();

            run_play();
            idle = 0;
            draw_menu();
         }
      }

      if (idle++ == 255)
      {
         // go back to the welcome screen after a while
         // if the player doesn't do anything
         idle = 0;
         draw_menu();
      }

      wait();
      sp1_UpdateNow();
   }
}
