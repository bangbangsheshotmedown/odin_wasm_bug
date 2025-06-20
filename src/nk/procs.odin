package nuklear

import "core:c"

when ODIN_OS == .Windows
{
   foreign import lib "lib/nuklear.lib"
}
else when ODIN_OS == .Linux
{
   foreign import lib "lib/nuklear.a"
}
else when ODIN_OS == .JS || ODIN_OS == .Freestanding
{
   foreign import lib "lib/nuklear-wasm.o"
}



@(default_calling_convention="c", link_prefix="")
foreign lib {

	/**
	* # nk_init_fixed
	* Initializes a `nk_context` struct from single fixed size memory block
	* Should be used if you want complete control over nuklear's memory management.
	* Especially recommended for system with little memory or systems with virtual memory.
	* For the later case you can just allocate for example 16MB of virtual memory
	* and only the required amount of memory will actually be committed.
	*
	* ```c
	* nk_bool nk_init_fixed(struct nk_context *ctx, void *memory, nk_size size, const struct nk_user_font *font);
	* ```
	*
	* !!! Warning
	*     make sure the passed memory block is aligned correctly for `nk_draw_commands`.
	*
	* Parameter   | Description
	* ------------|--------------------------------------------------------------
	* \param[in] ctx     | Must point to an either stack or heap allocated `nk_context` struct
	* \param[in] memory  | Must point to a previously allocated memory block
	* \param[in] size    | Must contain the total size of memory
	* \param[in] font    | Must point to a previously initialized font handle for more info look at font documentation
	*
	* \returns either `false(0)` on failure or `true(1)` on success.
	*/
	nk_init_fixed :: proc(_: ^nk_context, memory: rawptr, size: nk_size, _: ^nk_user_font) -> nk_bool ---

	/**
	* # nk_init
	* Initializes a `nk_context` struct with memory allocation callbacks for nuklear to allocate
	* memory from. Used internally for `nk_init_default` and provides a kitchen sink allocation
	* interface to nuklear. Can be useful for cases like monitoring memory consumption.
	*
	* ```c
	* nk_bool nk_init(struct nk_context *ctx, const struct nk_allocator *alloc, const struct nk_user_font *font);
	* ```
	*
	* Parameter   | Description
	* ------------|---------------------------------------------------------------
	* \param[in] ctx     | Must point to an either stack or heap allocated `nk_context` struct
	* \param[in] alloc   | Must point to a previously allocated memory allocator
	* \param[in] font    | Must point to a previously initialized font handle for more info look at font documentation
	*
	* \returns either `false(0)` on failure or `true(1)` on success.
	*/
	nk_init :: proc(_: ^nk_context, _: ^nk_allocator, _: ^nk_user_font) -> nk_bool ---

	/**
	* \brief Initializes a `nk_context` struct from two different either fixed or growing buffers.
	*
	* \details
	* The first buffer is for allocating draw commands while the second buffer is
	* used for allocating windows, panels and state tables.
	*
	* ```c
	* nk_bool nk_init_custom(struct nk_context *ctx, struct nk_buffer *cmds, struct nk_buffer *pool, const struct nk_user_font *font);
	* ```
	*
	* \param[in] ctx    Must point to an either stack or heap allocated `nk_context` struct
	* \param[in] cmds   Must point to a previously initialized memory buffer either fixed or dynamic to store draw commands into
	* \param[in] pool   Must point to a previously initialized memory buffer either fixed or dynamic to store windows, panels and tables
	* \param[in] font   Must point to a previously initialized font handle for more info look at font documentation
	*
	* \returns either `false(0)` on failure or `true(1)` on success.
	*/
	nk_init_custom :: proc(_: ^nk_context, cmds: ^nk_buffer, pool: ^nk_buffer, _: ^nk_user_font) -> nk_bool ---

	/**
	* \brief Resets the context state at the end of the frame.
	*
	* \details
	* This includes mostly garbage collector tasks like removing windows or table
	* not called and therefore used anymore.
	*
	* ```c
	* void nk_clear(struct nk_context *ctx);
	* ```
	*
	* \param[in] ctx  Must point to a previously initialized `nk_context` struct
	*/
	nk_clear :: proc(_: ^nk_context) ---

	/**
	* \brief Frees all memory allocated by nuklear; Not needed if context was initialized with `nk_init_fixed`.
	*
	* \details
	* ```c
	* void nk_free(struct nk_context *ctx);
	* ```
	*
	* \param[in] ctx  Must point to a previously initialized `nk_context` struct
	*/
	nk_free :: proc(_: ^nk_context) ---

	/**
	* \brief Begins the input mirroring process by resetting text, scroll
	* mouse, previous mouse position and movement as well as key state transitions.
	*
	* \details
	* ```c
	* void nk_input_begin(struct nk_context*);
	* ```
	*
	* \param[in] ctx Must point to a previously initialized `nk_context` struct
	*/
	nk_input_begin :: proc(_: ^nk_context) ---

	/**
	* \brief Mirrors current mouse position to nuklear
	*
	* \details
	* ```c
	* void nk_input_motion(struct nk_context *ctx, int x, int y);
	* ```
	*
	* \param[in] ctx   Must point to a previously initialized `nk_context` struct
	* \param[in] x     Must hold an integer describing the current mouse cursor x-position
	* \param[in] y     Must hold an integer describing the current mouse cursor y-position
	*/
	nk_input_motion :: proc(_: ^nk_context, x: c.int, y: c.int) ---

	/**
	* \brief Mirrors the state of a specific key to nuklear
	*
	* \details
	* ```c
	* void nk_input_key(struct nk_context*, enum nk_keys key, nk_bool down);
	* ```
	*
	* \param[in] ctx      Must point to a previously initialized `nk_context` struct
	* \param[in] key      Must be any value specified in enum `nk_keys` that needs to be mirrored
	* \param[in] down     Must be 0 for key is up and 1 for key is down
	*/
	nk_input_key :: proc(_: ^nk_context, _: nk_keys, down: nk_bool) ---

	/**
	* \brief Mirrors the state of a specific mouse button to nuklear
	*
	* \details
	* ```c
	* void nk_input_button(struct nk_context *ctx, enum nk_buttons btn, int x, int y, nk_bool down);
	* ```
	*
	* \param[in] ctx     Must point to a previously initialized `nk_context` struct
	* \param[in] btn     Must be any value specified in enum `nk_buttons` that needs to be mirrored
	* \param[in] x       Must contain an integer describing mouse cursor x-position on click up/down
	* \param[in] y       Must contain an integer describing mouse cursor y-position on click up/down
	* \param[in] down    Must be 0 for key is up and 1 for key is down
	*/
	nk_input_button :: proc(_: ^nk_context, _: nk_buttons, x: c.int, y: c.int, down: nk_bool) ---

	/**
	* \brief Copies the last mouse scroll value to nuklear.
	*
	* \details
	* Is generally a scroll value. So does not have to come from mouse and could
	* also originate from balls, tracks, linear guide rails, or other programs.
	*
	* ```c
	* void nk_input_scroll(struct nk_context *ctx, struct nk_vec2 val);
	* ```
	*
	* \param[in] ctx     | Must point to a previously initialized `nk_context` struct
	* \param[in] val     | vector with both X- as well as Y-scroll value
	*/
	nk_input_scroll :: proc(_: ^nk_context, val: nk_vec2) ---

	/**
	* \brief Copies a single ASCII character into an internal text buffer
	*
	* \details
	* This is basically a helper function to quickly push ASCII characters into
	* nuklear.
	*
	* \note
	*     Stores up to NK_INPUT_MAX bytes between `nk_input_begin` and `nk_input_end`.
	*
	* ```c
	* void nk_input_char(struct nk_context *ctx, char c);
	* ```
	*
	* \param[in] ctx     | Must point to a previously initialized `nk_context` struct
	* \param[in] c       | Must be a single ASCII character preferable one that can be printed
	*/
	nk_input_char :: proc(_: ^nk_context, _: c.char) ---

	/**
	* \brief Converts an encoded unicode rune into UTF-8 and copies the result into an
	* internal text buffer.
	*
	* \note
	*     Stores up to NK_INPUT_MAX bytes between `nk_input_begin` and `nk_input_end`.
	*
	* ```c
	* void nk_input_glyph(struct nk_context *ctx, const nk_glyph g);
	* ```
	*
	* \param[in] ctx     | Must point to a previously initialized `nk_context` struct
	* \param[in] g       | UTF-32 unicode codepoint
	*/
	nk_input_glyph :: proc(_: ^nk_context, _: cstring) ---

	/**
	* \brief Converts a unicode rune into UTF-8 and copies the result
	* into an internal text buffer.
	*
	* \details
	* \note
	*     Stores up to NK_INPUT_MAX bytes between `nk_input_begin` and `nk_input_end`.
	*
	* ```c
	* void nk_input_unicode(struct nk_context*, nk_rune rune);
	* ```
	*
	* \param[in] ctx     | Must point to a previously initialized `nk_context` struct
	* \param[in] rune    | UTF-32 unicode codepoint
	*/
	nk_input_unicode :: proc(_: ^nk_context, _: nk_rune) ---

	/**
	* \brief End the input mirroring process by resetting mouse grabbing
	* state to ensure the mouse cursor is not grabbed indefinitely.
	*
	* \details
	* ```c
	* void nk_input_end(struct nk_context *ctx);
	* ```
	*
	* \param[in] ctx     | Must point to a previously initialized `nk_context` struct
	*/
	nk_input_end :: proc(_: ^nk_context) ---

	/**
	* \brief Returns draw command pointer pointing to the next command inside the draw command list
	*
	* \details
	* ```c
	* const struct nk_command* nk__next(struct nk_context*, const struct nk_command*);
	* ```
	*
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct at the end of a frame
	* \param[in] cmd     | Must point to an previously a draw command either returned by `nk__begin` or `nk__next`
	*
	* \returns draw command pointer pointing to the next command inside the draw command list
	*/
	nk__next :: proc(_: ^nk_context, _: ^nk_command) -> ^nk_command ---

	/**
	* \brief Converts all internal draw commands into vertex draw commands and fills
	* three buffers with vertexes, vertex draw commands and vertex indices.
	*
	* \details
	* The vertex format as well as some other configuration values have to be
	* configured by filling out a `nk_convert_config` struct.
	*
	* ```c
	* nk_flags nk_convert(struct nk_context *ctx, struct nk_buffer *cmds,
	*     struct nk_buffer *vertices, struct nk_buffer *elements, const struct nk_convert_config*);
	* ```
	*
	* \param[in] ctx      Must point to an previously initialized `nk_context` struct at the end of a frame
	* \param[out] cmds     Must point to a previously initialized buffer to hold converted vertex draw commands
	* \param[out] vertices Must point to a previously initialized buffer to hold all produced vertices
	* \param[out] elements Must point to a previously initialized buffer to hold all produced vertex indices
	* \param[in] config   Must point to a filled out `nk_config` struct to configure the conversion process
	*
	* \returns one of enum nk_convert_result error codes
	*
	* Parameter                       | Description
	* --------------------------------|-----------------------------------------------------------
	* NK_CONVERT_SUCCESS              | Signals a successful draw command to vertex buffer conversion
	* NK_CONVERT_INVALID_PARAM        | An invalid argument was passed in the function call
	* NK_CONVERT_COMMAND_BUFFER_FULL  | The provided buffer for storing draw commands is full or failed to allocate more memory
	* NK_CONVERT_VERTEX_BUFFER_FULL   | The provided buffer for storing vertices is full or failed to allocate more memory
	* NK_CONVERT_ELEMENT_BUFFER_FULL  | The provided buffer for storing indices is full or failed to allocate more memory
	*/
	nk_convert :: proc(_: ^nk_context, cmds: ^nk_buffer, vertices: ^nk_buffer, elements: ^nk_buffer, _: ^nk_convert_config) -> nk_flags ---

	/**
	* \brief Returns a draw vertex command buffer iterator to iterate over the vertex draw command buffer
	*
	* \details
	* ```c
	* const struct nk_draw_command* nk__draw_begin(const struct nk_context*, const struct nk_buffer*);
	* ```
	*
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct at the end of a frame
	* \param[in] buf     | Must point to an previously by `nk_convert` filled out vertex draw command buffer
	*
	* \returns vertex draw command pointer pointing to the first command inside the vertex draw command buffer
	*/
	nk__draw_begin :: proc(_: ^nk_context, _: ^nk_buffer) -> ^nk_draw_command ---

	/**
	
	* # # nk__draw_end
	* \returns the vertex draw command at the end of the vertex draw command buffer
	*
	* ```c
	* const struct nk_draw_command* nk__draw_end(const struct nk_context *ctx, const struct nk_buffer *buf);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct at the end of a frame
	* \param[in] buf     | Must point to an previously by `nk_convert` filled out vertex draw command buffer
	*
	* \returns vertex draw command pointer pointing to the end of the last vertex draw command inside the vertex draw command buffer
	
	*/
	nk__draw_end :: proc(_: ^nk_context, _: ^nk_buffer) -> ^nk_draw_command ---

	/**
	* # # nk__draw_next
	* Increments the vertex draw command buffer iterator
	*
	* ```c
	* const struct nk_draw_command* nk__draw_next(const struct nk_draw_command*, const struct nk_buffer*, const struct nk_context*);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] cmd     | Must point to an previously either by `nk__draw_begin` or `nk__draw_next` returned vertex draw command
	* \param[in] buf     | Must point to an previously by `nk_convert` filled out vertex draw command buffer
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct at the end of a frame
	*
	* \returns vertex draw command pointer pointing to the end of the last vertex draw command inside the vertex draw command buffer
	
	*/
	nk__draw_next :: proc(_: ^nk_draw_command, _: ^nk_buffer, _: ^nk_context) -> ^nk_draw_command ---

	/**
	* # # nk_begin
	* Starts a new window; needs to be called every frame for every
	* window (unless hidden) or otherwise the window gets removed
	*
	* ```c
	* nk_bool nk_begin(struct nk_context *ctx, const char *title, struct nk_rect bounds, nk_flags flags);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	* \param[in] title   | Window title and identifier. Needs to be persistent over frames to identify the window
	* \param[in] bounds  | Initial position and window size. However if you do not define `NK_WINDOW_SCALABLE` or `NK_WINDOW_MOVABLE` you can set window position and size every frame
	* \param[in] flags   | Window flags defined in the nk_panel_flags section with a number of different window behaviors
	*
	* \returns `true(1)` if the window can be filled up with widgets from this point
	* until `nk_end` or `false(0)` otherwise for example if minimized
	
	*/
	nk_begin :: proc(ctx: ^nk_context, title: cstring, bounds: nk_rect, flags: nk_flags) -> nk_bool ---

	/**
	* # # nk_begin_titled
	* Extended window start with separated title and identifier to allow multiple
	* windows with same title but not name
	*
	* ```c
	* nk_bool nk_begin_titled(struct nk_context *ctx, const char *name, const char *title, struct nk_rect bounds, nk_flags flags);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	* \param[in] name    | Window identifier. Needs to be persistent over frames to identify the window
	* \param[in] title   | Window title displayed inside header if flag `NK_WINDOW_TITLE` or either `NK_WINDOW_CLOSABLE` or `NK_WINDOW_MINIMIZED` was set
	* \param[in] bounds  | Initial position and window size. However if you do not define `NK_WINDOW_SCALABLE` or `NK_WINDOW_MOVABLE` you can set window position and size every frame
	* \param[in] flags   | Window flags defined in the nk_panel_flags section with a number of different window behaviors
	*
	* \returns `true(1)` if the window can be filled up with widgets from this point
	* until `nk_end` or `false(0)` otherwise for example if minimized
	
	*/
	nk_begin_titled :: proc(ctx: ^nk_context, name: cstring, title: cstring, bounds: nk_rect, flags: nk_flags) -> nk_bool ---

	/**
	* # # nk_end
	* Needs to be called at the end of the window building process to process scaling, scrollbars and general cleanup.
	* All widget calls after this functions will result in asserts or no state changes
	*
	* ```c
	* void nk_end(struct nk_context *ctx);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	
	*/
	nk_end :: proc(ctx: ^nk_context) ---

	/**
	* # # nk_window_get_bounds
	* \returns a rectangle with screen position and size of the currently processed window
	*
	* !!! \warning
	*     Only call this function between calls `nk_begin_xxx` and `nk_end`
	* ```c
	* struct nk_rect nk_window_get_bounds(const struct nk_context *ctx);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	*
	* \returns a `nk_rect` struct with window upper left window position and size
	
	*/
	nk_window_get_bounds :: proc(ctx: ^nk_context) -> nk_rect ---

	/**
	* # # nk_window_get_position
	* \returns the position of the currently processed window.
	*
	* !!! \warning
	*     Only call this function between calls `nk_begin_xxx` and `nk_end`
	* ```c
	* struct nk_vec2 nk_window_get_position(const struct nk_context *ctx);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	*
	* \returns a `nk_vec2` struct with window upper left position
	
	*/
	nk_window_get_position :: proc(ctx: ^nk_context) -> nk_vec2 ---

	/**
	* # # nk_window_get_size
	* \returns the size with width and height of the currently processed window.
	*
	* !!! \warning
	*     Only call this function between calls `nk_begin_xxx` and `nk_end`
	* ```c
	* struct nk_vec2 nk_window_get_size(const struct nk_context *ctx);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	*
	* \returns a `nk_vec2` struct with window width and height
	
	*/
	nk_window_get_size :: proc(ctx: ^nk_context) -> nk_vec2 ---

	/**
	* nk_window_get_width
	* \returns the width of the currently processed window.
	*
	* !!! \warning
	*     Only call this function between calls `nk_begin_xxx` and `nk_end`
	* ```c
	* float nk_window_get_width(const struct nk_context *ctx);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	*
	* \returns the current window width
	*/
	nk_window_get_width :: proc(ctx: ^nk_context) -> f32 ---

	/**
	* # # nk_window_get_height
	* \returns the height of the currently processed window.
	*
	* !!! \warning
	*     Only call this function between calls `nk_begin_xxx` and `nk_end`
	* ```c
	* float nk_window_get_height(const struct nk_context *ctx);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	*
	* \returns the current window height
	
	*/
	nk_window_get_height :: proc(ctx: ^nk_context) -> f32 ---

	/**
	* # # nk_window_get_panel
	* \returns the underlying panel which contains all processing state of the current window.
	*
	* !!! \warning
	*     Only call this function between calls `nk_begin_xxx` and `nk_end`
	* !!! \warning
	*     Do not keep the returned panel pointer around, it is only valid until `nk_end`
	* ```c
	* struct nk_panel* nk_window_get_panel(struct nk_context *ctx);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	*
	* \returns a pointer to window internal `nk_panel` state.
	
	*/
	nk_window_get_panel :: proc(ctx: ^nk_context) -> ^nk_panel ---

	/**
	* # # nk_window_get_content_region
	* \returns the position and size of the currently visible and non-clipped space
	* inside the currently processed window.
	*
	* !!! \warning
	*     Only call this function between calls `nk_begin_xxx` and `nk_end`
	*
	* ```c
	* struct nk_rect nk_window_get_content_region(struct nk_context *ctx);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	*
	* \returns `nk_rect` struct with screen position and size (no scrollbar offset)
	* of the visible space inside the current window
	
	*/
	nk_window_get_content_region :: proc(ctx: ^nk_context) -> nk_rect ---

	/**
	* # # nk_window_get_content_region_min
	* \returns the upper left position of the currently visible and non-clipped
	* space inside the currently processed window.
	*
	* !!! \warning
	*     Only call this function between calls `nk_begin_xxx` and `nk_end`
	*
	* ```c
	* struct nk_vec2 nk_window_get_content_region_min(struct nk_context *ctx);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	*
	* returns `nk_vec2` struct with  upper left screen position (no scrollbar offset)
	* of the visible space inside the current window
	
	*/
	nk_window_get_content_region_min :: proc(ctx: ^nk_context) -> nk_vec2 ---

	/**
	* # # nk_window_get_content_region_max
	* \returns the lower right screen position of the currently visible and
	* non-clipped space inside the currently processed window.
	*
	* !!! \warning
	*     Only call this function between calls `nk_begin_xxx` and `nk_end`
	*
	* ```c
	* struct nk_vec2 nk_window_get_content_region_max(struct nk_context *ctx);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	*
	* \returns `nk_vec2` struct with lower right screen position (no scrollbar offset)
	* of the visible space inside the current window
	
	*/
	nk_window_get_content_region_max :: proc(ctx: ^nk_context) -> nk_vec2 ---

	/**
	* # # nk_window_get_content_region_size
	* \returns the size of the currently visible and non-clipped space inside the
	* currently processed window
	*
	* !!! \warning
	*     Only call this function between calls `nk_begin_xxx` and `nk_end`
	*
	* ```c
	* struct nk_vec2 nk_window_get_content_region_size(struct nk_context *ctx);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	*
	* \returns `nk_vec2` struct with size the visible space inside the current window
	
	*/
	nk_window_get_content_region_size :: proc(ctx: ^nk_context) -> nk_vec2 ---

	/**
	* # # nk_window_get_canvas
	* \returns the draw command buffer. Can be used to draw custom widgets
	* !!! \warning
	*     Only call this function between calls `nk_begin_xxx` and `nk_end`
	* !!! \warning
	*     Do not keep the returned command buffer pointer around it is only valid until `nk_end`
	*
	* ```c
	* struct nk_command_buffer* nk_window_get_canvas(struct nk_context *ctx);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	*
	* \returns a pointer to window internal `nk_command_buffer` struct used as
	* drawing canvas. Can be used to do custom drawing.
	*/
	nk_window_get_canvas :: proc(ctx: ^nk_context) -> ^nk_command_buffer ---

	/**
	* # # nk_window_get_scroll
	* Gets the scroll offset for the current window
	* !!! \warning
	*     Only call this function between calls `nk_begin_xxx` and `nk_end`
	*
	* ```c
	* void nk_window_get_scroll(struct nk_context *ctx, nk_uint *offset_x, nk_uint *offset_y);
	* ```
	*
	* Parameter    | Description
	* -------------|-----------------------------------------------------------
	* \param[in] ctx      | Must point to an previously initialized `nk_context` struct
	* \param[in] offset_x | A pointer to the x offset output (or NULL to ignore)
	* \param[in] offset_y | A pointer to the y offset output (or NULL to ignore)
	
	*/
	nk_window_get_scroll :: proc(ctx: ^nk_context, offset_x: ^nk_uint, offset_y: ^nk_uint) ---

	/**
	* # # nk_window_has_focus
	* \returns if the currently processed window is currently active
	* !!! \warning
	*     Only call this function between calls `nk_begin_xxx` and `nk_end`
	* ```c
	* nk_bool nk_window_has_focus(const struct nk_context *ctx);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	*
	* \returns `false(0)` if current window is not active or `true(1)` if it is
	
	*/
	nk_window_has_focus :: proc(ctx: ^nk_context) -> nk_bool ---

	/**
	* # # nk_window_is_hovered
	* Return if the current window is being hovered
	* !!! \warning
	*     Only call this function between calls `nk_begin_xxx` and `nk_end`
	* ```c
	* nk_bool nk_window_is_hovered(struct nk_context *ctx);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	*
	* \returns `true(1)` if current window is hovered or `false(0)` otherwise
	
	*/
	nk_window_is_hovered :: proc(ctx: ^nk_context) -> nk_bool ---

	/**
	* # # nk_window_is_collapsed
	* \returns if the window with given name is currently minimized/collapsed
	* ```c
	* nk_bool nk_window_is_collapsed(struct nk_context *ctx, const char *name);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	* \param[in] name    | Identifier of window you want to check if it is collapsed
	*
	* \returns `true(1)` if current window is minimized and `false(0)` if window not
	* found or is not minimized
	
	*/
	nk_window_is_collapsed :: proc(ctx: ^nk_context, name: cstring) -> nk_bool ---

	/**
	* # # nk_window_is_closed
	* \returns if the window with given name was closed by calling `nk_close`
	* ```c
	* nk_bool nk_window_is_closed(struct nk_context *ctx, const char *name);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	* \param[in] name    | Identifier of window you want to check if it is closed
	*
	* \returns `true(1)` if current window was closed or `false(0)` window not found or not closed
	
	*/
	nk_window_is_closed :: proc(ctx: ^nk_context, name: cstring) -> nk_bool ---

	/**
	* # # nk_window_is_hidden
	* \returns if the window with given name is hidden
	* ```c
	* nk_bool nk_window_is_hidden(struct nk_context *ctx, const char *name);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	* \param[in] name    | Identifier of window you want to check if it is hidden
	*
	* \returns `true(1)` if current window is hidden or `false(0)` window not found or visible
	
	*/
	nk_window_is_hidden :: proc(ctx: ^nk_context, name: cstring) -> nk_bool ---

	/**
	* # # nk_window_is_active
	* Same as nk_window_has_focus for some reason
	* ```c
	* nk_bool nk_window_is_active(struct nk_context *ctx, const char *name);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	* \param[in] name    | Identifier of window you want to check if it is active
	*
	* \returns `true(1)` if current window is active or `false(0)` window not found or not active
	*/
	nk_window_is_active :: proc(ctx: ^nk_context, name: cstring) -> nk_bool ---

	/**
	* # # nk_window_is_any_hovered
	* \returns if the any window is being hovered
	* ```c
	* nk_bool nk_window_is_any_hovered(struct nk_context*);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	*
	* \returns `true(1)` if any window is hovered or `false(0)` otherwise
	*/
	nk_window_is_any_hovered :: proc(ctx: ^nk_context) -> nk_bool ---

	/**
	* # # nk_item_is_any_active
	* \returns if the any window is being hovered or any widget is currently active.
	* Can be used to decide if input should be processed by UI or your specific input handling.
	* Example could be UI and 3D camera to move inside a 3D space.
	* ```c
	* nk_bool nk_item_is_any_active(struct nk_context*);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	*
	* \returns `true(1)` if any window is hovered or any item is active or `false(0)` otherwise
	
	*/
	nk_item_is_any_active :: proc(ctx: ^nk_context) -> nk_bool ---

	/**
	* # # nk_window_set_bounds
	* Updates position and size of window with passed in name
	* ```c
	* void nk_window_set_bounds(struct nk_context*, const char *name, struct nk_rect bounds);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	* \param[in] name    | Identifier of the window to modify both position and size
	* \param[in] bounds  | Must point to a `nk_rect` struct with the new position and size
	
	*/
	nk_window_set_bounds :: proc(ctx: ^nk_context, name: cstring, bounds: nk_rect) ---

	/**
	* # # nk_window_set_position
	* Updates position of window with passed name
	* ```c
	* void nk_window_set_position(struct nk_context*, const char *name, struct nk_vec2 pos);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	* \param[in] name    | Identifier of the window to modify both position
	* \param[in] pos     | Must point to a `nk_vec2` struct with the new position
	
	*/
	nk_window_set_position :: proc(ctx: ^nk_context, name: cstring, pos: nk_vec2) ---

	/**
	* # # nk_window_set_size
	* Updates size of window with passed in name
	* ```c
	* void nk_window_set_size(struct nk_context*, const char *name, struct nk_vec2);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	* \param[in] name    | Identifier of the window to modify both window size
	* \param[in] size    | Must point to a `nk_vec2` struct with new window size
	
	*/
	nk_window_set_size :: proc(ctx: ^nk_context, name: cstring, size: nk_vec2) ---

	/**
	* # # nk_window_set_focus
	* Sets the window with given name as active
	* ```c
	* void nk_window_set_focus(struct nk_context*, const char *name);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	* \param[in] name    | Identifier of the window to set focus on
	
	*/
	nk_window_set_focus :: proc(ctx: ^nk_context, name: cstring) ---

	/**
	* # # nk_window_set_scroll
	* Sets the scroll offset for the current window
	* !!! \warning
	*     Only call this function between calls `nk_begin_xxx` and `nk_end`
	*
	* ```c
	* void nk_window_set_scroll(struct nk_context *ctx, nk_uint offset_x, nk_uint offset_y);
	* ```
	*
	* Parameter    | Description
	* -------------|-----------------------------------------------------------
	* \param[in] ctx      | Must point to an previously initialized `nk_context` struct
	* \param[in] offset_x | The x offset to scroll to
	* \param[in] offset_y | The y offset to scroll to
	
	*/
	nk_window_set_scroll :: proc(ctx: ^nk_context, offset_x: nk_uint, offset_y: nk_uint) ---

	/**
	* # # nk_window_close
	* Closes a window and marks it for being freed at the end of the frame
	* ```c
	* void nk_window_close(struct nk_context *ctx, const char *name);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	* \param[in] name    | Identifier of the window to close
	
	*/
	nk_window_close :: proc(ctx: ^nk_context, name: cstring) ---

	/**
	* # # nk_window_collapse
	* Updates collapse state of a window with given name
	* ```c
	* void nk_window_collapse(struct nk_context*, const char *name, enum nk_collapse_states state);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	* \param[in] name    | Identifier of the window to close
	* \param[in] state   | value out of nk_collapse_states section
	
	*/
	nk_window_collapse :: proc(ctx: ^nk_context, name: cstring, state: nk_collapse_states) ---

	/**
	* # # nk_window_collapse_if
	* Updates collapse state of a window with given name if given condition is met
	* ```c
	* void nk_window_collapse_if(struct nk_context*, const char *name, enum nk_collapse_states, int cond);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	* \param[in] name    | Identifier of the window to either collapse or maximize
	* \param[in] state   | value out of nk_collapse_states section the window should be put into
	* \param[in] cond    | condition that has to be met to actually commit the collapse state change
	
	*/
	nk_window_collapse_if :: proc(ctx: ^nk_context, name: cstring, state: nk_collapse_states, cond: c.int) ---

	/**
	* # # nk_window_show
	* updates visibility state of a window with given name
	* ```c
	* void nk_window_show(struct nk_context*, const char *name, enum nk_show_states);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	* \param[in] name    | Identifier of the window to either collapse or maximize
	* \param[in] state   | state with either visible or hidden to modify the window with
	*/
	nk_window_show :: proc(ctx: ^nk_context, name: cstring, state: nk_show_states) ---

	/**
	* # # nk_window_show_if
	* Updates visibility state of a window with given name if a given condition is met
	* ```c
	* void nk_window_show_if(struct nk_context*, const char *name, enum nk_show_states, int cond);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	* \param[in] name    | Identifier of the window to either hide or show
	* \param[in] state   | state with either visible or hidden to modify the window with
	* \param[in] cond    | condition that has to be met to actually commit the visibility state change
	
	*/
	nk_window_show_if :: proc(ctx: ^nk_context, name: cstring, state: nk_show_states, cond: c.int) ---

	/**
	* # # nk_window_show_if
	* Line for visual separation. Draws a line with thickness determined by the current row height.
	* ```c
	* void nk_rule_horizontal(struct nk_context *ctx, struct nk_color color, NK_BOOL rounding)
	* ```
	*
	* Parameter       | Description
	* ----------------|-------------------------------------------------------
	* \param[in] ctx         | Must point to an previously initialized `nk_context` struct
	* \param[in] color       | Color of the horizontal line
	* \param[in] rounding    | Whether or not to make the line round
	*/
	nk_rule_horizontal :: proc(ctx: ^nk_context, color: nk_color, rounding: nk_bool) ---

	/**
	* Sets the currently used minimum row height.
	* !!! \warning
	*     The passed height needs to include both your preferred row height
	*     as well as padding. No internal padding is added.
	*
	* ```c
	* void nk_layout_set_min_row_height(struct nk_context*, float height);
	* ```
	*
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_begin_xxx`
	* \param[in] height  | New minimum row height to be used for auto generating the row height
	*/
	nk_layout_set_min_row_height :: proc(_: ^nk_context, height: f32) ---

	/**
	* Reset the currently used minimum row height back to `font_height + text_padding + padding`
	* ```c
	* void nk_layout_reset_min_row_height(struct nk_context*);
	* ```
	*
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_begin_xxx`
	*/
	nk_layout_reset_min_row_height :: proc(_: ^nk_context) ---

	/**
	* \brief Returns the width of the next row allocate by one of the layouting functions
	*
	* \details
	* ```c
	* struct nk_rect nk_layout_widget_bounds(struct nk_context*);
	* ```
	*
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_begin_xxx`
	*
	* \return `nk_rect` with both position and size of the next row
	*/
	nk_layout_widget_bounds :: proc(ctx: ^nk_context) -> nk_rect ---

	/**
	* \brief Utility functions to calculate window ratio from pixel size
	*
	* \details
	* ```c
	* float nk_layout_ratio_from_pixel(struct nk_context*, float pixel_width);
	* ```
	*
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_begin_xxx`
	* \param[in] pixel   | Pixel_width to convert to window ratio
	*
	* \returns `nk_rect` with both position and size of the next row
	*/
	nk_layout_ratio_from_pixel :: proc(ctx: ^nk_context, pixel_width: f32) -> f32 ---

	/**
	* \brief Sets current row layout to share horizontal space
	* between @cols number of widgets evenly. Once called all subsequent widget
	* calls greater than @cols will allocate a new row with same layout.
	*
	* \details
	* ```c
	* void nk_layout_row_dynamic(struct nk_context *ctx, float height, int cols);
	* ```
	*
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_begin_xxx`
	* \param[in] height  | Holds height of each widget in row or zero for auto layouting
	* \param[in] columns | Number of widget inside row
	*/
	nk_layout_row_dynamic :: proc(ctx: ^nk_context, height: f32, cols: c.int) ---

	/**
	* \brief Sets current row layout to fill @cols number of widgets
	* in row with same @item_width horizontal size. Once called all subsequent widget
	* calls greater than @cols will allocate a new row with same layout.
	*
	* \details
	* ```c
	* void nk_layout_row_static(struct nk_context *ctx, float height, int item_width, int cols);
	* ```
	*
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_begin_xxx`
	* \param[in] height  | Holds height of each widget in row or zero for auto layouting
	* \param[in] width   | Holds pixel width of each widget in the row
	* \param[in] columns | Number of widget inside row
	*/
	nk_layout_row_static :: proc(ctx: ^nk_context, height: f32, item_width: c.int, cols: c.int) ---

	/**
	* \brief Starts a new dynamic or fixed row with given height and columns.
	*
	* \details
	* ```c
	* void nk_layout_row_begin(struct nk_context *ctx, enum nk_layout_format fmt, float row_height, int cols);
	* ```
	*
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_begin_xxx`
	* \param[in] fmt     | either `NK_DYNAMIC` for window ratio or `NK_STATIC` for fixed size columns
	* \param[in] height  | holds height of each widget in row or zero for auto layouting
	* \param[in] columns | Number of widget inside row
	*/
	nk_layout_row_begin :: proc(ctx: ^nk_context, fmt: nk_layout_format, row_height: f32, cols: c.int) ---

	/**
	* \breif Specifies either window ratio or width of a single column
	*
	* \details
	* ```c
	* void nk_layout_row_push(struct nk_context*, float value);
	* ```
	*
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_begin_xxx`
	* \param[in] value   | either a window ratio or fixed width depending on @fmt in previous `nk_layout_row_begin` call
	*/
	nk_layout_row_push :: proc(_: ^nk_context, value: f32) ---

	/**
	* \brief Finished previously started row
	*
	* \details
	* ```c
	* void nk_layout_row_end(struct nk_context*);
	* ```
	*
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_begin_xxx`
	*/
	nk_layout_row_end :: proc(_: ^nk_context) ---

	/**
	* \brief Specifies row columns in array as either window ratio or size
	*
	* \details
	* ```c
	* void nk_layout_row(struct nk_context*, enum nk_layout_format, float height, int cols, const float *ratio);
	* ```
	*
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_begin_xxx`
	* \param[in] fmt     | Either `NK_DYNAMIC` for window ratio or `NK_STATIC` for fixed size columns
	* \param[in] height  | Holds height of each widget in row or zero for auto layouting
	* \param[in] columns | Number of widget inside row
	*/
	nk_layout_row :: proc(_: ^nk_context, _: nk_layout_format, height: f32, cols: c.int, ratio: ^f32) ---

	/**
	* # # nk_layout_row_template_begin
	* Begins the row template declaration
	* ```c
	* void nk_layout_row_template_begin(struct nk_context*, float row_height);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_begin_xxx`
	* \param[in] height  | Holds height of each widget in row or zero for auto layouting
	*/
	nk_layout_row_template_begin :: proc(_: ^nk_context, row_height: f32) ---

	/**
	* # # nk_layout_row_template_push_dynamic
	* Adds a dynamic column that dynamically grows and can go to zero if not enough space
	* ```c
	* void nk_layout_row_template_push_dynamic(struct nk_context*);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_begin_xxx`
	* \param[in] height  | Holds height of each widget in row or zero for auto layouting
	*/
	nk_layout_row_template_push_dynamic :: proc(_: ^nk_context) ---

	/**
	* # # nk_layout_row_template_push_variable
	* Adds a variable column that dynamically grows but does not shrink below specified pixel width
	* ```c
	* void nk_layout_row_template_push_variable(struct nk_context*, float min_width);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_begin_xxx`
	* \param[in] width   | Holds the minimum pixel width the next column must always be
	*/
	nk_layout_row_template_push_variable :: proc(_: ^nk_context, min_width: f32) ---

	/**
	* # # nk_layout_row_template_push_static
	* Adds a static column that does not grow and will always have the same size
	* ```c
	* void nk_layout_row_template_push_static(struct nk_context*, float width);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_begin_xxx`
	* \param[in] width   | Holds the absolute pixel width value the next column must be
	*/
	nk_layout_row_template_push_static :: proc(_: ^nk_context, width: f32) ---

	/**
	* # # nk_layout_row_template_end
	* Marks the end of the row template
	* ```c
	* void nk_layout_row_template_end(struct nk_context*);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_begin_xxx`
	*/
	nk_layout_row_template_end :: proc(_: ^nk_context) ---

	/**
	* # # nk_layout_space_begin
	* Begins a new layouting space that allows to specify each widgets position and size.
	* ```c
	* void nk_layout_space_begin(struct nk_context*, enum nk_layout_format, float height, int widget_count);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_begin_xxx`
	* \param[in] fmt     | Either `NK_DYNAMIC` for window ratio or `NK_STATIC` for fixed size columns
	* \param[in] height  | Holds height of each widget in row or zero for auto layouting
	* \param[in] columns | Number of widgets inside row
	*/
	nk_layout_space_begin :: proc(_: ^nk_context, _: nk_layout_format, height: f32, widget_count: c.int) ---

	/**
	* # # nk_layout_space_push
	* Pushes position and size of the next widget in own coordinate space either as pixel or ratio
	* ```c
	* void nk_layout_space_push(struct nk_context *ctx, struct nk_rect bounds);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_layout_space_begin`
	* \param[in] bounds  | Position and size in laoyut space local coordinates
	*/
	nk_layout_space_push :: proc(_: ^nk_context, bounds: nk_rect) ---

	/**
	* # # nk_layout_space_end
	* Marks the end of the layout space
	* ```c
	* void nk_layout_space_end(struct nk_context*);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_layout_space_begin`
	*/
	nk_layout_space_end :: proc(_: ^nk_context) ---

	/**
	* # # nk_layout_space_bounds
	* Utility function to calculate total space allocated for `nk_layout_space`
	* ```c
	* struct nk_rect nk_layout_space_bounds(struct nk_context*);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_layout_space_begin`
	*
	* \returns `nk_rect` holding the total space allocated
	*/
	nk_layout_space_bounds :: proc(ctx: ^nk_context) -> nk_rect ---

	/**
	* # # nk_layout_space_to_screen
	* Converts vector from nk_layout_space coordinate space into screen space
	* ```c
	* struct nk_vec2 nk_layout_space_to_screen(struct nk_context*, struct nk_vec2);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_layout_space_begin`
	* \param[in] vec     | Position to convert from layout space into screen coordinate space
	*
	* \returns transformed `nk_vec2` in screen space coordinates
	*/
	nk_layout_space_to_screen :: proc(ctx: ^nk_context, vec: nk_vec2) -> nk_vec2 ---

	/**
	* # # nk_layout_space_to_local
	* Converts vector from layout space into screen space
	* ```c
	* struct nk_vec2 nk_layout_space_to_local(struct nk_context*, struct nk_vec2);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_layout_space_begin`
	* \param[in] vec     | Position to convert from screen space into layout coordinate space
	*
	* \returns transformed `nk_vec2` in layout space coordinates
	*/
	nk_layout_space_to_local :: proc(ctx: ^nk_context, vec: nk_vec2) -> nk_vec2 ---

	/**
	* # # nk_layout_space_rect_to_screen
	* Converts rectangle from screen space into layout space
	* ```c
	* struct nk_rect nk_layout_space_rect_to_screen(struct nk_context*, struct nk_rect);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_layout_space_begin`
	* \param[in] bounds  | Rectangle to convert from layout space into screen space
	*
	* \returns transformed `nk_rect` in screen space coordinates
	*/
	nk_layout_space_rect_to_screen :: proc(ctx: ^nk_context, bounds: nk_rect) -> nk_rect ---

	/**
	* # # nk_layout_space_rect_to_local
	* Converts rectangle from layout space into screen space
	* ```c
	* struct nk_rect nk_layout_space_rect_to_local(struct nk_context*, struct nk_rect);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_layout_space_begin`
	* \param[in] bounds  | Rectangle to convert from layout space into screen space
	*
	* \returns transformed `nk_rect` in layout space coordinates
	*/
	nk_layout_space_rect_to_local :: proc(ctx: ^nk_context, bounds: nk_rect) -> nk_rect ---

	/**
	* # # nk_spacer
	* Spacer is a dummy widget that consumes space as usual but doesn't draw anything
	* ```c
	* void nk_spacer(struct nk_context* );
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after call `nk_layout_space_begin`
	*
	*/
	nk_spacer :: proc(ctx: ^nk_context) ---

	/**
	* \brief Starts a new widget group. Requires a previous layouting function to specify a pos/size.
	* ```c
	* nk_bool nk_group_begin(struct nk_context*, const char *title, nk_flags);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	* \param[in] title   | Must be an unique identifier for this group that is also used for the group header
	* \param[in] flags   | Window flags defined in the nk_panel_flags section with a number of different group behaviors
	*
	* \returns `true(1)` if visible and fillable with widgets or `false(0)` otherwise
	*/
	nk_group_begin :: proc(_: ^nk_context, title: cstring, _: nk_flags) -> nk_bool ---

	/**
	* \brief Starts a new widget group. Requires a previous layouting function to specify a pos/size.
	* ```c
	* nk_bool nk_group_begin_titled(struct nk_context*, const char *name, const char *title, nk_flags);
	* ```
	*
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	* \param[in] id      | Must be an unique identifier for this group
	* \param[in] title   | Group header title
	* \param[in] flags   | Window flags defined in the nk_panel_flags section with a number of different group behaviors
	*
	* \returns `true(1)` if visible and fillable with widgets or `false(0)` otherwise
	*/
	nk_group_begin_titled :: proc(_: ^nk_context, name: cstring, title: cstring, _: nk_flags) -> nk_bool ---

	/**
	* # # nk_group_end
	* Ends a widget group
	* ```c
	* void nk_group_end(struct nk_context*);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	*/
	nk_group_end :: proc(_: ^nk_context) ---

	/**
	* # # nk_group_scrolled_offset_begin
	* starts a new widget group. requires a previous layouting function to specify
	* a size. Does not keep track of scrollbar.
	* ```c
	* nk_bool nk_group_scrolled_offset_begin(struct nk_context*, nk_uint *x_offset, nk_uint *y_offset, const char *title, nk_flags flags);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	* \param[in] x_offset| Scrollbar x-offset to offset all widgets inside the group horizontally.
	* \param[in] y_offset| Scrollbar y-offset to offset all widgets inside the group vertically
	* \param[in] title   | Window unique group title used to both identify and display in the group header
	* \param[in] flags   | Window flags from the nk_panel_flags section
	*
	* \returns `true(1)` if visible and fillable with widgets or `false(0)` otherwise
	*/
	nk_group_scrolled_offset_begin :: proc(_: ^nk_context, x_offset: ^nk_uint, y_offset: ^nk_uint, title: cstring, flags: nk_flags) -> nk_bool ---

	/**
	* # # nk_group_scrolled_begin
	* Starts a new widget group. requires a previous
	* layouting function to specify a size. Does not keep track of scrollbar.
	* ```c
	* nk_bool nk_group_scrolled_begin(struct nk_context*, struct nk_scroll *off, const char *title, nk_flags);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	* \param[in] off     | Both x- and y- scroll offset. Allows for manual scrollbar control
	* \param[in] title   | Window unique group title used to both identify and display in the group header
	* \param[in] flags   | Window flags from nk_panel_flags section
	*
	* \returns `true(1)` if visible and fillable with widgets or `false(0)` otherwise
	*/
	nk_group_scrolled_begin :: proc(_: ^nk_context, off: ^nk_scroll, title: cstring, _: nk_flags) -> nk_bool ---

	/**
	* # # nk_group_scrolled_end
	* Ends a widget group after calling nk_group_scrolled_offset_begin or nk_group_scrolled_begin.
	* ```c
	* void nk_group_scrolled_end(struct nk_context*);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	*/
	nk_group_scrolled_end :: proc(_: ^nk_context) ---

	/**
	* # # nk_group_get_scroll
	* Gets the scroll position of the given group.
	* ```c
	* void nk_group_get_scroll(struct nk_context*, const char *id, nk_uint *x_offset, nk_uint *y_offset);
	* ```
	*
	* Parameter    | Description
	* -------------|-----------------------------------------------------------
	* \param[in] ctx      | Must point to an previously initialized `nk_context` struct
	* \param[in] id       | The id of the group to get the scroll position of
	* \param[in] x_offset | A pointer to the x offset output (or NULL to ignore)
	* \param[in] y_offset | A pointer to the y offset output (or NULL to ignore)
	*/
	nk_group_get_scroll :: proc(_: ^nk_context, id: cstring, x_offset: ^nk_uint, y_offset: ^nk_uint) ---

	/**
	* # # nk_group_set_scroll
	* Sets the scroll position of the given group.
	* ```c
	* void nk_group_set_scroll(struct nk_context*, const char *id, nk_uint x_offset, nk_uint y_offset);
	* ```
	*
	* Parameter    | Description
	* -------------|-----------------------------------------------------------
	* \param[in] ctx      | Must point to an previously initialized `nk_context` struct
	* \param[in] id       | The id of the group to scroll
	* \param[in] x_offset | The x offset to scroll to
	* \param[in] y_offset | The y offset to scroll to
	*/
	nk_group_set_scroll :: proc(_: ^nk_context, id: cstring, x_offset: nk_uint, y_offset: nk_uint) ---

	/**
	* # # nk_tree_push_hashed
	* Start a collapsible UI section with internal state management with full
	* control over internal unique ID used to store state
	* ```c
	* nk_bool nk_tree_push_hashed(struct nk_context*, enum nk_tree_type, const char *title, enum nk_collapse_states initial_state, const char *hash, int len,int seed);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	* \param[in] type    | Value from the nk_tree_type section to visually mark a tree node header as either a collapseable UI section or tree node
	* \param[in] title   | Label printed in the tree header
	* \param[in] state   | Initial tree state value out of nk_collapse_states
	* \param[in] hash    | Memory block or string to generate the ID from
	* \param[in] len     | Size of passed memory block or string in __hash__
	* \param[in] seed    | Seeding value if this function is called in a loop or default to `0`
	*
	* \returns `true(1)` if visible and fillable with widgets or `false(0)` otherwise
	*/
	nk_tree_push_hashed :: proc(_: ^nk_context, _: nk_tree_type, title: cstring, initial_state: nk_collapse_states, hash: cstring, len: c.int, seed: c.int) -> nk_bool ---

	/**
	* # # nk_tree_image_push_hashed
	* Start a collapsible UI section with internal state management with full
	* control over internal unique ID used to store state
	* ```c
	* nk_bool nk_tree_image_push_hashed(struct nk_context*, enum nk_tree_type, struct nk_image, const char *title, enum nk_collapse_states initial_state, const char *hash, int len,int seed);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct
	* \param[in] type    | Value from the nk_tree_type section to visually mark a tree node header as either a collapseable UI section or tree node
	* \param[in] img     | Image to display inside the header on the left of the label
	* \param[in] title   | Label printed in the tree header
	* \param[in] state   | Initial tree state value out of nk_collapse_states
	* \param[in] hash    | Memory block or string to generate the ID from
	* \param[in] len     | Size of passed memory block or string in __hash__
	* \param[in] seed    | Seeding value if this function is called in a loop or default to `0`
	*
	* \returns `true(1)` if visible and fillable with widgets or `false(0)` otherwise
	*/
	nk_tree_image_push_hashed :: proc(_: ^nk_context, _: nk_tree_type, _: nk_image, title: cstring, initial_state: nk_collapse_states, hash: cstring, len: c.int, seed: c.int) -> nk_bool ---

	/**
	* # # nk_tree_pop
	* Ends a collapsabale UI section
	* ```c
	* void nk_tree_pop(struct nk_context*);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after calling `nk_tree_xxx_push_xxx`
	*/
	nk_tree_pop :: proc(_: ^nk_context) ---

	/**
	* # # nk_tree_state_push
	* Start a collapsible UI section with external state management
	* ```c
	* nk_bool nk_tree_state_push(struct nk_context*, enum nk_tree_type, const char *title, enum nk_collapse_states *state);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after calling `nk_tree_xxx_push_xxx`
	* \param[in] type    | Value from the nk_tree_type section to visually mark a tree node header as either a collapseable UI section or tree node
	* \param[in] title   | Label printed in the tree header
	* \param[in] state   | Persistent state to update
	*
	* \returns `true(1)` if visible and fillable with widgets or `false(0)` otherwise
	*/
	nk_tree_state_push :: proc(_: ^nk_context, _: nk_tree_type, title: cstring, state: ^nk_collapse_states) -> nk_bool ---

	/**
	* # # nk_tree_state_image_push
	* Start a collapsible UI section with image and label header and external state management
	* ```c
	* nk_bool nk_tree_state_image_push(struct nk_context*, enum nk_tree_type, struct nk_image, const char *title, enum nk_collapse_states *state);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after calling `nk_tree_xxx_push_xxx`
	* \param[in] img     | Image to display inside the header on the left of the label
	* \param[in] type    | Value from the nk_tree_type section to visually mark a tree node header as either a collapseable UI section or tree node
	* \param[in] title   | Label printed in the tree header
	* \param[in] state   | Persistent state to update
	*
	* \returns `true(1)` if visible and fillable with widgets or `false(0)` otherwise
	*/
	nk_tree_state_image_push :: proc(_: ^nk_context, _: nk_tree_type, _: nk_image, title: cstring, state: ^nk_collapse_states) -> nk_bool ---

	/**
	* # # nk_tree_state_pop
	* Ends a collapsabale UI section
	* ```c
	* void nk_tree_state_pop(struct nk_context*);
	* ```
	*
	* Parameter   | Description
	* ------------|-----------------------------------------------------------
	* \param[in] ctx     | Must point to an previously initialized `nk_context` struct after calling `nk_tree_xxx_push_xxx`
	*/
	nk_tree_state_pop                 :: proc(_: ^nk_context) ---
	nk_tree_element_push_hashed       :: proc(_: ^nk_context, _: nk_tree_type, title: cstring, initial_state: nk_collapse_states, selected: ^nk_bool, hash: cstring, len: c.int, seed: c.int) -> nk_bool ---
	nk_tree_element_image_push_hashed :: proc(_: ^nk_context, _: nk_tree_type, _: nk_image, title: cstring, initial_state: nk_collapse_states, selected: ^nk_bool, hash: cstring, len: c.int, seed: c.int) -> nk_bool ---
	nk_tree_element_pop               :: proc(_: ^nk_context) ---
	nk_list_view_begin                :: proc(_: ^nk_context, out: ^nk_list_view, id: cstring, _: nk_flags, row_height: c.int, row_count: c.int) -> nk_bool ---
	nk_list_view_end                  :: proc(_: ^nk_list_view) ---
	nk_widget                         :: proc(_: ^nk_rect, _: ^nk_context) -> nk_widget_layout_states ---
	nk_widget_fitting                 :: proc(_: ^nk_rect, _: ^nk_context, _: nk_vec2) -> nk_widget_layout_states ---
	nk_widget_bounds                  :: proc(_: ^nk_context) -> nk_rect ---
	nk_widget_position                :: proc(_: ^nk_context) -> nk_vec2 ---
	nk_widget_size                    :: proc(_: ^nk_context) -> nk_vec2 ---
	nk_widget_width                   :: proc(_: ^nk_context) -> f32 ---
	nk_widget_height                  :: proc(_: ^nk_context) -> f32 ---
	nk_widget_is_hovered              :: proc(_: ^nk_context) -> nk_bool ---
	nk_widget_is_mouse_clicked        :: proc(_: ^nk_context, _: nk_buttons) -> nk_bool ---
	nk_widget_has_mouse_click_down    :: proc(_: ^nk_context, _: nk_buttons, down: nk_bool) -> nk_bool ---
	nk_spacing                        :: proc(_: ^nk_context, cols: c.int) ---
	nk_widget_disable_begin           :: proc(ctx: ^nk_context) ---
	nk_widget_disable_end             :: proc(ctx: ^nk_context) ---
	nk_text                           :: proc(_: ^nk_context, _: cstring, _: c.int, _: nk_flags) ---
	nk_text_colored                   :: proc(_: ^nk_context, _: cstring, _: c.int, _: nk_flags, _: nk_color) ---
	nk_text_wrap                      :: proc(_: ^nk_context, _: cstring, _: c.int) ---
	nk_text_wrap_colored              :: proc(_: ^nk_context, _: cstring, _: c.int, _: nk_color) ---
	nk_label                          :: proc(_: ^nk_context, _: cstring, align: nk_flags) ---
	nk_label_colored                  :: proc(_: ^nk_context, _: cstring, align: nk_flags, _: nk_color) ---
	nk_label_wrap                     :: proc(_: ^nk_context, _: cstring) ---
	nk_label_colored_wrap             :: proc(_: ^nk_context, _: cstring, _: nk_color) ---
	// nk_image                          :: proc(_: ^nk_context, _: nk_image) ---
	nk_image_color                    :: proc(_: ^nk_context, _: nk_image, _: nk_color) ---

	/* =============================================================================
	*
	*                                  BUTTON
	*
	* ============================================================================= */
	nk_button_text                :: proc(_: ^nk_context, title: cstring, len: c.int) -> nk_bool ---
	nk_button_label               :: proc(_: ^nk_context, title: cstring) -> nk_bool ---
	nk_button_color               :: proc(_: ^nk_context, _: nk_color) -> nk_bool ---
	nk_button_symbol              :: proc(_: ^nk_context, _: nk_symbol_type) -> nk_bool ---
	nk_button_image               :: proc(_: ^nk_context, img: nk_image) -> nk_bool ---
	nk_button_symbol_label        :: proc(_: ^nk_context, _: nk_symbol_type, _: cstring, text_alignment: nk_flags) -> nk_bool ---
	nk_button_symbol_text         :: proc(_: ^nk_context, _: nk_symbol_type, _: cstring, _: c.int, alignment: nk_flags) -> nk_bool ---
	nk_button_image_label         :: proc(_: ^nk_context, img: nk_image, _: cstring, text_alignment: nk_flags) -> nk_bool ---
	nk_button_image_text          :: proc(_: ^nk_context, img: nk_image, _: cstring, _: c.int, alignment: nk_flags) -> nk_bool ---
	nk_button_text_styled         :: proc(_: ^nk_context, _: ^nk_style_button, title: cstring, len: c.int) -> nk_bool ---
	nk_button_label_styled        :: proc(_: ^nk_context, _: ^nk_style_button, title: cstring) -> nk_bool ---
	nk_button_symbol_styled       :: proc(_: ^nk_context, _: ^nk_style_button, _: nk_symbol_type) -> nk_bool ---
	nk_button_image_styled        :: proc(_: ^nk_context, _: ^nk_style_button, img: nk_image) -> nk_bool ---
	nk_button_symbol_text_styled  :: proc(_: ^nk_context, _: ^nk_style_button, _: nk_symbol_type, _: cstring, _: c.int, alignment: nk_flags) -> nk_bool ---
	nk_button_symbol_label_styled :: proc(ctx: ^nk_context, style: ^nk_style_button, symbol: nk_symbol_type, title: cstring, align: nk_flags) -> nk_bool ---
	nk_button_image_label_styled  :: proc(_: ^nk_context, _: ^nk_style_button, img: nk_image, _: cstring, text_alignment: nk_flags) -> nk_bool ---
	nk_button_image_text_styled   :: proc(_: ^nk_context, _: ^nk_style_button, img: nk_image, _: cstring, _: c.int, alignment: nk_flags) -> nk_bool ---
	nk_button_set_behavior        :: proc(_: ^nk_context, _: nk_button_behavior) ---
	nk_button_push_behavior       :: proc(_: ^nk_context, _: nk_button_behavior) -> nk_bool ---
	nk_button_pop_behavior        :: proc(_: ^nk_context) -> nk_bool ---

	/* =============================================================================
	*
	*                                  CHECKBOX
	*
	* ============================================================================= */
	nk_check_label          :: proc(_: ^nk_context, _: cstring, active: nk_bool) -> nk_bool ---
	nk_check_text           :: proc(_: ^nk_context, _: cstring, _: c.int, active: nk_bool) -> nk_bool ---
	nk_check_text_align     :: proc(_: ^nk_context, _: cstring, _: c.int, active: nk_bool, widget_alignment: nk_flags, text_alignment: nk_flags) -> nk_bool ---
	nk_check_flags_label    :: proc(_: ^nk_context, _: cstring, flags: c.uint, value: c.uint) -> c.uint ---
	nk_check_flags_text     :: proc(_: ^nk_context, _: cstring, _: c.int, flags: c.uint, value: c.uint) -> c.uint ---
	nk_checkbox_label       :: proc(_: ^nk_context, _: cstring, active: ^nk_bool) -> nk_bool ---
	nk_checkbox_label_align :: proc(ctx: ^nk_context, label: cstring, active: ^nk_bool, widget_alignment: nk_flags, text_alignment: nk_flags) -> nk_bool ---
	nk_checkbox_text        :: proc(_: ^nk_context, _: cstring, _: c.int, active: ^nk_bool) -> nk_bool ---
	nk_checkbox_text_align  :: proc(ctx: ^nk_context, text: cstring, len: c.int, active: ^nk_bool, widget_alignment: nk_flags, text_alignment: nk_flags) -> nk_bool ---
	nk_checkbox_flags_label :: proc(_: ^nk_context, _: cstring, flags: ^c.uint, value: c.uint) -> nk_bool ---
	nk_checkbox_flags_text  :: proc(_: ^nk_context, _: cstring, _: c.int, flags: ^c.uint, value: c.uint) -> nk_bool ---

	/* =============================================================================
	*
	*                                  RADIO BUTTON
	*
	* ============================================================================= */
	nk_radio_label        :: proc(_: ^nk_context, _: cstring, active: ^nk_bool) -> nk_bool ---
	nk_radio_label_align  :: proc(ctx: ^nk_context, label: cstring, active: ^nk_bool, widget_alignment: nk_flags, text_alignment: nk_flags) -> nk_bool ---
	nk_radio_text         :: proc(_: ^nk_context, _: cstring, _: c.int, active: ^nk_bool) -> nk_bool ---
	nk_radio_text_align   :: proc(ctx: ^nk_context, text: cstring, len: c.int, active: ^nk_bool, widget_alignment: nk_flags, text_alignment: nk_flags) -> nk_bool ---
	nk_option_label       :: proc(_: ^nk_context, _: cstring, active: nk_bool) -> nk_bool ---
	nk_option_label_align :: proc(ctx: ^nk_context, label: cstring, active: nk_bool, widget_alignment: nk_flags, text_alignment: nk_flags) -> nk_bool ---
	nk_option_text        :: proc(_: ^nk_context, _: cstring, _: c.int, active: nk_bool) -> nk_bool ---
	nk_option_text_align  :: proc(ctx: ^nk_context, text: cstring, len: c.int, is_active: nk_bool, widget_alignment: nk_flags, text_alignment: nk_flags) -> nk_bool ---

	/* =============================================================================
	*
	*                                  SELECTABLE
	*
	* ============================================================================= */
	nk_selectable_label        :: proc(_: ^nk_context, _: cstring, align: nk_flags, value: ^nk_bool) -> nk_bool ---
	nk_selectable_text         :: proc(_: ^nk_context, _: cstring, _: c.int, align: nk_flags, value: ^nk_bool) -> nk_bool ---
	nk_selectable_image_label  :: proc(_: ^nk_context, _: nk_image, _: cstring, align: nk_flags, value: ^nk_bool) -> nk_bool ---
	nk_selectable_image_text   :: proc(_: ^nk_context, _: nk_image, _: cstring, _: c.int, align: nk_flags, value: ^nk_bool) -> nk_bool ---
	nk_selectable_symbol_label :: proc(_: ^nk_context, _: nk_symbol_type, _: cstring, align: nk_flags, value: ^nk_bool) -> nk_bool ---
	nk_selectable_symbol_text  :: proc(_: ^nk_context, _: nk_symbol_type, _: cstring, _: c.int, align: nk_flags, value: ^nk_bool) -> nk_bool ---
	nk_select_label            :: proc(_: ^nk_context, _: cstring, align: nk_flags, value: nk_bool) -> nk_bool ---
	nk_select_text             :: proc(_: ^nk_context, _: cstring, _: c.int, align: nk_flags, value: nk_bool) -> nk_bool ---
	nk_select_image_label      :: proc(_: ^nk_context, _: nk_image, _: cstring, align: nk_flags, value: nk_bool) -> nk_bool ---
	nk_select_image_text       :: proc(_: ^nk_context, _: nk_image, _: cstring, _: c.int, align: nk_flags, value: nk_bool) -> nk_bool ---
	nk_select_symbol_label     :: proc(_: ^nk_context, _: nk_symbol_type, _: cstring, align: nk_flags, value: nk_bool) -> nk_bool ---
	nk_select_symbol_text      :: proc(_: ^nk_context, _: nk_symbol_type, _: cstring, _: c.int, align: nk_flags, value: nk_bool) -> nk_bool ---

	/* =============================================================================
	*
	*                                  SLIDER
	*
	* ============================================================================= */
	nk_slide_float  :: proc(_: ^nk_context, min: f32, val: f32, max: f32, step: f32) -> f32 ---
	nk_slide_int    :: proc(_: ^nk_context, min: c.int, val: c.int, max: c.int, step: c.int) -> c.int ---
	nk_slider_float :: proc(_: ^nk_context, min: f32, val: ^f32, max: f32, step: f32) -> nk_bool ---
	nk_slider_int   :: proc(_: ^nk_context, min: c.int, val: ^c.int, max: c.int, step: c.int) -> nk_bool ---

	/* =============================================================================
	*
	*                                   KNOB
	*
	* ============================================================================= */
	nk_knob_float :: proc(_: ^nk_context, min: f32, val: ^f32, max: f32, step: f32, zero_direction: nk_heading, dead_zone_degrees: f32) -> nk_bool ---
	nk_knob_int   :: proc(_: ^nk_context, min: c.int, val: ^c.int, max: c.int, step: c.int, zero_direction: nk_heading, dead_zone_degrees: f32) -> nk_bool ---

	/* =============================================================================
	*
	*                                  PROGRESSBAR
	*
	* ============================================================================= */
	nk_progress :: proc(_: ^nk_context, cur: ^nk_size, max: nk_size, modifyable: nk_bool) -> nk_bool ---
	nk_prog     :: proc(_: ^nk_context, cur: nk_size, max: nk_size, modifyable: nk_bool) -> nk_size ---

	/* =============================================================================
	*
	*                                  COLOR PICKER
	*
	* ============================================================================= */
	nk_color_picker :: proc(_: ^nk_context, _: nk_colorf, _: nk_color_format) -> nk_colorf ---
	nk_color_pick   :: proc(_: ^nk_context, _: ^nk_colorf, _: nk_color_format) -> nk_bool ---

	/* =============================================================================
	*
	*                                  PROPERTIES
	*
	* =============================================================================*/
	/**
	* \page Properties
	* Properties are the main value modification widgets in Nuklear. Changing a value
	* can be achieved by dragging, adding/removing incremental steps on button click
	* or by directly typing a number.
	*
	* # Usage
	* Each property requires a unique name for identification that is also used for
	* displaying a label. If you want to use the same name multiple times make sure
	* add a '#' before your name. The '#' will not be shown but will generate a
	* unique ID. Each property also takes in a minimum and maximum value. If you want
	* to make use of the complete number range of a type just use the provided
	* type limits from `limits.h`. For example `INT_MIN` and `INT_MAX` for
	* `nk_property_int` and `nk_propertyi`. In additional each property takes in
	* a increment value that will be added or subtracted if either the increment
	* decrement button is clicked. Finally there is a value for increment per pixel
	* dragged that is added or subtracted from the value.
	*
	* ```c
	* int value = 0;
	* struct nk_context ctx;
	* nk_init_xxx(&ctx, ...);
	* while (1) {
	*     // Input
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
	*     //
	*     // Window
	*     if (nk_begin_xxx(...) {
	*         // Property
	*         nk_layout_row_dynamic(...);
	*         nk_property_int(ctx, "ID", INT_MIN, &value, INT_MAX, 1, 1);
	*     }
	*     nk_end(ctx);
	*     //
	*     // Draw
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
	* # Reference
	* Function            | Description
	* --------------------|-------------------------------------------
	* \ref nk_property_int     | Integer property directly modifying a passed in value
	* \ref nk_property_float   | Float property directly modifying a passed in value
	* \ref nk_property_double  | Double property directly modifying a passed in value
	* \ref nk_propertyi        | Integer property returning the modified int value
	* \ref nk_propertyf        | Float property returning the modified float value
	* \ref nk_propertyd        | Double property returning the modified double value
	*
	
	* # # nk_property_int
	* Integer property directly modifying a passed in value
	* !!! \warning
	*     To generate a unique property ID using the same label make sure to insert
	*     a `#` at the beginning. It will not be shown but guarantees correct behavior.
	*
	* ```c
	* void nk_property_int(struct nk_context *ctx, const char *name, int min, int *val, int max, int step, float inc_per_pixel);
	* ```
	*
	* Parameter           | Description
	* --------------------|-----------------------------------------------------------
	* \param[in] ctx             | Must point to an previously initialized `nk_context` struct after calling a layouting function
	* \param[in] name            | String used both as a label as well as a unique identifier
	* \param[in] min             | Minimum value not allowed to be underflown
	* \param[in] val             | Integer pointer to be modified
	* \param[in] max             | Maximum value not allowed to be overflown
	* \param[in] step            | Increment added and subtracted on increment and decrement button
	* \param[in] inc_per_pixel   | Value per pixel added or subtracted on dragging
	*/
	nk_property_int :: proc(_: ^nk_context, name: cstring, min: c.int, val: ^c.int, max: c.int, step: c.int, inc_per_pixel: f32) ---

	/**
	* # # nk_property_float
	* Float property directly modifying a passed in value
	* !!! \warning
	*     To generate a unique property ID using the same label make sure to insert
	*     a `#` at the beginning. It will not be shown but guarantees correct behavior.
	*
	* ```c
	* void nk_property_float(struct nk_context *ctx, const char *name, float min, float *val, float max, float step, float inc_per_pixel);
	* ```
	*
	* Parameter           | Description
	* --------------------|-----------------------------------------------------------
	* \param[in] ctx             | Must point to an previously initialized `nk_context` struct after calling a layouting function
	* \param[in] name            | String used both as a label as well as a unique identifier
	* \param[in] min             | Minimum value not allowed to be underflown
	* \param[in] val             | Float pointer to be modified
	* \param[in] max             | Maximum value not allowed to be overflown
	* \param[in] step            | Increment added and subtracted on increment and decrement button
	* \param[in] inc_per_pixel   | Value per pixel added or subtracted on dragging
	*/
	nk_property_float :: proc(_: ^nk_context, name: cstring, min: f32, val: ^f32, max: f32, step: f32, inc_per_pixel: f32) ---

	/**
	* # # nk_property_double
	* Double property directly modifying a passed in value
	* !!! \warning
	*     To generate a unique property ID using the same label make sure to insert
	*     a `#` at the beginning. It will not be shown but guarantees correct behavior.
	*
	* ```c
	* void nk_property_double(struct nk_context *ctx, const char *name, double min, double *val, double max, double step, double inc_per_pixel);
	* ```
	*
	* Parameter           | Description
	* --------------------|-----------------------------------------------------------
	* \param[in] ctx             | Must point to an previously initialized `nk_context` struct after calling a layouting function
	* \param[in] name            | String used both as a label as well as a unique identifier
	* \param[in] min             | Minimum value not allowed to be underflown
	* \param[in] val             | Double pointer to be modified
	* \param[in] max             | Maximum value not allowed to be overflown
	* \param[in] step            | Increment added and subtracted on increment and decrement button
	* \param[in] inc_per_pixel   | Value per pixel added or subtracted on dragging
	*/
	nk_property_double :: proc(_: ^nk_context, name: cstring, min: f64, val: ^f64, max: f64, step: f64, inc_per_pixel: f32) ---

	/**
	* # # nk_propertyi
	* Integer property modifying a passed in value and returning the new value
	* !!! \warning
	*     To generate a unique property ID using the same label make sure to insert
	*     a `#` at the beginning. It will not be shown but guarantees correct behavior.
	*
	* ```c
	* int nk_propertyi(struct nk_context *ctx, const char *name, int min, int val, int max, int step, float inc_per_pixel);
	* ```
	*
	* \param[in] ctx              Must point to an previously initialized `nk_context` struct after calling a layouting function
	* \param[in] name             String used both as a label as well as a unique identifier
	* \param[in] min              Minimum value not allowed to be underflown
	* \param[in] val              Current integer value to be modified and returned
	* \param[in] max              Maximum value not allowed to be overflown
	* \param[in] step             Increment added and subtracted on increment and decrement button
	* \param[in] inc_per_pixel    Value per pixel added or subtracted on dragging
	*
	* \returns the new modified integer value
	*/
	nk_propertyi :: proc(_: ^nk_context, name: cstring, min: c.int, val: c.int, max: c.int, step: c.int, inc_per_pixel: f32) -> c.int ---

	/**
	* # # nk_propertyf
	* Float property modifying a passed in value and returning the new value
	* !!! \warning
	*     To generate a unique property ID using the same label make sure to insert
	*     a `#` at the beginning. It will not be shown but guarantees correct behavior.
	*
	* ```c
	* float nk_propertyf(struct nk_context *ctx, const char *name, float min, float val, float max, float step, float inc_per_pixel);
	* ```
	*
	* \param[in] ctx              Must point to an previously initialized `nk_context` struct after calling a layouting function
	* \param[in] name             String used both as a label as well as a unique identifier
	* \param[in] min              Minimum value not allowed to be underflown
	* \param[in] val              Current float value to be modified and returned
	* \param[in] max              Maximum value not allowed to be overflown
	* \param[in] step             Increment added and subtracted on increment and decrement button
	* \param[in] inc_per_pixel    Value per pixel added or subtracted on dragging
	*
	* \returns the new modified float value
	*/
	nk_propertyf :: proc(_: ^nk_context, name: cstring, min: f32, val: f32, max: f32, step: f32, inc_per_pixel: f32) -> f32 ---

	/**
	* # # nk_propertyd
	* Float property modifying a passed in value and returning the new value
	* !!! \warning
	*     To generate a unique property ID using the same label make sure to insert
	*     a `#` at the beginning. It will not be shown but guarantees correct behavior.
	*
	* ```c
	* float nk_propertyd(struct nk_context *ctx, const char *name, double min, double val, double max, double step, double inc_per_pixel);
	* ```
	*
	* \param[in] ctx              Must point to an previously initialized `nk_context` struct after calling a layouting function
	* \param[in] name             String used both as a label as well as a unique identifier
	* \param[in] min              Minimum value not allowed to be underflown
	* \param[in] val              Current double value to be modified and returned
	* \param[in] max              Maximum value not allowed to be overflown
	* \param[in] step             Increment added and subtracted on increment and decrement button
	* \param[in] inc_per_pixel    Value per pixel added or subtracted on dragging
	*
	* \returns the new modified double value
	*/
	nk_propertyd                   :: proc(_: ^nk_context, name: cstring, min: f64, val: f64, max: f64, step: f64, inc_per_pixel: f32) -> f64 ---
	nk_edit_string                 :: proc(_: ^nk_context, _: nk_flags, buffer: cstring, len: ^c.int, max: c.int, _: nk_plugin_filter) -> nk_flags ---
	nk_edit_string_zero_terminated :: proc(_: ^nk_context, _: nk_flags, buffer: cstring, max: c.int, _: nk_plugin_filter) -> nk_flags ---
	nk_edit_buffer                 :: proc(_: ^nk_context, _: nk_flags, _: ^nk_text_edit, _: nk_plugin_filter) -> nk_flags ---
	nk_edit_focus                  :: proc(_: ^nk_context, flags: nk_flags) ---
	nk_edit_unfocus                :: proc(_: ^nk_context) ---

	/* =============================================================================
	*
	*                                  CHART
	*
	* ============================================================================= */
	nk_chart_begin            :: proc(_: ^nk_context, _: nk_chart_type, num: c.int, min: f32, max: f32) -> nk_bool ---
	nk_chart_begin_colored    :: proc(_: ^nk_context, _: nk_chart_type, _: nk_color, active: nk_color, num: c.int, min: f32, max: f32) -> nk_bool ---
	nk_chart_add_slot         :: proc(ctx: ^nk_context, _: nk_chart_type, count: c.int, min_value: f32, max_value: f32) ---
	nk_chart_add_slot_colored :: proc(ctx: ^nk_context, _: nk_chart_type, _: nk_color, active: nk_color, count: c.int, min_value: f32, max_value: f32) ---
	nk_chart_push             :: proc(_: ^nk_context, _: f32) -> nk_flags ---
	nk_chart_push_slot        :: proc(_: ^nk_context, _: f32, _: c.int) -> nk_flags ---
	nk_chart_end              :: proc(_: ^nk_context) ---
	nk_plot                   :: proc(_: ^nk_context, _: nk_chart_type, values: ^f32, count: c.int, offset: c.int) ---
	nk_plot_function          :: proc(_: ^nk_context, _: nk_chart_type, userdata: rawptr, value_getter: proc "c" (rawptr, c.int) -> f32, count: c.int, offset: c.int) ---

	/* =============================================================================
	*
	*                                  POPUP
	*
	* ============================================================================= */
	nk_popup_begin      :: proc(_: ^nk_context, _: nk_popup_type, _: cstring, _: nk_flags, bounds: nk_rect) -> nk_bool ---
	nk_popup_close      :: proc(_: ^nk_context) ---
	nk_popup_end        :: proc(_: ^nk_context) ---
	nk_popup_get_scroll :: proc(_: ^nk_context, offset_x: ^nk_uint, offset_y: ^nk_uint) ---
	nk_popup_set_scroll :: proc(_: ^nk_context, offset_x: nk_uint, offset_y: nk_uint) ---

	/* =============================================================================
	*
	*                                  COMBOBOX
	*
	* ============================================================================= */
	nk_combo              :: proc(_: ^nk_context, items: [^]cstring, count: c.int, selected: c.int, item_height: c.int, size: nk_vec2) -> c.int ---
	nk_combo_separator    :: proc(_: ^nk_context, items_separated_by_separator: cstring, separator: c.int, selected: c.int, count: c.int, item_height: c.int, size: nk_vec2) -> c.int ---
	nk_combo_string       :: proc(_: ^nk_context, items_separated_by_zeros: cstring, selected: c.int, count: c.int, item_height: c.int, size: nk_vec2) -> c.int ---
	nk_combo_callback     :: proc(_: ^nk_context, item_getter: proc "c" (rawptr, c.int, ^^c.char), userdata: rawptr, selected: c.int, count: c.int, item_height: c.int, size: nk_vec2) -> c.int ---
	nk_combobox           :: proc(_: ^nk_context, items: [^]cstring, count: c.int, selected: ^c.int, item_height: c.int, size: nk_vec2) ---
	nk_combobox_string    :: proc(_: ^nk_context, items_separated_by_zeros: cstring, selected: ^c.int, count: c.int, item_height: c.int, size: nk_vec2) ---
	nk_combobox_separator :: proc(_: ^nk_context, items_separated_by_separator: cstring, separator: c.int, selected: ^c.int, count: c.int, item_height: c.int, size: nk_vec2) ---
	nk_combobox_callback  :: proc(_: ^nk_context, item_getter: proc "c" (rawptr, c.int, ^^c.char), _: rawptr, selected: ^c.int, count: c.int, item_height: c.int, size: nk_vec2) ---

	/* =============================================================================
	*
	*                                  ABSTRACT COMBOBOX
	*
	* ============================================================================= */
	nk_combo_begin_text         :: proc(_: ^nk_context, selected: cstring, _: c.int, size: nk_vec2) -> nk_bool ---
	nk_combo_begin_label        :: proc(_: ^nk_context, selected: cstring, size: nk_vec2) -> nk_bool ---
	nk_combo_begin_color        :: proc(_: ^nk_context, color: nk_color, size: nk_vec2) -> nk_bool ---
	nk_combo_begin_symbol       :: proc(_: ^nk_context, _: nk_symbol_type, size: nk_vec2) -> nk_bool ---
	nk_combo_begin_symbol_label :: proc(_: ^nk_context, selected: cstring, _: nk_symbol_type, size: nk_vec2) -> nk_bool ---
	nk_combo_begin_symbol_text  :: proc(_: ^nk_context, selected: cstring, _: c.int, _: nk_symbol_type, size: nk_vec2) -> nk_bool ---
	nk_combo_begin_image        :: proc(_: ^nk_context, img: nk_image, size: nk_vec2) -> nk_bool ---
	nk_combo_begin_image_label  :: proc(_: ^nk_context, selected: cstring, _: nk_image, size: nk_vec2) -> nk_bool ---
	nk_combo_begin_image_text   :: proc(_: ^nk_context, selected: cstring, _: c.int, _: nk_image, size: nk_vec2) -> nk_bool ---
	nk_combo_item_label         :: proc(_: ^nk_context, _: cstring, alignment: nk_flags) -> nk_bool ---
	nk_combo_item_text          :: proc(_: ^nk_context, _: cstring, _: c.int, alignment: nk_flags) -> nk_bool ---
	nk_combo_item_image_label   :: proc(_: ^nk_context, _: nk_image, _: cstring, alignment: nk_flags) -> nk_bool ---
	nk_combo_item_image_text    :: proc(_: ^nk_context, _: nk_image, _: cstring, _: c.int, alignment: nk_flags) -> nk_bool ---
	nk_combo_item_symbol_label  :: proc(_: ^nk_context, _: nk_symbol_type, _: cstring, alignment: nk_flags) -> nk_bool ---
	nk_combo_item_symbol_text   :: proc(_: ^nk_context, _: nk_symbol_type, _: cstring, _: c.int, alignment: nk_flags) -> nk_bool ---
	nk_combo_close              :: proc(_: ^nk_context) ---
	nk_combo_end                :: proc(_: ^nk_context) ---

	/* =============================================================================
	*
	*                                  CONTEXTUAL
	*
	* ============================================================================= */
	nk_contextual_begin             :: proc(_: ^nk_context, _: nk_flags, _: nk_vec2, trigger_bounds: nk_rect) -> nk_bool ---
	nk_contextual_item_text         :: proc(_: ^nk_context, _: cstring, _: c.int, align: nk_flags) -> nk_bool ---
	nk_contextual_item_label        :: proc(_: ^nk_context, _: cstring, align: nk_flags) -> nk_bool ---
	nk_contextual_item_image_label  :: proc(_: ^nk_context, _: nk_image, _: cstring, alignment: nk_flags) -> nk_bool ---
	nk_contextual_item_image_text   :: proc(_: ^nk_context, _: nk_image, _: cstring, len: c.int, alignment: nk_flags) -> nk_bool ---
	nk_contextual_item_symbol_label :: proc(_: ^nk_context, _: nk_symbol_type, _: cstring, alignment: nk_flags) -> nk_bool ---
	nk_contextual_item_symbol_text  :: proc(_: ^nk_context, _: nk_symbol_type, _: cstring, _: c.int, alignment: nk_flags) -> nk_bool ---
	nk_contextual_close             :: proc(_: ^nk_context) ---
	nk_contextual_end               :: proc(_: ^nk_context) ---

	/* =============================================================================
	*
	*                                  TOOLTIP
	*
	* ============================================================================= */
	nk_tooltip       :: proc(_: ^nk_context, _: cstring) ---
	nk_tooltip_begin :: proc(_: ^nk_context, width: f32) -> nk_bool ---
	nk_tooltip_end   :: proc(_: ^nk_context) ---

	/* =============================================================================
	*
	*                                  MENU
	*
	* ============================================================================= */
	nk_menubar_begin           :: proc(_: ^nk_context) ---
	nk_menubar_end             :: proc(_: ^nk_context) ---
	nk_menu_begin_text         :: proc(_: ^nk_context, title: cstring, title_len: c.int, align: nk_flags, size: nk_vec2) -> nk_bool ---
	nk_menu_begin_label        :: proc(_: ^nk_context, _: cstring, align: nk_flags, size: nk_vec2) -> nk_bool ---
	nk_menu_begin_image        :: proc(_: ^nk_context, _: cstring, _: nk_image, size: nk_vec2) -> nk_bool ---
	nk_menu_begin_image_text   :: proc(_: ^nk_context, _: cstring, _: c.int, align: nk_flags, _: nk_image, size: nk_vec2) -> nk_bool ---
	nk_menu_begin_image_label  :: proc(_: ^nk_context, _: cstring, align: nk_flags, _: nk_image, size: nk_vec2) -> nk_bool ---
	nk_menu_begin_symbol       :: proc(_: ^nk_context, _: cstring, _: nk_symbol_type, size: nk_vec2) -> nk_bool ---
	nk_menu_begin_symbol_text  :: proc(_: ^nk_context, _: cstring, _: c.int, align: nk_flags, _: nk_symbol_type, size: nk_vec2) -> nk_bool ---
	nk_menu_begin_symbol_label :: proc(_: ^nk_context, _: cstring, align: nk_flags, _: nk_symbol_type, size: nk_vec2) -> nk_bool ---
	nk_menu_item_text          :: proc(_: ^nk_context, _: cstring, _: c.int, align: nk_flags) -> nk_bool ---
	nk_menu_item_label         :: proc(_: ^nk_context, _: cstring, alignment: nk_flags) -> nk_bool ---
	nk_menu_item_image_label   :: proc(_: ^nk_context, _: nk_image, _: cstring, alignment: nk_flags) -> nk_bool ---
	nk_menu_item_image_text    :: proc(_: ^nk_context, _: nk_image, _: cstring, len: c.int, alignment: nk_flags) -> nk_bool ---
	nk_menu_item_symbol_text   :: proc(_: ^nk_context, _: nk_symbol_type, _: cstring, _: c.int, alignment: nk_flags) -> nk_bool ---
	nk_menu_item_symbol_label  :: proc(_: ^nk_context, _: nk_symbol_type, _: cstring, alignment: nk_flags) -> nk_bool ---
	nk_menu_close              :: proc(_: ^nk_context) ---
	nk_menu_end                :: proc(_: ^nk_context) ---
	nk_style_default           :: proc(_: ^nk_context) ---
	nk_style_from_table        :: proc(_: ^nk_context, _: ^nk_color) ---
	nk_style_load_cursor       :: proc(_: ^nk_context, _: nk_style_cursor, _: ^nk_cursor) ---
	nk_style_load_all_cursors  :: proc(_: ^nk_context, _: ^nk_cursor) ---
	nk_style_get_color_by_name :: proc(_: nk_style_colors) -> cstring ---
	nk_style_set_font          :: proc(_: ^nk_context, _: ^nk_user_font) ---
	nk_style_set_cursor        :: proc(_: ^nk_context, _: nk_style_cursor) -> nk_bool ---
	nk_style_show_cursor       :: proc(_: ^nk_context) ---
	nk_style_hide_cursor       :: proc(_: ^nk_context) ---
	nk_style_push_font         :: proc(_: ^nk_context, _: ^nk_user_font) -> nk_bool ---
	nk_style_push_float        :: proc(_: ^nk_context, _: ^f32, _: f32) -> nk_bool ---
	nk_style_push_vec2         :: proc(_: ^nk_context, _: ^nk_vec2, _: nk_vec2) -> nk_bool ---
	nk_style_push_style_item   :: proc(_: ^nk_context, _: ^nk_style_item, _: nk_style_item) -> nk_bool ---
	nk_style_push_flags        :: proc(_: ^nk_context, _: ^nk_flags, _: nk_flags) -> nk_bool ---
	nk_style_push_color        :: proc(_: ^nk_context, _: ^nk_color, _: nk_color) -> nk_bool ---
	nk_style_pop_font          :: proc(_: ^nk_context) -> nk_bool ---
	nk_style_pop_float         :: proc(_: ^nk_context) -> nk_bool ---
	nk_style_pop_vec2          :: proc(_: ^nk_context) -> nk_bool ---
	nk_style_pop_style_item    :: proc(_: ^nk_context) -> nk_bool ---
	nk_style_pop_flags         :: proc(_: ^nk_context) -> nk_bool ---
	nk_style_pop_color         :: proc(_: ^nk_context) -> nk_bool ---

	/* =============================================================================
	*
	*                                  COLOR
	*
	* ============================================================================= */
	nk_rgb            :: proc(r: c.int, g: c.int, b: c.int) -> nk_color ---
	nk_rgb_iv         :: proc(rgb: ^c.int) -> nk_color ---
	nk_rgb_bv         :: proc(rgb: ^nk_byte) -> nk_color ---
	nk_rgb_f          :: proc(r: f32, g: f32, b: f32) -> nk_color ---
	nk_rgb_fv         :: proc(rgb: ^f32) -> nk_color ---
	nk_rgb_cf         :: proc(_c: nk_colorf) -> nk_color ---
	nk_rgb_hex        :: proc(rgb: cstring) -> nk_color ---
	nk_rgb_factor     :: proc(col: nk_color, factor: f32) -> nk_color ---
	nk_rgba           :: proc(r: c.int, g: c.int, b: c.int, a: c.int) -> nk_color ---
	nk_rgba_u32       :: proc(_: nk_uint) -> nk_color ---
	nk_rgba_iv        :: proc(rgba: ^c.int) -> nk_color ---
	nk_rgba_bv        :: proc(rgba: ^nk_byte) -> nk_color ---
	nk_rgba_f         :: proc(r: f32, g: f32, b: f32, a: f32) -> nk_color ---
	nk_rgba_fv        :: proc(rgba: ^f32) -> nk_color ---
	nk_rgba_cf        :: proc(_c: nk_colorf) -> nk_color ---
	nk_rgba_hex       :: proc(rgb: cstring) -> nk_color ---
	nk_hsva_colorf    :: proc(h: f32, s: f32, v: f32, a: f32) -> nk_colorf ---
	nk_hsva_colorfv   :: proc(_c: ^f32) -> nk_colorf ---
	nk_colorf_hsva_f  :: proc(out_h: ^f32, out_s: ^f32, out_v: ^f32, out_a: ^f32, _in: nk_colorf) ---
	nk_colorf_hsva_fv :: proc(hsva: ^f32, _in: nk_colorf) ---
	nk_hsv            :: proc(h: c.int, s: c.int, v: c.int) -> nk_color ---
	nk_hsv_iv         :: proc(hsv: ^c.int) -> nk_color ---
	nk_hsv_bv         :: proc(hsv: ^nk_byte) -> nk_color ---
	nk_hsv_f          :: proc(h: f32, s: f32, v: f32) -> nk_color ---
	nk_hsv_fv         :: proc(hsv: ^f32) -> nk_color ---
	nk_hsva           :: proc(h: c.int, s: c.int, v: c.int, a: c.int) -> nk_color ---
	nk_hsva_iv        :: proc(hsva: ^c.int) -> nk_color ---
	nk_hsva_bv        :: proc(hsva: ^nk_byte) -> nk_color ---
	nk_hsva_f         :: proc(h: f32, s: f32, v: f32, a: f32) -> nk_color ---
	nk_hsva_fv        :: proc(hsva: ^f32) -> nk_color ---

	/* color (conversion nuklear --> user) */
	nk_color_f        :: proc(r: ^f32, g: ^f32, b: ^f32, a: ^f32, _: nk_color) ---
	nk_color_fv       :: proc(rgba_out: ^f32, _: nk_color) ---
	nk_color_cf       :: proc(_: nk_color) -> nk_colorf ---
	nk_color_d        :: proc(r: ^f64, g: ^f64, b: ^f64, a: ^f64, _: nk_color) ---
	nk_color_dv       :: proc(rgba_out: ^f64, _: nk_color) ---
	nk_color_u32      :: proc(_: nk_color) -> nk_uint ---
	nk_color_hex_rgba :: proc(output: cstring, _: nk_color) ---
	nk_color_hex_rgb  :: proc(output: cstring, _: nk_color) ---
	nk_color_hsv_i    :: proc(out_h: ^c.int, out_s: ^c.int, out_v: ^c.int, _: nk_color) ---
	nk_color_hsv_b    :: proc(out_h: ^nk_byte, out_s: ^nk_byte, out_v: ^nk_byte, _: nk_color) ---
	nk_color_hsv_iv   :: proc(hsv_out: ^c.int, _: nk_color) ---
	nk_color_hsv_bv   :: proc(hsv_out: ^nk_byte, _: nk_color) ---
	nk_color_hsv_f    :: proc(out_h: ^f32, out_s: ^f32, out_v: ^f32, _: nk_color) ---
	nk_color_hsv_fv   :: proc(hsv_out: ^f32, _: nk_color) ---
	nk_color_hsva_i   :: proc(h: ^c.int, s: ^c.int, v: ^c.int, a: ^c.int, _: nk_color) ---
	nk_color_hsva_b   :: proc(h: ^nk_byte, s: ^nk_byte, v: ^nk_byte, a: ^nk_byte, _: nk_color) ---
	nk_color_hsva_iv  :: proc(hsva_out: ^c.int, _: nk_color) ---
	nk_color_hsva_bv  :: proc(hsva_out: ^nk_byte, _: nk_color) ---
	nk_color_hsva_f   :: proc(out_h: ^f32, out_s: ^f32, out_v: ^f32, out_a: ^f32, _: nk_color) ---
	nk_color_hsva_fv  :: proc(hsva_out: ^f32, _: nk_color) ---

	/* =============================================================================
	*
	*                                  IMAGE
	*
	* ============================================================================= */
	nk_handle_ptr        :: proc(_: rawptr) -> nk_handle ---
	nk_handle_id         :: proc(_: c.int) -> nk_handle ---
	nk_image_handle      :: proc(_: nk_handle) -> nk_image ---
	nk_image_ptr         :: proc(_: rawptr) -> nk_image ---
	nk_image_id          :: proc(_: c.int) -> nk_image ---
	nk_image_is_subimage :: proc(img: ^nk_image) -> nk_bool ---
	nk_subimage_ptr      :: proc(_: rawptr, w: nk_ushort, h: nk_ushort, sub_region: nk_rect) -> nk_image ---
	nk_subimage_id       :: proc(_: c.int, w: nk_ushort, h: nk_ushort, sub_region: nk_rect) -> nk_image ---
	nk_subimage_handle   :: proc(_: nk_handle, w: nk_ushort, h: nk_ushort, sub_region: nk_rect) -> nk_image ---

	/* =============================================================================
	*
	*                                  9-SLICE
	*
	* ============================================================================= */
	nk_nine_slice_handle       :: proc(_: nk_handle, l: nk_ushort, t: nk_ushort, r: nk_ushort, b: nk_ushort) -> nk_nine_slice ---
	nk_nine_slice_ptr          :: proc(_: rawptr, l: nk_ushort, t: nk_ushort, r: nk_ushort, b: nk_ushort) -> nk_nine_slice ---
	nk_nine_slice_id           :: proc(_: c.int, l: nk_ushort, t: nk_ushort, r: nk_ushort, b: nk_ushort) -> nk_nine_slice ---
	nk_nine_slice_is_sub9slice :: proc(img: ^nk_nine_slice) -> c.int ---
	nk_sub9slice_ptr           :: proc(_: rawptr, w: nk_ushort, h: nk_ushort, sub_region: nk_rect, l: nk_ushort, t: nk_ushort, r: nk_ushort, b: nk_ushort) -> nk_nine_slice ---
	nk_sub9slice_id            :: proc(_: c.int, w: nk_ushort, h: nk_ushort, sub_region: nk_rect, l: nk_ushort, t: nk_ushort, r: nk_ushort, b: nk_ushort) -> nk_nine_slice ---
	nk_sub9slice_handle        :: proc(_: nk_handle, w: nk_ushort, h: nk_ushort, sub_region: nk_rect, l: nk_ushort, t: nk_ushort, r: nk_ushort, b: nk_ushort) -> nk_nine_slice ---

	/* =============================================================================
	*
	*                                  MATH
	*
	* ============================================================================= */
	// nk_murmur_hash             :: proc(key: rawptr, len: c.int, seed: nk_hash) -> nk_hash ---
	// nk_triangle_from_direction :: proc(result: ^nk_vec2, r: nk_rect, pad_x: f32, pad_y: f32, _: nk_heading) ---
	// nk_vec2                    :: proc(x: f32, y: f32) -> nk_vec2 ---
	// @(link_name="nk_vec2i")
	// nk_vec2i_                  :: proc(x: c.int, y: c.int) -> nk_vec2 ---
	// nk_vec2v                   :: proc(xy: ^f32) -> nk_vec2 ---
	// nk_vec2iv                  :: proc(xy: ^c.int) -> nk_vec2 ---
	// nk_get_null_rect           :: proc() -> nk_rect ---
	// nk_rect                    :: proc(x: f32, y: f32, w: f32, h: f32) -> nk_rect ---
	// nk_recti                   :: proc(x: c.int, y: c.int, w: c.int, h: c.int) -> nk_rect ---
	// nk_recta                   :: proc(pos: nk_vec2, size: nk_vec2) -> nk_rect ---
	// nk_rectv                   :: proc(xywh: ^f32) -> nk_rect ---
	// nk_rectiv                  :: proc(xywh: ^c.int) -> nk_rect ---
	// nk_rect_pos                :: proc(_: nk_rect) -> nk_vec2 ---
	// nk_rect_size               :: proc(_: nk_rect) -> nk_vec2 ---

	/* =============================================================================
	*
	*                                  STRING
	*
	* ============================================================================= */
	nk_strlen                :: proc(str: cstring) -> c.int ---
	nk_stricmp               :: proc(s1: cstring, s2: cstring) -> c.int ---
	nk_stricmpn              :: proc(s1: cstring, s2: cstring, n: c.int) -> c.int ---
	nk_strtoi                :: proc(str: cstring, endptr: ^^c.char) -> c.int ---
	nk_strtof                :: proc(str: cstring, endptr: ^^c.char) -> f32 ---
	nk_strtod                :: proc(str: cstring, endptr: ^^c.char) -> f64 ---
	nk_strfilter             :: proc(text: cstring, regexp: cstring) -> c.int ---
	nk_strmatch_fuzzy_string :: proc(str: cstring, pattern: cstring, out_score: ^c.int) -> c.int ---
	nk_strmatch_fuzzy_text   :: proc(txt: cstring, txt_len: c.int, pattern: cstring, out_score: ^c.int) -> c.int ---

	/* =============================================================================
	*
	*                                  UTF-8
	*
	* ============================================================================= */
	nk_utf_decode            :: proc(_: cstring, _: ^nk_rune, _: c.int) -> c.int ---
	nk_utf_encode            :: proc(_: nk_rune, _: cstring, _: c.int) -> c.int ---
	nk_utf_len               :: proc(_: cstring, byte_len: c.int) -> c.int ---
	nk_utf_at                :: proc(buffer: cstring, length: c.int, index: c.int, unicode: ^nk_rune, len: ^c.int) -> cstring ---
	nk_buffer_init           :: proc(_: ^nk_buffer, _: ^nk_allocator, size: nk_size) ---
	nk_buffer_init_fixed     :: proc(_: ^nk_buffer, memory: rawptr, size: nk_size) ---
	nk_buffer_info           :: proc(_: ^nk_memory_status, _: ^nk_buffer) ---
	nk_buffer_push           :: proc(_: ^nk_buffer, type: nk_buffer_allocation_type, memory: rawptr, size: nk_size, align: nk_size) ---
	nk_buffer_mark           :: proc(_: ^nk_buffer, type: nk_buffer_allocation_type) ---
	nk_buffer_reset          :: proc(_: ^nk_buffer, type: nk_buffer_allocation_type) ---
	nk_buffer_clear          :: proc(_: ^nk_buffer) ---
	nk_buffer_free           :: proc(_: ^nk_buffer) ---
	nk_buffer_memory         :: proc(_: ^nk_buffer) -> rawptr ---
	nk_buffer_memory_const   :: proc(_: ^nk_buffer) -> rawptr ---
	nk_buffer_total          :: proc(_: ^nk_buffer) -> nk_size ---
	nk_str_init              :: proc(_: ^nk_str, _: ^nk_allocator, size: nk_size) ---
	nk_str_init_fixed        :: proc(_: ^nk_str, memory: rawptr, size: nk_size) ---
	nk_str_clear             :: proc(_: ^nk_str) ---
	nk_str_free              :: proc(_: ^nk_str) ---
	nk_str_append_text_char  :: proc(_: ^nk_str, _: cstring, _: c.int) -> c.int ---
	nk_str_append_str_char   :: proc(_: ^nk_str, _: cstring) -> c.int ---
	nk_str_append_text_utf8  :: proc(_: ^nk_str, _: cstring, _: c.int) -> c.int ---
	nk_str_append_str_utf8   :: proc(_: ^nk_str, _: cstring) -> c.int ---
	nk_str_append_text_runes :: proc(_: ^nk_str, _: ^nk_rune, _: c.int) -> c.int ---
	nk_str_append_str_runes  :: proc(_: ^nk_str, _: ^nk_rune) -> c.int ---
	nk_str_insert_at_char    :: proc(_: ^nk_str, pos: c.int, _: cstring, _: c.int) -> c.int ---
	nk_str_insert_at_rune    :: proc(_: ^nk_str, pos: c.int, _: cstring, _: c.int) -> c.int ---
	nk_str_insert_text_char  :: proc(_: ^nk_str, pos: c.int, _: cstring, _: c.int) -> c.int ---
	nk_str_insert_str_char   :: proc(_: ^nk_str, pos: c.int, _: cstring) -> c.int ---
	nk_str_insert_text_utf8  :: proc(_: ^nk_str, pos: c.int, _: cstring, _: c.int) -> c.int ---
	nk_str_insert_str_utf8   :: proc(_: ^nk_str, pos: c.int, _: cstring) -> c.int ---
	nk_str_insert_text_runes :: proc(_: ^nk_str, pos: c.int, _: ^nk_rune, _: c.int) -> c.int ---
	nk_str_insert_str_runes  :: proc(_: ^nk_str, pos: c.int, _: ^nk_rune) -> c.int ---
	nk_str_remove_chars      :: proc(_: ^nk_str, len: c.int) ---
	nk_str_remove_runes      :: proc(str: ^nk_str, len: c.int) ---
	nk_str_delete_chars      :: proc(_: ^nk_str, pos: c.int, len: c.int) ---
	nk_str_delete_runes      :: proc(_: ^nk_str, pos: c.int, len: c.int) ---
	nk_str_at_char           :: proc(_: ^nk_str, pos: c.int) -> cstring ---
	nk_str_at_rune           :: proc(_: ^nk_str, pos: c.int, unicode: ^nk_rune, len: ^c.int) -> cstring ---
	nk_str_rune_at           :: proc(_: ^nk_str, pos: c.int) -> nk_rune ---
	nk_str_at_char_const     :: proc(_: ^nk_str, pos: c.int) -> cstring ---
	nk_str_at_const          :: proc(_: ^nk_str, pos: c.int, unicode: ^nk_rune, len: ^c.int) -> cstring ---
	nk_str_get               :: proc(_: ^nk_str) -> cstring ---
	nk_str_get_const         :: proc(_: ^nk_str) -> cstring ---
	nk_str_len               :: proc(_: ^nk_str) -> c.int ---
	nk_str_len_char          :: proc(_: ^nk_str) -> c.int ---

	/** filter function */
	nk_filter_default            :: proc(_: ^nk_text_edit, unicode: nk_rune) -> nk_bool ---
	nk_filter_ascii              :: proc(_: ^nk_text_edit, unicode: nk_rune) -> nk_bool ---
	nk_filter_float              :: proc(_: ^nk_text_edit, unicode: nk_rune) -> nk_bool ---
	nk_filter_decimal            :: proc(_: ^nk_text_edit, unicode: nk_rune) -> nk_bool ---
	nk_filter_hex                :: proc(_: ^nk_text_edit, unicode: nk_rune) -> nk_bool ---
	nk_filter_oct                :: proc(_: ^nk_text_edit, unicode: nk_rune) -> nk_bool ---
	nk_filter_binary             :: proc(_: ^nk_text_edit, unicode: nk_rune) -> nk_bool ---
	nk_textedit_init             :: proc(_: ^nk_text_edit, _: ^nk_allocator, size: nk_size) ---
	nk_textedit_init_fixed       :: proc(_: ^nk_text_edit, memory: rawptr, size: nk_size) ---
	nk_textedit_free             :: proc(_: ^nk_text_edit) ---
	nk_textedit_text             :: proc(_: ^nk_text_edit, _: cstring, total_len: c.int) ---
	nk_textedit_delete           :: proc(_: ^nk_text_edit, _where: c.int, len: c.int) ---
	nk_textedit_delete_selection :: proc(_: ^nk_text_edit) ---
	nk_textedit_select_all       :: proc(_: ^nk_text_edit) ---
	nk_textedit_cut              :: proc(_: ^nk_text_edit) -> nk_bool ---
	nk_textedit_paste            :: proc(_: ^nk_text_edit, _: cstring, len: c.int) -> nk_bool ---
	nk_textedit_undo             :: proc(_: ^nk_text_edit) ---
	nk_textedit_redo             :: proc(_: ^nk_text_edit) ---

	/** shape outlines */
	nk_stroke_line     :: proc(b: ^nk_command_buffer, x0: f32, y0: f32, x1: f32, y1: f32, line_thickness: f32, _: nk_color) ---
	nk_stroke_curve    :: proc(_: ^nk_command_buffer, _: f32, _: f32, _: f32, _: f32, _: f32, _: f32, _: f32, _: f32, line_thickness: f32, _: nk_color) ---
	nk_stroke_rect     :: proc(_: ^nk_command_buffer, _: nk_rect, rounding: f32, line_thickness: f32, _: nk_color) ---
	nk_stroke_circle   :: proc(_: ^nk_command_buffer, _: nk_rect, line_thickness: f32, _: nk_color) ---
	nk_stroke_arc      :: proc(_: ^nk_command_buffer, cx: f32, cy: f32, radius: f32, a_min: f32, a_max: f32, line_thickness: f32, _: nk_color) ---
	nk_stroke_triangle :: proc(_: ^nk_command_buffer, _: f32, _: f32, _: f32, _: f32, _: f32, _: f32, line_thichness: f32, _: nk_color) ---
	nk_stroke_polyline :: proc(_: ^nk_command_buffer, points: ^f32, point_count: c.int, line_thickness: f32, col: nk_color) ---
	nk_stroke_polygon  :: proc(_: ^nk_command_buffer, points: ^f32, point_count: c.int, line_thickness: f32, _: nk_color) ---

	/** filled shades */
	nk_fill_rect             :: proc(_: ^nk_command_buffer, _: nk_rect, rounding: f32, _: nk_color) ---
	nk_fill_rect_multi_color :: proc(_: ^nk_command_buffer, _: nk_rect, left: nk_color, top: nk_color, right: nk_color, bottom: nk_color) ---
	nk_fill_circle           :: proc(_: ^nk_command_buffer, _: nk_rect, _: nk_color) ---
	nk_fill_arc              :: proc(_: ^nk_command_buffer, cx: f32, cy: f32, radius: f32, a_min: f32, a_max: f32, _: nk_color) ---
	nk_fill_triangle         :: proc(_: ^nk_command_buffer, x0: f32, y0: f32, x1: f32, y1: f32, x2: f32, y2: f32, _: nk_color) ---
	nk_fill_polygon          :: proc(_: ^nk_command_buffer, points: ^f32, point_count: c.int, _: nk_color) ---

	/** misc */
	nk_draw_image                           :: proc(_: ^nk_command_buffer, _: nk_rect, _: ^nk_image, _: nk_color) ---
	nk_draw_nine_slice                      :: proc(_: ^nk_command_buffer, _: nk_rect, _: ^nk_nine_slice, _: nk_color) ---
	nk_draw_text                            :: proc(_: ^nk_command_buffer, _: nk_rect, text: cstring, len: c.int, _: ^nk_user_font, _: nk_color, _: nk_color) ---
	nk_push_scissor                         :: proc(_: ^nk_command_buffer, _: nk_rect) ---
	nk_push_custom                          :: proc(_: ^nk_command_buffer, _: nk_rect, _: nk_command_custom_callback, usr: nk_handle) ---
	nk_input_has_mouse_click                :: proc(_: ^nk_input, _: nk_buttons) -> nk_bool ---
	nk_input_has_mouse_click_in_rect        :: proc(_: ^nk_input, _: nk_buttons, _: nk_rect) -> nk_bool ---
	nk_input_has_mouse_click_in_button_rect :: proc(_: ^nk_input, _: nk_buttons, _: nk_rect) -> nk_bool ---
	nk_input_has_mouse_click_down_in_rect   :: proc(_: ^nk_input, _: nk_buttons, _: nk_rect, down: nk_bool) -> nk_bool ---
	nk_input_is_mouse_click_in_rect         :: proc(_: ^nk_input, _: nk_buttons, _: nk_rect) -> nk_bool ---
	nk_input_is_mouse_click_down_in_rect    :: proc(i: ^nk_input, id: nk_buttons, b: nk_rect, down: nk_bool) -> nk_bool ---
	nk_input_any_mouse_click_in_rect        :: proc(_: ^nk_input, _: nk_rect) -> nk_bool ---
	nk_input_is_mouse_prev_hovering_rect    :: proc(_: ^nk_input, _: nk_rect) -> nk_bool ---
	nk_input_is_mouse_hovering_rect         :: proc(_: ^nk_input, _: nk_rect) -> nk_bool ---
	nk_input_mouse_clicked                  :: proc(_: ^nk_input, _: nk_buttons, _: nk_rect) -> nk_bool ---
	nk_input_is_mouse_down                  :: proc(_: ^nk_input, _: nk_buttons) -> nk_bool ---
	nk_input_is_mouse_pressed               :: proc(_: ^nk_input, _: nk_buttons) -> nk_bool ---
	nk_input_is_mouse_released              :: proc(_: ^nk_input, _: nk_buttons) -> nk_bool ---
	nk_input_is_key_pressed                 :: proc(_: ^nk_input, _: nk_keys) -> nk_bool ---
	nk_input_is_key_released                :: proc(_: ^nk_input, _: nk_keys) -> nk_bool ---
	nk_input_is_key_down                    :: proc(_: ^nk_input, _: nk_keys) -> nk_bool ---

	/* draw list */
	nk_draw_list_init   :: proc(_: ^nk_draw_list) ---
	nk_draw_list_setup  :: proc(_: ^nk_draw_list, _: ^nk_convert_config, cmds: ^nk_buffer, vertices: ^nk_buffer, elements: ^nk_buffer, line_aa: nk_anti_aliasing, shape_aa: nk_anti_aliasing) ---
	nk__draw_list_begin :: proc(_: ^nk_draw_list, _: ^nk_buffer) -> ^nk_draw_command ---
	nk__draw_list_next  :: proc(_: ^nk_draw_command, _: ^nk_buffer, _: ^nk_draw_list) -> ^nk_draw_command ---
	nk__draw_list_end   :: proc(_: ^nk_draw_list, _: ^nk_buffer) -> ^nk_draw_command ---

	/* path */
	nk_draw_list_path_clear       :: proc(_: ^nk_draw_list) ---
	nk_draw_list_path_line_to     :: proc(_: ^nk_draw_list, pos: nk_vec2) ---
	nk_draw_list_path_arc_to_fast :: proc(_: ^nk_draw_list, center: nk_vec2, radius: f32, a_min: c.int, a_max: c.int) ---
	nk_draw_list_path_arc_to      :: proc(_: ^nk_draw_list, center: nk_vec2, radius: f32, a_min: f32, a_max: f32, segments: c.uint) ---
	nk_draw_list_path_rect_to     :: proc(_: ^nk_draw_list, a: nk_vec2, b: nk_vec2, rounding: f32) ---
	nk_draw_list_path_curve_to    :: proc(_: ^nk_draw_list, p2: nk_vec2, p3: nk_vec2, p4: nk_vec2, num_segments: c.uint) ---
	nk_draw_list_path_fill        :: proc(_: ^nk_draw_list, _: nk_color) ---
	nk_draw_list_path_stroke      :: proc(_: ^nk_draw_list, _: nk_color, closed: nk_draw_list_stroke, thickness: f32) ---

	/* stroke */
	nk_draw_list_stroke_line      :: proc(_: ^nk_draw_list, a: nk_vec2, b: nk_vec2, _: nk_color, thickness: f32) ---
	nk_draw_list_stroke_rect      :: proc(_: ^nk_draw_list, rect: nk_rect, _: nk_color, rounding: f32, thickness: f32) ---
	nk_draw_list_stroke_triangle  :: proc(_: ^nk_draw_list, a: nk_vec2, b: nk_vec2, _c: nk_vec2, _: nk_color, thickness: f32) ---
	nk_draw_list_stroke_circle    :: proc(_: ^nk_draw_list, center: nk_vec2, radius: f32, _: nk_color, segs: c.uint, thickness: f32) ---
	nk_draw_list_stroke_curve     :: proc(_: ^nk_draw_list, p0: nk_vec2, cp0: nk_vec2, cp1: nk_vec2, p1: nk_vec2, _: nk_color, segments: c.uint, thickness: f32) ---
	nk_draw_list_stroke_poly_line :: proc(_: ^nk_draw_list, pnts: ^nk_vec2, cnt: c.uint, _: nk_color, _: nk_draw_list_stroke, thickness: f32, _: nk_anti_aliasing) ---

	/* fill */
	nk_draw_list_fill_rect             :: proc(_: ^nk_draw_list, rect: nk_rect, _: nk_color, rounding: f32) ---
	nk_draw_list_fill_rect_multi_color :: proc(_: ^nk_draw_list, rect: nk_rect, left: nk_color, top: nk_color, right: nk_color, bottom: nk_color) ---
	nk_draw_list_fill_triangle         :: proc(_: ^nk_draw_list, a: nk_vec2, b: nk_vec2, _c: nk_vec2, _: nk_color) ---
	nk_draw_list_fill_circle           :: proc(_: ^nk_draw_list, center: nk_vec2, radius: f32, col: nk_color, segs: c.uint) ---
	nk_draw_list_fill_poly_convex      :: proc(_: ^nk_draw_list, points: ^nk_vec2, count: c.uint, _: nk_color, _: nk_anti_aliasing) ---

	/* misc */
	nk_draw_list_add_image   :: proc(_: ^nk_draw_list, texture: nk_image, rect: nk_rect, _: nk_color) ---
	nk_draw_list_add_text    :: proc(_: ^nk_draw_list, _: ^nk_user_font, _: nk_rect, text: cstring, len: c.int, font_height: f32, _: nk_color) ---
	nk_style_item_color      :: proc(_: nk_color) -> nk_style_item ---
	nk_style_item_image      :: proc(img: nk_image) -> nk_style_item ---
	nk_style_item_nine_slice :: proc(slice: nk_nine_slice) -> nk_style_item ---
	nk_style_item_hide       :: proc() -> nk_style_item ---

}