// Written in the C programming language.
/* Copyright 2019 Ernesto Castellotti <erny.castell@gmail.com>
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. 
 */

#include <stdio.h>
#include <stdlib.h> 

int main() {
    void* ptr = malloc(10);

    if (!ptr) {
        printf("Allocation failed\n");
    } else {
        printf("Allocation success\n");
    }
}
