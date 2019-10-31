### アプリケーションについて

- このアプリケーションは、Dokcerを用いてRuby on Rails（以下Rails）の環境を作成することができるものです。自身の使いたいRuby及びRailsのバージョンを指定することができ、新たにアプリケーションを作る場合も、既存のアプリケーションをDockerで動かしたい場合も、簡単に行うことができます。


### 使用方法


#### １．新規でアプリケーションを作成する場合

- Dockerfile内の一番上の「ruby:」のあとでRubyのバージョンを指定することができます。初期状態では、「2.6.3」が指定されているので、Ruby 2.6.3がインストールされたDocker Imageを使用することになります。

- rails-appディレクトリにあるGemfile内の「gem 'rails'」のあとでRailsのバージョンを指定することができます。初期状態では、「5.2.2」が指定されているので、Rails 5.2.2がインストールされます。

- 上記の設定が完了したら、以下のコマンドを実行してrailsプロジェクトを作成します。   
※ 今回は、MySQLを使用していますが、任意のDBMSを使用することもできます。

```
 $ docker-compose run web rails new . --force --database=mysql
 ```

 - ホスト側のrails-appディレクトリに共有されているファイルに権限がないので、以下のコマンドで権限を変更します。   
 ※ Docker側で作成されたファイルは、権限がrootになっているので、ホスト側で編集したい場合はその都度以下のコマンドを実行する必要があります。

 ```
 $ docker-compose run web chmod -R +777 .
 ```
 
 - 新規プロジェクトを作成して新しく追加されたgemをインストールするため、イメージを再ビルドするために以下のコマンドを実行しておきます。
 
 ```
 $ docker-compose build
 ```

 - DBMSをMySQLに変更しているので、その設定をする。rails-app/config/database.ymlを編集します。   
 ※ usernameとpasswordをdoker-compose.ymlで指定したものに変更し、hostをdbに変更します。
 
 ```
 default: &default
  adapter: mysql2
  encoding: utf8
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: root
  password: secret
  host: db
 ```

- 以下のコマンドでアプリケーションを立ち上げます。

```
$ docker-compose up -d
```

- 以下のコマンドでデータベースを初期化します。

```
$ docker-compose exec web rake db:create
```

- ブラウザで `http://localhost:3000` にアクセスしてwelcomeページが表示されれば作業終了です。


#### ２．既存のアプリケーションを動かしたい場合

- Dockerfile内のrubyのバージョンを既存アプリで使用しているバージョンと合わせます。

- rails-appディレクトリを削除して、既存アプリをDockerfileと同じ場所に移動させます。

- Dockerfile及びdocker-compose.yml内のrails-appとなっている場所をすべて既存アプリのディレクトリ名に変更します。

- 既存アプリのconfig/database.ymlを編集します。  
 ※ usernameとpasswordをdoker-compose.ymlで指定したものに変更し、hostをdbに変更する。
 
 ```
 default: &default
  adapter: mysql2
  encoding: utf8
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: root
  password: secret
  host: db
 ```

 - 既存アプリでMySQL以外のDBMSを使用している場合は、docker-compose.ymlのdbを使用しているDBMSに合わせて編集します。

- 以下のコマンドで、アプリケーションを立ち上げます。

```
$ docker-compose up -d
```

- 以下のコマンドでデータベースを初期化します。

```
$ docker-compose exec web rake db:create
```

- 以下のコマンドでデータベースのマイグレーションを行います。

```
$ docker-compose exec web rake db:migrate
```

- ブラウザで自身で設定したルーティングに合わせてアクセスし、問題なく動いていれば作業終了です。
