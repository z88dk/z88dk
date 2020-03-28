#include <stdio.h>


void placeholder(int val, char *str) {
    printf("%d %s\n",val,str);
}




void s_fastcall(char *str) __z88dk_fastcall {
    placeholder(-1, str);
}

void test2() {
    void (*ptr)(char *str) __z88dk_fastcall = s_fastcall;
    s_fastcall("test2-direct");
    ptr("test2");
}

void s_regular(char *str) {
    placeholder(-1, str);
}

void test3() {
    void (*ptr)(char *str) = s_regular;
    s_regular("test3-direct");
    ptr("test3");
}

void is_regular(int val, char *str) {
    placeholder(val,str);
}

void test4() {
    void (*ptr)(int val, char *str) = is_regular;
    is_regular(10,"test4-direct");
    ptr(4, "test4");
}

void l_regular(long val)   {
    printf("Long val %ld\n",val);
}

void test5() {
    void (*ptr)(long l)  = l_regular;
    l_regular(101);
    ptr(-1L);
}

void d_fastcall(double d) __z88dk_fastcall {
    printf("Double val %lf\n",d);
}

void test6() {
    void (*ptr)(double d) __z88dk_fastcall = d_fastcall;
    d_fastcall(20.0);
    ptr(1.0);
}

void ll_fastcall(long a, long b)  __z88dk_fastcall {
    printf("A = %ld b = %ld\n",a,b);
}

void test7() {
    void (*ptr)(long a, long b) __z88dk_fastcall = ll_fastcall;

    ll_fastcall(100, -10);
    ptr(10, -1);
}

void is_fastcall(int val, char *str) __z88dk_fastcall {
    placeholder(val,str);
}

void test1() {
    int (*ptr)(int val, char *str) __z88dk_fastcall = is_fastcall;
    is_fastcall(10,"test1-direct");
    ptr(1, "test1");
}

int main() {
    test1();
    test2();
    test3();
    test4();
    test5();
    test6();
    test7();
    return 0;
}
