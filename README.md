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

For the moment, the printer can be installed that way:

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
