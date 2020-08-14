# Make coding more python3-ish
from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

from collections import defaultdict
from itertools import chain
from jinja2.filters import contextfilter
from jinja2.exceptions import FilterArgumentError


def contextfilter(f):
    """
    Decorator for marking context dependent filters. The current
    :class:`Context` will be passed as first argument.
    """
    f.contextfilter = True
    return f


@contextfilter
def map_dict(*args, **kwargs):
    """
    Apply a filter on a dictionary.
    The equivalent of the map() filter, but for dictionaries.
    """
    context = args[0]
    seq = args[1]

    if len(args) == 2 and 'attribute' in kwargs:
        attribute = kwargs.pop('attribute')
        if kwargs:
            raise FilterArgumentError('Unexpected keyword argument %r' %
                next(iter(kwargs)))
        func = make_attrgetter(context.environment, attribute)
    else:
        try:
            name = args[2]
            args = args[3:]
        except LookupError:
            raise FilterArgumentError('map requires a filter argument')
        func = lambda item: context.environment.call_filter(
            name, item, args, kwargs, context=context)

    if seq and isinstance(seq, dict):
        values = list(seq.values())
        keys = list(seq.keys())
        for i in range(len(keys)):
            seq[keys[i]] = func(values[i])

        return seq


def dict_mirror(d, by='values'):
    """
    Mirrors a dictionary by either its values or its keys
    """
    if isinstance(d, dict):
        if by == 'keys':
            d = dict(zip(d.keys(), d.keys()))
        else:
            d = dict(zip(d.values(), d.values()))

    return d


def dict_values_all(d):
    """
    Recursive function that returns a list with  all the values in a
    dictionary, even if they're deeply nested.
    """
    for v in d.values():
        if isinstance(v, dict):
            for item in dict_values_all(v):
                yield item
        else:
            yield v


def dict_values_csv(d):
    """
    Gets all the values from nested dictionaries and builds
    a comma separated list out of them (not escape safe).
    """
    return ','.join(list(dict_values_all(d)))


def combine_merge(value, append_dict):
    mydict = defaultdict(list)
    for key, value in chain(value.items(), append_dict.items()):
        mydict[key].append(value)
    return dict(mydict)


def values_to_dict(value):
    mydict = defaultdict(list)
    for key, value in chain(value.items()):
        if len(value) >= 2:
            mydict[value[0]] = value[1]
    return dict(mydict)


class FilterModule(object):
    def filters(self):
        return {
            'combine_merge': combine_merge,
            'dict_mirror': dict_mirror,
            'dict_values_all': dict_values_all,
            'dict_values_csv': dict_values_csv,
            'map_dict': map_dict,
            'values_to_dict': values_to_dict,
        }
