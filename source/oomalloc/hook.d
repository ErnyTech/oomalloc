// Written in the D programming language.
/* Copyright 2019 Ernesto Castellotti <erny.castell@gmail.com>
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. 
 */
 
module oomalloc.hook;
import oomalloc.start;

/**
 * Real functions
 */
extern(C) void* __libc_malloc(size_t size);
extern(C) void* __libc_calloc(size_t count, size_t size);
extern(C) void* __libc_realloc(void* ptr, size_t size);
extern(C) void* __libc_valloc(size_t size);
extern(C) void* __libc_pvalloc(size_t size);
extern(C) void* __libc_memalign(size_t alignment, size_t size);
extern(C) void* __libc_reallocarray(void* ptr, size_t count, size_t size);
extern(C) int __posix_memalign(void** ptr, size_t alignment, size_t size);


/**
 * Hooks
 */
extern(C) export void* malloc(size_t size) {
    immutable res = start(size);

    if (!res) {
        return null;
    }

    return __libc_malloc(size);
}

extern(C) export void* calloc(size_t count, size_t size) {
    immutable res = start(count * size);

    if (!res) {
        return null;
    }

    return __libc_calloc(count, size);   
}

extern(C) export void* realloc(void* ptr, size_t newsize) {
    immutable res = start(newsize);

    if (!res) {
        return null;
    }

    return __libc_realloc(ptr, newsize);
}

extern(C) export void* valloc(size_t size) {
    immutable res = start(size);

    if (!res) {
        return null;
    }

    return __libc_valloc(size);
}

extern(C) export void* pvalloc(size_t size) {
    immutable res = start(size);

    if (!res) {
        return null;
    }

    return __libc_pvalloc(size);
}

extern(C) export void* memalign(size_t alignment, size_t size) {
    immutable offset = alignment - 1 + (void*).sizeof;
    immutable res = start(size + offset);

    if (!res) {
        return null;
    }

    return __libc_memalign(alignment, size);
}

extern(C) export void* reallocarray(void* ptr, size_t count, size_t size) {
    immutable res = start(count * size);

    if (!res) {
        return null;
    }

    return __libc_reallocarray(ptr, count, size);
}

extern(C) export int posix_memalign(void** ptr, size_t alignment, size_t size) {
    import core.stdc.errno : ENOMEM;

    immutable offset = alignment - 1 + (void*).sizeof;
    immutable res = start(size + offset);

    if (!res) {
        return ENOMEM;
    }

    return __posix_memalign(ptr, alignment, size);
}