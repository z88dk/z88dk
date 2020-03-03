#include "test.h"
#include <stdlib.h>
#include <setjmp.h>


unsigned char array[300];

// No 32 bit multiplication for gbz80
void loop8(unsigned char *a, unsigned long n)
{
        for(unsigned long i = 0; i < n; i++)
                a[i * n] = 8;
}

/* A loop where the counter should be narrowed to a 16-bit unsigned type, but not further. */
void loop16(unsigned char *a)
{
        for (unsigned long i = 0; i < 300; i++)
                a[i] = 16;
}

/* A loop where the subtraction shoULd prevent optimization. */
void loopm(unsigned char *a)
{
        for (unsigned long i = (1UL << 20); i < (1UL << 20) + 1; i++)
                a[i - (1UL << 20)] = 1;
}

void modify1(unsigned long *p)
{
        *p = 17;
}

void modify2(unsigned long *p)
{
        *p = (1UL << 30);
}

/* Loops where access to the counter via pointers shoULd prevent optimization. */
void address(unsigned char *a)
{
        for (unsigned long i = (1UL << 28); i < (1UL << 30); i++)
        {
                modify1(&i);
                a[i] = 17;
                modify2(&i);
        }

        for (unsigned long i = (1UL << 28); i < (1UL << 30); i++)
        {
                unsigned long *p = &i;
                *p = 18;
                a[i] = 18;
                *p = (1UL << 30);
        }
}

void jump_func(jmp_buf *jp, unsigned long i)
{
        assertEqual (i ,(1UL << 29));
        longjmp (*jp, 0);
}

/* A loop where the side-effects from jump_func() shoULd prevent optimization. */
void jump(unsigned char *a)
{
        jmp_buf j;

        if (setjmp (j))
                return;

        for (unsigned long i = (1UL << 29); i < (1UL << 30); i++)
        {
                jump_func(&j, i);
                a[i] = 14;
        }

        a[0] = 13;
}

void test_loop(void)
{
        loop8 (array, 3);
        assertEqual(array[0],8);
        assertEqual(array[3],8);
        assertEqual(array[6],8);

        loop16 (array);
        assertEqual (array[0],16);
        assertEqual (array[17],16);
        assertEqual (array[255],16);
        assertEqual (array[256],16);
        assertEqual (array[299],16);

        loopm (array);
        assertEqual (array[0],1);

        address (array);
        assertEqual (array[17],17);
        assertEqual (array[18],18);

        jump (array);
        assertNotEqual (array[0],13);
}

void test_for(void)
{
  unsigned char i=0;
  unsigned char achar0 = 0;

  achar0 = 0;

  for(i=0; i<10; i++)
    achar0++;

  assertEqual(achar0, 10);
  assertEqual(i, 10);
}

void test_while(void)
{
  unsigned char i = 10;
  unsigned char achar0 = 0;

  do
    {
      achar0++;
    }
  while (--i);

  assertEqual(achar0, 10);
  assertEqual(i, 0);
}

int i23 = 0;
int i42 = 0;

void g23(int i)
{
        assertEqual(i,23);
        i23 ^= 23;
}

void g42(int i)
{
        assertEqual(i,42);
        i42 += 42;
}

void test_for_scope(void)
{
        {
                int i = 23;
                g23(i);
                for(int i = 0; i < 2; i++)
                {
                        int i = 42;
                        g42(i);
                }
                g23(i);
        }
        assertEqual(i23,0);
        assertEqual(i42,84);
}


int suite_loops()
{
    suite_setup("Loop Tests");

    suite_add_test(test_for);
    suite_add_test(test_for_scope);
    suite_add_test(test_while);
    suite_add_test(test_loop);

    return suite_run();
}


int main(int argc, char *argv[])
{
    int  res = 0;

    res += suite_loops();

    exit(res);
}
