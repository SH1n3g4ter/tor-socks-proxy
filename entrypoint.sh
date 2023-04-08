if ! grep -q "HashedControlPassword" /etc/tor/torrc
then
    printf "\nHashedControlPassword " >> /etc/tor/torrc && tor --hash-password "$TOR_CONTROL_PASSWD" >> /etc/tor/torrc
fi
/usr/bin/tor -f /etc/tor/torrc
