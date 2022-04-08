#!/bin/zsh

if [[ -d ~/.bitcoin || -d ~/.litecoin ]] {
    if [ -d ~/.bitcoin ] {
	export PATH=~/.bitcoin/bin:$PATH
	alias btcd='bitcoind'
	alias btc='bitcoin-cli'
    }
    if [ -d ~/.litecoin ] {
	export PATH=~/.litecoin/bin:$PATH
	alias ltcd='litecoind'
	alias ltc='litecoin-cli'
    }
}
