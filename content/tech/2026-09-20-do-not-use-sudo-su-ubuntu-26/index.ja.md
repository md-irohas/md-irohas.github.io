+++
title = '脱 sudo su のすすめ（Ubuntu 26.04、sudo-rs）'
date = '2026-09-22'
categories = ['ブログ（技術）']
tags = ['Linux', 'コマンド', 'やらかし']

isCJKLanguage = true
description = 'sudo su ではなく sudo -i を使いましょう。Ubuntu 26.04では、 sudo コマンドが従来の sudo から sudo-rs に置き換えられ、シグナル処理の挙動が少し変わったようです。その結果、SSHでサーバに接続し、sudo su を実行した状態で接続が切れると、sudo su のプロセスが延々と生き残ります...'
summary = 'sudo su ではなく sudo -i を使いましょう。Ubuntu 26.04では、 sudo コマンドが従来の sudo から sudo-rs に置き換えられ、シグナル処理の挙動が少し変わったようです。その結果、SSHでサーバに接続し、sudo su を実行した状態で接続が切れると、sudo su のプロセスが延々と生き残ります...'
showReadingTime = false

draft = false
+++


{{< zenn-link url='https://zenn.dev/md_irohas/articles/4991118bc5a619' >}}

---



## 結論

`sudo su` ではなく `sudo -i` （あるいは `sudo -s` ）を使いましょう。

Ubuntu 26.04では、 `sudo` コマンドが従来の `sudo` から `sudo-rs` に置き換えられ、シグナル処理の挙動が少し変わったようです。
その結果、SSHでサーバに接続し、`sudo su` を実行した状態で接続が切れると、`sudo su` のプロセスが延々と生き残ります...


## きっかけ

Ubuntu Server 26.04のサーバをSSH経由でセットアップ中、
何気なく `htop` でプロセスツリーを眺めてみたら、複数の `sudo su` プロセスが動いていることに気づきました。

{{< figure
    src="featured.png"
    alt="PID 1の直下に残ったsudo suのプロセスツリー"
    caption="PID 1の直下に残ったsudo suのプロセスツリー"
    class="w100"
    >}}

いずれも `tmux` の下にいるわけでもなく、PID 1の子プロセスとして動いていました。

これは何ぞ...？

というわけで調べました。


## 原因調査

検証環境は以下の通りです。

- Ubuntu Server 26.04
- sudo-rs (0.2.13-0ubuntu1.2)


### 再現性の確認

Ubuntu Server 26.04の仮想マシンを用意して色々と試した結果、
以下の条件で `sudo su` のプロセスが残ることが確認できました。

1. SSHでサーバに接続する
2. `sudo su` でrootのシェルを起動する
3. SSHの接続を強制的に切断する（ローカルのターミナルを閉じる）

再現性が確認できたので、原因を特定していきましょう。


### "sudo su" vs. "sudo -i"

`sudo su` について調べたところ、そもそも今どき `sudo su` は使わず、 `sudo -i` を使うことを知りました。

- sudo su とかしてる人はだいたいおっさん（Zenn）: https://zenn.dev/tmtms/articles/202105-sudo-su

そこで、 `sudo -i` で同様の検証をしたところ、SSH切断後に `sudo` のプロセスは残りませんでした。
つまり、 `sudo su` の `su` が何か悪さをしてそうです。

原因の見当がついたので、ChatGPTに仮想マシンのアクセス権を与えて、何が起こっているのか調べてもらいました。

その結果わかったことをざっくりまとめると以下の通りです（※技術的に正確ではありません）。

- SSHの切断時、SSHに起動されたシェル等のプロセスは、SIGHUPで切断（終了）が伝えられる。親プロセスから子プロセスへSIGHUPを伝えるかは実装次第だが、 `sudo` や `bash` などはSIGHUPを子プロセスに伝える。
- `sudo su` の場合、 `su` がSIGHUPをブロックする。そのため、子プロセスが自分で終了しない限り、 `sudo su` のプロセスは終了しない（i.e., `sudo su` の下で動く `bash` は終了しない）。
- `sudo -i` の場合、 `sudo` に起動されたシェルがSIGHUPを子プロセスに送信し、そのプロセスが終了すれば、`sudo -i` 以下も自然と終了する。

つまり、SSHの切断によるSIGHUPでは `sudo su` 以下のプロセスは終了せず、
その親プロセスが終了した結果 `sudo su` はPID 1に引き取られた、ということのようです。


### "sudo" vs. "sudo-rs"

Ubuntu 24.04まではそんなことなかったのにどうして...

と思ったのですが、Ubuntu 26.04では、 `sudo` の実装として `sudo-rs` が採用されていることを思い出しました。

- Ubuntu 26.04でsudoが変わった──sudo-rsの挙動を実機検証してみた（Zenn）: https://zenn.dev/penbit_lab/articles/09e6bc5dad919a

そこで、 `sudo-rs` から従来の `sudo` に戻して動作を確認すると、
SSH切断後に `sudo su` のプロセスはちゃんと終了していました。

つまり、 `sudo-rs` のSIGHUPの処理が従来の `sudo` と違うようです。

ここまでわかったので、従来の `sudo`（sudo-project版）と `sudo-rs` の実装をChatGPTに調べてもらいました。

その結果、従来の `sudo` は、TTY切断時の子プロセスの後始末を自前で実装していそうですが、
新しい `sudo-rs` は、現状その辺りをうまく処理できていなそうということがわかりました（実装を変更して試してないので確証はないですが）。

- GitHub sudo-project/sudo exec_pty.c: https://github.com/sudo-project/sudo/blob/1815241c464259564541cc6306e12f2763691d92/src/exec_pty.c#L335-L360
- GitHub trifectatechfoundation/sudo-rs, Issue "Better handling of closed user tty": https://github.com/trifectatechfoundation/sudo-rs/issues/1379


## まとめ

Ubuntu 26.04で採用された `sudo-rs` はシグナル処理の挙動が従来の `sudo` と違うので、
これを機に脱 `sudo su` して `sudo -i` （もしくは `sudo -s` ）を使いましょう。

`sudo-rs` のバグと言ってもいいのかもしれませんが、
従来の `sudo` が `sudo su` の問題を回避するためにわざわざ実装を追加していることを考えると、
`sudo su` は避けるのが無難なのかもしれません。

とはいえ、 `sudo su` のプロセスがPID 1の下に残り続けるのは、さすがに気持ちが悪いですね。。。


## 補足

- Ubuntu 26.04では、以下のコマンドで `sudo` の実装を切り替えることができます。

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

- また、上の `sudo` のコマンドを絶対パスで指定すれば、システム側でわざわざ切り替えずに、それぞれの `sudo` コマンドを実行することもできます。
- 別のコマンドですが、 `nohup` はSIGHUPをブロックしているのではなく、意図的に無視（SIG_IGN）しているそうです。


## 参考資料

- sudo su とかしてる人はだいたいおっさん（Zenn）: https://zenn.dev/tmtms/articles/202105-sudo-su
- Ubuntu 26.04でsudoが変わった──sudo-rsの挙動を実機検証してみた（Zenn）: https://zenn.dev/penbit_lab/articles/09e6bc5dad919a
- sudo-project/sudo (GitHub): https://github.com/sudo-project/sudo
- trifectatechfoundation/sudo-rs (GitHub): https://github.com/trifectatechfoundation/sudo-rs


## 編集履歴

- 2026/09/22: 初稿作成。
