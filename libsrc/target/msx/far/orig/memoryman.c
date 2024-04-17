#include <stdio.h>

#ifdef DEBUG
#define PRINT(...) printf(__VA_ARGS__)
#else
#define PRINT(...)
#endif

extern char mapper_allocate();
extern void mapper_put_p2(char segment);
extern char mapper_get_p2();


#define MAX_HEAP_PAGE 5
#define START_PAGE 0x8000
#define TYPESTART int

// how many pages are allocated
uint heap_npages;

/*
 [1,MAX_HEAP_PAGE] instead of [0,MAX_HEAP_PAGE)
 to have a 'e' part of the address > 0, useful for debug
 to distinguish between near and far addresses
 */
char heapseg[MAX_HEAP_PAGE+1];

void _mm_init_seg(char seg) {
  TYPESTART * start = (TYPESTART*)START_PAGE;
  char oldseg = mapper_get_p2();
  mapper_put_p2(seg); // 0x8000

  // the first int of the page is the offset of the first free mem
  *start = (long)sizeof(TYPESTART);  // after the first long
  mapper_put_p2(oldseg);
}

void mm_init() {
  heap_npages = 0;
  for (int i=1; i<MAX_HEAP_PAGE+1; i++) {
    heapseg[i] = mapper_allocate();
    if (heapseg[i] == 0)
      break;

    printf("page allocated for heap: %d\n", heapseg[i]);
    _mm_init_seg(heapseg[i]);
    heap_npages++;
  }
  printf("Allocated %d segments for heap (tot %dKB)\n", heap_npages, heap_npages*16);
}

// 0ehl
long mm_malloc(int size) {
  TYPESTART * start = (TYPESTART*)START_PAGE;
  static char pageindex = 0;  // page index
  pageindex = (pageindex + 1) % heap_npages;
  pageindex++; // starts from 1
  char oldseg = mapper_get_p2();
  mapper_put_p2(heapseg[pageindex]);
  TYPESTART toret = *start;
  *start += size;
  mapper_put_p2(oldseg);  // restore segment
  PRINT("malloc (%d) in pageid: %d, seg: %d, off %x\n", size, pageindex, heapseg[pageindex], toret);
  if (toret > 0x4000) {
    return 0L;   // OOM
  }

  long res = pageindex;
  res = (res << 16) | toret;

  return res;
}

void mm_free(char e, int hl) {
  // TODO
  //printf("free far\n");
}


char mm_lp_gchar(char e, int hl) {
  int address = START_PAGE + hl;
  char oldseg = mapper_get_p2();
  mapper_put_p2(heapseg[e]);
  char toret = *(char*)address;
  mapper_put_p2(oldseg);  // restore segment
  PRINT("gchar %x-%x has %lx\n", e, hl, toret);
  return toret;
}

int mm_lp_gint(char e, int hl) {
  int address = START_PAGE + hl;
  char oldseg = mapper_get_p2();
  mapper_put_p2(heapseg[e]);
  int toret = *(int*)address;
  mapper_put_p2(oldseg);  // restore segment
  PRINT("gint %x-%x has %x\n", e, hl, toret);
  return toret;
}

void mm_lp_pchar(char e, int hl, char towrite) {
  int address = START_PAGE + hl;
  PRINT("writing char %c to '%x' (seg %d) - '%x'\n", towrite, e, heapseg[e], address);
  char oldseg = mapper_get_p2();
  mapper_put_p2(heapseg[e]);
  *(char*)address = towrite;
  mapper_put_p2(oldseg);  // restore segment  
}

void mm_lp_pint(char e, int hl, int towrite) {
  int address = START_PAGE + hl;
  PRINT("wrt int %d in '%x' - '%x'\n", towrite, e, hl);
  char oldseg = mapper_get_p2();
  mapper_put_p2(heapseg[e]);
  *(int*)address = towrite;
  mapper_put_p2(oldseg);  // restore segment  
}

// 0ehl -> 0ehl
long mm_lp_gptr(char e, int hl) {
  int address = START_PAGE + hl;
  char oldseg = mapper_get_p2();
  mapper_put_p2(heapseg[e]);
  char e_res = *(char*)address;
  int hl_res = *(int*)(address+1);
  mapper_put_p2(oldseg);  // restore segment
  long toret = e_res;
  toret = (toret<<16) + hl_res;
  PRINT("gptr %x-%x has %lx\n", e_res, hl_res, toret);
  return toret;
}

void mm_lp_pptr(char e, int hl, long towrite) {
  int address = START_PAGE + hl;
  char oldseg = mapper_get_p2();
  mapper_put_p2(heapseg[e]);
  char e_towrite = (char)((towrite >> 16)& 0xF);
  int hl_towrite = (towrite & 0xFFFF);
  *(char*)address = e_towrite;
  *(int*)(address+1) = hl_towrite;
  mapper_put_p2(oldseg);  // restore segment
  PRINT("pptr wrote %lx (%x-%x) in '%x' - '%x'\n", towrite, e_towrite, hl_towrite, e, hl);
}

#ifdef __MMAN_TEST__

#include<stdlib.h>

extern void *__far malloc_far(long size);

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

void main() {
  // allocate segments
  mm_init();

  int nrep = 200;
  char tmp;
  clock_t t1, t2, t3,t4;

  // malloc benchmark
  char * ma;
  t1 = clock();
  for (int i = 0; i<nrep; i++) ma = malloc(sizeof(char));
  t2 = clock();
  for (int i = 0; i<nrep; i++) *ma = 'Z';
  t3 = clock();
  for (int i = 0; i<nrep; i++) tmp = *ma; //printf("---- val: %c\n", *ma);
  t4 = clock();
  printf("%d malloc: %.3f\n", nrep, (float)(t2-t1)/CLOCKS_PER_SEC);
  printf("%d write: %.3f\n", nrep, (float)(t3-t2)/CLOCKS_PER_SEC);
  printf("%d read: %.3f\n", nrep, (float)(t4-t3)/CLOCKS_PER_SEC);


  printf("\n");
  
  // malloc far benchmark
  char *__far maf;
  t1 = clock();
  for (int i = 0; i<nrep; i++) maf = malloc_far(sizeof(char));
  t2 = clock();
  for (int i = 0; i<nrep; i++) *maf = 'Z';
  t3 = clock();
  for (int i = 0; i<nrep; i++) tmp = *maf; //printf("---- val: %c\n", *ma);
  t4 = clock();

  printf("%d malloc far: %.3f\n", nrep, (float)(t2-t1)/CLOCKS_PER_SEC);
  printf("%d write far: %.3f\n", nrep, (float)(t3-t2)/CLOCKS_PER_SEC);
  printf("%d read far: %.3f\n", nrep, (float)(t4-t3)/CLOCKS_PER_SEC);

  printf("written val: %c\n", tmp);

}
#endif
