/* Benchmark computation of linear nlc-width.
   At a lower level, we mostly benchmark memory handling.
   This part of the benchmark is based on real-world code.
   Source: http://lnlc.sourceforge.net/

   (c) 2014 - 2018 Philipp Klaus Krause

   This program is free software; you can redistribute it and/or modify it
   under the terms of the GNU General Public License as published by the
   Free Software Foundation; either version 2, or (at your option) any
   later version. */

#include "stdcbench.h"

#ifdef C90LIB

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#if __STDC_VERSION__ >= 199901L
#include <stdbool.h>
#include <stdint.h>
typedef uint_least8_t node_t; // Needs to be an unsigned integer type, that has a maximum value >= MAX_N.
typedef uint_fast8_t count_t; // Needs to be an unsigned type, that has a maximum value >= 2^MAX_K.
#else
#define restrict
typedef unsigned char bool;
#define false 0
#define true 1
typedef unsigned char node_t;
typedef unsigned char count_t;
#endif

#define MAX_K 4
#define MAX_N 8

bool ref_adjacency_matrix[MAX_N][MAX_N];
node_t ref_n;
node_t max_k;

bool check_lnlc(bool);


static bool adjacency_matrix[MAX_N][MAX_N];
static node_t n;
static node_t node_degrees[MAX_N];
static node_t degree_list[MAX_N];
static node_t num_edges;

static node_t k;
static node_t node_colors[MAX_N];

bool ref_adjacency_matrix[MAX_N][MAX_N];
node_t ref_n;
static node_t ref_node_degrees[MAX_N];
static node_t ref_degree_list[MAX_N];
static node_t ref_mindeg, ref_maxdeg;
static node_t ref_num_edges;
static node_t ref_neighbour_degrees[MAX_N];

node_t max_k;

static char *instructions; /* Should point to a buffer of size at least MAX_N^2 * 80 + MAX_N * MAX_K to get instructions or 0 if those are not needed. */

bool add(void);
bool recolor(void);
bool test(void);

/* Add a new, colored node, connect it to a subset of existing colors. */
bool add(void)
{
	bool ret = false;
	node_t sum, ref_sum;
	node_t i;
	node_t new_node_color; /* Color of new node */
	count_t connect_colors; /* Colors new node is connected to (bitmask) */

	node_t node_degrees_backup[MAX_N];
	node_t degree_list_backup[MAX_N];
	node_t num_edges_backup;

	memcpy(node_degrees_backup, node_degrees, MAX_N * sizeof(node_t)); /* Copying fixed size is more efficient than copying only the part needed. */
	memcpy(degree_list_backup, degree_list, MAX_N * sizeof(node_t));
	num_edges_backup = num_edges;

	for(connect_colors = 0; connect_colors < (1 << k) && !ret; connect_colors++) /* New node can connect to any subset of existing colors. */
	{
		node_degrees[n] = 0;
		n++;
		memset(adjacency_matrix[n - 1], 0, (n - 1) * sizeof(bool)); /* Doing it once here is faster than having an else branch in the loop below. */

		/* Connect new node to existing nodes. */
		for(i = 0; i < n - 1; i++)
			if (connect_colors & (1 << node_colors[i]))
			{
				num_edges++;
				if(num_edges + (ref_n - n) * ref_mindeg / 2 > ref_num_edges) /* Early abort when there are too many edges already. */
 					goto tried;
				if(num_edges - num_edges_backup > ref_maxdeg) /* Early abort when there are too many edges at the new node already. */
					goto tried;

				adjacency_matrix[n - 1][i] = true;

				degree_list[node_degrees[i]]--;
				node_degrees[i]++;
				degree_list[node_degrees[i]]++;

				node_degrees[n - 1]++;
			}
		degree_list[node_degrees[n - 1]]++;

		if(num_edges + (ref_n - n) * ref_maxdeg < ref_num_edges) /* Early abort when there are too few edges still. */
			goto tried;

		if(n == ref_n)
		{
			if(test())
			{
				if(instructions)
				{
					instructions += sprintf(instructions, "Add node %d of color 0, connect it to nodes of the following colors: ", n - 1);
					for(i = 0; i < k; i++)
						if (connect_colors & (1 << i))
							instructions += sprintf(instructions, "%d ", i);
					instructions += sprintf(instructions, "\n");
				}

				ret = true;
			}
			goto tried;
		}

		/* Early abort when degrees are too high. */
		sum = 0;
		ref_sum = 0;
		for(i = ref_n - 1; i > 0; i--)
		{
			sum += degree_list[i];
			ref_sum += ref_degree_list[i];
			if(sum > ref_sum)
				goto tried;
		}

		for(new_node_color = 0; new_node_color <= k && new_node_color < max_k; new_node_color++) /* New node uses existing color, or exactly one above. */
		{
			node_t k_backup = k;

			if(new_node_color == k)
				k++;

			node_colors[n - 1] = new_node_color;

			/* Recurse to recoloring. */
			if(recolor())
			{
				if(instructions)
				{
					instructions += sprintf(instructions, "Add node %d of color %d, connect it to nodes of the following colors: ", n - 1, new_node_color);
					for(i = 0; i < k; i++)
						if (connect_colors & (1 << i))
							instructions += sprintf(instructions, "%d ", i);
					instructions +=  sprintf(instructions, "\n");
				}

				ret = true;

				goto tried;
			}

			k = k_backup;
		}

tried:
		n--;
		degree_list[n] = 0;
		memcpy(degree_list, degree_list_backup, MAX_N * sizeof(node_t));
		memcpy(node_degrees, node_degrees_backup, MAX_N * sizeof(node_t));
		num_edges = num_edges_backup;
	}

	return(ret);
}

static node_t recolormap[MAX_K];

bool do_recolor(void)
{
	bool ret = false;
	node_t i;
	node_t node_colors_backup[MAX_N];
	bool used_colors[MAX_N];
	node_t k_backup;

	/* Skip colorings that would recolor the most recently added node - it could have been added with target color in the first place instead. */
	if(recolormap[node_colors[n - 1]] != node_colors[n - 1] &&
		recolormap[node_colors[n - 1]] == recolormap[recolormap[node_colors[n - 1]]]) /* Recoloring the new node just for closing gaps created by recoloring of other nodes is ok. */
		return(false);

	k_backup = k;
	memcpy(node_colors_backup, node_colors, MAX_N * sizeof(node_t));

	/* Check coloring */
	memset(used_colors, 0, MAX_N * sizeof(bool));
	k = 0;
	for(i = 0; i < k_backup; i++)
	{
		used_colors[recolormap[i]] = true;
		if(recolormap[i] >= k)
			k = recolormap[i] + 1;
	}
	/* Do not allow gaps in colors. */
	for(i = 0; i < k; i++)
		if(!used_colors[i])
			goto tried;

	/* Recolor graph. */
	for(i = 0; i < n; i++)
		node_colors[i] = recolormap[node_colors[i]];

	/* Recurse to node addition. */
	if(ret = add())
	{
		for(i = 0; i < n; i++)
			if (node_colors[i] != node_colors_backup[i] && instructions)
				instructions += sprintf(instructions, "Recolor node %d from %d to %d\n", i, node_colors_backup[i], node_colors[i]);
	}

tried:
	memcpy(node_colors, node_colors_backup, MAX_N * sizeof(node_t));
	k = k_backup;

	return(ret);
}

bool maprecolor(node_t i)
{
	node_t j;

	if (i == k) /* Recurse in graph construction algorithm. */
		return(do_recolor());
	else /* Recurse in recoloring construction algorithm. */
		for(j = 0; j <= i; j++)	/* Never consider higher colors for recoloring. */
		{
			recolormap[i] = j;
			if(maprecolor(i + 1))
				return(true);
		}
	return(false);
}

/* Recolor nodes. */
bool recolor(void)
{
	return(maprecolor(0));
}

static node_t testperm[MAX_N];

/* Recursively generate permutations for isomorphism test. */
bool permtest(node_t i)
{
	node_t j;

	/* Check that all edges to the most recently considered node are ok. */
	for(j = 0; j + 2 < i; j++)
		if((testperm[i - 1] > testperm[j] ? adjacency_matrix[testperm[i - 1]][testperm[j]] : adjacency_matrix[testperm[j]][testperm[i - 1]]) != ref_adjacency_matrix[i - 1][j])
			return(false);

	if(i == n)
		return(true);

	for(j = i; j < n; j++)
	{
		node_t t;

		if (node_degrees[testperm[j]] != ref_node_degrees[i]) /* Do not try permutations where degrees do not match. */
			continue;

		t = testperm[i];
		testperm[i] = testperm[j];
		testperm[j] = t;

		if(permtest(i + 1))
			return(true);

		t = testperm[i];
		testperm[i] = testperm[j];
		testperm[j] = t;
	}

	return(false);
}

int cmp(const void *l, const void *r)
{
	return *((node_t*)r) - *((node_t *)l);
}

void calc_neighbour_degrees(node_t *restrict neighbour_degrees, bool (*adjacency_matrix)[MAX_N], const node_t *restrict degrees)
{
	node_t i, j;

	memset(neighbour_degrees, 0, MAX_N);
	for(i = 0; i < ref_n; i++)
		for(j = 0; j < i; j++)
			if(adjacency_matrix[i][j])
			{
				neighbour_degrees[i] += (1 << (degrees[j] - 1));
				neighbour_degrees[j] += (1 << (degrees[i] - 1));
			}
	qsort(neighbour_degrees, ref_n, sizeof(node_t), cmp);
}

/* Isomorphism test */
bool test(void)
{
	node_t i;
	node_t neighbour_degrees[MAX_N];

	/* Compare degree list first. */
	if (memcmp(ref_degree_list, degree_list, n * sizeof(node_t)))
		return(false);

	/* Compare degress of neighbours next. */
	calc_neighbour_degrees(neighbour_degrees, adjacency_matrix, node_degrees);
	if (memcmp(ref_neighbour_degrees, neighbour_degrees, n * sizeof(node_t)))
		return(false);

	for(i = 0; i < n; i++)
		testperm[i] = i;

	return(permtest(0));
}


/* Has the graph ref_adjacency_matrix of ref_n nodes linear nlc-width at most k? */
bool check_lnlc(bool output_instructions)
{
	bool ret;
	char *startinstructions;
	char *outinstructions = stdcbench_buffer.basic_char;
	node_t i, j;

	if(!ref_n)
		return(true);

	memset(ref_node_degrees, 0, MAX_N * sizeof(node_t));
	memset(ref_degree_list + 1, 0, (MAX_N - 1) * sizeof(node_t));
	ref_degree_list[0] = ref_n;
	ref_num_edges = 0;
	for(i = 0; i < ref_n; i++)
		for(j = 0; j < i; j++)
			if(ref_adjacency_matrix[i][j])
			{
				ref_degree_list[ref_node_degrees[i]]--;
				ref_node_degrees[i]++;
				ref_degree_list[ref_node_degrees[i]]++;
				ref_degree_list[ref_node_degrees[j]]--;
				ref_node_degrees[j]++;
				ref_degree_list[ref_node_degrees[j]]++;
				ref_num_edges++;
			}

	for(i = 1, ref_mindeg = ref_maxdeg = ref_node_degrees[0]; i < ref_n; i++)
	{
		node_t ref_deg = ref_node_degrees[i];
		if (ref_deg < ref_mindeg)
			ref_mindeg = ref_deg;
		if (ref_deg > ref_maxdeg)
			ref_maxdeg = ref_deg;
	}

	calc_neighbour_degrees(ref_neighbour_degrees, ref_adjacency_matrix, ref_node_degrees);

	memset(degree_list, 0, MAX_N * sizeof(node_t));
	num_edges = 0;
	k = 0;

	if(output_instructions)
	{
		if(!(startinstructions = instructions = malloc (60 + (ref_n) * (72 + max_k / 8 * 2) + (ref_n - 1) * (ref_n - 2) / 2 * 28)))
			stdcbench_error("c90lib c90lib_lnlc(): malloc() failed\n");
		else
			startinstructions[0] = 0;
	}
	else
		startinstructions = instructions = 0;
	
	ret = add();

	if (ret && startinstructions)
	{
		char *c;

		outinstructions += sprintf(outinstructions, "Instructions for constructing the graph:");

		while(c = strrchr(startinstructions, '\n'))
		{
			outinstructions += sprintf(outinstructions, c);
			*c = 0;
		}
		outinstructions += sprintf(outinstructions, "\n%s\n", startinstructions);
	}

	free(startinstructions);

	return(ret);
}

static const char resultinstructions[] =
	"Instructions for constructing the graph:\n"
	"\n"
	"Add node 0 of color 0, connect it to nodes of the following colors: \n"
	"Add node 1 of color 1, connect it to nodes of the following colors: \n"
	"Add node 2 of color 2, connect it to nodes of the following colors: 0 1 \n"
	"Add node 3 of color 1, connect it to nodes of the following colors: 0 \n"
	"Add node 4 of color 0, connect it to nodes of the following colors: 0 1 \n"
	"Recolor node 2 from 2 to 1\n"
	"Add node 5 of color 0, connect it to nodes of the following colors: 1 \n";

static volatile const bool prism[6][6] =
	{{0, 1, 1, 1, 0, 0},
	{1, 0, 1, 0, 1, 0},
	{1, 1, 0, 0, 0, 1},
	{1, 0, 0, 0, 1, 1},
	{0, 1, 0, 1, 0, 1},
	{0, 0, 1, 1, 1, 0}};

void c90lib_lnlc(void)
{
	node_t i, j;

	ref_n = 6;
	for(i = 0; i < ref_n; i++)
		for(j = 0; j < ref_n; j++)
			ref_adjacency_matrix[i][j] = prism[i][j];

	for(max_k = 0; max_k <= MAX_K; max_k++)
		if(check_lnlc(true))
			break;

	if(k != 1 || strcmp(stdcbench_buffer.basic_char, resultinstructions))
		stdcbench_error("c90lib c90lib_lnlc(): Result validation failed");
}

#endif

