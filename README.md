> The `master` branch has no module.  If you want to see one, switch to a branch.


# Generic DKMS Module Maker

This is a generic (autoconfigure style) DKMS Makefile to quickly hack some module.

For the module's `README.md`, see the subdirectory [`kernel/`](kernel/).
(This subdirectory is missing on the `master` branch, of course.)


# Usage

	# Checkout
	git clone https://github.com/hilbix/dkmakes.git
	cd dkmakes
	git checkout -b ${MODULE_NAME}

	# Variant if original kernel module is a single file:
	target=${KERNELSRC_MODULE_PATH}/${MODULE_NAME}
	mkdir -p kernel/$target
	ln --relative -s dkms.conf.in                                  kernel/$target/
	cp /usr/src/linux*/*/COPYING                                   kernel/$target/
	cp /usr/src/linux*/*/${KERNELSRC_MODULE_PATH}/Makefile         kernel/$target/
	cp /usr/src/linux*/*/${KERNELSRC_MODULE_PATH}/${MODULE_NAME}.c kernel/$target/
	vim kernel/$target/Makefile
	# remove all unneccessary lines from Makefile

	# variant if original kernel module is an entire directory:
	# T.B.D.

	# Happy hacking the module here, then, perhaps:
	vim VERSION

	# Now transform it into dkms
	sudo make

Notes:

- `make uninstall` to remove the `dksm` module again


## FAQ

WTF why?

- Because I like to automate complex things
- `dkms` is quite too complex.
- Period!

License

- Public Domain, so it is free as in free beer, free speech and free baby
- This does not refer to what you find beneath `kernel/`!
  - This probably has a different license (usually GPL 2.0 as the Kernel)
  - Hint: `rgrep SPDX`

