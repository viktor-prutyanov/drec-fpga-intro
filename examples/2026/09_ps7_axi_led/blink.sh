while true; do
  devmem 0x41200000 8 0x5
  sleep 0.2
  devmem 0x41200000 8 0xA
  sleep 0.2
done

