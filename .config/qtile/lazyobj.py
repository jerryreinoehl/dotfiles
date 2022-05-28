from libqtile.lazy import lazy


def lazyobj(Cls):
    """Creates an instance of `Cls` with all the callable attributes of `Cls`
    decorated with `lazy.function` to be used with qtile.
    """
    lazyobj = Cls()

    for attr_name, attr_val in Cls.__dict__.items():
        if callable(attr_val):
            def outer(self, func):
                @lazy.function
                def inner(qtile, *args, **kwargs):
                    func(self, *args, **kwargs)
                return inner

            setattr(lazyobj, attr_name, outer(lazyobj, attr_val))

    return lazyobj
