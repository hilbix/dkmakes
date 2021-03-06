# PL-2701 chip changes to the Linux plusb module

This adds the [j5create JUC500 USB 3.0 Wormhole Switch](https://en.j5create.com/products/juc500) to the Kernel's `plusb` driver.

Note, that this here is not always needed.
Everything works right out of the box using the `rndis` driver, as follows:

- On a first machine:
  - `ip a s` and note the interfaces
  - Plug link cable into the machine
  - `ip a s` and note the difference
  - `ip a add 172.17.17.1/24 dev usb0` where `usb0` stands for the new interface
- On a second machine:
  - Do the same, but with `172.17.17.2/24`
  - `ping 172.17.17.1` from the second machine works
- Beware of NetworkManager, it likes to remove the IP on new interfaces

Results at my side (YMMV):

- Kernel 5.4.0 USB 3.0: 1 CPU maxed out gives me around 130 MiB/s (Comparable to Gigabit Ethernet performance)
- Kernel 4.9.0 USB 2.0: fail (USB enumeration fails).

With this module here:

- A second USB network device shows up (`usb1` at my side).
  - Note that `usb1` and `usb0` are incompatible transports,
    so they should not span the same net.
- The `rndis` driver is not used for this "new" interface.
- This allows to use a higher MTU (tested: 60000)
  which is needed to reduce the high CPU demand on the receiving side.
- With MTU 60000 I got transfer speeds to 160 MiB/s
  which is significantly above Gigabit Ethernet speed.
- But beware of NetworkManager, it likes to remove the IP on unconfigured interfaces

> Perhaps it is not NetworkManager but unstable USB3.
> So it might be that each time something weird happens on USB3,
> NM resets the link.


## Source this is based on

- https://superuser.com/a/1165890/72223
  - https://lkml.org/lkml/2016/2/21/14
- `linux-source-5.4.0/drivers/net/usb/plusb.c`


## HowTo

	cd /usr/src
	git clone -b plusb https://github.com/hilbix/dkmakes.git
	cd dkmakes
	sudo make

Notes:

- Above installs the module `plusb` into all installed kernel(s).
- `make uninstall` removes the DKMS module again


## FAQ

WTF why?

- Because I dare to

License

- Most things in this directory have the same License as the Kernel, see `rgrep SPDX`
- This README is Public Domain
- My changes to `plusb/plusb.c` are Public Domain, too.

