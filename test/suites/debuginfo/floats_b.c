/* A second module with floats. No float code, so that it also links when built in
 * another format than floats_a.c (the "mixed" check) */
#include "floats.h"

float gb_f = 1024.0;
float gb_arr[2] = { 8.0, -16.0 };
float *gb_ptr = &gb_arr[1];
float *gb_p0 = &gb_arr[0];
struct tail gb_tail = { -1.5, 88 };
struct tail gb_tails[2] = { { 1.0, 11 }, { 2.0, 22 } };
struct wrap gb_wrap = { { 4.0, 44 }, 700 };
struct pay gb_pay = { 2.5 };
struct node gb_head = { 0, &gb_pay };

int fb(void)
{
    return 1024;
}
