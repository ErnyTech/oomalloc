// Written in the D programming language.
/* Copyright 2019 Ernesto Castellotti <erny.castell@gmail.com>
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. 
 */
 
module oomalloc.start;

import oomalloc.config;
import oomalloc.kill;
import oomalloc.oomcheck;

bool start(size_t size) {
    import oomalloc.util : write;
    import core.sys.posix.unistd : getpid;

    static if (DEBUG) {
        write("Allocation size: ");
        write(size);
        write("\n");
    }
    
    immutable isOom = checkOom(size);

    if (isOom) {
        static if (OOM_KILLER_MODE == KillerMode.KILL_AFTER_OOM) {

        }

        static if (OOM_KILLER_MODE == KillerMode.KILL_PREVENT_OOM) {
            static if (DEBUG || PRINT_OOM_ERROR) {
                write("OOM Killer mode: KILL_PREVENT_OOM\n");
                write("Memory allocation will be suppressed\n");
            }

            auto thisPid = getpid();
            killProcess(thisPid);

            return false;
        }

        static if (OOM_KILLER_MODE == KillerMode.RETURNULL_PREVENT_OOM) {
            static if (DEBUG || PRINT_OOM_ERROR) {
                write("OOM Killer mode: RETURNULL_PREVENT_OOM\n");
                write("Memory allocation will be suppressed\n");
            }

            return false;
        }
    }

    static if (DEBUG) {
        write("\n");
    }

    return true;
}