// Written in the D programming language.
/* Copyright 2019 Ernesto Castellotti <erny.castell@gmail.com>
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. 
 */
 
module oomalloc.kill;

import oomalloc.config;
import core.sys.posix.sys.types : pid_t;

bool killProcess(pid_t process, int sig = KILL_SIG, int count = 0) {
    import oomalloc.util : write, warn;
    import core.stdc.errno : errno, EPERM;
    import core.sys.posix.signal : kill, SIGKILL;
    import core.sys.posix.unistd : usleep;

    if (count > 20) {
        return false;
    } 

    static if (DEBUG || PRINT_OOM_ERROR) {
        write("Killer started, id of the victim process: ");
        write(process);
        write("\n");
        write("Killer sig: ");
        write(sig);
        write("\n");
    }

    if (process == 0) {  // Try prevent kernel panic
        static if (DEBUG || PRINT_OOM_ERROR) {
            warn("The attempt to kill the init has been suppressed, OOM not managed!");
        }

        return false;    
    }

    errno = 0;
    auto res = kill(process, sig);

    if (res != 0) {
        static if (DEBUG || PRINT_OOM_ERROR) {
            warn("Failed kill process, OOM not managed!", errno);
        }

        return false;
    }

    usleep(100 * 1000);

    if (!processIsRunning(process)) {
        static if (DEBUG || PRINT_OOM_ERROR) {
            write("Process terminated successfully\n");
        }

        return true;
    }

    static if (DEBUG || PRINT_OOM_ERROR) {
        warn("I try again to kill the process with SIGKILL after 100ms of patience");
    }

    return killProcess(process, SIGKILL, ++count);
}

private bool processIsRunning(pid_t process) {
    import core.sys.posix.signal : kill;

    auto res = kill(process, 0);

    if (res != 0) {
        return false;
    } else {
        return true;
    }
}