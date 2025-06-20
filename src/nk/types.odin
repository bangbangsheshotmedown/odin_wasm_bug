package nuklear

import "core:c"

/*
 * ==============================================================
 *
 *                          CONSTANTS
 *
 * ===============================================================
 */
NK_UNDEFINED :: -1.0
NK_UTF_INVALID :: 0xFFFD /**< internal invalid utf8 rune */
NK_UTF_SIZE :: 4 /**< describes the number of bytes a glyph consists of*/

NK_INPUT_MAX :: 16

NK_MAX_NUMBER_BUFFER :: 64

NK_SCROLLBAR_HIDING_TIMEOUT :: 4.0

// NK_API :: extern

// NK_LIB :: static

// NK_INTERN :: static
// NK_STORAGE :: static
// NK_GLOBAL :: static

// NK_FILE_LINE :: _FILE__ ":" #_LINE__

// NK_INT8 :: signed c.char
// NK_UINT8 :: unsigned c.char
// NK_INT16 :: signed c.short
// NK_UINT16 :: unsigned c.short
// NK_INT32 :: signed c.int
// NK_UINT32 :: unsigned c.int
// NK_SIZE_TYPE :: unsigned c.long
// NK_POINTER_TYPE :: unsigned c.long

NK_BOOL :: c.int

nk_char :: c.schar

nk_uchar :: c.uchar

nk_byte :: c.uchar

nk_short :: c.short

nk_ushort :: c.ushort

nk_int :: c.int

nk_uint :: c.uint

nk_size :: c.ulong

nk_ptr :: c.ulong

nk_bool :: c.int

nk_hash :: nk_uint

nk_flags :: nk_uint

nk_rune :: nk_uint

/* Make sure correct type size:
* This will fire with a negative subscript error if the type sizes
* are set incorrectly by the compiler, and compile out if not */
dummy_array440 :: [1]c.char

dummy_array441 :: [1]c.char

dummy_array442 :: [1]c.char

dummy_array443 :: [1]c.char

dummy_array444 :: [1]c.char

dummy_array445 :: [1]c.char

dummy_array446 :: [1]c.char

dummy_array447 :: [1]c.char

dummy_array448 :: [1]c.char

dummy_array452 :: [1]c.char

nk_false :: 0

nk_true :: 1

nk_color :: struct {
	r, g, b, a: nk_byte,
}

nk_colorf :: struct {
	r, g, b, a: f32,
}

nk_vec2 :: struct {
	x, y: f32,
}

nk_vec2i_ :: struct {
	x, y: c.short,
}

nk_rect :: struct {
	x, y, w, h: f32,
}

nk_recti :: struct {
	x, y, w, h: c.short,
}

nk_glyph :: [4]c.char

nk_handle :: struct #raw_union {
	ptr: rawptr,
	id:  c.int,
}

nk_image :: struct {
	handle: nk_handle,
	w, h:   nk_ushort,
	region: [4]nk_ushort,
}

nk_nine_slice :: struct {
	img:        nk_image,
	l, t, r, b: nk_ushort,
}

nk_cursor :: struct {
	img:          nk_image,
	size, offset: nk_vec2,
}

nk_scroll :: struct {
	x, y: nk_uint,
}

nk_heading :: enum c.int {
	UP,
	RIGHT,
	DOWN,
	LEFT,
}

nk_button_behavior :: enum c.int {
	DEFAULT,
	REPEATER,
}

nk_modify :: enum c.int {
	FIXED      = 0,
	MODIFIABLE = 1,
}

nk_orientation :: enum c.int {
	VERTICAL,
	HORIZONTAL,
}

nk_collapse_states :: enum c.int {
	INIMIZED = 0,
	AXIMIZED = 1,
}

nk_show_states :: enum c.int {
	HIDDEN = 0,
	SHOWN  = 1,
}

nk_chart_type :: enum c.int {
	LINES,
	COLUMN,
	MAX,
}

nk_chart_event :: enum c.int {
	HOVERING = 1,
	CLICKED  = 2,
}

nk_color_format :: enum c.int {
    RGB,
    RGBA,
}

nk_popup_type :: enum c.int {
	STATIC,
	DYNAMIC,
}

nk_layout_format :: enum c.int {
	DYNAMIC,
	STATIC,
}

nk_tree_type :: enum c.int {
	NODE,
	TAB,
}

nk_plugin_alloc :: proc "c" (nk_handle, rawptr, nk_size) -> rawptr

nk_plugin_free :: proc "c" (nk_handle, rawptr)

nk_plugin_filter :: proc "c" (^nk_text_edit, nk_rune) -> nk_bool

nk_plugin_paste :: proc "c" (nk_handle, ^nk_text_edit)

nk_plugin_copy :: proc "c" (nk_handle, cstring, c.int)

nk_allocator :: struct {
	userdata: nk_handle,
	alloc:    nk_plugin_alloc,
	free:     nk_plugin_free,
}

nk_symbol_type :: enum c.int {
	NONE,
	X,
	UNDERSCORE,
	CIRCLE_SOLID,
	CIRCLE_OUTLINE,
	RECT_SOLID,
	RECT_OUTLINE,
	TRIANGLE_UP,
	TRIANGLE_DOWN,
	TRIANGLE_LEFT,
	TRIANGLE_RIGHT,
	PLUS,
	MINUS,
	TRIANGLE_UP_OUTLINE,
	TRIANGLE_DOWN_OUTLINE,
	TRIANGLE_LEFT_OUTLINE,
	TRIANGLE_RIGHT_OUTLINE,
	MAX,
}

/* =============================================================================
*
*                                  INPUT
*
* =============================================================================*/
/**
* \page Input
*
* The input API is responsible for holding the current input state composed of
* mouse, key and text input states.
* It is worth noting that no direct OS or window handling is done in nuklear.
* Instead all input state has to be provided by platform specific code. This on one hand
* expects more work from the user and complicates usage but on the other hand
* provides simple abstraction over a big number of platforms, libraries and other
* already provided functionality.
*
* ```c
* nk_input_begin(&ctx);
* while (GetEvent(&evt)) {
*     if (evt.type == MOUSE_MOVE)
*         nk_input_motion(&ctx, evt.motion.x, evt.motion.y);
*     else if (evt.type == [...]) {
*         // [...]
*     }
* } nk_input_end(&ctx);
* ```
*
* # Usage
* Input state needs to be provided to nuklear by first calling `nk_input_begin`
* which resets internal state like delta mouse position and button transitions.
* After `nk_input_begin` all current input state needs to be provided. This includes
* mouse motion, button and key pressed and released, text input and scrolling.
* Both event- or state-based input handling are supported by this API
* and should work without problems. Finally after all input state has been
* mirrored `nk_input_end` needs to be called to finish input process.
*
* ```c
* struct nk_context ctx;
* nk_init_xxx(&ctx, ...);
* while (1) {
*     Event evt;
*     nk_input_begin(&ctx);
*     while (GetEvent(&evt)) {
*         if (evt.type == MOUSE_MOVE)
*             nk_input_motion(&ctx, evt.motion.x, evt.motion.y);
*         else if (evt.type == [...]) {
*             // [...]
*         }
*     }
*     nk_input_end(&ctx);
*     // [...]
*     nk_clear(&ctx);
* } nk_free(&ctx);
* ```
*
* # Reference
* Function            | Description
* --------------------|-------------------------------------------------------
* \ref nk_input_begin  | Begins the input mirroring process. Needs to be called before all other `nk_input_xxx` calls
* \ref nk_input_motion | Mirrors mouse cursor position
* \ref nk_input_key    | Mirrors key state with either pressed or released
* \ref nk_input_button | Mirrors mouse button state with either pressed or released
* \ref nk_input_scroll | Mirrors mouse scroll values
* \ref nk_input_char   | Adds a single ASCII text character into an internal text buffer
* \ref nk_input_glyph  | Adds a single multi-byte UTF-8 character into an internal text buffer
* \ref nk_input_unicode| Adds a single unicode rune into an internal text buffer
* \ref nk_input_end    | Ends the input mirroring process by calculating state changes. Don't call any `nk_input_xxx` function referenced above after this call
*/
nk_keys :: enum c.int {
	NONE,
	SHIFT,
	CTRL,
	DEL,
	ENTER,
	TAB,
	BACKSPACE,
	COPY,
	CUT,
	PASTE,
	UP,
	DOWN,
	LEFT,
	RIGHT,

	/* Shortcuts: text field */
	TEXT_INSERT_MODE,

	/* Shortcuts: text field */
	TEXT_REPLACE_MODE,

	/* Shortcuts: text field */
	TEXT_RESET_MODE,

	/* Shortcuts: text field */
	TEXT_LINE_START,

	/* Shortcuts: text field */
	TEXT_LINE_END,

	/* Shortcuts: text field */
	TEXT_START,

	/* Shortcuts: text field */
	TEXT_END,

	/* Shortcuts: text field */
	TEXT_UNDO,

	/* Shortcuts: text field */
	TEXT_REDO,

	/* Shortcuts: text field */
	TEXT_SELECT_ALL,

	/* Shortcuts: text field */
	TEXT_WORD_LEFT,

	/* Shortcuts: text field */
	TEXT_WORD_RIGHT,

	/* Shortcuts: scrollbar */
	SCROLL_START,

	/* Shortcuts: scrollbar */
	SCROLL_END,

	/* Shortcuts: scrollbar */
	SCROLL_DOWN,

	/* Shortcuts: scrollbar */
	SCROLL_UP,

	/* Shortcuts: scrollbar */
	MAX,
}

nk_buttons :: enum c.int {
	LEFT,
	MIDDLE,
	RIGHT,
	DOUBLE,
	MAX,
}

/** =============================================================================
*
*                                  DRAWING
*
* =============================================================================*/
/**
* \page Drawing
* This library was designed to be render backend agnostic so it does
* not draw anything to screen directly. Instead all drawn shapes, widgets
* are made of, are buffered into memory and make up a command queue.
* Each frame therefore fills the command buffer with draw commands
* that then need to be executed by the user and his own render backend.
* After that the command buffer needs to be cleared and a new frame can be
* started. It is probably important to note that the command buffer is the main
* drawing API and the optional vertex buffer API only takes this format and
* converts it into a hardware accessible format.
*
* # Usage
* To draw all draw commands accumulated over a frame you need your own render
* backend able to draw a number of 2D primitives. This includes at least
* filled and stroked rectangles, circles, text, lines, triangles and scissors.
* As soon as this criterion is met you can iterate over each draw command
* and execute each draw command in a interpreter like fashion:
*
* ```c
* const struct nk_command *cmd = 0;
* nk_foreach(cmd, &ctx) {
*     switch (cmd->type) {
*     case NK_COMMAND_LINE:
*         your_draw_line_function(...)
*         break;
*     case NK_COMMAND_RECT
*         your_draw_rect_function(...)
*         break;
*     case //...:
*         //[...]
*     }
* }
* ```
*
* In program flow context draw commands need to be executed after input has been
* gathered and the complete UI with windows and their contained widgets have
* been executed and before calling `nk_clear` which frees all previously
* allocated draw commands.
*
* ```c
* struct nk_context ctx;
* nk_init_xxx(&ctx, ...);
* while (1) {
*     Event evt;
*     nk_input_begin(&ctx);
*     while (GetEvent(&evt)) {
*         if (evt.type == MOUSE_MOVE)
*             nk_input_motion(&ctx, evt.motion.x, evt.motion.y);
*         else if (evt.type == [...]) {
*             [...]
*         }
*     }
*     nk_input_end(&ctx);
*     //
*     // [...]
*     //
*     const struct nk_command *cmd = 0;
*     nk_foreach(cmd, &ctx) {
*     switch (cmd->type) {
*     case NK_COMMAND_LINE:
*         your_draw_line_function(...)
*         break;
*     case NK_COMMAND_RECT
*         your_draw_rect_function(...)
*         break;
*     case ...:
*         // [...]
*     }
*     nk_clear(&ctx);
* }
* nk_free(&ctx);
* ```
*
* You probably noticed that you have to draw all of the UI each frame which is
* quite wasteful. While the actual UI updating loop is quite fast rendering
* without actually needing it is not. So there are multiple things you could do.
*
* First is only update on input. This of course is only an option if your
* application only depends on the UI and does not require any outside calculations.
* If you actually only update on input make sure to update the UI two times each
* frame and call `nk_clear` directly after the first pass and only draw in
* the second pass. In addition it is recommended to also add additional timers
* to make sure the UI is not drawn more than a fixed number of frames per second.
*
* ```c
* struct nk_context ctx;
* nk_init_xxx(&ctx, ...);
* while (1) {
*     // [...wait for input ]
*     // [...do two UI passes ...]
*     do_ui(...)
*     nk_clear(&ctx);
*     do_ui(...)
*     //
*     // draw
*     const struct nk_command *cmd = 0;
*     nk_foreach(cmd, &ctx) {
*     switch (cmd->type) {
*     case NK_COMMAND_LINE:
*         your_draw_line_function(...)
*         break;
*     case NK_COMMAND_RECT
*         your_draw_rect_function(...)
*         break;
*     case ...:
*         //[...]
*     }
*     nk_clear(&ctx);
* }
* nk_free(&ctx);
* ```
*
* The second probably more applicable trick is to only draw if anything changed.
* It is not really useful for applications with continuous draw loop but
* quite useful for desktop applications. To actually get nuklear to only
* draw on changes you first have to define `NK_ZERO_COMMAND_MEMORY` and
* allocate a memory buffer that will store each unique drawing output.
* After each frame you compare the draw command memory inside the library
* with your allocated buffer by memcmp. If memcmp detects differences
* you have to copy the command buffer into the allocated buffer
* and then draw like usual (this example uses fixed memory but you could
* use dynamically allocated memory).
*
* ```c
* //[... other defines ...]
* #define NK_ZERO_COMMAND_MEMORY
* #include "nuklear.h"
* //
* // setup context
* struct nk_context ctx;
* void *last = calloc(1,64*1024);
* void *buf = calloc(1,64*1024);
* nk_init_fixed(&ctx, buf, 64*1024);
* //
* // loop
* while (1) {
*     // [...input...]
*     // [...ui...]
*     void *cmds = nk_buffer_memory(&ctx.memory);
*     if (memcmp(cmds, last, ctx.memory.allocated)) {
*         memcpy(last,cmds,ctx.memory.allocated);
*         const struct nk_command *cmd = 0;
*         nk_foreach(cmd, &ctx) {
*             switch (cmd->type) {
*             case NK_COMMAND_LINE:
*                 your_draw_line_function(...)
*                 break;
*             case NK_COMMAND_RECT
*                 your_draw_rect_function(...)
*                 break;
*             case ...:
*                 // [...]
*             }
*         }
*     }
*     nk_clear(&ctx);
* }
* nk_free(&ctx);
* ```
*
* Finally while using draw commands makes sense for higher abstracted platforms like
* X11 and Win32 or drawing libraries it is often desirable to use graphics
* hardware directly. Therefore it is possible to just define
* `NK_INCLUDE_VERTEX_BUFFER_OUTPUT` which includes optional vertex output.
* To access the vertex output you first have to convert all draw commands into
* vertexes by calling `nk_convert` which takes in your preferred vertex format.
* After successfully converting all draw commands just iterate over and execute all
* vertex draw commands:
*
* ```c
* // fill configuration
* struct your_vertex
* {
*     float pos[2]; // important to keep it to 2 floats
*     float uv[2];
*     unsigned char col[4];
* };
* struct nk_convert_config cfg = {};
* static const struct nk_draw_vertex_layout_element vertex_layout[] = {
*     {NK_VERTEX_POSITION, NK_FORMAT_FLOAT, NK_OFFSETOF(struct your_vertex, pos)},
*     {NK_VERTEX_TEXCOORD, NK_FORMAT_FLOAT, NK_OFFSETOF(struct your_vertex, uv)},
*     {NK_VERTEX_COLOR, NK_FORMAT_R8G8B8A8, NK_OFFSETOF(struct your_vertex, col)},
*     {NK_VERTEX_LAYOUT_END}
* };
* cfg.shape_AA = NK_ANTI_ALIASING_ON;
* cfg.line_AA = NK_ANTI_ALIASING_ON;
* cfg.vertex_layout = vertex_layout;
* cfg.vertex_size = sizeof(struct your_vertex);
* cfg.vertex_alignment = NK_ALIGNOF(struct your_vertex);
* cfg.circle_segment_count = 22;
* cfg.curve_segment_count = 22;
* cfg.arc_segment_count = 22;
* cfg.global_alpha = 1.0f;
* cfg.tex_null = dev->tex_null;
* //
* // setup buffers and convert
* struct nk_buffer cmds, verts, idx;
* nk_buffer_init_default(&cmds);
* nk_buffer_init_default(&verts);
* nk_buffer_init_default(&idx);
* nk_convert(&ctx, &cmds, &verts, &idx, &cfg);
* //
* // draw
* nk_draw_foreach(cmd, &ctx, &cmds) {
* if (!cmd->elem_count) continue;
*     //[...]
* }
* nk_buffer_free(&cms);
* nk_buffer_free(&verts);
* nk_buffer_free(&idx);
* ```
*
* # Reference
* Function            | Description
* --------------------|-------------------------------------------------------
* \ref nk__begin       | Returns the first draw command in the context draw command list to be drawn
* \ref nk__next        | Increments the draw command iterator to the next command inside the context draw command list
* \ref nk_foreach      | Iterates over each draw command inside the context draw command list
* \ref nk_convert      | Converts from the abstract draw commands list into a hardware accessible vertex format
* \ref nk_draw_begin   | Returns the first vertex command in the context vertex draw list to be executed
* \ref nk__draw_next   | Increments the vertex command iterator to the next command inside the context vertex command list
* \ref nk__draw_end    | Returns the end of the vertex draw list
* \ref nk_draw_foreach | Iterates over each vertex draw command inside the vertex draw list
*/
nk_anti_aliasing :: enum c.int {
	OFF,
	ON,
}

nk_convert_result :: enum c.int {
	SUCCESS             = 0,
	INVALID_PARAM       = 1,
	COMMAND_BUFFER_FULL = 2,
	VERTEX_BUFFER_FULL  = 4,
	ELEMENT_BUFFER_FULL = 8,
}

nk_draw_null_texture :: struct {
	texture: nk_handle,

	/**!< texture handle to a texture with a white pixel */
	uv: nk_vec2,
}

nk_convert_config :: struct {
	global_alpha: f32,

	/**!< global alpha value */
	line_AA: nk_anti_aliasing,

	/**!< line anti-aliasing flag can be turned off if you are tight on memory */
	shape_AA: nk_anti_aliasing,

	/**!< shape anti-aliasing flag can be turned off if you are tight on memory */
	circle_segment_count: c.uint,

	/**!< number of segments used for circles: default to 22 */
	arc_segment_count: c.uint,

	/**!< number of segments used for arcs: default to 22 */
	curve_segment_count: c.uint,

	/**!< number of segments used for curves: default to 22 */
	tex_null: nk_draw_null_texture,

	/**!< handle to texture with a white pixel for shape drawing */
	vertex_layout: ^nk_draw_vertex_layout_element,

	/**!< describes the vertex output format and packing */
	vertex_size: nk_size,

	/**!< sizeof one vertex for vertex packing */
	vertex_alignment: nk_size,
}

/** =============================================================================
*
*                                  WINDOW
*
* =============================================================================*/
/**
* \page Window
* Windows are the main persistent state used inside nuklear and are life time
* controlled by simply "retouching" (i.e. calling) each window each frame.
* All widgets inside nuklear can only be added inside the function pair `nk_begin_xxx`
* and `nk_end`. Calling any widgets outside these two functions will result in an
* assert in debug or no state change in release mode.<br /><br />
*
* Each window holds frame persistent state like position, size, flags, state tables,
* and some garbage collected internal persistent widget state. Each window
* is linked into a window stack list which determines the drawing and overlapping
* order. The topmost window thereby is the currently active window.<br /><br />
*
* To change window position inside the stack occurs either automatically by
* user input by being clicked on or programmatically by calling `nk_window_focus`.
* Windows by default are visible unless explicitly being defined with flag
* `NK_WINDOW_HIDDEN`, the user clicked the close button on windows with flag
* `NK_WINDOW_CLOSABLE` or if a window was explicitly hidden by calling
* `nk_window_show`. To explicitly close and destroy a window call `nk_window_close`.<br /><br />
*
* # Usage
* To create and keep a window you have to call one of the two `nk_begin_xxx`
* functions to start window declarations and `nk_end` at the end. Furthermore it
* is recommended to check the return value of `nk_begin_xxx` and only process
* widgets inside the window if the value is not 0. Either way you have to call
* `nk_end` at the end of window declarations. Furthermore, do not attempt to
* nest `nk_begin_xxx` calls which will hopefully result in an assert or if not
* in a segmentation fault.
*
* ```c
* if (nk_begin_xxx(...) {
*     // [... widgets ...]
* }
* nk_end(ctx);
* ```
*
* In the grand concept window and widget declarations need to occur after input
* handling and before drawing to screen. Not doing so can result in higher
* latency or at worst invalid behavior. Furthermore make sure that `nk_clear`
* is called at the end of the frame. While nuklear's default platform backends
* already call `nk_clear` for you if you write your own backend not calling
* `nk_clear` can cause asserts or even worse undefined behavior.
*
* ```c
* struct nk_context ctx;
* nk_init_xxx(&ctx, ...);
* while (1) {
*     Event evt;
*     nk_input_begin(&ctx);
*     while (GetEvent(&evt)) {
*         if (evt.type == MOUSE_MOVE)
*             nk_input_motion(&ctx, evt.motion.x, evt.motion.y);
*         else if (evt.type == [...]) {
*             nk_input_xxx(...);
*         }
*     }
*     nk_input_end(&ctx);
*
*     if (nk_begin_xxx(...) {
*         //[...]
*     }
*     nk_end(ctx);
*
*     const struct nk_command *cmd = 0;
*     nk_foreach(cmd, &ctx) {
*     case NK_COMMAND_LINE:
*         your_draw_line_function(...)
*         break;
*     case NK_COMMAND_RECT
*         your_draw_rect_function(...)
*         break;
*     case //...:
*         //[...]
*     }
*     nk_clear(&ctx);
* }
* nk_free(&ctx);
* ```
*
* # Reference
* Function                            | Description
* ------------------------------------|----------------------------------------
* \ref nk_begin                            | Starts a new window; needs to be called every frame for every window (unless hidden) or otherwise the window gets removed
* \ref nk_begin_titled                     | Extended window start with separated title and identifier to allow multiple windows with same name but not title
* \ref nk_end                              | Needs to be called at the end of the window building process to process scaling, scrollbars and general cleanup
*
* \ref nk_window_find                      | Finds and returns the window with give name
* \ref nk_window_get_bounds                | Returns a rectangle with screen position and size of the currently processed window.
* \ref nk_window_get_position              | Returns the position of the currently processed window
* \ref nk_window_get_size                  | Returns the size with width and height of the currently processed window
* \ref nk_window_get_width                 | Returns the width of the currently processed window
* \ref nk_window_get_height                | Returns the height of the currently processed window
* \ref nk_window_get_panel                 | Returns the underlying panel which contains all processing state of the current window
* \ref nk_window_get_content_region        | Returns the position and size of the currently visible and non-clipped space inside the currently processed window
* \ref nk_window_get_content_region_min    | Returns the upper rectangle position of the currently visible and non-clipped space inside the currently processed window
* \ref nk_window_get_content_region_max    | Returns the upper rectangle position of the currently visible and non-clipped space inside the currently processed window
* \ref nk_window_get_content_region_size   | Returns the size of the currently visible and non-clipped space inside the currently processed window
* \ref nk_window_get_canvas                | Returns the draw command buffer. Can be used to draw custom widgets
* \ref nk_window_get_scroll                | Gets the scroll offset of the current window
* \ref nk_window_has_focus                 | Returns if the currently processed window is currently active
* \ref nk_window_is_collapsed              | Returns if the window with given name is currently minimized/collapsed
* \ref nk_window_is_closed                 | Returns if the currently processed window was closed
* \ref nk_window_is_hidden                 | Returns if the currently processed window was hidden
* \ref nk_window_is_active                 | Same as nk_window_has_focus for some reason
* \ref nk_window_is_hovered                | Returns if the currently processed window is currently being hovered by mouse
* \ref nk_window_is_any_hovered            | Return if any window currently hovered
* \ref nk_item_is_any_active               | Returns if any window or widgets is currently hovered or active
//
* \ref nk_window_set_bounds                | Updates position and size of the currently processed window
* \ref nk_window_set_position              | Updates position of the currently process window
* \ref nk_window_set_size                  | Updates the size of the currently processed window
* \ref nk_window_set_focus                 | Set the currently processed window as active window
* \ref nk_window_set_scroll                | Sets the scroll offset of the current window
//
* \ref nk_window_close                     | Closes the window with given window name which deletes the window at the end of the frame
* \ref nk_window_collapse                  | Collapses the window with given window name
* \ref nk_window_collapse_if               | Collapses the window with given window name if the given condition was met
* \ref nk_window_show                      | Hides a visible or reshows a hidden window
* \ref nk_window_show_if                   | Hides/shows a window depending on condition

* # nk_panel_flags
* Flag                        | Description
* ----------------------------|----------------------------------------
* NK_WINDOW_BORDER            | Draws a border around the window to visually separate window from the background
* NK_WINDOW_MOVABLE           | The movable flag indicates that a window can be moved by user input or by dragging the window header
* NK_WINDOW_SCALABLE          | The scalable flag indicates that a window can be scaled by user input by dragging a scaler icon at the button of the window
* NK_WINDOW_CLOSABLE          | Adds a closable icon into the header
* NK_WINDOW_MINIMIZABLE       | Adds a minimize icon into the header
* NK_WINDOW_NO_SCROLLBAR      | Removes the scrollbar from the window
* NK_WINDOW_TITLE             | Forces a header at the top at the window showing the title
* NK_WINDOW_SCROLL_AUTO_HIDE  | Automatically hides the window scrollbar if no user interaction: also requires delta time in `nk_context` to be set each frame
* NK_WINDOW_BACKGROUND        | Always keep window in the background
* NK_WINDOW_SCALE_LEFT        | Puts window scaler in the left-bottom corner instead right-bottom
* NK_WINDOW_NO_INPUT          | Prevents window of scaling, moving or getting focus
*
* # nk_collapse_states
* State           | Description
* ----------------|-----------------------------------------------------------
* NK_MINIMIZED| UI section is collapsed and not visible until maximized
* NK_MAXIMIZED| UI section is extended and visible until minimized
*/
nk_panel_flags :: enum c.int {
	BORDER           = 1,
	MOVABLE          = 2,
	SCALABLE         = 4,
	CLOSABLE         = 8,
	MINIMIZABLE      = 16,
	NO_SCROLLBAR     = 32,
	TITLE            = 64,
	SCROLL_AUTO_HIDE = 128,
	BACKGROUND       = 256,
	SCALE_LEFT       = 512,
	NO_INPUT         = 1024,
}

/* =============================================================================
*
*                                  LAYOUT
*
* =============================================================================*/
/**
* \page Layouting
* Layouting in general describes placing widget inside a window with position and size.
* While in this particular implementation there are five different APIs for layouting
* each with different trade offs between control and ease of use. <br /><br />
*
* All layouting methods in this library are based around the concept of a row.
* A row has a height the window content grows by and a number of columns and each
* layouting method specifies how each widget is placed inside the row.
* After a row has been allocated by calling a layouting functions and then
* filled with widgets will advance an internal pointer over the allocated row. <br /><br />
*
* To actually define a layout you just call the appropriate layouting function
* and each subsequent widget call will place the widget as specified. Important
* here is that if you define more widgets then columns defined inside the layout
* functions it will allocate the next row without you having to make another layouting <br /><br />
* call.
*
* Biggest limitation with using all these APIs outside the `nk_layout_space_xxx` API
* is that you have to define the row height for each. However the row height
* often depends on the height of the font. <br /><br />
*
* To fix that internally nuklear uses a minimum row height that is set to the
* height plus padding of currently active font and overwrites the row height
* value if zero. <br /><br />
*
* If you manually want to change the minimum row height then
* use nk_layout_set_min_row_height, and use nk_layout_reset_min_row_height to
* reset it back to be derived from font height. <br /><br />
*
* Also if you change the font in nuklear it will automatically change the minimum
* row height for you and. This means if you change the font but still want
* a minimum row height smaller than the font you have to repush your value. <br /><br />
*
* For actually more advanced UI I would even recommend using the `nk_layout_space_xxx`
* layouting method in combination with a cassowary constraint solver (there are
* some versions on github with permissive license model) to take over all control over widget
* layouting yourself. However for quick and dirty layouting using all the other layouting
* functions should be fine.
*
* # Usage
* 1.  __nk_layout_row_dynamic__<br /><br />
*     The easiest layouting function is `nk_layout_row_dynamic`. It provides each
*     widgets with same horizontal space inside the row and dynamically grows
*     if the owning window grows in width. So the number of columns dictates
*     the size of each widget dynamically by formula:
*
*     ```c
*     widget_width = (window_width - padding - spacing) * (1/column_count)
*     ```
*
*     Just like all other layouting APIs if you define more widget than columns this
*     library will allocate a new row and keep all layouting parameters previously
*     defined.
*
*     ```c
*     if (nk_begin_xxx(...) {
*         // first row with height: 30 composed of two widgets
*         nk_layout_row_dynamic(&ctx, 30, 2);
*         nk_widget(...);
*         nk_widget(...);
*         //
*         // second row with same parameter as defined above
*         nk_widget(...);
*         nk_widget(...);
*         //
*         // third row uses 0 for height which will use auto layouting
*         nk_layout_row_dynamic(&ctx, 0, 2);
*         nk_widget(...);
*         nk_widget(...);
*     }
*     nk_end(...);
*     ```
*
* 2.  __nk_layout_row_static__<br /><br />
*     Another easy layouting function is `nk_layout_row_static`. It provides each
*     widget with same horizontal pixel width inside the row and does not grow
*     if the owning window scales smaller or bigger.
*
*     ```c
*     if (nk_begin_xxx(...) {
*         // first row with height: 30 composed of two widgets with width: 80
*         nk_layout_row_static(&ctx, 30, 80, 2);
*         nk_widget(...);
*         nk_widget(...);
*         //
*         // second row with same parameter as defined above
*         nk_widget(...);
*         nk_widget(...);
*         //
*         // third row uses 0 for height which will use auto layouting
*         nk_layout_row_static(&ctx, 0, 80, 2);
*         nk_widget(...);
*         nk_widget(...);
*     }
*     nk_end(...);
*     ```
*
* 3.  __nk_layout_row_xxx__<br /><br />
*     A little bit more advanced layouting API are functions `nk_layout_row_begin`,
*     `nk_layout_row_push` and `nk_layout_row_end`. They allow to directly
*     specify each column pixel or window ratio in a row. It supports either
*     directly setting per column pixel width or widget window ratio but not
*     both. Furthermore it is a immediate mode API so each value is directly
*     pushed before calling a widget. Therefore the layout is not automatically
*     repeating like the last two layouting functions.
*
*     ```c
*     if (nk_begin_xxx(...) {
*         // first row with height: 25 composed of two widgets with width 60 and 40
*         nk_layout_row_begin(ctx, NK_STATIC, 25, 2);
*         nk_layout_row_push(ctx, 60);
*         nk_widget(...);
*         nk_layout_row_push(ctx, 40);
*         nk_widget(...);
*         nk_layout_row_end(ctx);
*         //
*         // second row with height: 25 composed of two widgets with window ratio 0.25 and 0.75
*         nk_layout_row_begin(ctx, NK_DYNAMIC, 25, 2);
*         nk_layout_row_push(ctx, 0.25f);
*         nk_widget(...);
*         nk_layout_row_push(ctx, 0.75f);
*         nk_widget(...);
*         nk_layout_row_end(ctx);
*         //
*         // third row with auto generated height: composed of two widgets with window ratio 0.25 and 0.75
*         nk_layout_row_begin(ctx, NK_DYNAMIC, 0, 2);
*         nk_layout_row_push(ctx, 0.25f);
*         nk_widget(...);
*         nk_layout_row_push(ctx, 0.75f);
*         nk_widget(...);
*         nk_layout_row_end(ctx);
*     }
*     nk_end(...);
*     ```
*
* 4.  __nk_layout_row__<br /><br />
*     The array counterpart to API nk_layout_row_xxx is the single nk_layout_row
*     functions. Instead of pushing either pixel or window ratio for every widget
*     it allows to define it by array. The trade of for less control is that
*     `nk_layout_row` is automatically repeating. Otherwise the behavior is the
*     same.
*
*     ```c
*     if (nk_begin_xxx(...) {
*         // two rows with height: 30 composed of two widgets with width 60 and 40
*         const float ratio[] = {60,40};
*         nk_layout_row(ctx, NK_STATIC, 30, 2, ratio);
*         nk_widget(...);
*         nk_widget(...);
*         nk_widget(...);
*         nk_widget(...);
*         //
*         // two rows with height: 30 composed of two widgets with window ratio 0.25 and 0.75
*         const float ratio[] = {0.25, 0.75};
*         nk_layout_row(ctx, NK_DYNAMIC, 30, 2, ratio);
*         nk_widget(...);
*         nk_widget(...);
*         nk_widget(...);
*         nk_widget(...);
*         //
*         // two rows with auto generated height composed of two widgets with window ratio 0.25 and 0.75
*         const float ratio[] = {0.25, 0.75};
*         nk_layout_row(ctx, NK_DYNAMIC, 30, 2, ratio);
*         nk_widget(...);
*         nk_widget(...);
*         nk_widget(...);
*         nk_widget(...);
*     }
*     nk_end(...);
*     ```
*
* 5.  __nk_layout_row_template_xxx__<br /><br />
*     The most complex and second most flexible API is a simplified flexbox version without
*     line wrapping and weights for dynamic widgets. It is an immediate mode API but
*     unlike `nk_layout_row_xxx` it has auto repeat behavior and needs to be called
*     before calling the templated widgets.
*     The row template layout has three different per widget size specifier. The first
*     one is the `nk_layout_row_template_push_static`  with fixed widget pixel width.
*     They do not grow if the row grows and will always stay the same.
*     The second size specifier is `nk_layout_row_template_push_variable`
*     which defines a minimum widget size but it also can grow if more space is available
*     not taken by other widgets.
*     Finally there are dynamic widgets with `nk_layout_row_template_push_dynamic`
*     which are completely flexible and unlike variable widgets can even shrink
*     to zero if not enough space is provided.
*
*     ```c
*     if (nk_begin_xxx(...) {
*         // two rows with height: 30 composed of three widgets
*         nk_layout_row_template_begin(ctx, 30);
*         nk_layout_row_template_push_dynamic(ctx);
*         nk_layout_row_template_push_variable(ctx, 80);
*         nk_layout_row_template_push_static(ctx, 80);
*         nk_layout_row_template_end(ctx);
*         //
*         // first row
*         nk_widget(...); // dynamic widget can go to zero if not enough space
*         nk_widget(...); // variable widget with min 80 pixel but can grow bigger if enough space
*         nk_widget(...); // static widget with fixed 80 pixel width
*         //
*         // second row same layout
*         nk_widget(...);
*         nk_widget(...);
*         nk_widget(...);
*     }
*     nk_end(...);
*     ```
*
* 6.  __nk_layout_space_xxx__<br /><br />
*     Finally the most flexible API directly allows you to place widgets inside the
*     window. The space layout API is an immediate mode API which does not support
*     row auto repeat and directly sets position and size of a widget. Position
*     and size hereby can be either specified as ratio of allocated space or
*     allocated space local position and pixel size. Since this API is quite
*     powerful there are a number of utility functions to get the available space
*     and convert between local allocated space and screen space.
*
*     ```c
*     if (nk_begin_xxx(...) {
*         // static row with height: 500 (you can set column count to INT_MAX if you don't want to be bothered)
*         nk_layout_space_begin(ctx, NK_STATIC, 500, INT_MAX);
*         nk_layout_space_push(ctx, nk_rect(0,0,150,200));
*         nk_widget(...);
*         nk_layout_space_push(ctx, nk_rect(200,200,100,200));
*         nk_widget(...);
*         nk_layout_space_end(ctx);
*         //
*         // dynamic row with height: 500 (you can set column count to INT_MAX if you don't want to be bothered)
*         nk_layout_space_begin(ctx, NK_DYNAMIC, 500, INT_MAX);
*         nk_layout_space_push(ctx, nk_rect(0.5,0.5,0.1,0.1));
*         nk_widget(...);
*         nk_layout_space_push(ctx, nk_rect(0.7,0.6,0.1,0.1));
*         nk_widget(...);
*     }
*     nk_end(...);
*     ```
*
* # Reference
* Function                                     | Description
* ---------------------------------------------|------------------------------------
* \ref nk_layout_set_min_row_height            | Set the currently used minimum row height to a specified value
* \ref nk_layout_reset_min_row_height          | Resets the currently used minimum row height to font height
* \ref nk_layout_widget_bounds                 | Calculates current width a static layout row can fit inside a window
* \ref nk_layout_ratio_from_pixel              | Utility functions to calculate window ratio from pixel size
* \ref nk_layout_row_dynamic                   | Current layout is divided into n same sized growing columns
* \ref nk_layout_row_static                    | Current layout is divided into n same fixed sized columns
* \ref nk_layout_row_begin                     | Starts a new row with given height and number of columns
* \ref nk_layout_row_push                      | Pushes another column with given size or window ratio
* \ref nk_layout_row_end                       | Finished previously started row
* \ref nk_layout_row                           | Specifies row columns in array as either window ratio or size
* \ref nk_layout_row_template_begin            | Begins the row template declaration
* \ref nk_layout_row_template_push_dynamic     | Adds a dynamic column that dynamically grows and can go to zero if not enough space
* \ref nk_layout_row_template_push_variable    | Adds a variable column that dynamically grows but does not shrink below specified pixel width
* \ref nk_layout_row_template_push_static      | Adds a static column that does not grow and will always have the same size
* \ref nk_layout_row_template_end              | Marks the end of the row template
* \ref nk_layout_space_begin                   | Begins a new layouting space that allows to specify each widgets position and size
* \ref nk_layout_space_push                    | Pushes position and size of the next widget in own coordinate space either as pixel or ratio
* \ref nk_layout_space_end                     | Marks the end of the layouting space
* \ref nk_layout_space_bounds                  | Callable after nk_layout_space_begin and returns total space allocated
* \ref nk_layout_space_to_screen               | Converts vector from nk_layout_space coordinate space into screen space
* \ref nk_layout_space_to_local                | Converts vector from screen space into nk_layout_space coordinates
* \ref nk_layout_space_rect_to_screen          | Converts rectangle from nk_layout_space coordinate space into screen space
* \ref nk_layout_space_rect_to_local           | Converts rectangle from screen space into nk_layout_space coordinates
*/
nk_widget_align :: enum c.int {
	LEFT     = 1,
	CENTERED = 2,
	RIGHT    = 4,
	TOP      = 8,
	MIDDLE   = 16,
	BOTTOM   = 32,
}

nk_widget_alignment :: enum c.int {
	LEFT     = 17,
	CENTERED = 18,
	RIGHT    = 20,
}

/* =============================================================================
*
*                                  LIST VIEW
*
* ============================================================================= */
nk_list_view :: struct {
	/* public: */
	begin, end, count: c.int,

	/* private: */
	total_height: c.int,
	ctx:            ^nk_context,
	scroll_pointer: ^nk_uint,
	scroll_value:   nk_uint,
}

/* =============================================================================
*
*                                  WIDGET
*
* ============================================================================= */
nk_widget_layout_states :: enum c.int {
	INVALID,  /**< The widget cannot be seen and is completely out of view */
	VALID,    /**< The widget is completely inside the window and can be updated and drawn */
	ROM,      /**< The widget is partially visible and cannot be updated */
	DISABLED, /**< The widget is manually disabled and acts like NK_WIDGET_ROM */
}

nk_widget_states :: enum c.int {
	MODIFIED = 2,
	INACTIVE = 4,

	/**!< widget is neither active nor hovered */
	ENTERED = 8,

	/**!< widget has been hovered on the current frame */
	HOVER = 16,

	/**!< widget is being hovered */
	ACTIVED = 32,

	/**!< widget is currently activated */
	LEFT = 64,

	/**!< widget is from this frame on not hovered anymore */
	HOVERED = 18,

	/**!< widget is being hovered */
	ACTIVE = 34,
}

/* =============================================================================
*
*                                  TEXT
*
* ============================================================================= */
nk_text_align :: enum c.int {
	LEFT     = 1,
	CENTERED = 2,
	RIGHT    = 4,
	TOP      = 8,
	MIDDLE   = 16,
	BOTTOM   = 32,
}

nk_text_alignment :: enum c.int {
	LEFT     = 17,
	CENTERED = 18,
	RIGHT    = 20,
}

/* =============================================================================
*
*                                  TEXT EDIT
*
* ============================================================================= */
nk_edit_flags :: enum c.int {
	DEFAULT              = 0,
	READ_ONLY            = 1,
	AUTO_SELECT          = 2,
	SIG_ENTER            = 4,
	ALLOW_TAB            = 8,
	NO_CURSOR            = 16,
	SELECTABLE           = 32,
	CLIPBOARD            = 64,
	CTRL_ENTER_NEWLINE   = 128,
	NO_HORIZONTAL_SCROLL = 256,
	ALWAYS_INSERT_MODE   = 512,
	MULTILINE            = 1024,
	GOTO_END_ON_ACTIVATE = 2048,
}

nk_edit_types :: enum c.int {
	SIMPLE = 512,
	FIELD  = 608,
	BOX    = 1640,
	EDITOR = 1128,
}

nk_edit_events :: enum c.int {
	ACTIVE      = 1,

	/**!< edit widget is currently being modified */
	INACTIVE = 2,

	/**!< edit widget is not active and is not being modified */
	ACTIVATED = 4,

	/**!< edit widget went from state inactive to state active */
	DEACTIVATED = 8,

	/**!< edit widget went from state active to state inactive */
	COMMITED = 16,
}

/* =============================================================================
 *
 *                                  STYLE
 *
 * ============================================================================= */
NK_WIDGET_DISABLED_FACTOR :: 0.5

nk_style_colors :: enum c.int {
	TEXT,
	WINDOW,
	HEADER,
	BORDER,
	BUTTON,
	BUTTON_HOVER,
	BUTTON_ACTIVE,
	TOGGLE,
	TOGGLE_HOVER,
	TOGGLE_CURSOR,
	SELECT,
	SELECT_ACTIVE,
	SLIDER,
	SLIDER_CURSOR,
	SLIDER_CURSOR_HOVER,
	SLIDER_CURSOR_ACTIVE,
	PROPERTY,
	EDIT,
	EDIT_CURSOR,
	COMBO,
	CHART,
	CHART_COLOR,
	CHART_COLOR_HIGHLIGHT,
	SCROLLBAR,
	SCROLLBAR_CURSOR,
	SCROLLBAR_CURSOR_HOVER,
	SCROLLBAR_CURSOR_ACTIVE,
	TAB_HEADER,
	KNOB,
	KNOB_CURSOR,
	KNOB_CURSOR_HOVER,
	KNOB_CURSOR_ACTIVE,
	COUNT,
}

nk_style_cursor :: enum c.int {
	ARROW,
	TEXT,
	MOVE,
	RESIZE_VERTICAL,
	RESIZE_HORIZONTAL,
	RESIZE_TOP_LEFT_DOWN_RIGHT,
	RESIZE_TOP_RIGHT_DOWN_LEFT,
	COUNT,
}

// NK_STRTOD :: nk_strtod

nk_text_width_f :: proc "c" (nk_handle, f32, cstring, c.int) -> f32

nk_query_font_glyph_f :: proc "c" (nk_handle, f32, ^nk_user_font_glyph, nk_rune, nk_rune)

nk_user_font_glyph :: struct {
	uv: [2]nk_vec2,

	/**!< texture coordinates */
	offset: nk_vec2,

	/**!< offset between top left and glyph */
	width, height: f32,

	/**!< size of the glyph  */
	xadvance: f32,
}

nk_user_font :: struct {
	userdata: nk_handle,

	/**!< user provided font handle */
	height: f32,

	/**!< max height of the font */
	width: nk_text_width_f,
	query:    nk_query_font_glyph_f,

	/**!< font glyph callback to query drawing info */
	texture: nk_handle,
}

/** ==============================================================
*
*                          MEMORY BUFFER
*
* ===============================================================*/
/**
* \page Memory Buffer
* A basic (double)-buffer with linear allocation and resetting as only
* freeing policy. The buffer's main purpose is to control all memory management
* inside the GUI toolkit and still leave memory control as much as possible in
* the hand of the user while also making sure the library is easy to use if
* not as much control is needed.
* In general all memory inside this library can be provided from the user in
* three different ways.
*
* The first way and the one providing most control is by just passing a fixed
* size memory block. In this case all control lies in the hand of the user
* since he can exactly control where the memory comes from and how much memory
* the library should consume. Of course using the fixed size API removes the
* ability to automatically resize a buffer if not enough memory is provided so
* you have to take over the resizing. While being a fixed sized buffer sounds
* quite limiting, it is very effective in this library since the actual memory
* consumption is quite stable and has a fixed upper bound for a lot of cases.
*
* If you don't want to think about how much memory the library should allocate
* at all time or have a very dynamic UI with unpredictable memory consumption
* habits but still want control over memory allocation you can use the dynamic
* allocator based API. The allocator consists of two callbacks for allocating
* and freeing memory and optional userdata so you can plugin your own allocator.
*
* The final and easiest way can be used by defining
* NK_INCLUDE_DEFAULT_ALLOCATOR which uses the standard library memory
* allocation functions malloc and free and takes over complete control over
* memory in this library.
*/
nk_memory_status :: struct {
	memory:    rawptr,
	type:      c.uint,
	size:      nk_size,
	allocated: nk_size,
	needed:    nk_size,
	calls:     nk_size,
}

nk_allocation_type :: enum c.int {
	FIXED,
	DYNAMIC,
}

nk_buffer_allocation_type :: enum c.int {
	FRONT,
	BACK,
	MAX,
}

nk_buffer_marker :: struct {
	active: nk_bool,
	offset: nk_size,
}

nk_memory :: struct {
	ptr:  rawptr,
	size: nk_size,
}

nk_buffer :: struct {
	marker: [2]nk_buffer_marker,

	/**!< buffer marker to free a buffer to a certain offset */
	pool: nk_allocator,

	/**!< allocator callback for dynamic buffers */
	type: nk_allocation_type,

	/**!< memory management type */
	memory: nk_memory,

	/**!< memory and size of the current memory block */
	grow_factor: f32,

	/**!< growing factor for dynamic memory management */
	allocated: nk_size,

	/**!< total amount of memory allocated */
	needed: nk_size,

	/**!< totally consumed memory given that enough memory is present */
	calls: nk_size,

	/**!< number of allocation calls */
	size: nk_size,
}

/** ==============================================================
*
*                          STRING
*
* ===============================================================*/
/**  Basic string buffer which is only used in context with the text editor
*  to manage and manipulate dynamic or fixed size string content. This is _NOT_
*  the default string handling method. The only instance you should have any contact
*  with this API is if you interact with an `nk_text_edit` object inside one of the
*  copy and paste functions and even there only for more advanced cases. */
nk_str :: struct {
	buffer: nk_buffer,
	len:    c.int,
}

NK_TEXTEDIT_UNDOSTATECOUNT     :: 99

NK_TEXTEDIT_UNDOCHARCOUNT      :: 999

nk_clipboard :: struct {
	userdata: nk_handle,
	paste:    nk_plugin_paste,
	copy:     nk_plugin_copy,
}

nk_text_undo_record :: struct {
	_where:        c.int,
	insert_length: c.short,
	delete_length: c.short,
	char_storage:  c.short,
}

nk_text_undo_state :: struct {
	undo_rec:        [99]nk_text_undo_record,
	undo_char:       [999]nk_rune,
	undo_point:      c.short,
	redo_point:      c.short,
	undo_char_point: c.short,
	redo_char_point: c.short,
}

nk_text_edit_type :: enum c.int {
	SINGLE_LINE,
	MULTI_LINE,
}

nk_text_edit_mode :: enum c.int {
	VIEW,
	INSERT,
	REPLACE,
}

nk_text_edit :: struct {
	clip:                  nk_clipboard,
	_string:               nk_str,
	filter:                nk_plugin_filter,
	scrollbar:             nk_vec2,
	cursor:                c.int,
	select_start:          c.int,
	select_end:            c.int,
	mode:                  c.uchar,
	cursor_at_end_of_line: c.uchar,
	initialized:           c.uchar,
	has_preferred_x:       c.uchar,
	single_line:           c.uchar,
	active:                c.uchar,
	padding1:              c.uchar,
	preferred_x:           f32,
	undo:                  nk_text_undo_state,
}

/* ===============================================================
*
*                          DRAWING
*
* ===============================================================*/
/**
* \page Drawing
* This library was designed to be render backend agnostic so it does
* not draw anything to screen. Instead all drawn shapes, widgets
* are made of, are buffered into memory and make up a command queue.
* Each frame therefore fills the command buffer with draw commands
* that then need to be executed by the user and his own render backend.
* After that the command buffer needs to be cleared and a new frame can be
* started. It is probably important to note that the command buffer is the main
* drawing API and the optional vertex buffer API only takes this format and
* converts it into a hardware accessible format.
*
* To use the command queue to draw your own widgets you can access the
* command buffer of each window by calling `nk_window_get_canvas` after
* previously having called `nk_begin`:
*
* ```c
*     void draw_red_rectangle_widget(struct nk_context *ctx)
*     {
*         struct nk_command_buffer *canvas;
*         struct nk_input *input = &ctx->input;
*         canvas = nk_window_get_canvas(ctx);
*
*         struct nk_rect space;
*         enum nk_widget_layout_states state;
*         state = nk_widget(&space, ctx);
*         if (!state) return;
*
*         if (state != NK_WIDGET_ROM)
*             update_your_widget_by_user_input(...);
*         nk_fill_rect(canvas, space, 0, nk_rgb(255,0,0));
*     }
*
*     if (nk_begin(...)) {
*         nk_layout_row_dynamic(ctx, 25, 1);
*         draw_red_rectangle_widget(ctx);
*     }
*     nk_end(..)
*
* ```
* Important to know if you want to create your own widgets is the `nk_widget`
* call. It allocates space on the panel reserved for this widget to be used,
* but also returns the state of the widget space. If your widget is not seen and does
* not have to be updated it is '0' and you can just return. If it only has
* to be drawn the state will be `NK_WIDGET_ROM` otherwise you can do both
* update and draw your widget. The reason for separating is to only draw and
* update what is actually necessary which is crucial for performance.
*/
nk_command_type :: enum c.int {
	NOP,
	SCISSOR,
	LINE,
	CURVE,
	RECT,
	RECT_FILLED,
	RECT_MULTI_COLOR,
	CIRCLE,
	CIRCLE_FILLED,
	ARC,
	ARC_FILLED,
	TRIANGLE,
	TRIANGLE_FILLED,
	POLYGON,
	POLYGON_FILLED,
	POLYLINE,
	TEXT,
	IMAGE,
	CUSTOM,
}

/** command base and header of every command inside the buffer */
nk_command :: struct {
	type: nk_command_type,
	next: nk_size,
}

nk_command_scissor :: struct {
	header: nk_command,
	x, y:   c.short,
	w, h:   c.ushort,
}

nk_command_line :: struct {
	header:         nk_command,
	line_thickness: c.ushort,
	begin:          nk_vec2i_,
	end:            nk_vec2i_,
	color:          nk_color,
}

nk_command_curve :: struct {
	header:         nk_command,
	line_thickness: c.ushort,
	begin:          nk_vec2i_,
	end:            nk_vec2i_,
	ctrl:           [2]nk_vec2i_,
	color:          nk_color,
}

nk_command_rect :: struct {
	header:         nk_command,
	rounding:       c.ushort,
	line_thickness: c.ushort,
	x, y:           c.short,
	w, h:           c.ushort,
	color:          nk_color,
}

nk_command_rect_filled :: struct {
	header:   nk_command,
	rounding: c.ushort,
	x, y:     c.short,
	w, h:     c.ushort,
	color:    nk_color,
}

nk_command_rect_multi_color :: struct {
	header: nk_command,
	x, y:   c.short,
	w, h:   c.ushort,
	left:   nk_color,
	top:    nk_color,
	bottom: nk_color,
	right:  nk_color,
}

nk_command_triangle :: struct {
	header:         nk_command,
	line_thickness: c.ushort,
	a:              nk_vec2i_,
	b:              nk_vec2i_,
	_c:             nk_vec2i_,
	color:          nk_color,
}

nk_command_triangle_filled :: struct {
	header: nk_command,
	a:      nk_vec2i_,
	b:      nk_vec2i_,
	_c:     nk_vec2i_,
	color:  nk_color,
}

nk_command_circle :: struct {
	header:         nk_command,
	x, y:           c.short,
	line_thickness: c.ushort,
	w, h:           c.ushort,
	color:          nk_color,
}

nk_command_circle_filled :: struct {
	header: nk_command,
	x, y:   c.short,
	w, h:   c.ushort,
	color:  nk_color,
}

nk_command_arc :: struct {
	header:         nk_command,
	cx, cy:         c.short,
	r:              c.ushort,
	line_thickness: c.ushort,
	a:              [2]f32,
	color:          nk_color,
}

nk_command_arc_filled :: struct {
	header: nk_command,
	cx, cy: c.short,
	r:      c.ushort,
	a:      [2]f32,
	color:  nk_color,
}

nk_command_polygon :: struct {
	header:         nk_command,
	color:          nk_color,
	line_thickness: c.ushort,
	point_count:    c.ushort,
	points:         [1]nk_vec2i_,
}

nk_command_polygon_filled :: struct {
	header:      nk_command,
	color:       nk_color,
	point_count: c.ushort,
	points:      [1]nk_vec2i_,
}

nk_command_polyline :: struct {
	header:         nk_command,
	color:          nk_color,
	line_thickness: c.ushort,
	point_count:    c.ushort,
	points:         [1]nk_vec2i_,
}

nk_command_image :: struct {
	header: nk_command,
	x, y:   c.short,
	w, h:   c.ushort,
	img:    nk_image,
	col:    nk_color,
}

nk_command_custom_callback :: proc "c" (rawptr, c.short, c.short, c.ushort, c.ushort, nk_handle)

nk_command_custom :: struct {
	header:        nk_command,
	x, y:          c.short,
	w, h:          c.ushort,
	callback_data: nk_handle,
	callback:      nk_command_custom_callback,
}

nk_command_text :: struct {
	header:     nk_command,
	font:       ^nk_user_font,
	background: nk_color,
	foreground: nk_color,
	x, y:       c.short,
	w, h:       c.ushort,
	height:     f32,
	length:     c.int,
	_string:    [2]c.char,
}

nk_command_clipping :: enum c.int {
	FF = 0,
	N  = 1,
}

nk_command_buffer :: struct {
	base:             ^nk_buffer,
	clip:             nk_rect,
	use_clipping:     c.int,
	userdata:         nk_handle,
	begin, end, last: nk_size,
}

/* ===============================================================
*
*                          INPUT
*
* ===============================================================*/
nk_mouse_button :: struct {
	down:        nk_bool,
	clicked:     c.uint,
	clicked_pos: nk_vec2,
}

nk_mouse :: struct {
	buttons:      [4]nk_mouse_button,
	pos:          nk_vec2,
	prev:         nk_vec2,
	delta:        nk_vec2,
	scroll_delta: nk_vec2,
	grab:         c.uchar,
	grabbed:      c.uchar,
	ungrab:       c.uchar,
}

nk_key :: struct {
	down:    nk_bool,
	clicked: c.uint,
}

nk_keyboard :: struct {
	keys:     [30]nk_key,
	text:     [16]c.char,
	text_len: c.int,
}

nk_input :: struct {
	keyboard: nk_keyboard,
	mouse:    nk_mouse,
}

nk_draw_index :: nk_ushort

nk_draw_list_stroke :: enum c.int {
	OPEN   = 0,

	/***< build up path has no connection back to the beginning */
	CLOSED = 1,
}

nk_draw_vertex_layout_attribute :: enum c.int {
	POSITION,
	COLOR,
	TEXCOORD,
	ATTRIBUTE_COUNT,
}

nk_draw_vertex_layout_format :: enum c.int {
	SCHAR,
	SSHORT,
	SINT,
	UCHAR,
	USHORT,
	UINT,
	FLOAT,
	DOUBLE,
	COLOR_BEGIN,
	R8G8B8 = 8,
	R16G15B16,
	R32G32B32,
	R8G8B8A8,
	B8G8R8A8,
	R16G15B16A16,
	R32G32B32A32,
	R32G32B32A32_FLOAT,
	R32G32B32A32_DOUBLE,
	RGB32,
	RGBA32,
	COLOR_END = 18,
	COUNT,
}

nk_draw_vertex_layout_element :: struct {
	attribute: nk_draw_vertex_layout_attribute,
	format:    nk_draw_vertex_layout_format,
	offset:    nk_size,
}

nk_draw_command :: struct {
	elem_count: c.uint,    /**< number of elements in the current draw batch */
	clip_rect:  nk_rect,   /**< current screen clipping rectangle */
	texture:    nk_handle, /**< current texture to set */
}

nk_draw_list :: struct {
	clip_rect:     nk_rect,
	circle_vtx:    [12]nk_vec2,
	config:        nk_convert_config,
	buffer:        ^nk_buffer,
	vertices:      ^nk_buffer,
	elements:      ^nk_buffer,
	element_count: c.uint,
	vertex_count:  c.uint,
	cmd_count:     c.uint,
	cmd_offset:    nk_size,
	path_count:    c.uint,
	path_offset:   c.uint,
	line_AA:       nk_anti_aliasing,
	shape_AA:      nk_anti_aliasing,
}

/* ===============================================================
*
*                          GUI
*
* ===============================================================*/
nk_style_item_type :: enum c.int {
	COLOR,
	IMAGE,
	NINE_SLICE,
}

nk_style_item_data :: struct #raw_union {
	color: nk_color,
	image: nk_image,
	slice: nk_nine_slice,
}

nk_style_item :: struct {
	type: nk_style_item_type,
	data:nk_style_item_data,
}

nk_style_text :: struct {
	color:           nk_color,
	padding:         nk_vec2,
	color_factor:    f32,
	disabled_factor: f32,
}

nk_style_button :: struct {
	/* background */
	normal: nk_style_item,
	hover:                   nk_style_item,
	active:                  nk_style_item,
	border_color:            nk_color,
	color_factor_background: f32,

	/* text */
	text_background: nk_color,
	text_normal:             nk_color,
	text_hover:              nk_color,
	text_active:             nk_color,
	text_alignment:          nk_flags,
	color_factor_text:       f32,

	/* properties */
	border: f32,
	rounding:                f32,
	padding:                 nk_vec2,
	image_padding:           nk_vec2,
	touch_padding:           nk_vec2,
	disabled_factor:         f32,

	/* optional user callbacks */
	userdata: nk_handle,
	draw_begin:              proc "c" (^nk_command_buffer, nk_handle),
	draw_end:                proc "c" (^nk_command_buffer, nk_handle),
}

nk_style_toggle :: struct {
	/* background */
	normal: nk_style_item,
	hover:           nk_style_item,
	active:          nk_style_item,
	border_color:    nk_color,

	/* cursor */
	cursor_normal: nk_style_item,
	cursor_hover:    nk_style_item,

	/* text */
	text_normal: nk_color,
	text_hover:      nk_color,
	text_active:     nk_color,
	text_background: nk_color,
	text_alignment:  nk_flags,

	/* properties */
	padding: nk_vec2,
	touch_padding:   nk_vec2,
	spacing:         f32,
	border:          f32,
	color_factor:    f32,
	disabled_factor: f32,

	/* optional user callbacks */
	userdata: nk_handle,
	draw_begin:      proc "c" (^nk_command_buffer, nk_handle),
	draw_end:        proc "c" (^nk_command_buffer, nk_handle),
}

nk_style_selectable :: struct {
	/* background (inactive) */
	normal: nk_style_item,
	hover:               nk_style_item,
	pressed:             nk_style_item,

	/* background (active) */
	normal_active: nk_style_item,
	hover_active:        nk_style_item,
	pressed_active:      nk_style_item,

	/* text color (inactive) */
	text_normal: nk_color,
	text_hover:          nk_color,
	text_pressed:        nk_color,

	/* text color (active) */
	text_normal_active: nk_color,
	text_hover_active:   nk_color,
	text_pressed_active: nk_color,
	text_background:     nk_color,
	text_alignment:      nk_flags,

	/* properties */
	rounding: f32,
	padding:             nk_vec2,
	touch_padding:       nk_vec2,
	image_padding:       nk_vec2,
	color_factor:        f32,
	disabled_factor:     f32,

	/* optional user callbacks */
	userdata: nk_handle,
	draw_begin:          proc "c" (^nk_command_buffer, nk_handle),
	draw_end:            proc "c" (^nk_command_buffer, nk_handle),
}

nk_style_slider :: struct {
	/* background */
	normal: nk_style_item,
	hover:           nk_style_item,
	active:          nk_style_item,
	border_color:    nk_color,

	/* background bar */
	bar_normal: nk_color,
	bar_hover:       nk_color,
	bar_active:      nk_color,
	bar_filled:      nk_color,

	/* cursor */
	cursor_normal: nk_style_item,
	cursor_hover:    nk_style_item,
	cursor_active:   nk_style_item,

	/* properties */
	border: f32,
	rounding:        f32,
	bar_height:      f32,
	padding:         nk_vec2,
	spacing:         nk_vec2,
	cursor_size:     nk_vec2,
	color_factor:    f32,
	disabled_factor: f32,

	/* optional buttons */
	show_buttons: c.int,
	inc_button:      nk_style_button,
	dec_button:      nk_style_button,
	inc_symbol:      nk_symbol_type,
	dec_symbol:      nk_symbol_type,

	/* optional user callbacks */
	userdata: nk_handle,
	draw_begin:      proc "c" (^nk_command_buffer, nk_handle),
	draw_end:        proc "c" (^nk_command_buffer, nk_handle),
}

nk_style_knob :: struct {
	/* background */
	normal: nk_style_item,
	hover:             nk_style_item,
	active:            nk_style_item,
	border_color:      nk_color,

	/* knob */
	knob_normal: nk_color,
	knob_hover:        nk_color,
	knob_active:       nk_color,
	knob_border_color: nk_color,

	/* cursor */
	cursor_normal: nk_color,
	cursor_hover:      nk_color,
	cursor_active:     nk_color,

	/* properties */
	border: f32,
	knob_border:       f32,
	padding:           nk_vec2,
	spacing:           nk_vec2,
	cursor_width:      f32,
	color_factor:      f32,
	disabled_factor:   f32,

	/* optional user callbacks */
	userdata: nk_handle,
	draw_begin:        proc "c" (^nk_command_buffer, nk_handle),
	draw_end:          proc "c" (^nk_command_buffer, nk_handle),
}

nk_style_progress :: struct {
	/* background */
	normal: nk_style_item,
	hover:               nk_style_item,
	active:              nk_style_item,
	border_color:        nk_color,

	/* cursor */
	cursor_normal: nk_style_item,
	cursor_hover:        nk_style_item,
	cursor_active:       nk_style_item,
	cursor_border_color: nk_color,

	/* properties */
	rounding: f32,
	border:              f32,
	cursor_border:       f32,
	cursor_rounding:     f32,
	padding:             nk_vec2,
	color_factor:        f32,
	disabled_factor:     f32,

	/* optional user callbacks */
	userdata: nk_handle,
	draw_begin:          proc "c" (^nk_command_buffer, nk_handle),
	draw_end:            proc "c" (^nk_command_buffer, nk_handle),
}

nk_style_scrollbar :: struct {
	/* background */
	normal: nk_style_item,
	hover:               nk_style_item,
	active:              nk_style_item,
	border_color:        nk_color,

	/* cursor */
	cursor_normal: nk_style_item,
	cursor_hover:        nk_style_item,
	cursor_active:       nk_style_item,
	cursor_border_color: nk_color,

	/* properties */
	border: f32,
	rounding:            f32,
	border_cursor:       f32,
	rounding_cursor:     f32,
	padding:             nk_vec2,
	color_factor:        f32,
	disabled_factor:     f32,

	/* optional buttons */
	show_buttons: c.int,
	inc_button:          nk_style_button,
	dec_button:          nk_style_button,
	inc_symbol:          nk_symbol_type,
	dec_symbol:          nk_symbol_type,

	/* optional user callbacks */
	userdata: nk_handle,
	draw_begin:          proc "c" (^nk_command_buffer, nk_handle),
	draw_end:            proc "c" (^nk_command_buffer, nk_handle),
}

nk_style_edit :: struct {
	/* background */
	normal: nk_style_item,
	hover:                nk_style_item,
	active:               nk_style_item,
	border_color:         nk_color,
	scrollbar:            nk_style_scrollbar,

	/* cursor  */
	cursor_normal: nk_color,
	cursor_hover:         nk_color,
	cursor_text_normal:   nk_color,
	cursor_text_hover:    nk_color,

	/* text (unselected) */
	text_normal: nk_color,
	text_hover:           nk_color,
	text_active:          nk_color,

	/* text (selected) */
	selected_normal: nk_color,
	selected_hover:       nk_color,
	selected_text_normal: nk_color,
	selected_text_hover:  nk_color,

	/* properties */
	border: f32,
	rounding:             f32,
	cursor_size:          f32,
	scrollbar_size:       nk_vec2,
	padding:              nk_vec2,
	row_padding:          f32,
	color_factor:         f32,
	disabled_factor:      f32,
}

nk_style_property :: struct {
	/* background */
	normal: nk_style_item,
	hover:           nk_style_item,
	active:          nk_style_item,
	border_color:    nk_color,

	/* text */
	label_normal: nk_color,
	label_hover:     nk_color,
	label_active:    nk_color,

	/* symbols */
	sym_left: nk_symbol_type,
	sym_right:       nk_symbol_type,

	/* properties */
	border: f32,
	rounding:        f32,
	padding:         nk_vec2,
	color_factor:    f32,
	disabled_factor: f32,
	edit:            nk_style_edit,
	inc_button:      nk_style_button,
	dec_button:      nk_style_button,

	/* optional user callbacks */
	userdata: nk_handle,
	draw_begin:      proc "c" (^nk_command_buffer, nk_handle),
	draw_end:        proc "c" (^nk_command_buffer, nk_handle),
}

nk_style_chart :: struct {
	/* colors */
	background: nk_style_item,
	border_color:    nk_color,
	selected_color:  nk_color,
	color:           nk_color,

	/* properties */
	border: f32,
	rounding:        f32,
	padding:         nk_vec2,
	color_factor:    f32,
	disabled_factor: f32,
	show_markers:    nk_bool,
}

nk_style_combo :: struct {
	/* background */
	normal: nk_style_item,
	hover:           nk_style_item,
	active:          nk_style_item,
	border_color:    nk_color,

	/* label */
	label_normal: nk_color,
	label_hover:     nk_color,
	label_active:    nk_color,

	/* symbol */
	symbol_normal: nk_color,
	symbol_hover:    nk_color,
	symbol_active:   nk_color,

	/* button */
	button: nk_style_button,
	sym_normal:      nk_symbol_type,
	sym_hover:       nk_symbol_type,
	sym_active:      nk_symbol_type,

	/* properties */
	border: f32,
	rounding:        f32,
	content_padding: nk_vec2,
	button_padding:  nk_vec2,
	spacing:         nk_vec2,
	color_factor:    f32,
	disabled_factor: f32,
}

nk_style_tab :: struct {
	/* background */
	background: nk_style_item,
	border_color:         nk_color,
	text:                 nk_color,

	/* button */
	tab_maximize_button: nk_style_button,
	tab_minimize_button:  nk_style_button,
	node_maximize_button: nk_style_button,
	node_minimize_button: nk_style_button,
	sym_minimize:         nk_symbol_type,
	sym_maximize:         nk_symbol_type,

	/* properties */
	border: f32,
	rounding:             f32,
	indent:               f32,
	padding:              nk_vec2,
	spacing:              nk_vec2,
	color_factor:         f32,
	disabled_factor:      f32,
}

nk_style_header_align :: enum c.int {
	LEFT,
	RIGHT,
}

nk_style_window_header :: struct {
	/* background */
	normal: nk_style_item,
	hover:           nk_style_item,
	active:          nk_style_item,

	/* button */
	close_button: nk_style_button,
	minimize_button: nk_style_button,
	close_symbol:    nk_symbol_type,
	minimize_symbol: nk_symbol_type,
	maximize_symbol: nk_symbol_type,

	/* title */
	label_normal: nk_color,
	label_hover:     nk_color,
	label_active:    nk_color,

	/* properties */
	align: nk_style_header_align,
	padding:         nk_vec2,
	label_padding:   nk_vec2,
	spacing:         nk_vec2,
}

nk_style_window :: struct {
	header:                  nk_style_window_header,
	fixed_background:        nk_style_item,
	background:              nk_color,
	border_color:            nk_color,
	popup_border_color:      nk_color,
	combo_border_color:      nk_color,
	contextual_border_color: nk_color,
	menu_border_color:       nk_color,
	group_border_color:      nk_color,
	tooltip_border_color:    nk_color,
	scaler:                  nk_style_item,
	border:                  f32,
	combo_border:            f32,
	contextual_border:       f32,
	menu_border:             f32,
	group_border:            f32,
	tooltip_border:          f32,
	popup_border:            f32,
	min_row_height_padding:  f32,
	rounding:                f32,
	spacing:                 nk_vec2,
	scrollbar_size:          nk_vec2,
	min_size:                nk_vec2,
	padding:                 nk_vec2,
	group_padding:           nk_vec2,
	popup_padding:           nk_vec2,
	combo_padding:           nk_vec2,
	contextual_padding:      nk_vec2,
	menu_padding:            nk_vec2,
	tooltip_padding:         nk_vec2,
}

nk_style :: struct {
	font:              ^nk_user_font,
	cursors:           [7]^nk_cursor,
	cursor_active:     ^nk_cursor,
	cursor_last:       ^nk_cursor,
	cursor_visible:    c.int,
	text:              nk_style_text,
	button:            nk_style_button,
	contextual_button: nk_style_button,
	menu_button:       nk_style_button,
	option:            nk_style_toggle,
	checkbox:          nk_style_toggle,
	selectable:        nk_style_selectable,
	slider:            nk_style_slider,
	knob:              nk_style_knob,
	progress:          nk_style_progress,
	property:          nk_style_property,
	edit:              nk_style_edit,
	chart:             nk_style_chart,
	scrollh:           nk_style_scrollbar,
	scrollv:           nk_style_scrollbar,
	tab:               nk_style_tab,
	combo:             nk_style_combo,
	window:            nk_style_window,
}

NK_MAX_LAYOUT_ROW_TEMPLATE_COLUMNS :: 16

NK_CHART_MAX_SLOT :: 4

nk_panel_type :: enum c.int {
	NONE       = 0,
	WINDOW     = 1,
	GROUP      = 2,
	POPUP      = 4,
	CONTEXTUAL = 16,
	COMBO      = 32,
	MENU       = 64,
	TOOLTIP    = 128,
}

nk_panel_set :: enum c.int {
	NONBLOCK = 240,
	POPUP    = 244,
	SUB      = 246,
}

nk_chart_slot :: struct {
	type:            nk_chart_type,
	color:           nk_color,
	highlight:       nk_color,
	min, max, range: f32,
	count:           c.int,
	last:            nk_vec2,
	index:           c.int,
	show_markers:    nk_bool,
}

nk_chart :: struct {
	slot:       c.int,
	x, y, w, h: f32,
	slots:      [4]nk_chart_slot,
}

nk_panel_row_layout_type :: enum c.int {
	DYNAMIC_FIXED = 0,
	DYNAMIC_ROW,
	DYNAMIC_FREE,
	DYNAMIC,
	STATIC_FIXED,
	STATIC_ROW,
	STATIC_FREE,
	STATIC,
	TEMPLATE,
	COUNT,
}

nk_row_layout :: struct {
	type:        nk_panel_row_layout_type,
	index:       c.int,
	height:      f32,
	min_height:  f32,
	columns:     c.int,
	ratio:       ^f32,
	item_width:  f32,
	item_height: f32,
	item_offset: f32,
	filled:      f32,
	item:        nk_rect,
	tree_depth:  c.int,
	templates:   [16]f32,
}

nk_popup_buffer :: struct {
	begin:  nk_size,
	parent: nk_size,
	last:   nk_size,
	end:    nk_size,
	active: nk_bool,
}

nk_menu_state :: struct {
	x, y, w, h: f32,
	offset:     nk_scroll,
}

nk_panel :: struct {
	type:              nk_panel_type,
	flags:             nk_flags,
	bounds:            nk_rect,
	offset_x:          ^nk_uint,
	offset_y:          ^nk_uint,
	at_x, at_y, max_x: f32,
	footer_height:     f32,
	header_height:     f32,
	border:            f32,
	has_scrolling:     c.uint,
	clip:              nk_rect,
	menu:              nk_menu_state,
	row:               nk_row_layout,
	chart:             nk_chart,
	buffer:            ^nk_command_buffer,
	parent:            ^nk_panel,
}

NK_WINDOW_MAX_NAME :: 64

nk_window_flags :: enum c.int {
	PRIVATE         = 2048,
	DYNAMIC         = 2048,  /**< special window type growing up in height while being filled to a certain maximum height */
	ROM             = 4096,  /**< sets window widgets into a read only mode and does not allow input changes */
	NOT_INTERACTIVE = 5120,  /**< prevents all interaction caused by input to either window or widgets inside */
	HIDDEN          = 8192,  /**< Hides window and stops any window interaction and drawing */
	CLOSED          = 16384, /**< Directly closes and frees the window at the end of the frame */
	MINIMIZED       = 32768, /**< marks the window as minimized */
	REMOVE_ROM      = 65536, /**< Removes read only mode at the end of the window */
}

nk_popup_state :: struct {
	win:                ^nk_window,
	type:               nk_panel_type,
	buf:                nk_popup_buffer,
	name:               nk_hash,
	active:             nk_bool,
	combo_count:        c.uint,
	con_count, con_old: c.uint,
	active_con:         c.uint,
	header:             nk_rect,
}

nk_edit_state :: struct {
	name:         nk_hash,
	seq:          c.uint,
	old:          c.uint,
	active, prev: c.int,
	cursor:       c.int,
	sel_start:    c.int,
	sel_end:      c.int,
	scrollbar:    nk_scroll,
	mode:         c.uchar,
	single_line:  c.uchar,
}

nk_property_state :: struct {
	active, prev: c.int,
	buffer:       [64]c.char,
	length:       c.int,
	cursor:       c.int,
	select_start: c.int,
	select_end:   c.int,
	name:         nk_hash,
	seq:          c.uint,
	old:          c.uint,
	state:        c.int,
}

nk_window :: struct {
	seq:                    c.uint,
	name:                   nk_hash,
	name_string:            [64]c.char,
	flags:                  nk_flags,
	bounds:                 nk_rect,
	scrollbar:              nk_scroll,
	buffer:                 nk_command_buffer,
	layout:                 ^nk_panel,
	scrollbar_hiding_timer: f32,

	/* persistent widget state */
	property: nk_property_state,
	popup:                  nk_popup_state,
	edit:                   nk_edit_state,
	scrolled:               c.uint,
	widgets_disabled:       nk_bool,
	tables:                 ^nk_table,
	table_count:            c.uint,

	/* window list hooks */
	next: ^nk_window,
	prev:                   ^nk_window,
	parent:                 ^nk_window,
}

nk_config_stack_style_item_element :: struct {
	address:   ^nk_style_item,
	old_value: nk_style_item,
}

nk_config_stack_float_element :: struct {
	address:   ^f32,
	old_value: f32,
}

nk_config_stack_vec2_element :: struct {
	address:   ^nk_vec2,
	old_value: nk_vec2,
}

nk_config_stack_flags_element :: struct {
	address:   ^nk_flags,
	old_value: nk_flags,
}

nk_config_stack_color_element :: struct {
	address:   ^nk_color,
	old_value: nk_color,
}

nk_config_stack_user_font_element :: struct {
	address:   ^^nk_user_font,
	old_value: ^nk_user_font,
}

nk_config_stack_button_behavior_element :: struct {
	address:   ^nk_button_behavior,
	old_value: nk_button_behavior,
}

nk_config_stack_style_item :: struct {
	head:     c.int,
	elements: [16]nk_config_stack_style_item_element,
}

nk_config_stack_float :: struct {
	head:     c.int,
	elements: [32]nk_config_stack_float_element,
}

nk_config_stack_vec2 :: struct {
	head:     c.int,
	elements: [16]nk_config_stack_vec2_element,
}

nk_config_stack_flags :: struct {
	head:     c.int,
	elements: [32]nk_config_stack_flags_element,
}

nk_config_stack_color :: struct {
	head:     c.int,
	elements: [32]nk_config_stack_color_element,
}

nk_config_stack_user_font :: struct {
	head:     c.int,
	elements: [8]nk_config_stack_user_font_element,
}

nk_config_stack_button_behavior :: struct {
	head:     c.int,
	elements: [8]nk_config_stack_button_behavior_element,
}

NK_BUTTON_BEHAVIOR_STACK_SIZE :: 8

NK_FONT_STACK_SIZE :: 8

NK_STYLE_ITEM_STACK_SIZE :: 16

NK_FLOAT_STACK_SIZE :: 32

NK_VECTOR_STACK_SIZE :: 16

NK_FLAGS_STACK_SIZE :: 32

NK_COLOR_STACK_SIZE :: 32

nk_float :: f32

nk_configuration_stacks :: struct {
	style_items:      nk_config_stack_style_item,
	floats:           nk_config_stack_float,
	vectors:          nk_config_stack_vec2,
	flags:            nk_config_stack_flags,
	colors:           nk_config_stack_color,
	fonts:            nk_config_stack_user_font,
	button_behaviors: nk_config_stack_button_behavior,
}

// NK_VALUE_PAGE_CAPACITY :: ((((sizeof(struct nk_window)) < (sizeof(struct nk_panel)) ? (sizeof(struct nk_panel)) : (sizeof(struct nk_window))) / sizeof(nk_uint))) / 2

nk_table :: struct {
	seq:        c.uint,
	size:       c.uint,
	keys:       [60]nk_hash,
	values:     [60]nk_uint,
	next, prev: ^nk_table,
}

nk_page_data :: struct #raw_union {
	tbl: nk_table,
	pan: nk_panel,
	win: nk_window,
}

nk_page_element :: struct {
	data:nk_page_data,
	next: ^nk_page_element,
	prev: ^nk_page_element,
}

nk_page :: struct {
	size: c.uint,
	next: ^nk_page,
	win:  [1]nk_page_element,
}

nk_pool :: struct {
	alloc:      nk_allocator,
	type:       nk_allocation_type,
	page_count: c.uint,
	pages:      ^nk_page,
	freelist:   ^nk_page_element,
	capacity:   c.uint,
	size:       nk_size,
	cap:        nk_size,
}

nk_context :: struct {
	/* public: can be accessed freely */
	input:              nk_input,
	style:              nk_style,
	memory:             nk_buffer,
	clip:               nk_clipboard,
	last_widget_state:  nk_flags,
	button_behavior:    nk_button_behavior,
	stacks:             nk_configuration_stacks,
	delta_time_seconds: f32,
	draw_list:          nk_draw_list,

	/** text editor objects are quite big because of an internal
	* undo/redo stack. Therefore it does not make sense to have one for
	* each window for temporary use cases, so I only provide *one* instance
	* for all windows. This works because the content is cleared anyway */
	text_edit: nk_text_edit,

	/** draw buffer used for overlay drawing operation like cursor */
	overlay: nk_command_buffer,

	/** windows */
	build: c.int,
	use_pool:           c.int,
	pool:               nk_pool,
	begin:              ^nk_window,
	end:                ^nk_window,
	active:             ^nk_window,
	current:            ^nk_window,
	freelist:           ^nk_page_element,
	count:              c.uint,
	seq:                c.uint,
}

/* ==============================================================
 *                          MATH
 * =============================================================== */
NK_PI :: 3.141592654
NK_PI_HALF :: 1.570796326

NK_MAX_FLOAT_PRECISION :: 2