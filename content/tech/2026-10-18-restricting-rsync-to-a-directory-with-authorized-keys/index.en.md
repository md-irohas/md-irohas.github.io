+++
title = 'Restricting rsync to a Specific Directory with authorized_keys'
date = '2026-10-18'
categories = ['Blog (Tech)']
tags = ['Linux', 'SSH', 'rsync']

isCJKLanguage = false
description = 'Learn how to use SSH authorized_keys and rrsync to restrict rsync access to a specific directory.'
summary = 'Learn how to use SSH authorized_keys and rrsync to restrict rsync access to a specific directory.'
showReadingTime = false

draft = false
+++

<!--
{{< devto-link url='' >}}

---
-->


## Introduction

In research environments, sharing large datasets with collaborators over the internet is a common task.
This often involves transferring files with `scp` (which uses `sftp` under the hood these days) or `rsync` over SSH with public key authentication.
However, simply creating an SSH account for file sharing also allows access to other directories that the account can read or write, as well as shell access and port forwarding. That is not ideal from a security perspective.

A common approach is to configure `ChrootDirectory` for each user in `sshd_config` and force the use of `internal-sftp`.
But for tasks such as synchronization, you may still want to use `rsync`.

In this article, I'll show you a simple way to share files within a specific directory using SSH's `authorized_keys` and the `rsync` helper script `rrsync` (restricted rsync).


> [!NOTE]
> This article assumes you are familiar with:
> - Creating and configuring Linux users
> - SSH public key authentication
> - Basic `rsync` usage


## TL;DR

- SSH's `authorized_keys` lets you restrict the commands and features available to each public key.
- Setting `rrsync` as the `command` in `authorized_keys` lets you restrict the directory that a client can read from or write to using `rsync`.

Here are examples of an `authorized_keys` entry and an `rsync` command.
Adjust the username, public key, paths, command arguments, and other details to suit your environment.


### Example: Allow Read-Only Access

An example `authorized_keys` entry on the server:

```text
# Allow read-only access to /srv/project-x on the server.

restrict,command="/usr/bin/rrsync -ro /srv/project-x" ssh-ed25519 AAAA...
```

An example `rsync` command to run on the client:

```sh
# Download the files in /srv/project-x/dataset/ on the server to the client's mydataset directory.

user@client:~$ rsync -av \
    -e 'ssh -i ~/.ssh/id_ed25519' \
    user@server:dataset/ \
    ./mydataset/
```

The path specified by the client is interpreted relative to `/srv/project-x`, the directory configured on the server.
For write-only access, use `-wo` instead of `-ro`.

> [!WARNING]
> Depending on the options you use, files may be transferred or deleted unintentionally, particularly when using `--delete` for uploads.
> Apply appropriate restrictions in `authorized_keys`, and check what will happen beforehand with `-n` (`--dry-run`).


## Test Environment

- Ubuntu Server 26.04
- rsync 3.4.1 (using the `rrsync` script included in the `rsync` package)

> [!WARNING]
> While writing this article, I noticed that the `rrsync` script included with rsync 3.4.1 appears to have a vulnerability that allows directory restrictions to be bypassed ([CVE-2026-53783](https://github.com/RsyncProject/rsync/blob/master/NEWS.md#news-for-rsync-350-13-aug-2026)).
> For safe use, use version 3.5.1 or later.


## authorized_keys and rrsync

Let's briefly look at `authorized_keys` and `rrsync`.


### authorized_keys

To allow SSH login with public key authentication, add each client public key to the login user's `~/.ssh/authorized_keys` file on the server, one key per line.

```text
# Example ~/.ssh/authorized_keys
ssh-ed25519 AAAA...(public-key1)
ssh-ed25519 AAAA...(public-key2)
```

If a line contains only a public key, the client can use a shell and run commands within the limits of the server configuration and the user's permissions.

You can add options before each public key to restrict the features available when that key is used.

```text
restrict,from="192.0.2.0/24",command="echo 'hello'" ssh-ed25519 AAAA...(public-key3)
```

- `restrict`: Disables PTY allocation, port forwarding, agent forwarding, X11 forwarding, and execution of `~/.ssh/rc`.
- `from="..."`: Restricts connections by source IP address or hostname. CIDR notation is also supported.
- `command="..."`: Runs the specified command instead of the command requested by the client.

In the example above, PTY allocation and port forwarding are disabled, connections are allowed only from `192.0.2.0/24`, and the command that runs is always `echo 'hello'` (which simply prints hello), regardless of the command the user requests.

There are many other options available in `authorized_keys`. If you're interested, see the "AUTHORIZED_KEYS FILE FORMAT" section of the `sshd` man page.

- [sshd(8) (Ubuntu 26.04)](https://manpages.ubuntu.com/manpages/resolute/man8/sshd.8.html)


### rrsync

The `rsync` command synchronizes files between directories.
Because it can synchronize data over SSH, it is commonly used for network backups and similar tasks.

Although `rsync` is often used to synchronize entire directories, you can also transfer individual files by specifying their paths.

There is a helper script for `rsync` called `rrsync` (restricted rsync).
It is implemented in Python and, as the name suggests, provides a restricted version of `rsync`.
On Ubuntu and some other distributions, the script is included in the `rsync` package.

By setting `rrsync` as the `command` in `authorized_keys`, you can make only a specific directory available to the client.

Here is the help output for `rrsync`:

```sh
$ rrsync -help
usage: rrsync [-ro | -wo] [-munge] [-no-del] [-no-lock] [-no-overwrite] [-help] DIR

Use "man rrsync" to learn how to restrict ssh users to using a restricted rsync command.

positional arguments:
  DIR            The restricted directory to use.

options:
  -ro            Allow only reading from the DIR. Implies -no-del and -no-lock.
  -wo            Allow only writing to the DIR.
  -munge         Enable rsync's --munge-links on the server side.
  -no-del        Disable rsync's --delete* and --remove* options.
  -no-lock       Avoid the single-run (per-user) lock check.
  -no-overwrite  Prevent overwriting existing files by enforcing --ignore-existing
  -help, -h      Output this help message and exit.
```

The only required argument is `DIR`, which specifies the directory to share.

If you set `rrsync /srv/project-x` as the `command` in `authorized_keys`, the client can use `rsync` to read and write files only within `/srv/project-x/`.

With this configuration, paths specified by the client are interpreted as follows:

| Path specified by the client | Actual path on the server |
| :--- | :-- |
| `user@server:./` | `/srv/project-x/` |
| `user@server:dataset/` | `/srv/project-x/dataset/` |
| `user@server:dataset/file.bin` | `/srv/project-x/dataset/file.bin` |

Use `-ro` or `-wo` to allow only reading or only writing, respectively.

- `-ro`: Allows only reading from the server.
- `-wo`: Allows only writing to the server. On its own, `-wo` does not prevent existing files from being overwritten or deleted, so combine it with `-no-del` or `-no-overwrite` as needed.

The restrictions imposed by `rrsync` apply on top of normal Linux file permissions.
Also, `rrsync` works by checking paths and options; it does not provide isolation like `chroot`.

> [!NOTE]
> Keep the following points in mind when choosing the shared directory (`DIR`):
>
> - Do not use the user's home directory as `DIR`.
>   If `DIR` contains `~/.ssh/authorized_keys` or `~/.bashrc` and you allow write access, the client could modify those files to bypass the restrictions.
> - Access outside `DIR` through symbolic links is also subject to restrictions.
>   `rrsync` is designed to reject options that dereference symbolic links, such as `--copy-links`, as well as paths that resolve outside `DIR`.
>   However, versions affected by the vulnerability mentioned in the Test Environment section may allow these restrictions to be bypassed.


#### How rrsync Works

`rrsync` is a Python wrapper script for `rsync`.

- [GitHub: RsyncProject / rsync](https://github.com/RsyncProject/rsync/blob/master/support/rrsync)

The command specified by `command` in `authorized_keys` receives the command string originally requested by the client in the `SSH_ORIGINAL_COMMAND` environment variable.
`rrsync` parses this string and starts `rsync` on the server with the appropriate restrictions.

The main rules for handling paths are:

- A path with `..` as a component is rejected.
- An absolute path starting with `/` is rewritten relative to `DIR`. For example, with the configuration above, `user@server:/dataset/` refers to `/srv/project-x/dataset/`.

You could implement similar behavior by checking `SSH_ORIGINAL_COMMAND` in your own script. Be careful, though: mistakes in path or option handling could allow the restrictions to be bypassed.


## Alternative: SFTP + chroot

As a side note...

If you don't specifically need `rsync`, you can also combine SFTP with `ChrootDirectory` to restrict access to a particular directory. This is probably the more common approach.
In that case, configure the restrictions in the server's `sshd_config` rather than `authorized_keys`.

```text
# /etc/ssh/sshd_config
Match User user2
    ChrootDirectory /srv/project-x
    ForceCommand internal-sftp
    DisableForwarding yes
    PermitTTY no
```

- `ChrootDirectory`: Sets `/srv/project-x` as the root directory after login. The client sees it as `/`.
- `ForceCommand internal-sftp`: Prevents commands other than SFTP from running. SCP using SFTP under the hood is also allowed. For read-only access, use `internal-sftp -R`.

The directory specified by `ChrootDirectory` and all its parent directories must be owned by `root` and must not be writable by anyone other than `root`.
If you want to allow uploads, create a separate subdirectory that the user can write to, such as `/srv/project-x/upload`.


## Summary

In this article, I showed how to use SSH's `authorized_keys` and `rrsync` to restrict the directory a client can access with `rsync`.

Beyond the features and commands covered here, there are plenty of useful tools and options that are easy to overlook.
Try exploring what might work for your own use case.


## References

- [rsync(1)](https://download.samba.org/pub/rsync/rsync.1)
- [rrsync(1)](https://download.samba.org/pub/rsync/rrsync.1)
- [sshd(8): AUTHORIZED_KEYS FILE FORMAT (Ubuntu 26.04)](https://manpages.ubuntu.com/manpages/resolute/man8/sshd.8.html)
- [rsync NEWS (including the fix for CVE-2026-53783)](https://github.com/RsyncProject/rsync/blob/master/NEWS.md)
- [rrsync implementation](https://github.com/RsyncProject/rsync/blob/master/support/rrsync)


## Change History

- 2026/11/03: First version.
