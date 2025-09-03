# React Developer Tools

React Developer Tools を使うことで、Reactのコンポーネントを調査し、propsやstateを編集し、パフォーマンスの問題を特定できます。

## このページで学ぶこと

- React Developer Toolsをインストールする方法

## ブラウザ拡張機能

Reactを使ったウェブサイトをデバッグする最も簡単な方法は、React Developer Tools というブラウザ拡張機能をインストールすることです。これは複数の人気のブラウザで利用可能です。

- Chrome用にインストール
- Firefox用にインストール
- Edge用にインストール

これで、Reactで構築されたウェブサイトを訪れると、ComponentsとProfilerパネルが表示されるようになります。

## Safariおよび他のブラウザ

他のブラウザ（例えばSafari）の場合、react-devtoolsのnpmパッケージをインストールします。

```
# Yarn
yarn global add react-devtools

# Npm
npm install -g react-devtools
```

次に、ターミナルから開発者ツールを開きます。

```
react-devtools
```

そして、ウェブサイトの`<head>`の先頭に以下の`<script>`タグを追加して、ウェブサイトを接続します。

```
<html>
  <head>
    <script src="http://localhost:8097"></script>
```

ここでブラウザでウェブサイトをリロードし、開発者ツールで表示できるようにしてください。

## モバイル(React Native)

React Nativeで作成するアプリの調査を行う場合は、React Developer Toolsと密に統合された組み込みデバッガであるReact Native DevToolsを使用できます。要素のハイライトや選択を含むすべての機能が、ブラウザ版の機能拡張と同様に動作します。

0.76より前のバージョンのReact Nativeの場合は、上記のSafariおよび他のブラウザのガイドに従ってスタンドアロン版のReact DevToolsを使用してください。
