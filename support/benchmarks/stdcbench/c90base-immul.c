/* Benchmark integr matrix operations.
   At a lower level, we mostly benchmark integer multiplications and loops.
   This part of the benchmark is synthetic. */

#include "stdcbench.h"

#ifdef C90BASE

#if __STDC_VERSION__ < 199901L
#define restrict
#endif

static void imul_mv(int *restrict r,  const int *restrict m, const int *restrict v, unsigned int s)
{
	unsigned int i = 0;
	unsigned int j = 0;

	for(i = 0; i < s; i++)
	{
		r[i] = 0;
		for(j = 0; j < s; j++)
			r[i] += m[i * s + j] * v[j];
	}
}

static void imul_mm(int *restrict r, const int *restrict m, const int *restrict n, unsigned int s)
{
	unsigned int i = 0;
	unsigned int j = 0;
	unsigned int k = 0;

	for(i = 0; i < s; i++)
		for(j = 0; j < s; j++)
		{
			r[i * s + j] = 0;
			for(k = 0; k < s; k++)
				r[i * s + j] += m[i * s + k] * n[k * s + j];
		}
}

static const int back[] =
	{2, 0, 0, 0,
	0, 0, -2, 0,
	0, 2, 0, 0,
	0, 0, 0, 1};

static const int left[] =
	{0, 0, -1, 0,
	0, 1, 0, 0,
	1, 0, 0, 0,
	0, 0, 0, 1};

#define NUM_VECTORS 16

static const volatile int vectors[NUM_VECTORS][4] =
	{{1, 1, 1, 0},
	{-1, -1, -1, 0},
	{3, 2, -1, 0},
	{-2, 24, -1, 0},
	{1, 1, 1, 1},
	{-1, -1, -1, 1},
	{3, 2, -1, 1},
	{-2, 24, -1, 1},
	{2, 2, 2, 0},
	{-2, -2, -2, 0},
	{7, 3, -1, 0},
	{-4, 40, -2, 0},
	{3, 3, 3, 1},
	{-4, -4, -4, 1},
	{9, 4, -1, 1},
	{-3, 50, -2, 1}};

void c90base_immul(void)
{
	unsigned int i, j;

	for(i = 0; i < 200; i++)
	{
		for(j = 0; j < 4; j++)
			stdcbench_buffer.signed_int[j] = vectors[i % NUM_VECTORS][j];
		for(j = 0; j < 4; j++)
			stdcbench_buffer.signed_int[28 + j] = vectors[i % NUM_VECTORS][j];

		/* Multiply vector by individual matrices */
		imul_mv(stdcbench_buffer.signed_int + 4, back, stdcbench_buffer.signed_int + 0, 4);
		imul_mv(stdcbench_buffer.signed_int + 8, left, stdcbench_buffer.signed_int + 4, 4);

		/* Multiply matrices first, then multiply vector by result */
		imul_mm(stdcbench_buffer.signed_int + 12, left, back, 4);
		imul_mv(stdcbench_buffer.signed_int + 4, stdcbench_buffer.signed_int + 12, stdcbench_buffer.signed_int + 28, 4);

		for(j = 0; j < 4; j++)
			if (stdcbench_buffer.signed_int[8 + j] != stdcbench_buffer.signed_int[4 + j])
			{
				stdcbench_error("c90base c90base_immul(): Result validation failed");
				return;
			}
	}
}

#endif

