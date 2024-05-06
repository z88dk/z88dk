
typedef union {
  int a;
  long b;
} un_t;

typedef struct {
  char c;
  un_t pt;
} st_t;

void callit();

void func(st_t *__far far_p) {
  callit(far_p);
  callit(&(far_p->c));
  callit(&(far_p->pt));
  callit(&(far_p->pt.b));
}
