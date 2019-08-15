// Written in the D programming language.
/* Copyright 2019 Ernesto Castellotti <erny.castell@gmail.com>
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. 
 */
 
module oomalloc.oomcheck;
import oomalloc.config;

struct MemInfo {
    size_t memTotal;
    size_t memAvailable;
    size_t swapTotal;
    size_t swapFree;
}

bool checkOom(size_t sizeToAlloc) {
    import oomalloc.util : write;

    immutable memInfo = getMemInfo();

    static if (DEBUG) {
        write("Mem total: ");
        write(memInfo.memTotal);
        write("\n");
        
        write("Mem memAvailable: ");
        write(memInfo.memAvailable);
        write("\n");
        
        write("Swap total: ");
        write(memInfo.swapTotal);
        write("\n");
        
        write("Swap free: ");
        write(memInfo.swapFree);
        write("\n");
    }

    immutable memAvailablePercent = (memInfo.memAvailable * 100) / memInfo.memTotal;
    immutable swapFreePercent = (memInfo.swapFree * 100) / memInfo.swapTotal;

    static if (OOM_KILLER_MODE == KillerMode.KILL_AFTER_OOM) {
        immutable isOom = (memAvailablePercent <= KILL_PERCENT || swapFreePercent <= SWAP_KILL_PERCENT);
    }

    static if (OOM_KILLER_MODE == KillerMode.KILL_PREVENT_OOM || OOM_KILLER_MODE == KillerMode.RETURNULL_PREVENT_OOM) {
        immutable minMem = (KILL_PERCENT * memInfo.memTotal) / 100;
        immutable newMemAvailable = memInfo.memAvailable - (sizeToAlloc / 1024);
        immutable isOom = (newMemAvailable <= minMem);

        static if (DEBUG) {
            write("Min available: ");
            write(minMem);
            write("\n");
            
            write("New available mem (after allocation): ");
            write(newMemAvailable);
            write("\n");
        }
    }

    static if (DEBUG || PRINT_OOM_ERROR) {
        if (isOom) {
            write("OOM detected!\n");
        }
    }

    return isOom;
}

MemInfo getMemInfo() {
    import oomalloc.util : panic;
    import core.sys.posix.fcntl : open, O_RDONLY;
    import core.sys.posix.unistd : read;
    import core.stdc.errno : errno;

    __gshared int memInfoFile = -1;
    __gshared char[8192] buffer;
    MemInfo memInfo;

    errno = 0;
    if (memInfoFile == -1) {
        memInfoFile = open("/proc/meminfo", O_RDONLY);
    }
    panic(memInfoFile != -1, "Could not open /proc/meminfo", errno);

    errno = 0;
    size_t length = read(memInfoFile, buffer.ptr, buffer.sizeof - 1);
    panic(length != -1, "Could not read /proc/meminfo", errno);

    memInfo.memTotal = getEntry("MemTotal:", buffer);
    memInfo.memAvailable = getEntry("MemAvailable:", buffer);
    memInfo.swapTotal = getEntry("SwapTotal:", buffer);
    memInfo.swapFree = getEntry("SwapFree:", buffer);

    return memInfo;
}

size_t getEntry(string name, char[] buffer) {
    import oomalloc.util : panic;
    import core.stdc.string : strstr;
    import core.stdc.stdlib : strtol;
    import core.stdc.errno : errno;

    auto entryPtr = strstr(buffer.ptr, name.ptr);
    panic(entryPtr != null, "getEntry failed");

    errno = 0;
    size_t value = strtol(entryPtr + name.length, null, 10);
    panic(errno == 0, "getEntry failed", errno);

    return value;
}