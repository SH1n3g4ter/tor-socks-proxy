for i in $(seq 1 $INSTANCES_COUNT); do
    if [ "$i" -gt 128 ]; then
        break
    fi
    (echo "authenticate \"$TOR_CONTROL_PW\""; echo "signal newnym"; echo quit) | nc localhost $(expr 9499 + $i)
done
