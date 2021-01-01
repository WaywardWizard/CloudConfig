#!/bin/bash
if hash pixz;then
	echo pixz
	pv -ptr $1 | pixz > $1.pixz
fi
if hash pbzip2;then
	echo pbzip2
	pv -ptr $1 | pbzip2 -c > $1.pbzip2
fi
if hash lbzip2;then
	echo lbzip2
	pv -ptr $1 | lbzip2 -c > $1.lbzip2
fi
if hash zstd;then
	echo zstd
	pv -ptr $1 | zstd - > $1.zst
fi
