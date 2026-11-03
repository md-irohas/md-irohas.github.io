+++
title = 'rsyncで特定のディレクトリのみを共有する（w/ authorized_keys）'
date = '2026-10-18'
categories = ['ブログ（技術）']
tags = ['Linux', 'SSH', 'rsync']

isCJKLanguage = true
description = 'SSHのauthorized_keysとrrsyncを使って、rsyncのアクセス先を特定のディレクトリに制限する方法を紹介します。'
summary = 'SSHのauthorized_keysとrrsyncを使って、rsyncのアクセス先を特定のディレクトリに制限する方法を紹介します。'
showReadingTime = false

draft = false
+++


{{< zenn-link url="https://zenn.dev/md_irohas/articles/e341afe19f9d8a" >}}

---


## はじめに

研究系の職場にいると、大容量のデータをインターネット経由で関係先と共有することがよくあります。
その場合、公開鍵認証のSSHを使った`scp`（最近は内部的には`sftp`ですが）や`rsync`でファイルを送受信することが多いです。
しかし、共有用のSSHアカウントを作っただけでは、そのアカウントの権限でアクセスできる他のディレクトリの読み書きや、シェルの利用、ポート転送等もできてしまうため、セキュリティ上好ましくありません。

よく使われる方法としては、`sshd_config`でユーザごとに`ChrootDirectory`を設定して、コマンドを`internal-sftp`に設定することが多いですが、同期等では`rsync`を使いたくなることも多いです。

そこで本記事では、SSHの`authorized_keys`と`rsync`のヘルパースクリプトである`rrsync`（restricted rsync）を使って、特定のディレクトリ内のファイルのみを簡単に共有する方法を紹介します。


> [!NOTE]
> 本記事は以下の知識を前提とします。
> - Linuxにおけるユーザの作成・設定
> - SSHの公開鍵認証
> - `rsync`の基本的な使い方


## TL;DR

- SSHの`authorized_keys`では、実行できるコマンドや機能を公開鍵ごとに制限できます。
- `authorized_keys`の`command`に`rrsync`を指定することで、クライアントが`rsync`で読み書きできるディレクトリを制限できます。

`authorized_keys`と`rsync`コマンドの例は以下の通りです。
ユーザ名、公開鍵、パス（Path）、コマンドの引数等は、ご自身の環境に合わせて適宜読み替えてください。


### 例: 読み取りのみを許可

サーバの`authorized_keys`の例。

```text
# サーバの /srv/project-x の読み取りのみを許可。

restrict,command="/usr/bin/rrsync -ro /srv/project-x" ssh-ed25519 AAAA...
```

クライアントで実行する`rsync`コマンドの例。

```sh
# サーバの /srv/project-x/dataset/ 内のファイルを、クライアントの mydataset ディレクトリへダウンロードする。

user@client:~$ rsync -av \
    -e 'ssh -i ~/.ssh/id_ed25519' \
    user@server:dataset/ \
    ./mydataset/
```

クライアントが指定したパスは、サーバで指定した`/srv/project-x`を基準に解釈されます。
また、書き込み専用にする場合は、`-ro`の代わりに`-wo`を使用します。

> [!WARNING]
> オプションによっては、ファイルが意図せずに転送・削除されることがあります（特に、書き込み時に`--delete`オプションを指定した場合等）。
> `authorized_keys`側でしっかり制限するとともに、事前に`-n`（`--dry-run`）オプションで動作を確認しましょう。


## 検証環境

- Ubuntu Server 26.04
- rsync 3.4.1（`rrsync`は`rsync`パッケージに付属しているものを使用）

> [!WARNING]
> 記事の執筆中に気づいたのですが、rsync 3.4.1に付属する`rrsync`にはディレクトリの制限を回避する脆弱性があるようです（[CVE-2026-53783](https://github.com/RsyncProject/rsync/blob/master/NEWS.md#news-for-rsync-350-13-aug-2026)）。
> 安全に使いたい場合には、3.5.1以降のバージョンを使用しましょう。


## authorized_keysとrrsync

`authorized_keys`と`rrsync`について簡単に説明します。


### authorized_keys

SSHサーバで公開鍵認証によるログインを許可するには、クライアントの公開鍵をサーバ側のログインユーザの`~/.ssh/authorized_keys`に1行ずつ登録します。

```text
# ~/.ssh/authorized_keys の例
ssh-ed25519 AAAA...(public-key1)
ssh-ed25519 AAAA...(public-key2)
```

公開鍵のみを記述した場合、サーバ側の設定とユーザの権限の範囲で、シェルやコマンドを利用できます。

公開鍵の前には鍵ごとに設定を書くことができ、その鍵で利用できる機能を制限することができます。

```text
restrict,from="192.0.2.0/24",command="echo 'hello'" ssh-ed25519 AAAA...(public-key3)
```

- `restrict`: PTYの割り当て、ポート・エージェント・X11の転送、および、`~/.ssh/rc`の実行を禁止する。
- `from="..."`: 接続元のIPアドレスやホスト名を制限する。CIDR形式も指定できる。
- `command="..."`: クライアントが要求したコマンドの代わりに、指定したコマンドを実行する。

例えば、上の設定例の場合、PTYの割り当てやポート転送等は禁止、`192.0.2.0/24`からのみ接続可、実行されるコマンドは（ユーザがどんなコマンドを打っても）常に`echo 'hello'`（helloと出力するだけ）という動作になります。

`authorized_keys`で使えるオプションは他にもたくさんありますので、興味がある方は`sshd`のmanページの「AUTHORIZED_KEYS FILE FORMAT」を確認してください。

- [sshd(8) (Ubuntu 26.04)](https://manpages.ubuntu.com/manpages/resolute/man8/sshd.8.html)


### rrsync

`rsync`コマンドは、ディレクトリ間のファイルを同期するコマンドです。
`rsync`はSSH上でデータを同期できることから、ネットワーク経由のバックアップ等によく使われます。

なお、`rsync`はディレクトリ単位の同期で使用されることが多いですが、ファイルを指定することでファイル単体の転送も可能です。

`rsync`のヘルパースクリプトとして`rrsync`（restricted rsync）というスクリプトがあります。
Pythonで実装されており、名前の通り、機能を制限した`rsync`を提供します。
Ubuntu等では、`rsync`のパッケージにこのスクリプトが付属しています。

この`rrsync`を`authorized_keys`の`command`に指定することで、特定のディレクトリのみをクライアントに提供できるようになります。

`rrsync`のヘルプは以下の通りです。

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

必須の引数は、共有するディレクトリを指定する`DIR`のみです。

`rrsync /srv/project-x`を`authorized_keys`の`command`に設定した場合、クライアントは`rsync`コマンドで`/srv/project-x/`内のファイルのみを読み書きすることができます。

クライアントが指定したパスは、先の設定では以下のように解釈されます。

| クライアントが指定したパス | サーバ上の実際のパス |
| :--- | :-- |
| `user@server:./` | `/srv/project-x/` |
| `user@server:dataset/` | `/srv/project-x/dataset/` |
| `user@server:dataset/file.bin` | `/srv/project-x/dataset/file.bin` |

読み取りのみ・書き込みのみに制限するには、それぞれ`-ro`と`-wo`オプションを使用します。

- `-ro`: サーバからの読み取りのみを許可する。
- `-wo`: サーバへの書き込みのみを許可する。`-wo`だけでは既存ファイルの上書きや削除までは禁止されないので、必要に応じて`-no-del`や`-no-overwrite`を併用します。

なお、`rrsync`の制限は通常のLinuxのファイルアクセスの権限の上に適用されます。
また、`rrsync`はパスやオプションを検査する仕組みであり、`chroot`のような隔離を実現するものではありません。

> [!NOTE]
> 共有するディレクトリ（`DIR`）の設定には、以下の点に注意してください。
>
> - `DIR`にはユーザのホームディレクトリを指定しないでください。
>   `DIR`が`~/.ssh/authorized_keys`や`~/.bashrc`を含む場合、書き込みを許可すると、クライアントがこれらを書き換えて制限を回避できてしまいます。
> - シンボリックリンクを介した`DIR`の外へのアクセスも、制限の対象です。
>   `rrsync`はリンクの中身を転送するオプション（`--copy-links`等）や、`DIR`の外に解決されるパスを拒否する仕組みになっています。
>   ただし、検証環境の節で触れた脆弱性があるバージョンでは、この制限を回避されるおそれがあります。


#### rrsyncの実装

`rrsync`はPythonで書かれた`rsync`のラッパースクリプトです。

- [GitHub: RsyncProject / rsync](https://github.com/RsyncProject/rsync/blob/master/support/rrsync)

`authorized_keys`の`command`に指定したコマンドには、クライアントが実行しようとしたコマンドの文字列が環境変数`SSH_ORIGINAL_COMMAND`として渡されます。
`rrsync`は、この文字列をパースして処理し、サーバ側の`rsync`を起動することで制限つきの`rsync`を実現しています。

主なパスの扱いは以下の通りです。

- パスの構成要素に`..`を指定するとエラーになる。
- `/`から始まる絶対パスは、`DIR`を基準としたパスに置き換えられる。例えば、先の例の`user@server:/dataset/`は`/srv/project-x/dataset/`になる。

自作のスクリプトで`SSH_ORIGINAL_COMMAND`を検査することで同様の処理を実現できますが、パスやオプションの処理を誤ると制限を回避されるおそれがありますのでご注意ください。


## 参考: SFTP + chroot の場合

参考までに...

`rsync`にこだわらないのであれば、SFTPと`ChrootDirectory`を組み合わせて、アクセス先を制限する方法もあります（おそらくこちらが一般的です）。
その場合、`authorized_keys`ではなく、サーバの`sshd_config`で制限します。

```text
# /etc/ssh/sshd_config
Match User user2
    ChrootDirectory /srv/project-x
    ForceCommand internal-sftp
    DisableForwarding yes
    PermitTTY no
```

- `ChrootDirectory`: ログイン後のルートディレクトリを`/srv/project-x`にする。クライアントからは`/`として見える。
- `ForceCommand internal-sftp`: SFTP以外のコマンドを実行できなくする（内部的にSFTPを使うSCPは可）。読み取りのみにする場合は`internal-sftp -R`とする。

なお、`ChrootDirectory`に指定したディレクトリとその上位のディレクトリは、すべて`root`所有かつ`root`以外が書き込めない権限にする必要があります。
そのため、クライアントにアップロードを許可する場合は、`/srv/project-x/upload`のように、ユーザが書き込めるサブディレクトリを別途用意してください。


## まとめ

SSHの`authorized_keys`と`rrsync`を使って、クライアントが`rsync`でアクセスできるディレクトリを制限する方法を紹介しました。

この記事で紹介した機能やコマンド以外にも、意外と知られていない便利な機能やコマンドが数多くあります。
皆さんも、ぜひ自分の用途に合わせて調べてみてください。


## 参考資料

- [rsync(1)](https://download.samba.org/pub/rsync/rsync.1)
- [rrsync(1)](https://download.samba.org/pub/rsync/rrsync.1)
- [sshd(8): AUTHORIZED_KEYS FILE FORMAT (Ubuntu 26.04)](https://manpages.ubuntu.com/manpages/resolute/man8/sshd.8.html)
- [rsync NEWS（CVE-2026-53783の修正を含む）](https://github.com/RsyncProject/rsync/blob/master/NEWS.md)
- [rrsyncの実装](https://github.com/RsyncProject/rsync/blob/master/support/rrsync)


## 編集履歴

- 2026/11/03: 初稿作成。
