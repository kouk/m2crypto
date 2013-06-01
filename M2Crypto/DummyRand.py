"""M2Crypto wrapper for OpenSSL PRNG. Requires OpenSSL 0.9.5 and above.  """

__all__ = ['dummyrand_set', 'dummyrand_restore']

import m2

dummyrand_set       = m2.dummyrand_set
dummyrand_restore   = m2.dummyrand_restore
