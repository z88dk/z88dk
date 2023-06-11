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
#ifndef _SXML_H_
#define _SXML_H_

/**
 * \brief Current SXMLC version, as a `const char[]`.
 */
#define SXMLC_VERSION "4.5.0"

#ifdef __cplusplus
extern "C" {
#endif

#include <stdio.h>

/**
 * \brief Define this to compile unicode support.
 */
#ifdef SXMLC_UNICODE
	typedef wchar_t SXML_CHAR;
	#define C2SX(c) L ## c
	#define CEOF WEOF
	#define sx_strcmp wcscmp
	#define sx_strncmp wcsncmp
	#define sx_strlen wcslen
	#define sx_strdup wcsdup
	#define sx_strchr wcschr
	#define sx_strrchr wcsrchr
	#define sx_strcpy wcscpy
	#define sx_strncpy wcsncpy
	#define sx_strcat wcscat
	#define sx_printf wprintf
	#define sx_fprintf fwprintf
	#define sx_sprintf swprintf
	#define sx_fgetc fgetwc
	#define sx_fputc fputwc
	#define sx_puts putws
	#define sx_fputs fputws
    #define sx_isspace iswspace
	#if defined(WIN32) || defined(WIN64)
		#define sx_fopen _wfopen
	#else
		#define sx_fopen fopen
	#endif
    #define sx_fclose fclose
	#define sx_feof feof
#else
	typedef char SXML_CHAR;
	#define C2SX(c) c
	#define CEOF EOF
	#define sx_strcmp strcmp
	#define sx_strncmp strncmp
	#define sx_strlen strlen
	#define sx_strdup __sx_strdup
	#define sx_strchr strchr
	#define sx_strrchr strrchr
	#define sx_strcpy strcpy
	#define sx_strncpy strncpy
	#define sx_strcat strcat
	#define sx_printf printf
	#define sx_fprintf fprintf
	#define sx_sprintf sprintf
	#define sx_fgetc fgetc
	#define sx_fputc fputc
	#define sx_puts puts
	#define sx_fputs fputs
	#define sx_isspace(c) ((int)c >= 0 && (int)c <= 127 && isspace((int)c))
	#if defined(WIN32) || defined(WIN64) // On Windows, if the filename has unicode characters in it, assume them to be UTF8 and convert it to wide char before calling _wfopen()
		FILE* sx_fopen(const SXML_CHAR* filename, const SXML_CHAR* mode);
	#else // On Linux, simply call fopen()
		#define sx_fopen fopen
	#endif
	#define sx_fclose fclose
	#define sx_feof feof
#endif

#ifdef DBG_MEM
	void* __malloc(size_t sz);
	void* __calloc(size_t count, size_t sz);
	void* __realloc(void* mem, size_t sz);
	void __free(void* mem);
	char* __sx_strdup(const char* s);
#else
	#define __malloc malloc
	#define __calloc calloc
	#define __realloc realloc
	#define __free free
	#define __sx_strdup strdup
#endif

/**
 * \brief The number of bytes to add to currently allocated buffer for line reading. Default to 256 characters (=512
 * 		bytes with unicode support).
 */
#ifndef MEM_INCR_RLA
#define MEM_INCR_RLA (256*sizeof(SXML_CHAR)) /* Initial buffer size and increment for memory reallocations */
#endif

#ifndef false
#define false 0
#endif

#ifndef true
#define true 1
#endif

#define NULC ((SXML_CHAR)C2SX('\0'))
#define isquote(c) (((c) == C2SX('"')) || ((c) == C2SX('\'')))

/**
 * \brief Buffer data source used by 'read_line_alloc' when required. 'buf' should be 0-terminated.
 */
typedef struct _DataSourceBuffer {
	const SXML_CHAR* buf;
	int buf_len;
	int cur_pos;
} DataSourceBuffer;

typedef FILE* DataSourceFile;

/**
 * \brief Describes the type of data source used for parsing.
 */
typedef enum _DataSourceType {
	DATA_SOURCE_FILE = 0,
	DATA_SOURCE_BUFFER,
	DATA_SOURCE_MAX
} DataSourceType;

/**
 * \brief Node types for `XMLNode`.
 *
 * Types marked *[N/A]* are *not* valid types for an `XMLNode` but are used
 * internally by the parser.
 */
typedef enum _TagType {
	TAG_ERROR = -1,
	TAG_NONE = 0,
	TAG_PARTIAL,	/**< Node containing a legal `>` that stopped file reading. *[N/A]* */
	TAG_FATHER,		/**< `<tag>` - Next nodes will be children of this one. */
	TAG_SELF,		/**< `<tag/>` - Standalone node. */
	TAG_INSTR,		/**< `<?prolog?>` - Processing instructions, or prolog node. */
	TAG_COMMENT,	/**< `<!--comment-->` */
	TAG_CDATA,		/**< `<![CDATA[ ]]>` - CDATA node */
	TAG_DOCTYPE,	/**< `<!DOCTYPE [ ]>` - DOCTYPE node */
	TAG_END,		/**< `</tag>` - End of father node. *[N/A]* */
	TAG_TEXT,		/**< Special node used as a text container. */
					/**< and `node->tag` is `NULL`. */

	TAG_USER = 100	/*!<  User-defined tag start */
} TagType;

/* TODO: Performance improvement with some fixed-sized strings ??? (e.g. XMLAttribute.name[64], XMLNode.tag[64]).
 * Also better for platforms where allocations can be forbidden (e.g. embedded, space, ...). */

/**
 * \brief An XML attribute in the form `name="value"`.
 *
 * An attribute can be *deactivated*, in which case it will not be taken into account in functions
 * `XMLNode_print*()`, `XMLNode_get_attribute_count()`.
 */
typedef struct _XMLAttribute {
	SXML_CHAR* name;	/**< The attribute name. */
	SXML_CHAR* value;	/**< The attribute value. */
	int active;			/**< `true` if the attribute is active. */
} XMLAttribute;

/* Constant to know whether a struct has been initialized (XMLNode or XMLDoc)
 * TODO: Find a better way. */
#define XML_INIT_DONE 0x19770522 /* Happy Birthday ;) */

/**
 * \brief An XML node.
 *
 * For tag types `TAG_INSTR`, `TAG_COMMENT`, `TAG_CDATA` and `TAG_DOCTYPE`, the text is
 * stored in `node->tag`, with `node->text` being `NULL`.
 *
 * A node can be *deactivated*, in which case it will not be taken into account in functions
 * `XMLNode_print*()`, `XMLNode_get_children_count()`, `XMLNode_get_child()`, `XMLNode_insert_child()`, ...
 *
 * If `text_as_nodes` is zeroed during parsing, the `node->text` is the concatenation of
 * all texts found under the node: `<a>text<b/>other text</a>` will show `node->tag == "a"`
 * and `node->text == "textother text"`.
 * If `text_as_nodes` is non-zeroed, the same node will have 3 children: child [0] type is
 * `TAG_TEXT` (with text `"text"`), child [1] type is `TAG_SELF` and child [2] type is
 * `TAG_TEXT` (with text `"other text"`).
 *
 * *N.B. that when reading a pretty-printed XML, the extra line breaks and spaces will be stored
 * in `node->text`*.
 */
typedef struct _XMLNode {
	SXML_CHAR* tag;				/**< Tag name, or text for tag types `TAG_INSTR`, `TAG_COMMENT`, `TAG_CDATA` and `TAG_DOCTYPE`. */
	SXML_CHAR* text;			/**< Text inside the node, or `NULL` if empty. */
	XMLAttribute* attributes;	/**< Array of attributes. */
	int n_attributes;			/**< Number of attributes *in `attributes` array* (might not be the number of *active* attributes). */
	
	struct _XMLNode* father;	/**< Pointer to father node. `NULL` if root. */
	struct _XMLNode** children; /**< Array of children nodes. */
	int n_children;				/**< Number of nodes *in `children` array* (might not be the number of *active* children). */
	
	TagType tag_type;			/**< Node type. */
	int active;					/**< 'true' to tell that node is active and should be displayed by 'XMLDoc_print_*()'. */

	void* user;	/**< Pointer for user data associated to the node. */

	/* Keep 'init_value' as the last member */
	int init_value;	/**< Initialized to 'XML_INIT_DONE' to indicate that node has been initialized properly. */
} XMLNode;

#ifndef SXMLC_MAX_PATH
#ifdef _MAX_PATH
#define SXMLC_MAX_PATH _MAX_PATH
#else
#define SXMLC_MAX_PATH 256
#endif
#endif

/**
 * \brief Describe the types of BOM detected while reading an XML buffer.
 */
typedef enum _BOM_TYPE {
	BOM_NONE = 0x00,
	BOM_UTF_8 = 0xefbbbf,
	BOM_UTF_16BE = 0xfeff,
	BOM_UTF_16LE = 0xfffe,
	BOM_UTF_32BE = 0x0000feff,
	BOM_UTF_32LE = 0xfffe0000
} BOM_TYPE;
    
/**
 * \brief An XML document, basically an array of `XMLNode`.
 *
 * An sxmlc XML document can have several root nodes. It actually usually have a prolog `<?xml version="1.0" ...?>`
 * as the first node, then maybe a few comment nodes, then the first root node, which is the last node in
 * correctly-formed XML, but there can also be some other nodes after it.
 */
typedef struct _XMLDoc {
	SXML_CHAR filename[SXMLC_MAX_PATH];
	BOM_TYPE bom_type;		/**< BOM type (UTF-8, UTF-16*). */
	unsigned char bom[5];	/**< First characters read that might be a BOM when unicode is used. */
	int sz_bom;				/**< Number of bytes in BOM. */
	XMLNode** nodes;		/* Nodes of the document, including prolog, comments and root nodes */
	int n_nodes;			/* Number of nodes in 'nodes' */
	int i_root;				/* Index of first root node in 'nodes', -1 if document is empty */

	/* Keep 'init_value' as the last member */
	int init_value;	/* Initialized to 'XML_INIT_DONE' to indicate that document has been initialized properly */
} XMLDoc;

/**
 * \brief Register an XML tag, giving its 'start' and 'end' string, which should include '<' and '>'.
 *
 * \param tag_type is user-given and has to be less than or equal to `TAG_USER`. It will be
 * 		returned as the `tag_type` member of the `XMLNode` struct.
 * 		*Note that no test is performed to check for an already-existing `tag_type`*.
 * \param start The start string used to detect such tag (e.g. `"<![CDATA["`). Should start with `<`.
 * \param end The tag end string (e.g. `"]]>"`). Should end with `>`.
 * \return tag index in user tags table when successful, or -1 if the `tag_type` is invalid or
 * 		the new tag could not be registered (e.g. when `start` does not start with `<` or
 * 		`end` does not end with `>`).
 */
int XML_register_user_tag(TagType tag_type, SXML_CHAR* start, SXML_CHAR* end);

/**
 * \brief Remove a registered user tag.
 * \param i_tag The user-tag number, as returned by `XML_register_user_tag()`.
 * \return the new number of registered user tags or -1 if `i_tag` is invalid.
 */
int XML_unregister_user_tag(int i_tag);

/**
 * \brief Get the number of user-defined tags
 * \return the number of registered tags.
 */
int XML_get_nb_registered_user_tags(void);

/**
 * \brief Search for a user tag based on it type.
 * \param tag_type The tag type, as given in `XML_register_user_tag()`.
 * \return the index of first occurrence of 'tag_type' in registered user tags, or '-1' if not found.
 */
int XML_get_registered_user_tag(TagType tag_type);

/**
 * \brief The different reasons why parsing would fail.
 */
typedef enum _ParseError {
	PARSE_ERR_NONE = 0,					/**< Success. */
	PARSE_ERR_MEMORY = -1,				/**< Not enough memory for an `?alloc()` call. */
	PARSE_ERR_UNEXPECTED_TAG_END = -2,	/**< When a tag end does not match the tag start (e.g. `<a></b>`). */
	PARSE_ERR_SYNTAX = -3,				/**< General syntax error. */
	PARSE_ERR_EOF = -4,					/**< Unexpected EOF. */
	PARSE_ERR_TEXT_OUTSIDE_NODE = -5,	/**< During DOM loading. */
	PARSE_ERR_UNEXPECTED_NODE_END = -6	/**< During DOM loading. */
} ParseError;

/**
 * \brief Events that can happen when loading an XML document.
 *
 * These will be passed to the `all_event` callback of the SAX parser.
 */
typedef enum _XMLEvent {
	XML_EVENT_START_DOC,	/**< Document parsing started. */
	XML_EVENT_START_NODE,	/**< New node detected (all attributes are read). */
	XML_EVENT_END_NODE,		/**< Last node ended. */
	XML_EVENT_TEXT,			/**< Text detected in current node. */
	XML_EVENT_ERROR,		/**< Parsing error. */
	XML_EVENT_END_DOC		/**< Document parsing finished. */
} XMLEvent;

/**
 * \brief Structure given as an argument for SAX callbacks to retrieve information about parsing status.
 */
typedef struct _SAX_Data {
	const SXML_CHAR* name;	/**< Document name (file name or buffer name). */
	int line_num;			/**< Current line number being processed. */
	void* user;				/**< User-given data. */
	DataSourceType type;	/**< Data source type [DATA_SOURCE_FILE|DATA_SOURCE_BUFFER]. */
	void* src;				/**< Data source [DataSourceFile|DataSourceBuffer]. Depends on type. */
} SAX_Data;

/**
 * \brief User callbacks used for SAX parsing.
 *
 * Return values of these callbacks should be 0 to stop parsing. Some callbacks can be set to `NULL`
 * to disable handling of some events (e.g. everything `NULL` except `all_event()`).
 *
 * All parameters are pointers to structures that will no longer be available after callback returns so
 * it is recommended that the callback uses the information and stores it in its own data structure.
 *
 * *WARNING! SAX PARSING DOES NOT CHECK FOR XML INTEGRITY!* e.g. a tag end without a matching tag start
 * will not be detected by the parser and should be detected by the callbacks instead.
 */
typedef struct _SAX_Callbacks {
	/**
	 * \fn start_doc
	 * \brief Callback called when parsing starts, *before* parsing the first node.
	 */
	int (*start_doc)(SAX_Data* sd);

	/**
	 * \fn start_node
	 * \brief Callback called when a new node starts (e.g. `<tag>` or `<tag/>`).
	 *
	 * Attributes are read and available from `node->attributes`.
	 * N.B. "self-contained" ndoes (e.g. `<tag/>`) will trigger an immediate call to the `end_node()` callback
	 * after the `start_node()` callback.
	 */
	int (*start_node)(const XMLNode* node, SAX_Data* sd);

	/**
	 * \fn end_node
	 * \brief Callback called when a node ends (e.g. `</tag>` or `<tag/>`).
	 */
	int (*end_node)(const XMLNode* node, SAX_Data* sd);

	/**
	 * \fn new_text
	 * \brief Callback called when text has been found in the last node (e.g. `<tag>text<...`).
	 */
	int (*new_text)(SXML_CHAR* text, SAX_Data* sd);

	/**
	 * \fn end_doc
	 * \brief Callback called when parsing is finished.
	 * No other callbacks will be called after it.
	 */
	int (*end_doc)(SAX_Data* sd);

	/**
	 * \fn on_error
	 * \brief Callback called when an error occurs during parsing.
	 * \param error_num is the error number
	 * \param line_number is the line number in the stream being read (file or buffer).
	 */
	int (*on_error)(ParseError error_num, int line_number, SAX_Data* sd);

	/**
	 * \fn all_event
	 * \brief Callback called when text has been found in the last node.
	 *
	 * \param event is the type of event for which the callback was called:
	 	 - `XML_EVENT_START_DOC`:
	 	 	 - `node` is NULL.
	 	 	 - 'text` is the file name if a file is being parsed, `NULL` if a buffer is being parsed.
	 	 	 - `n` is 0.
	 	 - `XML_EVENT_START_NODE`:
	 	 	 - `node` is the node starting, with tag and all attributes initialized.
	 	 	 - `text` is NULL.
	 	 	 - `n` is the number of lines parsed.
	 	 - `XML_EVENT_END_NODE`:
	 	 	 - `node` is the node ending, with tag, attributes and text initialized.
	 	 	 - `text` is NULL.
	 	 	 - `n` is the number of lines parsed.
	 	 - `XML_EVENT_TEXT`:
	 	 	 - `node` is NULL.
	 	 	 - `text` is the text to be added to last node started and not finished.
	 	 	 - `n` is the number of lines parsed.
	 	 - `XML_EVENT_ERROR`:
	 	 	 - Everything is NULL.
	 	 	 - `n` is one of the `PARSE_ERR_*`.
	 	 - `XML_EVENT_END_DOC`:
	 	 	 - `node` is `NULL`.
	 	 	 - `text` is the file name if a file is being parsed, NULL if a buffer is being parsed.
	 	 	 - `n` is the number of lines parsed.
	 */
	int (*all_event)(XMLEvent event, const XMLNode* node, SXML_CHAR* text, const int n, SAX_Data* sd);
} SAX_Callbacks;

/**
 * \brief Helper function to initialize all `sax` members to `NULL`.
 * \param sax The callbacks structure to initialize.
 * \return `false` is `sax` is NULL.
 */
int SAX_Callbacks_init(SAX_Callbacks* sax);

/**
 * \brief Set of SAX callbacks used by `XMLDoc_parse_file_DOM()`.
 *
 * These are made available to be able to load an XML document using DOM implementation
 * with user-defined code at some point (e.g. counting nodes, running search, ...).
 *
 * In this case, the `XMLDoc_parse_file_SAX()` has to be called instead of the `XMLDoc_parse_file_DOM()`,
 * providing either these callbacks directly, or a functions calling these callbacks.<br>
 * To do that, you should initialize the `doc` member of the `DOM_through_SAX` struct and call the
 * `XMLDoc_parse_file_SAX()` giving this struct as a the `user` data pointer.
 */
typedef struct _DOM_through_SAX {
	XMLDoc* doc;		/**< Document to fill up. */
	XMLNode* current;	/**< For internal use (current father node). */
	ParseError error;	/**< For internal use (parse status). */
	int line_error;		/**< For internal use (line number when error occurred). */
	int text_as_nodes;	/**< For internal use (store text inside nodes as sequential TAG_TEXT nodes). */
} DOM_through_SAX;

int DOMXMLDoc_doc_start(SAX_Data* dom);
int DOMXMLDoc_node_start(const XMLNode* node, SAX_Data* dom);
int DOMXMLDoc_node_text(SXML_CHAR* text, SAX_Data* dom);
int DOMXMLDoc_node_end(const XMLNode* node, SAX_Data* dom);
int DOMXMLDoc_parse_error(ParseError error_num, int line_number, SAX_Data* sd);
int DOMXMLDoc_doc_end(SAX_Data* dom);

/**
 * \brief Initialize `sax` with the "official" DOM callbacks.
 */
int SAX_Callbacks_init_DOM(SAX_Callbacks* sax);

/* --- XMLNode methods --- */

/**
 * \brief Parse an attribute to an `XMLAttribute` struct.
 * \param str contains the string to parse, supposed like `attrName[ ]=[ ]["]attr Value["]`.
 * \param to is the position in `str` to stop at, or `-1` to parse until the end of `str`.
 * \param xmlattr filled with `xmlattr->name` to `attrName` and `xmlattr->value` to `attr Value`.
 * \return 0 if not enough memory or bad parameters (`str` or `xmlattr` is `NULL`),
		2 if last quote is missing in the attribute value,  1 if `xmlattr` was filled correctly.
 */
int XML_parse_attribute_to(const SXML_CHAR* str, int to, XMLAttribute* xmlattr);

/**
 * \fn XML_parse_attribute
 * \brief Short for `XML_parse_attribute_to()` with `to=-1`.
 */
#define XML_parse_attribute(str, xmlattr) XML_parse_attribute_to(str, -1, xmlattr)

/**
 * \brief Reads a string that is supposed to be an xml tag like `<tag (attribName="attribValue")* [/]>` or `</tag>`.
 * \param str The string to parse.
 * \param xmlnode the `XMLNode` structure which tag name and attributes will be filled.
 * \returns 0 if an error occurred (malformed `str` or memory). `TAG_*` when string is recognized.
 */
TagType XML_parse_1string(const SXML_CHAR* str, XMLNode* xmlnode);

/**
 * \brief Allocate and initialize XML nodes.
 * \param n is the number of contiguous elements to allocate (to create and array).
 * \return `NULL` if not enough memory, or the pointer to the elements otherwise.
 */
XMLNode* XMLNode_allocN(int n);

/**
 * \fn XMLNode_alloc
 * \brief Shortcut to allocate one node only.
 */
#define XMLNode_alloc() XMLNode_allocN(1)

/**
 * \brief Allocate and initialize a new `XMLNode` of the given type, tag name and text.
 * \param tag_type The node tag type.
 * \param tag The node tag.
 * \param text The node text.
 * \return `NULL` if not enough memory, or the pointer to the node otherwise.
 */

XMLNode* XMLNode_new(const TagType tag_type, const SXML_CHAR* tag, const SXML_CHAR* text);

/**
 * \fn XMLNode_new_node_comment
 * \brief Utility to create a comment: `<!--tag-->`
 */
#define XMLNode_new_node_comment(comment) XMLNode_new(TAG_COMMENT, (comment), NULL)
/**
 * \fn XMLNode_new_comment
 */
#define XMLNode_new_comment XMLNode_new_node_comment

/**
 * \fn XMLNode_new_node_text
 * \brief Utility to create a simple node with text: `<tag>text</tag>`
 */
#define XMLNode_new_node_text(tag, text) XMLNode_new(TAG_TEXT, (tag), (text))
/**
 * \fn XMLNode_new_text
 */
#define XMLNode_new_text XMLNode_new_node_text

/**
 * \brief Initialize an already-allocated XMLNode.
 */
int XMLNode_init(XMLNode* node);

/**
 * \brief Tells whether a node is valid.
 */
#define XMLNode_is_valid(node) ((node) != NULL && (node)->init_value == XML_INIT_DONE)

/**
 * \brief Free a node and all its children.
 */
int XMLNode_free(XMLNode* node);

/**
 * \brief Copy a node to another one, optionally including its children.
 * \param dst The node receiving the copy. N.B. thtat the node is freed first!
 * \param src The node to duplicate. If `NULL`, `dst` is freed and initialized.
 * \param copy_children `true` to include `src` children (recursive copy).
 * \return `false` in case of memory error or if `dst` is `NULL` or `src` uninitialized.
 */
int XMLNode_copy(XMLNode* dst, const XMLNode* src, int copy_children);

/**
 * \brief Duplicate a node, potentially with its children.
 * \param node The node to duplicate.
 * \param copy_children `true` to include `src` children (recursive copy).
 * \return `NULL` if not enough memory, or a pointer to the new node otherwise.
 */
XMLNode* XMLNode_dup(const XMLNode* node, int copy_children);

/**
 * \brief Set the active/inactive state of `node`.
 *
 * Set `active` to `true` to activate `node` and all its children, and enable its use
 * in other functions (e.g. `XMLDoc_print()`, ...).
 */
int XMLNode_set_active(XMLNode* node, int active);

/**
 * \brief Set node tag.
 * \param node The node to set.
 * \param tag The tag to set in `node`. A *copy* of `tag` will be assigned to `node->tag`, using `strdup()`.
 * \return `false` for memory error, `true` otherwise.
 */
int XMLNode_set_tag(XMLNode* node, const SXML_CHAR* tag);

/**
 * \brief Set the node type to one of `TagType` or any user-registered tag.
 * \return 'false' when the node or the 'tag_type' is invalid.
 */
int XMLNode_set_type(XMLNode* node, const TagType tag_type);

/**
 * \brief Add an attribute to a node or update an existing one.
 * \param node The node to which add/update an attribute.
 * \param attr_name The attribute name. A *copy* will be assigned through `strdup()`.
 * \param attr_value The attribute value. A *copy* will be assigned through `strdup()`.
 * \return the new number of attributes, or -1 for memory problem.
 */
int XMLNode_set_attribute(XMLNode* node, const SXML_CHAR* attr_name, const SXML_CHAR* attr_value);

/**
 * \brief Retrieve an attribute value, based on its name, returning a default value if the attribute
 * 		does not exist.
 * \param node The node.
 * \param attr_name The attribute name to search.
 * \param attr_value A pointer receiving a *copy* of the attribute value (from `strdup()`).
 * \param default_attr_value If `attr_name` does not exist in `node`, a *copy* (from `strdup()`)
 * 		of this string will be stored in `attr_value`.
 * \return `false` when the `node` is invalid, `attr_name` is NULL or empty, or `attr_value` is NULL.
 */
int XMLNode_get_attribute_with_default(XMLNode* node, const SXML_CHAR* attr_name, const SXML_CHAR** attr_value, const SXML_CHAR* default_attr_value);

/**
 * \fn XMLNode_get_attribute
 * \brief Helper macro that retrieve an attribute value, or an empty string if the attribute does not exist.
 */
#define XMLNode_get_attribute(node, attr_name, attr_value) XMLNode_get_attribute_with_default(node, attr_name, attr_value, C2SX(""))

/**
 * \return the number of active attributes of 'node', or '-1' if 'node' is invalid.
 */
int XMLNode_get_attribute_count(const XMLNode* node);

/**
 * \brief Search for the active attribute `attr_name` in `node`, starting from index `isearch`
 * and returns its index, or -1 if not found or error.
 */
int XMLNode_search_attribute(const XMLNode* node, const SXML_CHAR* attr_name, int isearch);

/**
 * \brief Remove attribute index `i_attr`.
 * \return the new number of attributes or -1 on invalid arguments.
 */
int XMLNode_remove_attribute(XMLNode* node, int i_attr);

/**
 * \brief Remove all attributes from `node`.
 */
int XMLNode_remove_all_attributes(XMLNode* node);

/**
 * Set node text to a copy of `text` (from `strdup()`), or remove text if set to `NULL`.
 * \return `true` when successful, `false` on error.
 */
int XMLNode_set_text(XMLNode* node, const SXML_CHAR* text);

/**
 * \fn XMLNode_remove_text
 * \brief Helper macro to remove text from `node`.
 */
#define XMLNode_remove_text(node) XMLNode_set_text(node, NULL);

/**
 * \brief Add a child to a node.
 * \return `false` for memory problem, `true` otherwise.
 */
int XMLNode_add_child(XMLNode* node, XMLNode* child);

/**
 * \brief Insert a node at a given position.
 * \param node The node to which inserting the child node.
 * \param child The node to insert.
 * \param index The insert position: if `index <= 0`: will be the first child (0).
 * 		If `index >= child->father->n_children`: will be the last child.
 * \return 'false' if 'node' is not initialized, 'true' otherwise.
 */
int XMLNode_insert_child(XMLNode* node, XMLNode* child, int index);

/**
 * \fn XMLNode_insert_before
 * \brief Insert a node before the given node (i.e. at its index).
 */
#define XMLNode_insert_before(node, child) XMLNode_insert_child(node, child, XMLNode_get_index(node))
/**
 * \fn XMLNode_insert_after
 * \brief Insert a node after the given node.
 */
#define XMLNode_insert_after(node, child) XMLNode_insert_child(node, child, XMLNode_get_index(node)+1)

/**
 * \brief Move a child node among its siblings.
 * \param node The node which children should be moved.
 * \param from Position of the node to move.
 * \param to Position to move to. Moved to first position if `to <= 0` or last position
 * 		if `to >= node->n_children`.
 * \return `false` if `node` is not initialized or `from` is invalid. `true` otherwise.
 */
int XMLNode_move_child(XMLNode* node, int from, int to);

/**
 * \brief Get the number of *active* children of a node.
 * \param node The node.
 * \return the number of active children nodes of `node`, or -1 if `node` is invalid.
 * 		N.B. that it can be different from `node->n_children` if some nodes are deactivated!
 */
int XMLNode_get_children_count(const XMLNode* node);

/**
 * \brief Get the node position among its *active* siblings.
 * \param node The node.
 * \return `node` position among its siblings, -1 if `node` is invalid or -2 if `node` could
 * 		not be found in its father's children (in which case I'd appreciate a bug report with
 * 		the XML and steps that led to that situation!).
 */
int XMLNode_get_index(const XMLNode* node);

/**
 * \brief Get an *active* node.
 * \param node The node.
 * \param i_child The active node index to retrieve.
 * \return the `i_child`th *active* node.
 */
XMLNode* XMLNode_get_child(const XMLNode* node, int i_child);

/**
 * \brief Remove the `i_child`th *active* child of the node.
 * \param node The node.
 * \param i_child The active node index to retrieve.
 * \param free_child if `true`, free the child node itself (and its children, recursively).
 * 		This parameter is usually `true` but should be `false` when child nodes are pointers
 * 		to local or global variables instead of user-allocated memory.
 * \return the new number of children or -1 on invalid arguments.
 */
int XMLNode_remove_child(XMLNode* node, int i_child, int free_child);

/**
 * \brief Remove (and frees) all children from the node.
 * \param node The node.
 * \return `true`.
 */
int XMLNode_remove_children(XMLNode* node);

/**
 * \param node1 The first node to test.
 * \param node2 The second node to test.
 * \return `true` if `node1` is the same as `node2` (i.e. same tag, same active attributes)
 * 		but *not necessarily* the same children.
 */
int XMLNode_equal(const XMLNode* node1, const XMLNode* node2);

/**
 * \brief Get the next sibling node.
 * \param node The node which sibling to retrieve.
 * \return the next sibling of the node, or `NULL` if `node` is invalid or the last child
 * 		or if its father could not be determined (i.e. `node` is a root node).
 */
XMLNode* XMLNode_next_sibling(const XMLNode* node);

/**
 * \brief Get the "next" node: first child (if any) of next sibling otherwise.
 * \param node The node.
 * \return the next node in XML order, or `NULL` if `node` is invalid or the last node.
 */
XMLNode* XMLNode_next(const XMLNode* node);



/* --- XMLDoc methods --- */


/**
 * \brief Initializes an already-allocated XML document.
 * \param doc The document to initialize.
 * \return `false` if `doc` is NULL.
 */
int XMLDoc_init(XMLDoc* doc);

/**
 * \brief Free an XML document, including all of its nodes, recursively.
 * \param doc The document to initialize.
 * \return `false` if `doc` was not initialized.
 */
int XMLDoc_free(XMLDoc* doc);

/**
 * \brief Set the new document root node.
 * \param doc The document to initialize.
 * \param i_root The element index to set as root.
 * \return `false` if `doc` is not initialized or `i_root` is invalid, `true` otherwise.
 */
int XMLDoc_set_root(XMLDoc* doc, int i_root);

/**
 * \brief Add a node to the document.
 *
 * If the node type is `TAG_FATHER`, it also sets the document root node if previously undefined.
 * \param doc The document.
 * \param node The node to add.
 * \return the node index, or -1 for uninitialized `doc` or `node`, or memory error.
 */
int XMLDoc_add_node(XMLDoc* doc, XMLNode* node);

/**
 * \brief Remove a node from the document root nodes. Inactive nodes can be removed like this.
 * \param doc The XML document.
 * \param i_node The node index to remove
 * \param free_node if `true`, free the node itself. This parameter is usually `true`
 * 		but should be 'false' when the node is a pointer to local or global variable instead of
 * 		user-allocated memory.
 * \return `true` if node was removed or `false` if `doc` or `i_node` is invalid.
 */
int XMLDoc_remove_node(XMLDoc* doc, int i_node, int free_node);

#define XMLDoc_remove_root_node XMLDoc_remove_node

/**
 * \brief Shortcut macro to retrieve root node from a document. Equivalent to `doc->nodes[doc->i_root]`,
 *		or `NULL` if there is no root node.
 */
#define XMLDoc_root(doc) (((doc)->i_root) < 0 ? NULL : ((doc)->nodes[(doc)->i_root]))

/**
 * \brief Shortcut macro to add a node to 'doc' root node. Equivalent to `XMLDoc_add_child_root(XMLDoc* doc, XMLNode* child)`.
 */
#define XMLDoc_add_child_root(doc, child) XMLNode_add_child((doc)->nodes[(doc)->i_root], (child))

/**
 * \brief Default quote to use to print attribute value (defaults to a double. quote `"`).
 *
 * User can redefine it with its own character by adding a `-DXML_DEFAULT_QUOTE` compiler option.
 */
#ifndef XML_DEFAULT_QUOTE
#define XML_DEFAULT_QUOTE C2SX('"')
#endif

/**
 * \brief Print the node and its children to a file (that can be `stdout`).
 *
 * \param node The node to print.
 * \param f The file to print to (can be `stdout`).
 * \param tag_sep The string to use to separate nodes from each other (usually `"\n"`).
 * \param child_sep The additional string to put for each child level (usually `"\t"`).
 * \param attr_sep The additional string to put to separate attributes (usually `" "`).
 * \param keep_text_spaces indicates that text should not be printed if it is composed of
 * 		spaces, tabs or new lines only (e.g. when XML document spans on several lines due to
 * 		pretty-printing).
 * \param sz_line The maximum number of characters that can be put on a single line. The
 * 		node remainder will be output to extra lines.
 * \param nb_char_tab How many characters should be counted for a tab when counting characters
 * 		in the line. It usually is 8 or 4, but at least 1.
 * \return `false` on invalid arguments (`NULL` `node` or `f`), `true` otherwise.
 */
int XMLNode_print_attr_sep(const XMLNode* node, FILE* f, const SXML_CHAR* tag_sep, const SXML_CHAR* child_sep, const SXML_CHAR* attr_sep, int keep_text_spaces, int sz_line, int nb_char_tab);

/**
 * \brief For backward compatibility (`attr_sep` is a space).
 */
#define XMLNode_print(node, f, tag_sep, child_sep, keep_text_spaces, sz_line, nb_char_tab) XMLNode_print_attr_sep(node, f, tag_sep, child_sep, C2SX(" "), keep_text_spaces, sz_line, nb_char_tab)

/**
 * \brief Print the node "header": `<tagname attribname="attibval" ...[/]>`, spanning it on several lines if needed.
 * \return `false` on invalid arguments (`NULL` `node` or `f`), `true` otherwise.
 */
int XMLNode_print_header(const XMLNode* node, FILE* f, int sz_line, int nb_char_tab);

/**
 * \brief Prints the XML document using `XMLNode_print_attr_sep()` on all document nodes.
 */
int XMLDoc_print_attr_sep(const XMLDoc* doc, FILE* f, const SXML_CHAR* tag_sep, const SXML_CHAR* child_sep, const SXML_CHAR* attr_sep, int keep_text_spaces, int sz_line, int nb_char_tab);

/* For backward compatibility */
#define XMLDoc_print(doc, f, tag_sep, child_sep, keep_text_spaces, sz_line, nb_char_tab) XMLDoc_print_attr_sep(doc, f, tag_sep, child_sep, C2SX(" "), keep_text_spaces, sz_line, nb_char_tab)

/**
 * \brief Parse a file into an initialized XML document (DOM mode).
 * \param filename The file to parse.
 * \param doc The document to parse into.
 * \param text_as_nodes should be non-zero to put text into separate TAG_TEXT nodes.
 * \return `false` in case of error (memory or unavailable filename, malformed document), `true` otherwise.
 */
int XMLDoc_parse_file_DOM_text_as_nodes(const SXML_CHAR* filename, XMLDoc* doc, int text_as_nodes);

/**
 * \brief For backward compatibility (`text_as_nodes` is 0)
 */
#define XMLDoc_parse_file_DOM(filename, doc) XMLDoc_parse_file_DOM_text_as_nodes(filename, doc, 0)

/**
 * \brief Parse a memory buffer into an initialized document (DOM mode).
 * \param buffer The memory buffer to parse.
 * \param name The buffer name (to identify several buffers if run concurrently).
 * \param doc The document to parse into.
 * \param text_as_nodes should be non-zero to put text into separate TAG_TEXT nodes.
 * \return `false` in case of error (memory or unavailable filename, malformed document), `true` otherwise.
 */
int XMLDoc_parse_buffer_DOM_text_as_nodes(const SXML_CHAR* buffer, const SXML_CHAR* name, XMLDoc* doc, int text_as_nodes);

/**
 * \brief For backward compatibility (`text_as_nodes` is 0)
 */
#define XMLDoc_parse_buffer_DOM(buffer, name, doc) XMLDoc_parse_buffer_DOM_text_as_nodes(buffer, name, doc, 0)

/**
 * \brief Parse an XML file, calling SAX callbacks.
 * \param filename The file to parse.
 * \param sax The SAX callbacks that will be called by the parser on each XML event.
 * \param user A user-given pointer that will be given back to all callbacks.
 * \return `false` in case of error (memory or unavailable filename, malformed document) or when requested
 * 		by a SAX callback. `true` otherwise.
 */
int XMLDoc_parse_file_SAX(const SXML_CHAR* filename, const SAX_Callbacks* sax, void* user);

/**
 * \brief Parse an XML buffer, calling SAX callbacks.
 * \param buffer The memory buffer to parse.
 * \param buffer_len The buffer lenght, in *characters* (i.e. can be 2 bytes in unicode).
 * \param name An optional buffer name.
 * \param sax The SAX callbacks that will be called by the parser on each XML event.
 * \param user A user-given pointer that will be given back to all callbacks.
 * \return `false` in case of error (memory or unavailable filename, malformed document) or when requested
 * 		by a SAX callback. `true` otherwise.
 */
int XMLDoc_parse_buffer_SAX_len(const SXML_CHAR* buffer, int buffer_len, const SXML_CHAR* name, const SAX_Callbacks* sax, void* user);

/**
 * \brief For backward compatibility (buffer length is `strlen(buffer)`).
 */
#define XMLDoc_parse_buffer_SAX(buffer, name, sax, user) XMLDoc_parse_buffer_SAX_len(buffer, sx_strlen(buffer), name, sax, user)

/**
 * \brief Parse an XML file using the DOM implementation.
 */
#define XMLDoc_parse_file XMLDoc_parse_file_DOM



/* --- Utility functions --- */

/**
 * \brief Get next byte from data source.
 * \return as `fgetc()` would for `FILE*`.
 */
int _bgetc(DataSourceBuffer* ds);

/**
 * \brief know if the end has been reached in a data source.
 * \return as `feof()` would for `FILE*`.
 */
int _beob(DataSourceBuffer* ds);

/**
 * \brief Read a "line" from data source, eventually (re-)allocating a given buffer. A "line" is defined
 * as a portion starting with character `from` (usually `<`) ending at character `to` (usually `>`).
 *
 * Characters read will be stored in `line` starting at `i0` (this allows multiple calls to
 * `read_line_alloc()` on the same `line` buffer without overwriting it at each call).
 * Searches for character `from` until character `to`. If `from` is 0, starts from
 * current position in the data source. If `to` is 0, it is replaced by `\n`.
 *
 * \param in The data source (either `FILE*` if `in_type` is `DATA_SOURCE_FILE` or `SXML_CHAR*`
 * 		if `in_type` is `DATA_SOURCE_BUFFER`).
 * \param in_type specifies the type of data source to be read.
 * \param line can be `NULL`, in which case it will be allocated to `*sz_line` bytes. After the function
 * 		returns, `*sz_line` is the actual buffer size. This allows multiple calls to this function using
 * 		the same buffer (without re-allocating/freeing).
 * \param sz_line is the size of the buffer `line` if previously allocated (in `SXML_CHAR`, not byte!).
 * 		If `NULL` or 0, an internal value of `MEM_INCR_RLA` is used.
 * \param i0 The position where read characters are stored in `line`.
 * \param from The character indicating a start of line.
 * \param to The character indicating an end of line.
 * \param keep_fromto if 0, removes characters `from` and `to` from the line (stripping).
 * \param interest is a special character of interest, usually `\n` so we can count line numbers in the
 * 		data source (valid only if `interest_count` is not `NULL`).
 * \param interest_count if not `NULL`, will receive the count of `interest` characters while searching.
 * \returns the number of characters in the line or 0 if an error occurred.
 */
int read_line_alloc(void* in, DataSourceType in_type, SXML_CHAR** line, int* sz_line, int i0, SXML_CHAR from, SXML_CHAR to, int keep_fromto, SXML_CHAR interest, int* interest_count);

/**
 * \brief Concatenates the string pointed at by `src1` with `src2` into `*src1` and return it.
 * \return `*src1`, or `NULL` if out of memory.
 */
SXML_CHAR* strcat_alloc(SXML_CHAR** src1, const SXML_CHAR* src2);

/**
 * \brief Strip whitespaces at the beginning and end of a string, modifying it.
 * \param str The string to strip.
 * \param repl_sq if not null, squeezes spaces to an single character `repl_sq`.
 * \returns the stripped string, which can be `str` directly if there are no whitespaces
 * 		at the beginning.
 * 		N.B. that if `str` was allocated, it should be freed later, *not* the returned
 * 		reference.
 */
SXML_CHAR* strip_spaces(SXML_CHAR* str, SXML_CHAR repl_sq);

/**
 * \brief Remove `\` characters from `str`, modifying it.
 * \return `str` unescaped.
 */
SXML_CHAR* str_unescape(SXML_CHAR* str);

/**
 * \brief Split a string into a left and right part around a given separator.
 *
 * The beginning and end indices of left part are stored in `l0` and `l1` while the
 * right part's are stored in `r0` and `r1`. The separator position is stored at `i_sep`
 * (whenever these are not `NULL`).
 * Whenever the right member is empty (e.g. `"attrib"` or `"attrib="`), `*r0` is set to
 * `strlen(str)` and `*r1` to `*r0-1` (crossed).
 *
 * \param str The string to split.
 * \param sep The separator (e.g. `=`).
 * \param l0 will contain the index of the left part first character in `str`.
 * \param l1 will contain the index of left part last character in `str`.
 * \param i_sep will contain the index of the separator in `str`, or -1 if not found.
 * \param r0 will contain the index of the left part first character in `str`.
 * \param r1 will contain the index of left part last character in `str`.
 * \param ignore_spaces Is `true`, computed indexes will not take into account potential
 *		spaces around the separator as well as before left part and after right part, so
 *		`&quot;name=val&quot;` will be equivalent to `&quot;name = val&quot;`.
 * \param ignore_quotes If `true`, quotes (`&quot;` or `&apos;`) will not be taken into account when parsing left
 * 		and right members, so `&quot;name = 'val'&quot;` will be equivalent to `&quot;name = val&quot;`.
 *
 * \return `false` when `str` is malformed, `true` when splitting was successful.
 */
int split_left_right(SXML_CHAR* str, SXML_CHAR sep, int* l0, int* l1, int* i_sep, int* r0, int* r1, int ignore_spaces, int ignore_quotes);

/**
 Detect a potential BOM at the current file position and read it into 'bom' (if not NULL,
 'bom' should be at least 5 bytes). It also moves the 'f' beyond the BOM so it's possible to
 skip it by calling 'freadBOM(f, NULL, NULL)'. If no BOM is found, it leaves 'f' file pointer
 is reset to its original location.
 If not null, 'sz_bom' is filled with how many bytes are stored in 'bom'.
 Return the BOM type or BOM_NONE if none found (empty 'bom' in this case).
 */
BOM_TYPE freadBOM(FILE* f, unsigned char* bom, int* sz_bom);

/**
 * \brief Checks if the given string contains HTML escape character (`&`).
 *
 * It can be useful to know whether `html2str()` would need to be called on
 * `html`.
 *
 * \param html The string to check.
 *
 * \returns `false` if `html` does not contain the HTML escape character.
 */
int has_html(SXML_CHAR* html);

/**
 * \brief Replace occurrences of special HTML characters escape sequences (e.g. `"&amp;"`)
 * by its character equivalent (e.g. `"&"`).
 *
 * If `html == str`, replacement is made in `str` itself, overwriting it.
 * If `str` is `NULL`, replacement is made into `html`, overwriting it.
 *
 * \param html The string containing the HTML escapes (e.g. `"h&ocirc;tel"`).
 * \param str The string to receive the unescaped string (e.g. `"hôtel"`).
 *
 * \returns The unescaped string (`str`, or `html` if `str` was `NULL`).
 */
SXML_CHAR* html2str(SXML_CHAR* html, SXML_CHAR* str);

/**
 * \brief Replace occurrences of special characters (e.g. `&`) into their XML escaped
 * equivalent (e.g. `"&amp;"`).
 *
 * `html` is supposed allocated to the correct size (e.g. using `__malloc(strlen_html(str)+30)`)
 * and *different* from `str` (unlike `html2str()`), as the string will expand.
 * If it is `NULL`, `str` will be analyzed and a string will be allocated to the exact size and
 * returned. In that case, it is the responsibility of the caller to `free()` the result!
 * \return `html`, or `NULL` if `str` or `html` are `NULL`, or when `html` is `str`.
 */
SXML_CHAR* str2html(SXML_CHAR* str, SXML_CHAR* html);

/**
 * \brief Compute the length of a string as if all its special character were replaced by their HTML
 * escapes.
 * \return 0 if `str` is NULL.
 */
int strlen_html(SXML_CHAR* str);

/**
 * \brief Print a string to a file, transforming special characters into their HTML equivalent.

 * This is more efficient than a call to `fprintf(f, str2html(str))` as it does not need memory
 * allocation; rather, it converts characters on-the-fly while writing.
 * If `f` is NULL, does not print `str` but rather counts the number of characters that
 * would be printed.
 *
 * \returns the number of output characters.
 */
int fprintHTML(FILE* f, SXML_CHAR* str);

#ifdef __cplusplus
}
#endif

#endif
