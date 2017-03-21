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

#ifdef TIMER
   #define TIMER_START()       __asm__("TIMER_START:")
   #define TIMER_STOP()        __asm__("TIMER_STOP:")
#else
   #define TIMER_START()
   #define TIMER_STOP()
#endif

#ifdef __Z88DK
   #include <intrinsic.h>
   #ifdef PRINTF
      // enable printf %f
      #pragma output CLIB_OPT_PRINTF = 0x04000000
   #endif
#endif


#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#define sqrt sqrtf

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
    0, 0, 0, 0, 0, 0, solar_mass
  },
  {                               /* jupiter */
    4.84143144246472090e+00,
    -1.16032004402742839e+00,
    -1.03622044471123109e-01,
    1.66007664274403694e-03 * days_per_year,
    7.69901118419740425e-03 * days_per_year,
    -6.90460016972063023e-05 * days_per_year,
    9.54791938424326609e-04 * solar_mass
  },
  {                               /* saturn */
    8.34336671824457987e+00,
    4.12479856412430479e+00,
    -4.03523417114321381e-01,
    -2.76742510726862411e-03 * days_per_year,
    4.99852801234917238e-03 * days_per_year,
    2.30417297573763929e-05 * days_per_year,
    2.85885980666130812e-04 * solar_mass
  },
  {                               /* uranus */
    1.28943695621391310e+01,
    -1.51111514016986312e+01,
    -2.23307578892655734e-01,
    2.96460137564761618e-03 * days_per_year,
    2.37847173959480950e-03 * days_per_year,
    -2.96589568540237556e-05 * days_per_year,
    4.36624404335156298e-05 * solar_mass
  },
  {                               /* neptune */
    1.53796971148509165e+01,
    -2.59193146099879641e+01,
    1.79258772950371181e-01,
    2.68067772490389322e-03 * days_per_year,
    1.62824170038242295e-03 * days_per_year,
    -9.51592254519715870e-05 * days_per_year,
    5.15138902046611451e-05 * solar_mass
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

TIMER_START();

  offset_momentum(NBODIES, bodies);
  PRINTF2("%.9f\n", energy(NBODIES, bodies));
  scale_bodies(NBODIES, bodies, DT);
  for (i = 1; i <= n; i++)  {
    advance(NBODIES, bodies);
  }
  scale_bodies(NBODIES, bodies, RECIP_DT);
  PRINTF2("%.9f\n", energy(NBODIES, bodies));

TIMER_STOP();

  return 0;
}
