
typedef unsigned int uint;
typedef uint PNT_n;
typedef struct Pnt_B { unsigned char x,y; } Pnt;
typedef union PNT_U {
    Pnt p;
    PNT_n pnt;
} PNT;
typedef struct Mob_ { PNT p; } Mob;
//////////////////////////////////////////////////////
PNT_n P(unsigned char x, unsigned char y) {
  PNT b;
  b.p.x = x; b.p.y = y;
  return b.pnt;
}

void main() {
  Mob m;
  m.p.pnt = P(33,44);
//  printf("Z %d %d ", m.p.p.x, m.p.p.y);
  Pnt k; k = m.p.p;
//  printf("S %d %d \n", k.x, k.y);
}

