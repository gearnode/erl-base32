# Introduction
This document contains development notes about the `base32` library.

# Versioning
The following `base32` versions are available:
- `0.y.z` unstable versions.
- `x.y.z` stable versions: `base32` will maintain reasonable backward
  compatibility, deprecating features before removing them.
- Experimental untagged versions.

Developers who use unstable or experimental versions are responsible for
updating their application when `base32` is modified. Note that unstable
versions can be modified without backward compatibility at any time.

# Modules
## `base32`
### `encode/1`
Encodes a binary into a base32 encoded binary.

Example:
```erlang
base32:encode(<<"foobar">>).
```

### `decode/1`
Decodes a base32 encoded binary into a binary.

Example:
```erlang
base32:decode(<<"MZXW6YTBOI======">>).
```

## `base32hex`
### `encode/1`
Encodes a binary into a base32hex encoded binary.

Example:
```erlang
base32hex:encode(<<"foobar">>).
```

### `decode/1`
Decodes a base32hex encoded binary into a binary.

Example:
```erlang
base32hex:decode(<<"CPNMUOJ1E8======">>).
```
