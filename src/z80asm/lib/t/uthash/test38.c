#include "uthash.h"
#include <stdlib.h>
#include <stdio.h>

struct test_t {
  int a;
  UT_hash_handle hh;
};

struct test_t *tests=NULL, *test, *tmp;

int main(void) {
  int a, b;
  for (b=0; b < 3; b++) {
    for (a=0; a < 10; a++) {
      test = NULL;
      HASH_FIND(hh, tests, &a, sizeof(a), test);
      if (! test) {
        test = (struct test_t*)m_malloc(sizeof(struct test_t));
        memset(test, 0, sizeof(struct test_t));
        test->a = a;
        HASH_ADD(hh, tests, a, sizeof(a), test);
      }
    }
  }
  printf("hash count %u\n", HASH_COUNT(tests));
  
  /* free memory */
  HASH_ITER(hh, tests, test, tmp) {
	HASH_DEL(tests, test);     /* delete; users advances to next */
	m_free(test);
  }

  return 0;
}
