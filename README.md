# pg_dump_n_dropbox_uploader

Postgresのダンプを取得してDropboxにアップロードするシェルスクリプト。

## Dropboxへのファイルアップロードスクリプトの入手

- [参考リンク](https://github.com/andreafabrizi/Dropbox-Uploader)

```sh
### スクリプトを入手
$ git clone https://github.com/andreafabrizi/Dropbox-Uploader.git

### Dropbox developerサイトでアクセストークンを生成しておく

### 実行権限を付与して、初期化
$ chmod +x dropbox_uploader.sh
$ ./dropbox_uploader.sh
生成したアクセストークンを入力

### コンフィグファイルが自動生成される
$ ls -la ~/.dropbox_uploader

### uploader の手動実行コマンド
$./dropbox_uploader.sh upload ローカルパス リモートパス
```

## 本スクリプト用の環境構築

```
/opt/knowledge_uploader
├── /data  #pg_dumpの出力ファイルを一時的に保存する
├── /logs  #ログを出力
├── knowledge_uploader.sh  #メインロジック

```
