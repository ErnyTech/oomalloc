// Written in the D programming language.
/* Copyright 2019 Ernesto Castellotti <erny.castell@gmail.com>
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. 
 */
 
module oomalloc.config;

// This is the oomalloc configuration:
enum KILL_PERCENT = 5;
enum SWAP_KILL_PERCENT = 5;
enum OOM_KILLER_MODE = KillerMode.RETURNULL_PREVENT_OOM;
enum PRINT_OOM_ERROR = false;

// All the code under this line is used internally to configure oomalloc, 
// the user must NEVER change it!!!
enum KillerMode {
    KILL_AFTER_OOM,
    KILL_PREVENT_OOM,
    RETURNULL_PREVENT_OOM
}

debug {
    enum DEBUG = true;
} else {
    enum DEBUG = false;
}