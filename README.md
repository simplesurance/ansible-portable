## Customized portable-ansible version

### Installing

```
curl -fsSL \
        https://raw.githubusercontent.com/simplesurance/ansible-portable/master/scripts/installer.sh \
        | bash -s -- <VERSION> <INSTALL_DIR> <BIN_SYMLINK_DIR>
```


eg:
```
curl -fsSL \
        https://raw.githubusercontent.com/simplesurance/ansible-portable/master/scripts/installer.sh \
        | bash -s -- 0.0.8 /opt/ansible /usr/local/bin
```
