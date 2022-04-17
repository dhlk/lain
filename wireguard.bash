#!/bin/bash
# args: {netns name} {wireguard config}... : {address config}...
set -e

namespace="$1"
shift

link="$(md5sum <<< "$namespace" | cut -c -15)"

ip netns add "$namespace"
ip link add "$link" type wireguard

while [ $# -gt 0 ]; do
	if [ "$1" == ':' ]; then
		shift
		break
	fi
	wg addconf "$link" "$1"
	shift
done

ip link set "$link" netns "$namespace"
ip -n "$namespace" link set "$link" name wg0

while [ $# -gt 0 ]; do
	while read -r cidr; do
		ip -n "$namespace" addr add "$cidr" dev wg0
	done < "$1"
	shift
done

ip -n "$namespace" link set wg0 up
ip -n "$namespace" route add default dev wg0
