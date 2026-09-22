+++
title = 'Moving Away from sudo su (Ubuntu 26.04, sudo-rs)'
date = '2026-09-22'
categories = ['Blog (Tech)']
tags = ['Linux', 'Command', 'My Failure']

isCJKLanguage = false
description = 'Use sudo -i instead of sudo su. In Ubuntu 26.04, the traditional sudo implementation has been replaced by sudo-rs, and signal handling seems to have changed slightly. As a result, if your SSH connection drops while you are running sudo su, the sudo su processes can stay alive indefinitely...'
summary = 'Use sudo -i instead of sudo su. In Ubuntu 26.04, the traditional sudo implementation has been replaced by sudo-rs, and signal handling seems to have changed slightly. As a result, if your SSH connection drops while you are running sudo su, the sudo su processes can stay alive indefinitely...'
showReadingTime = false

draft = false
+++


{{< devto-link url='https://dev.to/mkt/moving-away-from-sudo-su-ubuntu-2604-sudo-rs-480d' >}}

---

## TL;DR

Use `sudo -i` (or `sudo -s`) instead of `sudo su`.

In Ubuntu 26.04, the traditional `sudo` implementation has been replaced by `sudo-rs`, and signal handling seems to have changed slightly.
As a result, if your SSH connection drops while you are running `sudo su`, the `sudo su` processes can stay alive indefinitely...


## How I Noticed

While setting up an Ubuntu Server 26.04 machine over SSH,
I happened to look at the process tree in `htop` and noticed several `sudo su` processes running.

{{< figure
    src="featured.png"
    alt="Process tree showing sudo su processes left running directly under PID 1"
    caption="Process tree showing sudo su processes left running directly under PID 1"
    class="w100"
    >}}

None of them were running under `tmux`; they were all children of PID 1.

What was going on...?

I decided to investigate.


## Investigating the Cause

Here's the environment I used for testing:

- Ubuntu Server 26.04
- sudo-rs (0.2.13-0ubuntu1.2)


### Reproducing the Issue

After running a range of tests on an Ubuntu Server 26.04 virtual machine,
I confirmed that the `sudo su` processes stayed alive under the following conditions:

1. Connect to the server over SSH.
2. Start a root shell with `sudo su`.
3. Force the SSH connection to close by closing the local terminal.

With a reproducible case, I could start narrowing down the cause.


### "sudo su" vs. "sudo -i"

While looking into `sudo su`, I learned that these days, the recommendation is to use `sudo -i` instead.

I repeated the same test with `sudo -i`, and no `sudo` processes remained after the SSH connection closed.
That suggested the `su` part of `sudo su` was involved.

With a likely cause in mind, I gave ChatGPT access to the virtual machine and asked it to investigate what was happening.

Here's a rough summary of what it found. This is a simplified explanation, not a technically precise one.

- When an SSH connection closes, processes such as the shell launched by SSH are notified of the disconnect through SIGHUP. Whether a parent process forwards SIGHUP to its children depends on the implementation, but programs such as `sudo` and `bash` do forward it.
- With `sudo su`, `su` blocks SIGHUP. As a result, the `sudo su` processes do not exit unless their child process exits on its own (i.e., the `bash` process running under `sudo su` stays alive).
- With `sudo -i`, the shell launched by `sudo` sends SIGHUP to its child process. Once that process exits, `sudo -i` exits naturally as well.

In other words, it seems that SIGHUP from the SSH disconnect did not terminate `sudo su` or the processes beneath it.
When its parent process exited, `sudo su` was reparented to PID 1.


### "sudo" vs. "sudo-rs"

But I hadn't seen this happen on Ubuntu 24.04 or earlier...

Then I remembered that Ubuntu 26.04 uses `sudo-rs` as its `sudo` implementation.

- User management — sudo-rs (Ubuntu Server documentation): https://ubuntu.com/server/docs/how-to/security/user-management/#sudo-rs

I switched from `sudo-rs` back to the traditional `sudo` implementation and repeated the test.
This time, the `sudo su` processes exited properly when the SSH connection closed.

So it seemed that `sudo-rs` handled SIGHUP differently from the traditional `sudo`.

At this point, I asked ChatGPT to look into the implementations of both the traditional `sudo` (the sudo-project version) and `sudo-rs`.

From that investigation, it appeared that the traditional `sudo` has its own logic for cleaning up child processes when the TTY disconnects,
while the newer `sudo-rs` does not currently seem to handle that situation well. I haven't modified either implementation to test this, so I can't be certain.

- GitHub sudo-project/sudo exec_pty.c: https://github.com/sudo-project/sudo/blob/1815241c464259564541cc6306e12f2763691d92/src/exec_pty.c#L335-L360
- GitHub trifectatechfoundation/sudo-rs, issue "Better handling of closed user tty": https://github.com/trifectatechfoundation/sudo-rs/issues/1379


## Summary

The `sudo-rs` implementation used in Ubuntu 26.04 handles signals differently from the traditional `sudo`.
This seems like a good opportunity to move away from `sudo su` and use `sudo -i` (or `sudo -s`) instead.

You could perhaps call this a bug in `sudo-rs`.
Still, considering that the traditional `sudo` has extra logic to work around the issue with `sudo su`,
avoiding `sudo su` may be the safer choice.

That said, seeing `sudo su` processes linger under PID 1 is still pretty unsettling...


## Additional Notes

- On Ubuntu 26.04, you can switch between `sudo` implementations with the following command:

    ```sh
    $ sudo update-alternatives --config sudo

    There are 2 choices for the alternative sudo (providing /usr/bin/sudo).

      Selection    Path                     Priority   Status
    ------------------------------------------------------------
    * 0            /usr/lib/cargo/bin/sudo   50        auto mode
      1            /usr/bin/sudo.ws          40        manual mode
      2            /usr/lib/cargo/bin/sudo   50        manual mode

    Press <enter> to keep the current choice[*], or type selection number:
    ```

- You can also run either `sudo` implementation using its absolute path shown above, without changing the system-wide selection.
- As a related aside, I learned that `nohup` deliberately ignores SIGHUP (`SIG_IGN`), rather than blocking it.


## References

- User management — sudo-rs (Ubuntu Server documentation): https://ubuntu.com/server/docs/how-to/security/user-management/#sudo-rs
- sudo-project/sudo (GitHub): https://github.com/sudo-project/sudo
- trifectatechfoundation/sudo-rs (GitHub): https://github.com/trifectatechfoundation/sudo-rs


## Change History

- 2026/09/22: First version.
