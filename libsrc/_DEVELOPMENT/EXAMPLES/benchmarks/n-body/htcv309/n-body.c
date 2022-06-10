/* The Computer Language Benchmarks Game
 * http://benchmarksgame.alioth.debian.org/
 *
 * contributed by Christoph Bauer
 * slightly sped up by Petr Prokhorenkov
 */

#ifdef STATIC
#undef  STATIC
#define STATIC            static
#else
#define STATIC
#endif

#ifdef PRINTF
#define PRINTF2(a,b)      printf(a,b)
#else
#define PRINTF2(a,b)
#endif

#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#define pi 3.141592653589793
#define solar_mass (4 * pi * pi)
#define days_per_year 365.24

struct planet {
  double x, y, z;
  double vx, vy, vz;
  double mass;
};

/*
 * Here's one weird thing: inlining of this function
 * decreases performance by 25%. (I.e. do not compile this with -O3)
 * Advances with dt == 1.0
 */
void advance(int nbodies, struct planet * bodies)
{
  STATIC int i, j;
  STATIC struct planet *b, *b2;
  STATIC double dx, dy, dz;
  STATIC double inv_distance, mag;

  for (i = 0; i < nbodies; i++) {
    b = &(bodies[i]);
    for (j = i + 1; j < nbodies; j++) {
      b2 = &(bodies[j]);
      dx = b->x - b2->x;
      dy = b->y - b2->y;
      dz = b->z - b2->z;
      inv_distance = 1.0/sqrt(dx * dx + dy * dy + dz * dz);
      mag = inv_distance * inv_distance * inv_distance;
      b->vx -= dx * b2->mass * mag;
      b->vy -= dy * b2->mass * mag;
      b->vz -= dz * b2->mass * mag;
      b2->vx += dx * b->mass * mag;
      b2->vy += dy * b->mass * mag;
      b2->vz += dz * b->mass * mag;
    }
  }
  for (i = 0; i < nbodies; i++) {
    b = &(bodies[i]);
    b->x += b->vx;
    b->y += b->vy;
    b->z += b->vz;
  }
}

double energy(int nbodies, struct planet * bodies)
{
  STATIC double e;
  STATIC int i, j;
  STATIC struct planet *b, *b2;
  STATIC double dx, dy, dz;
  STATIC double distance;

  e = 0.0;
  for (i = 0; i < nbodies; i++) {
    b = &(bodies[i]);
    e += 0.5 * b->mass * (b->vx * b->vx + b->vy * b->vy + b->vz * b->vz);
    for (j = i + 1; j < nbodies; j++) {
      b2 = &(bodies[j]);
      dx = b->x - b2->x;
      dy = b->y - b2->y;
      dz = b->z - b2->z;
      distance = sqrt(dx * dx + dy * dy + dz * dz);
      e -= (b->mass * b2->mass) / distance;
    }
  }
  return e;
}

void offset_momentum(int nbodies, struct planet * bodies)
{
  STATIC double px, py, pz;
  STATIC int i;
  
  px = py = pz = 0.0;
  for (i = 0; i < nbodies; i++) {
    px += bodies[i].vx * bodies[i].mass;
    py += bodies[i].vy * bodies[i].mass;
    pz += bodies[i].vz * bodies[i].mass;
  }
  bodies[0].vx = - px / solar_mass;
  bodies[0].vy = - py / solar_mass;
  bodies[0].vz = - pz / solar_mass;
}

#define NBODIES 5
struct planet bodies[NBODIES] = {
  {                               /* sun */
    0, 0, 0, 0, 0, 0, 3.9478417604E+01
  },
  {                               /* jupiter */
     4.8414314425E+00,
    -1.1603200440E+00,
    -1.0362204447E-01,
     6.0632639300E-01,
     2.8119868449E+00,
    -2.5218361660E-02,
     3.7693674870E-02
  },
  {                               /* saturn */
     8.3433667182E+00,
     4.1247985641E+00,
    -4.0352341711E-01,
    -1.0107743462E+00,
     1.8256623712E+00,
     8.4157613766E-03,
     1.1286326132E-02
  },
  {                               /* uranus */
     1.2894369562E+01,
    -1.5111151402E+01,
    -2.2330757889E-01,
     1.0827910064E+00,
     8.6871301817E-01,
    -1.0832637401E-02,
     1.7237240571E-03
  },
  {                               /* neptune */
     1.5379697115E+01,
    -2.5919314610E+01,
     1.7925877295E-01,
     9.7909073224E-01,
     5.9469899865E-01,
    -3.4755955504E-02,
     2.0336868699E-03
  }
};

#define DT 1e-2
#define RECIP_DT (1.0/DT)

/*
 * Rescale certain properties of bodies. That allows doing
 * consequential advance()'s as if dt were equal to 1.0.
 *
 * When all advances done, rescale bodies back to obtain correct energy.
 */
void scale_bodies(int nbodies, struct planet * bodies, double scale) {
    STATIC int i;

    for (i = 0; i < nbodies; i++) {
        bodies[i].mass *= scale*scale;
        bodies[i].vx *= scale;
        bodies[i].vy *= scale;
        bodies[i].vz *= scale;
    }
}

int main(int argc, char ** argv)
{
  int i;
  int n = 1000;
  
#ifdef COMMAND
  n = atoi(argv[1]);
#endif

  offset_momentum(NBODIES, bodies);
  PRINTF2("%.9f\n", energy(NBODIES, bodies));
  scale_bodies(NBODIES, bodies, DT);
  for (i = 1; i <= n; i++)  {
    advance(NBODIES, bodies);
  }
  scale_bodies(NBODIES, bodies, RECIP_DT);
  PRINTF2("%.9f\n", energy(NBODIES, bodies));

  return 0;
}
