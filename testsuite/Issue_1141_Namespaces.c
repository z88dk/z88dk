extern void set1(void);
extern void set2(void);

__addressmod set1 nspace1;
__addressmod set2 nspace2;

extern nspace1 int *nspace2 x;

nspace1 int *y;

void function() {
    *x = 2;
}

void function2() {
    *y = 2;
}

nspace2 int z = 2;

void func3() {
   z = 2;
}
