# IPPEs

<div align="center">
  <p>&nbsp;</p>
  <p><strong>IPP E</strong>verywhere <strong>s</strong>ucks</p>
  <p>A small project to allow old printers to be installed without <a href="https://www.pwg.org/ipp/everywhere.html" target="_blank">IPP Everywhere</a>.</p>
  <p>&nbsp;</p>
</div>

## Reason behind this project

The main reason of this project is decision taken by the CUPS maintainer to [drop support for `PPD` files](https://github.com/OpenPrinting/cups-sharing/issues/4) and now rely on [IPP Everywhere](https://www.pwg.org/ipp/everywhere.html) by default and print a warning when using a `PPD` file:

```console
$ lpadmin -p test -E -v ipp://[REDACTED] -m uld-samsung/Samsung_C48x_Series.ppd
lpadmin: Printer drivers are deprecated and will stop working in a future version of CUPS.
```

For the moment, the printer can be installed with `lpadmin` as shown above and the result can be seen with `lpstat`:

```console
$ lpstat -t | grep -i test
device for test: ipp://[REDACTED]
test accepting requests since sam 01 jui 2023 14:30:38
printer test is idle.  enabled since sam 01 jui 2023 14:30:38
```

> __and it works!__ - _which is not the case with the `everywhere` driver is selected..._

But what will happens when the `PPD` files support will be removed? Owners of old printers will have to buy a new one to be able to print their documents??

__HELL NO!!__

That's why I've made this project, to allow end-users to be able to install their old printers without having to pass a complete night to debug everything and finally make it work without really knowing how 😅

## Required tools

In order to be able to run the script or simply debug things by yourself, you will need the following commands:

* `lpstat`
* `lpinfo`
* `lpadmin`

Optionally, if you have `avahi` enabled and want to use it, you will then need these commands:

* `avahi-browse`
* `driverless`

You can install them with the following packages:

* `cups` or `cups-client`
* `avahi-utils` (if using `avahi`)

If you want to see the network packets exchanged between your computer and your printer, you will also need to install the `tcpdump` package.

Here is an example command:

```console
$ sudo tcpdump -Xvni any "port 5353 or port 631 or port 9001"
```

## References

* https://wiki.archlinux.org/title/CUPS
* https://wiki.archlinux.org/title/CUPS/Printer-specific_problems
* https://wiki.archlinux.org/title/CUPS/Troubleshooting
* https://github.com/OpenPrinting/cups-sharing/issues/4
* https://wiki.debian.org/CUPSDriverlessPrinting
* https://wiki.debian.org/CUPSIPPEverywhere
* https://www.pwg.org/ipp/everywhere.html
* https://github.com/apple/cups/issues/5088
* https://wiki.archlinux.org/title/Avahi
* https://github.com/lathiat/nss-mdns

## Author

* __Jiab77__