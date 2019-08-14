// Written in the D programming language.
/* Copyright 2019 Ernesto Castellotti <erny.castell@gmail.com>
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. 
 */

module oomalloc.util;

void strrev(char[] result) {
    import std.algorithm.mutation : swap;
    
    size_t i;
    size_t j;
    char a;

    if (result.length <= 1) {
        return;
    }
    
    for (i = 0, j = result.length - 1; i < j; i++, j--) {
        a = result[i];
        result[i] = result[j];
        result[j] = a;
    }
}

size_t itoa(size_t value, char[] result, size_t base = 10) {
    size_t resultLength;
    enum letters = "zyxwvutsrqponmlkjihgfedcba9876543210123456789abcdefghijklmnopqrstuvwxyz";
    
    if (base < 2 || base > 36) {
        result[0] = '\0';
        return 0;
    }
    
    if (value < 0) {
        result[0] = '-';
        resultLength++;
    }
    
    foreach(i, ref str; value < 0 ? result[1 .. result.length] : result) {
        if (!value) {
            resultLength += i;
            break;
        }
        
        auto tmpValue = value;
        value /= base;
        str = letters [35 + (tmpValue - value * base)];
    }
    
    result[resultLength] = '\0';  
    result = result[0 .. resultLength];
    strrev(result);
    return resultLength;
}

void write(char[] str) {
    import core.sys.linux.unistd : write;
    write(1, str.ptr, str.length);
}

void write(string str) {
    import core.sys.linux.unistd : write;
    write(1, str.ptr, str.length);
}

void write(size_t value) {
    import core.sys.linux.unistd : write;

    __gshared char[64] str;
    auto length = itoa(value, str);
    write(1, str.ptr, length);
}

void panic(string msg, int errorCode = 1) {
    import core.stdc.stdlib : exit;

    write("panic: ");
    write(msg);
    write(", error code: ");
    write(errorCode);
    write("\n");
    exit(errorCode);
}

void panic(bool value, string msg, int errorCode = 1) {
    if (!value) {
        panic(msg, errorCode);
    }
}