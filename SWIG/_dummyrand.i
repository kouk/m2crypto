/* -*- Mode: C; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/* $Id$ */

%module _dummyrand

%{
#include <stdlib.h>
static int _dummyrand_status = 0;
%}

%inline %{
/* code below inspired by http://stackoverflow.com/questions/7437177/force-openssls-rngs-to-return-a-repeatable-byte-sequence */
static void dummyrand_cleanup() {
    _dummyrand_status = 0;
}

/* Seed the libc RNG with the first 4 bytes of the buffer and
 unless if caller claims to add entropy assume it's enough */
static void dummyrand_add(const void *buf, int num, double add_entropy) {
    if (num >= 4) {
        srand( *((unsigned int *) buf) );
    }

    if (add_entropy>0) {
        _dummyrand_status=1;
    }
}

/* return 1 if dummyrand_add has been called at least once */
static int dummyrand_status() { 
    return _dummyrand_status;
}

/* just call dummyrand_add */
static void dummyrand_seed(const void *buf, int num) {
    dummyrand_add(buf, num, num);
}

/* Use libc rand() to get num random bytes. Return error if entropy not added. */
static int dummyrand_bytes(unsigned char *buf, int num) {
    int i;
    for( i = 0; i < num; i++ ) {
        buf[i] = rand() % 256;
    }
    return _dummyrand_status;
}

/* method table */
const RAND_METHOD dummyrand_meth = {
        dummyrand_seed,
        dummyrand_bytes,
        dummyrand_cleanup,
        dummyrand_add,
        dummyrand_bytes,
        dummyrand_status
};

/* pointer to original rand method */
const RAND_METHOD *dummyrand_saved = NULL;

/* our RAND method */
const RAND_METHOD *RAND_dummyrand() { 
    return &dummyrand_meth;
}

/* set the dummy rand method */
PyObject *dummyrand_set(void) {
    dummyrand_saved = (const RAND_METHOD *)RAND_get_rand_method();
    RAND_set_rand_method(RAND_dummyrand());
    Py_INCREF(Py_None);
    return Py_None;
}

/* restore the original rand method */
PyObject *dummyrand_restore(void) {
    if (dummyrand_saved != NULL) {
        RAND_set_rand_method(dummyrand_saved);
        dummyrand_saved = NULL;
    }
    Py_INCREF(Py_None);
    return Py_None;
}

%}
