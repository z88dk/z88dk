/**
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
#ifndef _SXMLCSEARCH_H_
#define _SXMLCSEARCH_H_

#ifdef __cplusplus
extern "C" {
#endif

#include "sxmlc.h"

/**
 * \brief XML search parameters. Can be initialized from an XPath string.
 */
typedef struct _XMLSearch {

	SXML_CHAR* tag; /**< Search for nodes which tag match this `tag` field. */
					/**< If NULL or an empty string, all nodes will be matching. */

	XMLAttribute* attributes;	/**< Search for nodes which attributes match all the ones described. */
								/**< If NULL, all nodes will be matching. */
								/**<  The `attribute->name` should not be NULL. If corresponding `attribute->value` */
								/**< is NULL or an empty-string, search will return the first node with an attribute */
								/**< `attribute->name`, no matter what its value is. */
								/**< If `attribute->value` is not NULL, a matching node should have an attribute */
								/**< `attribute->name` with the corresponding value `attribute->value`. */
								/**< When `attribute->value` is not NULL, the `attribute->active` should be `true` */
								/**< to specify that values should be equal, or `false` to specify that values should */
								/**< be different. */
	int n_attributes;	/**< The size of `attributes`array. */

	SXML_CHAR* text;	/**< Search for nodes which text match this `text` field. */
						/**< If NULL or an empty string, all nodes will be matching (i.e. not used). */

	struct _XMLSearch* next;	/**< Next search to perform on children of a node matching current struct. */
								/**< Used to search for nodes children of specific nodes (used in XPath queries). */
	struct _XMLSearch* prev;

	XMLNode* stop_at;	/**< Internal use only. Must be initialized to 'INVALID_XMLNODE_POINTER' prior to first search. */

	/* Keep 'init_value' as the last member */
	int init_value;	/**< Initialized to 'XML_INIT_DONE' to indicate that document has been initialized properly */
} XMLSearch;

/**
 * \brief The prototype used by the regular expression handler.
 * The default regex function can be overriden by user code through `XMLSearch_set_regexpr_compare()`.
 * \param str The string to match on `pattern`.
 * \param pattern The pattern to match `str` to.
 * \return `true` if `str` matches `pattern`.
 */
typedef int (*REGEXPR_COMPARE)(SXML_CHAR* str, SXML_CHAR* pattern);

/**
 * \brief Set a new comparison function to evaluate whether a string matches a given pattern.
 *
 * The default one is `regstrcmp()` which handles limited regular expressions (<code>'?'</code>
 * and <code>'*'</code> wildcards).
 *
 * \return The previous function used for matching.
 */
REGEXPR_COMPARE XMLSearch_set_regexpr_compare(REGEXPR_COMPARE fct);

/**
 * \brief Initialize an empty search. No memory freeing is performed.
 * \param search The search parameters.
 * \return `false` when `search` is NULL.
 */
int XMLSearch_init(XMLSearch* search);

/**
 * \brief Free all search members except for the `search->next` member that should be freed
 * by its creator, unless `free_next` is `true`.
 *
 * It is recommended that `free_next` is positioned to `true` only when the creator did not
 * handle the whole memory allocation chain, e.g. when using `XMLSearch_init_from_XPath()`
 * that allocates all search structs.
 *
 * \param search The search parameters.
 * \param free_next `false` in order *not* to free the `search->next` structures.
 *
 * \return `false` when `search` is NULL.
 */
int XMLSearch_free(XMLSearch* search, int free_next);

/**
 * \brief Set the search based on tag.
 * \param search The search parameters.
 * \param tag should be NULL or empty to search for any node (e.g. search based on attributes
 * only). In this case, the previous tag is freed.
 * \return `true` upon successful completion, `false` for memory error.
 */
int XMLSearch_search_set_tag(XMLSearch* search, const SXML_CHAR* tag);

/**
 * \brief Add an attribute search criteria.
 * \param search The search parameters.
 * \param attr_name is the attribute name to search. Mandatory.
 * \param attr_value should be NULL to test for attribute presence only
 * 		(no test on value). An empty string means the attribute should exist
 * 		with an empty value.
 * \param value_equal should be specified to test for attribute value equality (`true`) or
 *		difference (`false`).
 * \return the index of the new attribute, or -1 for memory error.
 */
int XMLSearch_search_add_attribute(XMLSearch* search, const SXML_CHAR* attr_name, const SXML_CHAR* attr_value, int value_equal);

/**
 * \brief Retrieve attribute search parameters on attribute `attr_name`.
 * \param search The search parameters.
 * \param attr_name The attribute name to look for.
 * \return The attribute search index or -1 if not found.
 */
int XMLSearch_search_get_attribute_index(const XMLSearch* search, const SXML_CHAR* attr_name);

/**
 * \brief Remove the attribute search parameters by index.
 * \param search The search parameters.
 * \param i_attr The search attribute index.
 * \return the number of search attributes parameters left.
 */
int XMLSearch_search_remove_attribute(XMLSearch* search, int i_attr);

/**
 * \brief Set the search based on text content.
 * \param search The search parameters.
 * \param text should be NULL or empty to search for any node (e.g. search based on attributes
 * 		only). In this case, the previous text is freed.
 *
 * \return `true` upon successful completion, `false` for memory error.
 */
int XMLSearch_search_set_text(XMLSearch* search, const SXML_CHAR* text);

/**
 * \brief Set an additional search on children nodes of a previously matching node.
 *
 * Search struct are chained to finally return the node matching the last search struct,
 * which father node matches the previous search struct, and so on.
 * This allows describing more complex search queries like XPath
 * `"//FatherTag[@attrib=val]/ChildTag/"`.
 *
 * In this case, a first search struct would have `search->tag = "FatherTag"` and
 * `search->attributes[0] = { "attrib", "val" }` and a second search struct with
 * `search->tag = "ChildTag"`.
 * If `children_search` is NULL, next search is removed. Freeing previous search is to be
 * performed by its owner.
 * In any case, if `search` next search is not NULL, it is freed.
 *
 * \param search The search parameters.
 * \param children_search The search parameters to be applied to children of nodes
 * 		matching `search`.
 *
 * \return `true` when association has been made, `false` when an error occurred.
 */
int XMLSearch_search_set_children_search(XMLSearch* search, XMLSearch* children_search);

/**
 * \brief Compute an XPath-equivalent string of the search criteria.
 *
 * \param search The search parameters. NULL will return an empty string.
 * \param xpath is a pointer to a string that will be allocated by the function and should
 *		be freed after use.
 * \param quote is the quote character to be used (e.g. `"` or `'`). If <code>'\0'</code>,
 * 		`XML_DEFAULT_QUOTE` will be used.
 *
 * \return `false` for a memory problem, `true` otherwise.
 */
SXML_CHAR* XMLSearch_get_XPath_string(const XMLSearch* search, SXML_CHAR** xpath, SXML_CHAR quote);

/**
 * \brief Initialize a search struct from an XPath-like query. "XPath-like" means that
 * it does not fully comply to XPath standard.
 *
 * \param xpath should be like <code>"tag[.=text, @attrib="value", @attrib!='value', ...]/tag..."</code>.
 * 		*Warning*: the XPath query on node text like `father[child="text"]` should be
 * 		re-written `father/child[.="text"]` instead (which should be XPath-compliant as well).
 * \param search The search parameters.
 *
 *
 * \return `true` when `search` was correctly initialized, `false` in case of memory
 * 		problem or malformed `xpath`.
 */
int XMLSearch_init_from_XPath(const SXML_CHAR* xpath, XMLSearch* search);

/**
 * \brief Check whether a node matches a search criteria.
 *
 * If `search->prev` is not NULL (i.e. has a father search), `node->father` is also
 * tested, recursively (i.e. grand-father and so on).
 *
 * \param node The node to test. `tag_type` should be `TAG_FATHER` or `TAG_SELF` only.
 * \param search The search parameters.
 *
 * \return `false` when `node` does not match or for invalid arguments, `true`
 * 		if `node` is a match.
 */
int XMLSearch_node_matches(const XMLNode* node, const XMLSearch* search);

/**
 * \brief Search next matching node, according to search parameters.
 *
 * Search starts from node `from` by scanning all its children, and going up to siblings,
 * uncles and so on.
 *
 * Searching for the next matching node is performed by running the search again on the last
 * matching node. So `search` has to be initialized by `XMLSearch_init()` prior to the first
 * call, to memorize the initial `from` node and know where to stop search.
 * `from` ITSELF IS NOT CHECKED! Direct call to `XMLSearch_node_matches(from, search)` should
 * be made if necessary.
 *
 * If the document has several root nodes, a complete search in the document should be performed
 * by manually calling `XMLSearch_next()` on each root node in a for loop.
 * Note that `search` should be the initial search struct (i.e. `search->prev` should be NULL). This
 * cannot be checked corrected by the function itself as it is partly recursive.
 *
 * \param from The node to start searching from.
 * \param search The search parameters.
 *
 * \return the next matching node according to `search` criteria, or NULL when no more nodes match
 * 		or when an error occurred.
 */
XMLNode* XMLSearch_next(const XMLNode* from, XMLSearch* search);

/**
 * \brief Get node XPath-like equivalent: `tag[.="text", @attribute="value", ...]`, potentially
 * including father nodes XPathes.
 *
 * The computed XPath is stored in a dynamically-allocated string.
 *
 * \return the XPath, or NULL if `node` is invalid or on memory error.
 */
SXML_CHAR* XMLNode_get_XPath(XMLNode* node, SXML_CHAR** xpath, int incl_parents);

/**
 * Checks whether a string corresponds to a pattern.
 * \param str The string to check.
 * \param pattern can use wildcads such as `*` (any potentially empty string) or
 * 		`?` (any character) and use `\` as an escape character.
 * \returns `true` when `str` matches `pattern`, `false` otherwise.
 */
int regstrcmp(SXML_CHAR* str, SXML_CHAR* pattern);

#ifdef __cplusplus
}
#endif

#endif
