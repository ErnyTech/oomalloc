#!/bin/sh
cd ..
dub build --force --build=debug
cd test
gcc app.c -o app
LD_PRELOAD=../liboomalloc.so ./app
rm app
rm ../liboomalloc.so
cd ..
dub clean
