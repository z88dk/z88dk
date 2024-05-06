
typedef union {
  int a;
  long b;
} un_t;

struct x {
        long c;
};

typedef struct {
  char c;
  un_t pt;
  char arr[10];
  struct x *extra;
} st_t;

void callit();

void func(st_t *__far far_p) {
  callit(far_p);
}

void func0(st_t *__far far_p) {
  callit(&(far_p->c));
}
void func1(st_t *__far far_p) {
  callit(&(far_p->pt));
}
void func2(st_t *__far far_p) {
  callit(&(far_p->pt.b));
}
void func2a(st_t *__far far_p) {
  callit((far_p->pt.a));
}
void func2b(st_t *__far far_p) {
  callit((far_p->pt.b));
}

void func3(st_t *__far far_p) {
  far_p->arr[2] = 10;
}
void func4(st_t *__far far_p) {
  callit(&far_p->arr[5]);
}


void func5(st_t *__far far_p) {
  // This is incorrect, c is accessed via far
  callit(&far_p->extra->c);
}

void func5a(st_t *__far far_p) {
  // This is incorrect, c is accessed via far
  callit(far_p->extra->c);
}
