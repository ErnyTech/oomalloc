// Written in the D programming language.
/* Copyright 2019 Ernesto Castellotti <erny.castell@gmail.com>
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. 
 */
 
module oomalloc.start;

import oomalloc.config;
import oomalloc.oomcheck;

bool start(size_t size) {
    import oomalloc.util : write;

    debug {
        write("Allocation size: ");
        write(size);
        write("\n");
    }
    
    immutable isOom = checkOom(size);

    if (isOom) {
        static if (OOM_KILLER_MODE == KillerMode.KILL_AFTER_OOM) {

        }

        static if (OOM_KILLER_MODE == KillerMode.KILL_PREVENT_OOM) {
            debug {
                write("OOM Killer mode: KILL_PREVENT_OOM\n");
                write("Memory allocation will be suppressed\n");
                write("\n");
            }

            return false;
        }

        static if (OOM_KILLER_MODE == KillerMode.RETURNULL_PREVENT_OOM) {
            debug {
                write("OOM Killer mode: RETURNULL_PREVENT_OOM\n");
                write("Memory allocation will be suppressed\n");
                write("\n");
            }

            return false;
        }
    }

    debug {
        write("\n");
    }

    return true;
}