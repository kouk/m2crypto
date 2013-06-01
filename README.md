M2Crypto + AES CTR
==================

This repository contains some modifications to the [M2Crypto][] code. Specifically:

- Make setup.py pass `--swig-opts` to SWIG.
- Conditionally enable AES CTR mode.

If your OpenSSL version has AES CTR mode enabled, and is installed under
`/usr/local`, you can build and install the M2Crypto modules to your home
directory like this:

    python setup.py build_ext --openssl /usr/local/ --swig-opts "-DHAVE_AES_CTR"
    python setup.py install --user

[M2Crypto]: http://chandlerproject.org/Projects/MeTooCrypto
