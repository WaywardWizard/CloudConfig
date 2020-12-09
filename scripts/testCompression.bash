#!/bin/bash
pixz < $1 > $1.pixz
pbzip2 -k $1
lbzip2 -k $1
zstd - < $1 > $1.zst
