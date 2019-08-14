// Written in the D programming language.
/* Copyright 2019 Ernesto Castellotti <erny.castell@gmail.com>
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. 
 */
 
module oomalloc.config;

enum KillerMode {
    KILL_AFTER_OOM,
    KILL_PREVENT_OOM,
    RETURNULL_PREVENT_OOM
}

enum KILL_PERCENT = 5;
enum SWAP_KILL_PERCENT = 5;
enum OOM_KILLER_MODE = KillerMode.RETURNULL_PREVENT_OOM;