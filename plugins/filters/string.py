import json


def to_safe_json(value):
    """
    Safely escapes a json string so that it can be wrapped in double quotes.
    This is useful to use in deploy vars so that they can be safely passed
    as hcl environment variables.
    """
    return json.dumps(json.dumps(value))


class FilterModule(object):
    def filters(self):
        return {
            'to_safe_json': to_safe_json,
        }
