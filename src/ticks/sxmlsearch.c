/*
	Copyright (c) 2010, Matthieu Labas
	All rights reserved.

	Redistribution and use in source and binary forms, with or without modification,
	are permitted provided that the following conditions are met:

	1. Redistributions of source code must retain the above copyright notice,
	   this list of conditions and the following disclaimer.

	2. Redistributions in binary form must reproduce the above copyright notice,
	   this list of conditions and the following disclaimer in the documentation
	   and/or other materials provided with the distribution.

	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
	IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
	INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
	NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
	PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
	WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
	ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
	OF SUCH DAMAGE.

	The views and conclusions contained in the software and documentation are those of the
	authors and should not be interpreted as representing official policies, either expressed
	or implied, of the FreeBSD Project.
*/
#if defined(WIN32) || defined(WIN64)
#pragma warning(disable : 4996)
#endif

#include <string.h>
#include <stdlib.h>
#include "sxmlc.h"
#include "sxmlsearch.h"

#define INVALID_XMLNODE_POINTER ((XMLNode*)-1)

/* The function used to compare a string to a pattern */
static REGEXPR_COMPARE regstrcmp_search = regstrcmp;

REGEXPR_COMPARE XMLSearch_set_regexpr_compare(REGEXPR_COMPARE fct)
{
	REGEXPR_COMPARE previous = regstrcmp_search;

	regstrcmp_search = fct;

	return previous;
}

int XMLSearch_init(XMLSearch* search)
{
	if (search == NULL)
		return false;

	search->tag = NULL;
	search->text = NULL;
	search->attributes = NULL;
	search->n_attributes = 0;
	search->next = NULL;
	search->prev = NULL;
	search->stop_at = INVALID_XMLNODE_POINTER; /* Because 'NULL' can be a valid value */
	search->init_value = XML_INIT_DONE;
	
	return true;
}

int XMLSearch_free(XMLSearch* search, int free_next)
{
	int i;

	if (search == NULL || search->init_value != XML_INIT_DONE)
		return false;

	if (search->tag != NULL) {
		__free(search->tag);
		search->tag = NULL;
	}

	if (search->attributes != NULL) {
		for (i = 0; i < search->n_attributes; i++) {
			if (search->attributes[i].name != NULL)
				__free(search->attributes[i].name);
			if (search->attributes[i].value != NULL)
				__free(search->attributes[i].value);
		}
		__free(search->attributes);
		search->n_attributes = 0;
		search->attributes = NULL;
	}

	if (free_next && search->next != NULL) {
		(void)XMLSearch_free(search->next, true);
		__free(search->next);
		search->next = NULL;
	}
	search->init_value = 0; /* Something not XML_INIT_DONE, otherwise we'll go into 'XMLSearch_free' again */
	(void)XMLSearch_init(search);

	return true;
}

int XMLSearch_search_set_tag(XMLSearch* search, const SXML_CHAR* tag)
{
	if (search == NULL)
		return false;

	if (tag == NULL) {
		if (search->tag != NULL) {
			__free(search->tag);
			search->tag = NULL;
		}
		return true;
	}

	search->tag = sx_strdup(tag);
	return (search->tag != NULL);
}

int XMLSearch_search_set_text(XMLSearch* search, const SXML_CHAR* text)
{
	if (search == NULL)
		return false;

	if (text == NULL) {
		if (search->text != NULL) {
			__free(search->text);
			search->text = NULL;
		}
		return true;
	}

	search->text = sx_strdup(text);
	return (search->text != NULL);
}

int XMLSearch_search_add_attribute(XMLSearch* search, const SXML_CHAR* attr_name, const SXML_CHAR* attr_value, int value_equal)
{
	int i;
	XMLAttribute* pt;
	SXML_CHAR* name;
	SXML_CHAR* value;

	if (search == NULL)
		return -1;

	if (attr_name == NULL || attr_name[0] == NULC)
		return -1;

	name = sx_strdup(attr_name);
	value = (attr_value == NULL ? NULL : sx_strdup(attr_value));
	if (name == NULL || (attr_value && value == NULL)) {
		if (value != NULL)
			__free(value);
		if (name != NULL)
			__free(name);
	}

	i = search->n_attributes;
	pt = (XMLAttribute*)__realloc(search->attributes, (i + 1) * sizeof(XMLAttribute));
	if (pt == NULL) {
		if (value)
			__free(value);
		__free(name);
		return -1;
	}

	pt[i].name = name;
	pt[i].value = value;
	pt[i].active = value_equal;

	search->n_attributes = i+1;
	search->attributes = pt;

	return i;
}

int XMLSearch_search_get_attribute_index(const XMLSearch* search, const SXML_CHAR* attr_name)
{
	int i;

	if (search == NULL || attr_name == NULL || attr_name[0] == NULC)
		return -1;

	for (i = 0; i < search->n_attributes; i++) {
		if (!sx_strcmp(search->attributes[i].name, attr_name))
			return i;
	}

	return -1;
}

int XMLSearch_search_remove_attribute(XMLSearch* search, int i_attr)
{
	XMLAttribute* pt;

	if (search == NULL || i_attr < 0 || i_attr >= search->n_attributes)
		return -1;

	/* Free attribute fields first */
	if (search->n_attributes == 1)
		pt = NULL;
	else {
		pt = (XMLAttribute*)__malloc((search->n_attributes - 1) * sizeof(XMLAttribute));
		if (pt == NULL)
			return -1;
	}
	if (search->attributes[i_attr].name != NULL)
		__free(search->attributes[i_attr].name);
	if (search->attributes[i_attr].value != NULL)
		__free(search->attributes[i_attr].value);

	if (pt != NULL) {
		memcpy(pt, search->attributes, i_attr * sizeof(XMLAttribute));
		memcpy(&pt[i_attr], &search->attributes[i_attr + 1], (search->n_attributes - i_attr - 1) * sizeof(XMLAttribute));
	}
	if (search->attributes)
		__free(search->attributes);
	search->attributes = pt;
	search->n_attributes--;

	return search->n_attributes;
}

int XMLSearch_search_set_children_search(XMLSearch* search, XMLSearch* children_search)
{
	if (search == NULL)
		return false;

	if (search->next != NULL)
		XMLSearch_free(search->next, true);

	search->next = children_search;
	children_search->prev = search;

	return true;
}

SXML_CHAR* XMLSearch_get_XPath_string(const XMLSearch* search, SXML_CHAR** xpath, SXML_CHAR quote)
{
	const XMLSearch* s;
	SXML_CHAR squote[] = C2SX("'");
	int i, fill;

	if (xpath == NULL)
		return NULL;

	/* NULL 'search' is an empty string */
	if (search == NULL) {
		*xpath = sx_strdup(C2SX(""));
		if (*xpath == NULL)
			return NULL;

		return *xpath;
	}

	squote[0] = (quote == NULC ? XML_DEFAULT_QUOTE : quote);

	for (s = search; s != NULL; s = s->next) {
		if (s != search && strcat_alloc(xpath, C2SX("/")) == NULL) goto err; /* No "/" prefix for the first criteria */
		if (strcat_alloc(xpath, s->tag == NULL || s->tag[0] == NULC ? C2SX("*"): s->tag) == NULL) goto err;

		if (s->n_attributes > 0 || (s->text != NULL && s->text[0] != NULC))
			if (strcat_alloc(xpath, C2SX("[")) == NULL) goto err;

		fill = false; /* '[' has not been filled with text yet, no ", " separator should be added */
		if (s->text != NULL && s->text[0] != NULC) {
			if (strcat_alloc(xpath, C2SX(".=")) == NULL) goto err;
			if (strcat_alloc(xpath, squote) == NULL) goto err;
			if (strcat_alloc(xpath, s->text) == NULL) goto err;
			if (strcat_alloc(xpath, squote) == NULL) goto err;
			fill = true;
		}

		for (i = 0; i < s->n_attributes; i++) {
			if (fill) {
				if (strcat_alloc(xpath, C2SX(", ")) == NULL) goto err;
			} else
				fill = true; /* filling is being performed */
			if (strcat_alloc(xpath, C2SX("@")) == NULL) goto err;
			if (strcat_alloc(xpath, s->attributes[i].name) == NULL) goto err;
			if (s->attributes[i].value == NULL) continue;

			if (strcat_alloc(xpath, s->attributes[i].active ? C2SX("=") : C2SX("!=")) == NULL) goto err;
			if (strcat_alloc(xpath, squote) == NULL) goto err;
			if (strcat_alloc(xpath, s->attributes[i].value) == NULL) goto err;
			if (strcat_alloc(xpath, squote) == NULL) goto err;
		}
		if ((s->text != NULL && s->text[0] != NULC) || s->n_attributes > 0) {
			if (strcat_alloc(xpath, C2SX("]")) == NULL) goto err;
		}
	}

	return *xpath;

err:
	__free(*xpath);
	*xpath = NULL;

	return NULL;
}

/*
 Extract search information from 'xpath', where 'xpath' represents a single node
 (i.e. no '/' inside, except escaped ones), stripped from lead and tail '/'.
 tag[.=text, @attrib="value"] with potential spaces around '=' and ','.
 Return 'false' if parsing failed, 'true' for success.
 This is an internal function so we assume that arguments are valid (non-NULL).
 */
static int _init_search_from_1XPath(SXML_CHAR* xpath, XMLSearch* search)
{
	SXML_CHAR *p, *q;
	SXML_CHAR c, c1, cc;
	int l0, l1, is, r0, r1;
	int ret;

	XMLSearch_init(search);

	/* Look for tag name */
	for (p = xpath; *p != NULC && *p != C2SX('['); p++) ;
	c = *p; /* Either '[' or '\0' */
	*p = NULC;
	ret = XMLSearch_search_set_tag(search, xpath);
	*p = c;
	if (!ret)
		return false;

	if (*p == NULC)
		return true;

	/* Here, '*p' is '[', we have to parse either text or attribute names/values until ']' */
	for (p++; *p && *p != C2SX(']'); p++) {
		for (q = p; *q && *q != C2SX(',') && *q != C2SX(']'); q++) ; /* Look for potential ',' separator to null it */
		cc = *q;
		if (*q == C2SX(',') || *q == C2SX(']'))
			*q = NULC;
		ret = true;
		switch (*p) {
			case C2SX('.'): /* '.[ ]=[ ]["']...["']' to search for text */
				if (!split_left_right(p, C2SX('='), &l0, &l1, &is, &r0, &r1, true, true))
					return false;
				c = p[r1+1];
				p[r1+1] = NULC;
				ret = XMLSearch_search_set_text(search, &p[r0]);
				p[r1+1] = c;
				p += r1+1;
				break;

			/* Attribute name, possibly '@attrib[[ ]=[ ]"value"]' */
			case C2SX('@'):
				if (!split_left_right(++p, '=', &l0, &l1, &is, &r0, &r1, true, true))
					return false;
				c = p[l1+1];
				c1 = p[r1+1];
				p[l1+1] = NULC;
				p[r1+1] = NULC;
				ret = (XMLSearch_search_add_attribute(search, &p[l0], (is < 0 ? NULL : &p[r0]), true) < 0 ? false : true); /* 'is' < 0 when there is no '=' (i.e. check for attribute presence only */
				p[l1+1] = c;
				p[r1+1] = c1;
				p += r1-1; /* Jump to next value */
				break;

			default: /* Not implemented */
				break;
		}
		*q = cc; /* Restore ',' separator if any */
		if (!ret)
			return false;
	}

	return true;
}

int XMLSearch_init_from_XPath(const SXML_CHAR* xpath, XMLSearch* search)
{
	XMLSearch *search1, *search2;
	SXML_CHAR *p, *tag, *tag0;
	SXML_CHAR c;

	if (!XMLSearch_init(search))
		return false;

	/* NULL or empty xpath is an empty (initialized only) search */
	if (xpath == NULL || *xpath == NULC)
		return true;

	search1 = NULL;		/* Search struct to add the xpath portion to */
	search2 = search;	/* Search struct to be filled from xpath portion */

	tag = tag0 = sx_strdup(xpath); /* Create a copy of 'xpath' to be able to patch it (or segfault if 'xpath' is const, cnacu6o Sergey@sourceforge!) */
	while (*tag != NULC) {
		if (search2 != search) { /* Allocate a new search when the original one (i.e. 'search') has already been filled */
			search2 = (XMLSearch*)__calloc(1, sizeof(XMLSearch));
			if (search2 == NULL) {
				__free(tag0);
				(void)XMLSearch_free(search, true);
				return false;
			}
		}
		/* Skip all first '/' */
		for (; *tag != NULC && *tag == C2SX('/'); tag++) ;
		if (*tag == NULC) {
			__free(tag0);
			return false;
		}

		/* Look for the end of tag name: after '/' (to get another tag) or end of string */
		for (p = &tag[1]; *p != NULC && *p != C2SX('/'); p++) {
			if (*p == C2SX('\\') && *++p == NULC)
				break; /* Escape character, '\' could be the last character... */
		}
		c = *p; /* Backup character before nulling it */
		*p = NULC;
		if (!_init_search_from_1XPath(tag, search2)) {
			__free(tag0);
			(void)XMLSearch_free(search, true);
			return false;
		}
		*p = c;

		/* 'search2' is the newly parsed tag, 'search1' is the previous tag (or NULL if 'search2' is the first tag to parse (i.e. 'search2' == 'search') */

		if (search1 != NULL) search1->next = search2;
		if (search2 != search) search2->prev = search1;
		search1 = search2;
		search2 = NULL; /* Will force allocation during next loop */
		tag = p;
	}

	__free(tag0);
	return true;
}

static int _attribute_matches(XMLAttribute* to_test, XMLAttribute* pattern)
{
	if (to_test == NULL && pattern == NULL)
		return true;

	if (to_test == NULL || pattern == NULL)
		return false;
	
	/* No test on name => match */
	if (pattern->name == NULL || pattern->name[0] == NULC)
		return true;

	/* Test on name fails => no match */
	if (!regstrcmp_search(to_test->name, pattern->name))
		return false;

	/* No test on value => match */
	if (pattern->value == NULL)
		return true;

	/* Test on value according to pattern "equal" attribute */
	return regstrcmp_search(to_test->value, pattern->value) == pattern->active ? true : false;
}

int XMLSearch_node_matches(const XMLNode* node, const XMLSearch* search)
{
	int i, j;

	if (node == NULL)
		return false;

	if (search == NULL)
		return true;

	/* No comments, prolog, or such type of nodes are tested */
	if (node->tag_type != TAG_FATHER && node->tag_type != TAG_SELF)
		return false;

	/* Check tag */
	if (search->tag != NULL && !regstrcmp_search(node->tag, search->tag))
		return false;

	/* Check text */
	if (search->text != NULL && !regstrcmp_search(node->text, search->text))
		return false;

	/* Check attributes */
	if (search->attributes != NULL) {
		for (i = 0; i < search->n_attributes; i++) {
			for (j = 0; j < node->n_attributes; j++) {
				if (!node->attributes[j].active)
					continue;
				if (_attribute_matches(&node->attributes[j], &search->attributes[i]))
					break;
			}
			if (j >= node->n_attributes) /* All attributes where scanned without a successful match */
				return false;
		}
	}

	/* 'node' matches 'search'. If there is a father search, its father must match it */
	if (search->prev != NULL)
		return XMLSearch_node_matches(node->father, search->prev);

	/* TODO: Should a node match if search has no more 'prev' search and node father is still below the initial search ?
	 Depends if XPath started with "//" (=> yes) or "/" (=> no).
	 if (search->prev == NULL && node->father != search->from) return false; ? */
		
	return true;
}

XMLNode* XMLSearch_next(const XMLNode* from, XMLSearch* search)
{
	XMLNode* node;

	if (search == NULL || from == NULL)
		return NULL;

	/* Go down the last child search as fathers will be tested recursively by the 'XMLSearch_node_matches' function */
	for (; search->next != NULL; search = search->next) ;

	/* Initialize the 'stop_at' node on first search, to remember where to stop as there will be multiple calls */
	/* 'stop_at' can be NULL when 'from' is a root node, that is why it should be initialized with something else than NULL */
	if (search->stop_at == INVALID_XMLNODE_POINTER)
		search->stop_at = XMLNode_next_sibling(from);

	for (node = XMLNode_next(from); node != search->stop_at; node = XMLNode_next(node)) { /* && node != NULL */
		if (!XMLSearch_node_matches(node, search))
			continue;

		/* 'node' is a matching node */

		/* No search to perform on 'node' children => 'node' is returned */
		if (search->next == NULL)
			return node;

		/* Run the search on 'node' children */
		return XMLSearch_next(node, search->next);
	}

	return NULL;
}

static SXML_CHAR* _get_XPath(const XMLNode* node, SXML_CHAR** xpath)
{
	int i, n, brackets, sz_xpath;
	SXML_CHAR* p;

	brackets = 0;
	sz_xpath = sx_strlen(node->tag);
	if (node->text != NULL) {
		sz_xpath += strlen_html(node->text) + 4; /* 4 = '.=""' */
		brackets = 2; /* Text has to be displayed => add '[]' */
	}
	for (i = 0; i < node->n_attributes; i++) {
		if (!node->attributes[i].active)
			continue;
		brackets = 2; /* At least one attribute has to be displayed => add '[]' */
		sz_xpath += strlen_html(node->attributes[i].name) + strlen_html(node->attributes[i].value) + 6; /* 6 = ', @=""' */
	}
	sz_xpath += brackets + 1;
	*xpath = (SXML_CHAR*)__malloc(sz_xpath*sizeof(SXML_CHAR));

	if (*xpath == NULL)
		return NULL;

	sx_strcpy(*xpath, node->tag);
	if (node->text != NULL) {
		sx_strcat(*xpath, C2SX("[.=\""));
		(void)str2html(node->text, &(*xpath[sx_strlen(*xpath)]));
		sx_strcat(*xpath, C2SX("\""));
		n = 1; /* Indicates '[' has been put */
	} else
		n = 0;

	for (i = 0; i < node->n_attributes; i++) {
		if (!node->attributes[i].active)
			continue;

		if (n == 0) {
			sx_strcat(*xpath, C2SX("["));
			n = 1;
		} else
			sx_strcat(*xpath, C2SX(", "));
		p = &(*xpath)[sx_strlen(*xpath)];

		/* Standard and Unicode versions of 'sprintf' do not have the same signature! :( */
		sx_sprintf(p,
#ifdef SXMLC_UNICODE
			sz_xpath,
#endif
			C2SX("@%s=%c"), node->attributes[i].name, XML_DEFAULT_QUOTE);

		(void)str2html(node->attributes[i].value, p);
		sx_strcat(*xpath, C2SX("\""));
	}
	if (n > 0)
		sx_strcat(*xpath, C2SX("]"));

	return *xpath;
}

SXML_CHAR* XMLNode_get_XPath(XMLNode* node, SXML_CHAR** xpath, int incl_parents)
{
	SXML_CHAR* xp = NULL;
	SXML_CHAR* xparent;
	XMLNode* parent;

	if (node == NULL || node->init_value != XML_INIT_DONE || xpath == NULL)
		return NULL;

	if (!incl_parents) {
		if (_get_XPath(node, &xp) == NULL) {
			*xpath = NULL;
			return NULL;
		}
		return *xpath = xp;
	}

	/* Go up to root node */
	parent = node;
	do {
		xparent = NULL;
		if (_get_XPath(parent, &xparent) == NULL) goto xp_err;
		if (xp != NULL) {
			if (strcat_alloc(&xparent, C2SX("/")) == NULL) goto xp_err;
			if (strcat_alloc(&xparent, xp) == NULL) goto xp_err;
		}
		xp = xparent;
		parent = parent->father;
	} while (parent != NULL);
	if ((*xpath = sx_strdup(C2SX("/"))) == NULL || strcat_alloc(xpath, xp) == NULL) goto xp_err;

	return *xpath;

xp_err:
	if (xp != NULL) __free(xp);
	*xpath = NULL;

	return NULL;
}
