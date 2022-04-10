#!/bin/bash

set -e

export NODE_IP=$(sudo kubectl get nodes --namespace redis -o jsonpath="{.items[0].status.addresses[0].address}")
export NODE_PORT=$(sudo kubectl get --namespace redis -o jsonpath="{.spec.ports[0].nodePort}" services redis-master)
export REDIS_PASSWORD=$(sudo kubectl get secret --namespace redis redis -o jsonpath="{.data.redis-password}" | base64 --decode)
export REDIS_KEY_PATTERN="patch_*"

declare -a ar_val=()
declare -A arr=(); 

rd_cli=("REDISCLI_AUTH=$REDIS_PASSWORD")
rd_cli+=(redis-cli -h $NODE_IP -p $NODE_PORT)

# cat > /tmp/rancher-patching.txt <<EOF
# avk8st-node1;worker;3d;avkst-node2;2022-02-14;test-t3
# avk8st-node3;control;4d;avkst-node4;2022-02-15;test-t3
# EOF

# PUB_SUB
# echo "PUBLISH ptestt3 'old_node avk8st-node1 role worker age 3d new_node avkst-node2 node_timestamp 2022-02-14 cluster test-t3'" | REDISCLI_AUTH="$REDIS_PASSWORD" redis-cli -h $NODE_IP -p $NODE_PORT --pipe

# Key must be unique
cat > /tmp/rancher-cmd.txt <<EOF
HSET patch_test_t3_3 old_node avk8st-node1 role worker age 3d new_node avkst-node2 node_timestamp 2022-02-14 cluster test-t3
HSET patch_test_t3_4 old_node avk8st-node3 role worker age 4d new_node avkst-node4 node_timestamp 2022-02-15 cluster test-t3
EOF

cat /tmp/rancher-cmd.txt

# https://redis.io/docs/reference/patterns/bulk-loading/
cat /tmp/rancher-cmd.txt | eval ${rd_cli[@]} --pipe

# Default to '*' key pattern, meaning all redis keys in the namespace
REDIS_KEY_PATTERN="${REDIS_KEY_PATTERN:-*}"
for key in $(eval ${rd_cli[@]} --scan --pattern "$REDIS_KEY_PATTERN"); do
    # echo "Key : '$key'" 
    printf "$key: $(eval ${rd_cli[@]} HKEYS $key | sed 's/^/  /')\n"
    printf "value: $(eval ${rd_cli[@]} HVALS $key | sed 's/^/  /')\n"
    # arr["$a"]="$b"; done < <(eval ${rd_cli[@]} hgetall $key)
done

# for key in $(eval ${rd_cli[@]} KEYS "\*"); do 
#     echo "Key : '$key'" 
#     ar+=$(eval ${rd_cli[@]} HGETALL $key;)
# done

echo ${ar_val[@]}
# once complete i need to remove from hmap!
# echo "DEL " | REDISCLI_AUTH="$REDIS_PASSWORD" redis-cli -h $NODE_IP -p $NODE_PORT --pipe

