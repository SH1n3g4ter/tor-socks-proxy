TOR_CONTROL_HASHPW=$(tor --hash-password "$TOR_CONTROL_PW")
for i in $(seq 1 $INSTANCES_COUNT); do
    if [ "$i" -gt 128 ]; then
        break
    fi
    if ! test -f "/etc/tor/torrc_$i"; then
        cp /etc/tor/torrc_base /etc/tor/torrc_$i
        if [ "$i" -eq 1 ]; then
            echo "DNSPort 0.0.0.0:8853" >> /etc/tor/torrc_$i
        fi
        echo "SocksPort 0.0.0.0:$(expr 8999 + $i)
DataDirectory /var/lib/tor/$i
ControlPort 127.0.0.1:$(expr 9499 + $i)
HashedControlPassword $TOR_CONTROL_HASHPW" >> /etc/tor/torrc_$i
    fi
    mkdir -p /var/lib/tor/$i
    /usr/bin/tor -f /etc/tor/torrc_$i &
done
tail -f /dev/null