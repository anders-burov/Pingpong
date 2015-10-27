# Wireless Ping Pong

The objective of this project is to build a small scale wireless network. There are to wireless nodes:
* Mobile
* Stationary
Both are Arduinos with Xbee modules (XB24-ACI-001)

The mobile node sends sensor data (tilt of accelerometer) over ZigBee to the stationary node. The latter aggregates information and then forwards it to the specific IP address over Ethernet network. The Application operating on the other side of the Ethernet receives data and visualizes it as a simple ping pong game.

# Controls

* Tilt accelerometer to move the left paddle
* Enter 'w', 's' to move the right paddle
* Enter 'p', 'r' to pause/play, restart
* Press UP/DOWN to change the speed of the ball

# Known issues

The stationary node sits on address 192.168.5.10, try to select conforming IP address for the application.

This snippet would help if the interface keeps dropping the address.

```while :; do ifconfig enp5s0 192.168.5.5 netmask 255.255.255.0 up; sleep 1; done```

For 2 Xbee modules to see each other, they have to operate on the network with the same ID. To simplify things enter in both modules the personal addresses MY and destionation addresses DL pointing to each other. Here you can start looking for how to configure your Xbee http://cpham.perso.univ-pau.fr/WSN/XBee.html

# Requirements

Processing 2.2.1
Arduino 1.0.6
