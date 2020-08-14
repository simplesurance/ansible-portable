import json


def traefik_params(d):
    """
    Converts a dictionary or list to a string ready to be fed
    as traefik v2 parameters, ie: `my_value1`, `my_value2`.
    """
    iter = d
    if isinstance(iter, dict):
        iter = iter.values()

    l = []
    for i in iter:
        l.append('`%s`' % (i))

    return ','.join(l)


class FilterModule(object):
    def filters(self):
        return {
            'traefik_params': traefik_params,
        }
