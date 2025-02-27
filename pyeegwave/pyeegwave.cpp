#define PY_SSIZE_T_CLEAN
#include <Python.h>

#include <iostream>
#include <fstream>
#include <string>


#include "../src/eegimage.h"


static PyObject *
pyeegwave_extract(PyObject *self, PyObject *args)
{
    const char *command;
    int sts;

    PyObject* seq;
    int seqlen;
    int i;

    //if (!PyArg_ParseTuple(args, "s", &command))
    //    return NULL;


    /* get one argument as a sequence */
    if(!PyArg_ParseTuple(args, "O", &seq))
        return 0;
    seq = PySequence_Fast(seq, "argument must be iterable");
    if(!seq)
        return 0;


    float descr[128];
    double *signal;


    /* prepare data as an array of doubles */
    seqlen = PySequence_Fast_GET_SIZE(seq);
    //if(!dbar) {
    //    Py_DECREF(seq);
    //    return PyErr_NoMemory(  );
    //}


    signal = new double[seqlen];
    memset(signal,0,sizeof(double)*seqlen);


    for(i=0; i < seqlen; i++) {
        PyObject *fitem;
        PyObject *item = PySequence_Fast_GET_ITEM(seq, i);
        if(!item) {
            Py_DECREF(seq);
            return 0;
        }
        fitem = PyNumber_Float(item);
        if(!fitem) {
            Py_DECREF(seq);
            PyErr_SetString(PyExc_TypeError, "all items must be numbers");
            return 0;
        }
        signal[i] = PyFloat_AS_DOUBLE(fitem);
        Py_DECREF(fitem);
    }    

    /* clean up, compute, and return result */
    Py_DECREF(seq);

    xeegimagedescriptor(&descr[0],signal,256,seqlen,1,1,true,1);

    int N=128;
    PyObject* python_val = PyList_New(N);
    for (int i = 0; i < N; ++i)
    {
        PyObject* pv = Py_BuildValue("f", descr[i]);
        PyList_SetItem(python_val, i, pv);
    }

    delete signal;


    return python_val;




    //sts = 3;
    //return Py_BuildValue("i", sts);
}

static PyMethodDef SpamMethods[] = {
    {"extract",  pyeegwave_extract, METH_VARARGS,
     "Execute a shell command."},
    {NULL, NULL, 0, NULL}        /* Sentinel */
};

static struct PyModuleDef spammodule = {
    PyModuleDef_HEAD_INIT,
    "pyeegwave",   /* name of module */
    NULL, /* module documentation, may be NULL */
    -1,       /* size of per-interpreter state of the module,
                 or -1 if the module keeps state in global variables. */
    SpamMethods
};

PyMODINIT_FUNC
PyInit_pyeegwave(void)
{
    return PyModule_Create(&spammodule);
}


int
main(int argc, char *argv[])
{
    wchar_t *program = Py_DecodeLocale(argv[0], NULL);
    if (program == NULL) {
        fprintf(stderr, "Fatal error: cannot decode argv[0]\n");
        exit(1);
    }

    printf("Running the module...\n");

    /* Add a built-in module, before Py_Initialize */
    PyImport_AppendInittab("pyeegwave", PyInit_pyeegwave);

    /* Pass argv[0] to the Python interpreter */
    Py_SetProgramName(program);

    /* Initialize the Python interpreter.  Required. */
    Py_Initialize();

    /* Optionally import the module; alternatively,
       import can be deferred until the embedded script
       imports it. */
    PyImport_ImportModule("pyeegwave");


    PyMem_RawFree(program);
    return 0;
}
