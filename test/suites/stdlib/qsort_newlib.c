
#ifndef __8080__

#include "stdlib_tests.h"
#include <stdint.h>

#define NUM 550L

typedef void (*exec_sort)(void *base,size_t nmemb,size_t size,void *compar) __smallc;

static uint16_t i;
static int16_t numbers[NUM];

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

const char* isort_name = "insertion";
const char* ssort_name = "shell";
#ifndef __RCMX000__
   const char* qsort_name = "quick 0x0c";    // middle-pivot, insertion-sort enabled, equality dispersal enabled
#else
   const char* qsort_name = "quick 0x04";    // Rabbit has no R register used for equality distribution
#endif

// include newlib implementation of various sorts
static void dummy()
{
#asm
   // configure quicksort implementation
#ifndef __RCMX000__
   DEFC __CLIB_OPT_SORT_QSORT = 0x0c   ; middle-pivot, insertion-sort enabled, equality dispersal enabled
#else
   DEFC __CLIB_OPT_SORT_QSORT = 0x04   ; middle-pivot, insertion-sort enabled, equality dispersal disabled (missing R reg)
#endif

   ; Include newlib sorts
   INCLUDE "../../../libsrc/_DEVELOPMENT/stdlib/z80/sort/__sort_parameters.asm"
   INCLUDE "../../../libsrc/_DEVELOPMENT/stdlib/z80/sort/asm_insertion_sort.asm"
   INCLUDE "../../../libsrc/_DEVELOPMENT/stdlib/z80/sort/asm_shellsort.asm"
   INCLUDE "../../../libsrc/_DEVELOPMENT/stdlib/z80/sort/asm_quicksort.asm"

   #define read_qsort_small_c_args \
         pop af \ pop ix \ pop de \ pop hl \ pop bc \ \
         push bc \ push hl \ push de \ push ix \ push af \ \
         ; enter : ix = int (*compar)(de=const void *, hl=const void *) \
         ;         bc = void *base \
         ;         hl = size_t nmemb \
         ;         de = size_t size

#endasm
}

// execute insertion sort directly
static void exec_newlib_isort(void *base,size_t nmemb,size_t size,void *compar) __smallc __naked
{
#asm
   read_qsort_small_c_args
   call asm_insertion_sort
   ret
#endasm
}

// execute shell sort directly
static void exec_newlib_ssort(void *base,size_t nmemb,size_t size,void *compar) __smallc __naked
{
#asm
   read_qsort_small_c_args
   call asm_shellsort
   ret
#endasm
}

// execute quick sort directly
static void exec_newlib_qsort(void *base,size_t nmemb,size_t size,void *compar) __smallc __naked
{
#asm
   read_qsort_small_c_args
   call asm_quicksort
   ret
#endasm
}

static void init_numbers(int16_t val0, int16_t v_add)
{
   // not pseudo random numbers, but keeping the performance of all init styles same
   printf("Numbers: %d %+d & 0x3fff: ", val0, v_add);
   for (i = 0; i < NUM; ++i, val0 += v_add) numbers[i] = val0 & 0x3fff;
   for (i = 0; i < 3; ++i) printf("%d, ", numbers[i]);
   printf("...\n");
}

static void qsort_test_case(struct qsort_init_data *test, exec_sort exec_sort_fn, const char* sort_name)
{
   printf("[%s][%s]: ", sort_name, test->name);
   // init numbers array
   init_numbers(test->val0, test->v_add);
   // perform sort
   printf("sort running. ");
   exec_sort_fn(numbers, NUM, sizeof(int16_t), ascending_order);
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

static void isort_test_case_ran() { qsort_test_case(data+0, &exec_newlib_isort, isort_name); }
static void isort_test_case_ord() { qsort_test_case(data+1, &exec_newlib_isort, isort_name); }
static void isort_test_case_rev() { qsort_test_case(data+2, &exec_newlib_isort, isort_name); }
static void isort_test_case_equ() { qsort_test_case(data+3, &exec_newlib_isort, isort_name); }

static void ssort_test_case_ran() { qsort_test_case(data+0, &exec_newlib_ssort, ssort_name); }
static void ssort_test_case_ord() { qsort_test_case(data+1, &exec_newlib_ssort, ssort_name); }
static void ssort_test_case_rev() { qsort_test_case(data+2, &exec_newlib_ssort, ssort_name); }
static void ssort_test_case_equ() { qsort_test_case(data+3, &exec_newlib_ssort, ssort_name); }

static void qsort_test_case_ran() { qsort_test_case(data+0, &exec_newlib_qsort, qsort_name); }
static void qsort_test_case_ord() { qsort_test_case(data+1, &exec_newlib_qsort, qsort_name); }
static void qsort_test_case_rev() { qsort_test_case(data+2, &exec_newlib_qsort, qsort_name); }
static void qsort_test_case_equ() { qsort_test_case(data+3, &exec_newlib_qsort, qsort_name); }

int test_qsort_newlib()
{
    suite_setup("newlib insertion/shell/quick sorts tests");

    suite_add_test(isort_test_case_ran);
    suite_add_test(isort_test_case_ord);
    suite_add_test(isort_test_case_rev);
    suite_add_test(isort_test_case_equ);

    suite_add_test(ssort_test_case_ran);
    suite_add_test(ssort_test_case_ord);
    suite_add_test(ssort_test_case_rev);
    suite_add_test(ssort_test_case_equ);

    suite_add_test(qsort_test_case_ran);
    suite_add_test(qsort_test_case_ord);
    suite_add_test(qsort_test_case_rev);
    suite_add_test(qsort_test_case_equ);
    return suite_run();
}

#endif
