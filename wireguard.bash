#!/bin/bash
# args: {netns name} {wireguard config}... : {address config}...
set -e

namespace="$1"
shift

ip netns add "$namespace"
ip link add "$namespace" type wireguard
ip link set "$namespace" netns "$namespace"
ip -n "$namespace" link set "$namespace" name wg0

while [ $# -gt 0 ]; do
	if [ "$1" == ':' ]; then
		shift
		break
	fi
	ip netns exec "$namespace" wg addconf wg0 "$1"
	shift
done

while [ $# -gt 0 ]; do
	while read -r cidr; do
		ip -n "$namespace" addr add "$cidr" dev wg0
	done < "$1"
	shift
done

ip -n "$namespace" link set wg0 up
ip -n "$namespace" route add default dev wg0
