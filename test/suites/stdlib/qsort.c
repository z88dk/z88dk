
#ifndef __8080__

#include "stdlib_tests.h"
#include <stdint.h>

#define NUM 550L

static uint16_t i;
static int16_t numbers[NUM];

static void init_numbers(int16_t val0, int16_t v_add)
{
   // not pseudo random numbers, but keeping the performance of all init styles same
   printf("Numbers: %d %+d & 0x3fff: ", val0, v_add);
   for (i = 0; i < NUM; ++i, val0 += v_add) numbers[i] = val0 & 0x3fff;
   for (i = 0; i < 3; ++i) printf("%d, ", numbers[i]);
   printf("...\n");
}

static int ascending_order(int16_t *a, int16_t *b)
{
   // signed comparison is only good for |num| < 32768
   return *a - *b;
}

static struct qsort_init_data {
   int16_t val0, v_add;
   int16_t result_first, result_last;
   int32_t sum;
   const char name[4];
} data[] = {
   { 1, +197, 0, 16352, 4331041, "ran" },
   { 1, +1, 1, NUM, (NUM*(NUM+1))>>1, "ord" },
   { NUM, -1, 1, NUM, (NUM*(NUM+1))>>1, "rev" },
   { NUM>>1, +0, NUM>>1, NUM>>1, (NUM*(NUM>>1)), "equ" },
};

static void qsort_test_case(struct qsort_init_data *test)
{
   printf("[%s]: ", test->name);
   // init numbers array
   init_numbers(test->val0, test->v_add);
   // perform qsort
   printf("qsort running. ");
   qsort(numbers, NUM, sizeof(int16_t), ascending_order);
   printf("done: %d, %d, ..., %d, %d\n", numbers[0], numbers[1], numbers[NUM-2], numbers[NUM-1]);
   // verify result
   int32_t sum = (int32_t)numbers[0];
   for (i = 1; i < NUM; ++i) {
      sum += (int32_t)numbers[i];
      Assert(numbers[i-1] <= numbers[i], "Sort failed");
   }
   Assert(test->result_first == numbers[0], "Sort failed [first]");
   Assert(test->result_last == numbers[NUM-1], "Sort failed [last]");
   Assert(test->sum == sum, "Sort failed [sum]");
}

static void qsort_test_case_ran()
{
    qsort_test_case(data+0);
}

static void qsort_test_case_ord()
{
    qsort_test_case(data+1);
}

static void qsort_test_case_rev()
{
    qsort_test_case(data+2);
}

static void qsort_test_case_equ()
{
    qsort_test_case(data+3);
}

int test_qsort()
{
    suite_setup("classic-lib qsort() tests");
    suite_add_test(qsort_test_case_ran);
    suite_add_test(qsort_test_case_ord);
    suite_add_test(qsort_test_case_rev);
    suite_add_test(qsort_test_case_equ);
    return suite_run();
}

#endif
