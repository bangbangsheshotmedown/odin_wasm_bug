package main

import "base:runtime"
import "core:mem"

import "nk"


g_allocator : mem.Allocator
nuklear: NuklearRenderer

@(export)
_start::proc"c"() {

    context = runtime.default_context()
    g_allocator = runtime.default_wasm_allocator()

    init_nk(&nuklear, g_allocator)
}



NuklearRenderer :: struct {
    allocator: mem.Allocator,
    nk_ctx: nk.nk_context,
    nk_allocator: nk.nk_allocator,
}

init_nk::proc(self: ^NuklearRenderer, allocator: mem.Allocator) {

    self.allocator = allocator

    self.nk_allocator.userdata.ptr = self
    self.nk_allocator.alloc = dnk_allocate
    self.nk_allocator.free = dnk_free

    nk.nk_init(&self.nk_ctx, &self.nk_allocator, nil)
}

dnk_allocate::proc"c"(handle: nk.nk_handle, old: rawptr, size: nk.nk_size) -> rawptr
{
    context = runtime.default_context()

    self:= cast(^NuklearRenderer) handle.ptr

    b, err := make([]u8, size, self.allocator)

    return raw_data(b)
}
dnk_free::proc"c"(handle: nk.nk_handle, old: rawptr)
{
}

nk_assert_odin::proc"c"(cond:i32)
{
    // if cond == 0 {
    //     panic("noo")
    // }
}