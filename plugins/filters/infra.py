import re

from ansible.errors import AnsibleFilterError


def target2region(value):
    """
    Very simple filter plugin to extract region from the deployment target
    templated_string: "{{ target|target2region }}"
    """
    if re.search("^sb-.*", value):
        return "eu"

    search = re.search("^.+-(stg|prd)-(.+)$", value)
    if search:
        return search.group(2)

    raise AnsibleFilterError("Cannot get region out of target: %s" % value)


def target2project_id(value):
    """
    Very simple filter plugin to extract project_id from the deployment target
    templated_string: "{{ target|target2project_id }}"
    """
    if re.search("^sb-.*", value):
        return "sisu"

    search = re.search("^(.+)-(stg|prd)-(.+)$", value)
    if search:
        return search.group(1)

    raise AnsibleFilterError("Cannot get project_id out of target: %s" % value)


class FilterModule(object):
    def filters(self):
        return {
            'target2region': target2region,
            'target2project_id': target2project_id,
        }
