### `config/secret.yml` を作成
`secret.yml`の例

```yaml
development:
  secret_key_base: 0a9cdc75f4735b03060d8f884a7730f4f9c023be5ee698db9d9a2f886899d7b9f10d0f011f9e8421997c46bb057bdaa19a49ed321feee661a3358f2742c39be8

test:
  secret_key_base: d48502694755e2211d87658e7ff5b053e6a4b2a0f2645ebedc405cb1c1ab959fed229b42f554cdc1b195b2345a0d33c98cf16512ede067bfadb6fbb763cd3b87

production:
  secret_key_base: <%= ENV["SECRET_KEY_BASE"] %>
```

### データベース & テーブルの作成

```bash
$ bundle exec rake db:create
$ bundle exec rake db:migrate
```

## 起動方法

### サーバー起動

```
$ bundle exec rails s
```

### 仕事割当期限チェックワーカー

```bash
$ bundle exec sidekiq -q assign
```