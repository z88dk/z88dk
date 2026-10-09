/* [de-rearb] A word DE-home pick that no resident region can serve is
 * rejected at lowering, and the function is lowered again without any DE-class
 * home. fill() is that shape: the loop index is the pick, and every loop body
 * needs DE for its own staging. The re-lowered function must compute the same
 * tables as the plain C below. sp and fp, 8080 and gbz80. */
#include "test.h"

#define BUF_LEN    256
#define ARR_LEN    64
#define STRUCT_LEN 16

struct rec { int a, b, c, d; };

static unsigned char buffer[BUF_LEN];
static int           arr[ARR_LEN];
static int           mat[ARR_LEN];
static struct rec    recs[STRUCT_LEN];

static void fill(void)
{
    unsigned int i;
    unsigned int seed = 0xC001U;
    for (i = 0; i < BUF_LEN; i++) {
        buffer[i] = (unsigned char)(seed & 0xFFU);
        seed = (unsigned int)(seed * 25173U + 13849U);
    }
    for (i = 0; i < ARR_LEN; i++)
        arr[i] = ((int)buffer[(i*2)+0]) | (((int)buffer[(i*2)+1]) << 8);
    for (i = 0; i < ARR_LEN; i++)
        mat[i] = arr[i];
    for (i = 0; i < STRUCT_LEN; i++) {
        recs[i].a = arr[(i*4)+0];
        recs[i].b = arr[(i*4)+1];
        recs[i].c = arr[(i*4)+2];
        recs[i].d = arr[(i*4)+3];
    }
}

static void test_derearb(void)
{
    unsigned int i, seed = 0xC001U, sum = 0;
    fill();
    for (i = 0; i < BUF_LEN; i++) {
        unsigned char want = (unsigned char)seed;
        assertEqual(buffer[i], want);
        seed = seed * 25173U + 13849U;
    }
    for (i = 0; i < ARR_LEN; i++) {
        unsigned int w = buffer[2*i] | ((unsigned int)buffer[2*i+1] << 8);
        assertEqual(arr[i], (int)w);
        assertEqual(mat[i], (int)w);
        sum += w;
    }
    for (i = 0; i < STRUCT_LEN; i++) {
        assertEqual(recs[i].a, arr[4*i]);
        assertEqual(recs[i].b, arr[4*i+1]);
        assertEqual(recs[i].c, arr[4*i+2]);
        assertEqual(recs[i].d, arr[4*i+3]);
    }
    assertEqual(sum != 0, 1);
}

int main(int argc, char *argv[])
{
    suite_setup("derearb");
    suite_add_test(test_derearb);
    return suite_run();
}
