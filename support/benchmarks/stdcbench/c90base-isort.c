/* Benchmark insertion sort.
   At a lower level, we mostly benchmark control-flow constructs, indirection and comparisons
   This part of the benchmark is based on real-world code. */

#include "stdcbench.h"

#ifdef C90BASE

#if __STDC_VERSION__ >= 199901L
#include <stdint.h>
#else
typedef unsigned char uint_fast8_t;
#endif

struct cvu_sprite
{
	unsigned char y;
	unsigned char x;
	unsigned char name;
	unsigned char tag;
};

static int cvu_get_sprite_y(const struct cvu_sprite *sprite)
{
	if(sprite->y > 255 - 32)
		return((int)(sprite->y) - 256);
	return(sprite->y);
}

static void cvu_set_sprite_y(struct cvu_sprite *sprite, int y)
{
	if(y > 207)
		y = 207;
	if(y < -32)
		y = -32;
	if(y < 0)
		y += 256;

	sprite->y = y;
}

typedef unsigned char spm_sprite;
#define SPM_MAX_SPRITES 20
#define spm_get_sprite(i) (spm_sprites + (i))

struct cvu_sprite spm_sprites[SPM_MAX_SPRITES];
spm_sprite spm_sprites_list[SPM_MAX_SPRITES];

static void spm_sort(void)
{
	uint_fast8_t i, j;
	spm_sprite temp;
	int y;

	for(i = 1; i < SPM_MAX_SPRITES; i++)
	{
		j = i;
		temp = spm_sprites_list[j];
		y = cvu_get_sprite_y(spm_get_sprite(temp));
		while(j && y < cvu_get_sprite_y(spm_get_sprite(spm_sprites_list[j - 1])))
		{
			spm_sprites_list[j] = spm_sprites_list[j - 1];
			j--;		
		}
		spm_sprites_list[j] = temp;
	}
}

static const int y_startpositions[4][SPM_MAX_SPRITES] =
	{{120, 110, 90, 100, 190, 190, 190, 130, 125, 80, 132, -8, 20, 40, 60, -10, 20, 30, 40, 50},
	{20, 110, 90, 0, 190, 190, 90, 130, 125, 20, 132, -8, 20, 40, 10, -10, 20, 30, 20, 50},
	{120, 110, 0, 100, 190, 190, 190, 130, 125, 80, 132, -8, 20, 40, 60, -10, 20, 30, 40, 50},
	{120, 100, 90, 100, 190, 190, 190, 130, 125, 80, 132, -8, 20, 40, 60, -10, 20, -3, 40, 50}};
static const int y_endpositions[4][SPM_MAX_SPRITES] =
	{{207, 115, 95, 105, 207, 195, 195, 135, 207, 85, 137, -3, 85, 45, 65, -5, 115, 35, 45, 55},
	{115, 115, 95, 5, 207, 195, 95, 135, 207, 25, 137, -3, 85, 45, 15, -5, 115, 35, 25, 55},
	{207, 115, 5, 105, 207, 195, 195, 135, 207, 85, 137, -3, 85, 45, 65, -5, 115, 35, 45, 55},
	{207, 105, 95, 105, 207, 195, 195, 135, 207, 85, 137, -3, 85, 45, 65, -5, 115, 2, 45, 55}};
static const spm_sprite y_endlists[4][SPM_MAX_SPRITES] =
	{{15, 11, 17, 18, 13, 19, 14, 12, 9, 2, 3, 16, 1, 7, 10, 6, 5, 8, 0, 4},
	{15, 11, 3, 14, 18, 9, 17, 13, 19, 12, 6, 2, 16, 1, 0, 7, 10, 5, 8, 4},
	{15, 11, 2, 17, 18, 13, 19, 14, 12, 9, 3, 16, 1, 7, 10, 6, 5, 8, 0, 4},
	{15, 11, 17, 18, 13, 19, 14, 12, 9, 2, 3, 1, 16, 7, 10, 6, 5, 8, 0, 4}};

static const int (*const volatile y_startpos)[SPM_MAX_SPRITES] = y_startpositions;
static const int (*const volatile y_endpos)[SPM_MAX_SPRITES] = y_endpositions;
static const spm_sprite (*const volatile y_endl)[SPM_MAX_SPRITES] = y_endlists;

void c90base_isort(void)
{
	uint_fast8_t i,  j;

	for(j = 0; j < 15; j++)
	{
		for(i = 0; i < SPM_MAX_SPRITES; i++)
		{
			cvu_set_sprite_y(spm_sprites + i, y_startpos[j % 4][i]);
			spm_sprites_list[i] = i;
		}

		for(i = 0; i < 100; i++)
		{
			int y = cvu_get_sprite_y(spm_sprites + i % SPM_MAX_SPRITES);

			if (!(i % 8))
				y += 30;

			y++;

			cvu_set_sprite_y(spm_sprites + i % SPM_MAX_SPRITES, y);

			spm_sort();
		}

		for(i = 0; i < SPM_MAX_SPRITES; i++)
			if (cvu_get_sprite_y(spm_sprites + i) != y_endpos[j % 4][i] || spm_sprites_list[i] != y_endl[j % 4][i])
			{
				stdcbench_error("c90base c90base_isort(): Result validation failed");
				return;
			}
	}
}

#endif

