# 既存プロジェクトにReactを追加する

既存のプロジェクトにインタラクティブな要素を加えたい場合、プロジェクトをReactで書き直す必要はありません。Reactを既存のスタックに追加することで、どこにでもインタラクティブなReactコンポーネントをレンダーできます。

### 補足

ローカル環境で開発するには Node.jsをインストールする必要があります。Reactをオンラインや単純なHTMLページで試すことも可能ですが、現実的には開発時に利用する大抵のJavaScriptツールには Node.jsが必要です。

## 既存のウェブサイトの一部にReactを使う

例えばRailsなどの他のサーバテクノロジで構築されている`example.com`というウェブアプリがあり、`example.com/some-app/`から始まる全ルートをReactで完全に実装したいとします。

以下の手順に従って設定することをお勧めします。

1. Reactベースのフレームワークのうちひとつを使い、アプリのReact部分をビルドします。
2. フレームワークの設定で`/some-app`を`base path`に指定します（方法：Next.js、Gatsby）。
3. サーバまたはプロキシを設定して、`/some-app/`以下のすべてのリクエストを React アプリで処理するようにします
。
こうすることで、アプリのReact部分がこれらのフレームワークに組み込まれたベストプラクティスを最大限に取り入れることができます。

多くのReactベースのフレームワークはフルスタックであり、Reactアプリがサーバ機能を活用できるようになっています。ただし、サーバでJavaScriptを実行できない場合や実行したくない場合でも、同じアプローチが使用できます。この場合、エクスポートされたHTML/CSS/JS（Next.jsの場合は `next export`出力、Gatsbyの場合はデフォルトを`/some-app`としてサーブします。

## 既存ページの一部にReactを使う

他のテクノロジ（Railsのようなサーバ側のものでもBackboneのようなクライアント側のものでも）で構築された既存のページがあり、そのページのどこかにインタラクティブな Reactコンポーネントをレンダーしたいとします。これはReactを結合する一般的な方法です。実際、Meta では何年もの間、ほとんどのReact使用法がこうでした！

これを行うには、2 つのステップが必要です。

1. JavaScript開発環境を設定して、JSX 構文の使用、`import`/`export`構文を使ったコードのモジュール分割、npmパッケージレジストリからのパッケージ（例えばReact）の使用ができるようにする。

2. ページ上の表示させたい場所にReactコンポーネントをレンダーする。

具体的なアプローチはあなたの既存ページのセットアップによって異なりますが、一部の詳細について見ていきましょう。

## ステップ1: モジュラーなJavaScript環境を設定する

モジュラーなJavaScript環境を使用すると、すべてのコードを単一のファイルに書くのではなく、Reactコンポーネントを別々のファイルに記述できるようになります。また、他の開発者によって npmパッケージレジストリに公開されている、素晴らしいパッケージ群（React自身も含む）を使えるようにもなります。具体的なやり方はあなたの既存のセットアップ方法によって異なります。

- アプリが既に`import`文を使ってファイル分割するよう設定されている場合、その既存の設定を使用するようにしてみてください。JS コードで`<div />`と記述すると、構文エラーが発生するかどうかを確認してください。構文エラーが発生する場合は、Babelを使用してJavaScriptを変換するようにし、JSXを使うためにBabel Reactプリセットを有効にしてください。

- JavaScriptモジュールをコンパイルする既存のセットアップがない場合は、Viteを使ってセットアップします。Viteコミュニティは、Rails、Django、Laravelをはじめ、多くのバックエンドフレームワークとのインテグレーションをメンテナンスしています。あなたのバックエンドフレームワークがリストされていない場合は、このガイドに従って手動でViteビルドをバックエンドと統合してください。

セットアップがうまくいっているかどうかを確認するには、プロジェクトフォルダーで次のコマンドを実行します。

```
npm install react react-dom
```

そして、あなたのメインの`JavaScript`ファイル（おそらく`index.js`や`main.js`といった名前のもの）の先頭に、以下のコードを追加します。

```
import { createRoot } from 'react-dom/client';

// Clear the existing HTML content
document.body.innerHTML = '<div id="app"></div>';

// Render your React component instead
const root = createRoot(document.getElementById('app'));
root.render(<h1>Hello, world</h1>);
```

ページ全体が「Hello, world!」に置き換わった場合は、すべてがうまくいったことになります。このまま読み進めてください。

### 補足

既存のプロジェクトにモジュラーな JavaScript 環境を組み込むことを最初は不安に感じるかもしれませんが、その価値はあると思います！行き詰まったら、コミュニティのリソースまたはVite Chatを試してみてください。

## ステップ2: ページにReactコンポーネントをレンダーする

前のステップでは、以下のコードをメインファイルのトップに置きました。

```
import { createRoot } from 'react-dom/client';

// Clear the existing HTML content
document.body.innerHTML = '<div id="app"></div>';

// Render your React component instead
const root = createRoot(document.getElementById('app'));
root.render(<h1>Hello, world</h1>);
```

もちろん、実際には既存の HTML コンテンツを削除したい訳ではありません！

なので上記のコードは削除してください。

代わりに、あなたのHTML内の特定の場所に Reactコンポーネントをレンダーしたいはずです。HTML ページ（またはそれを生成しているサーバテンプレート）を開き、次のようにして、任意のタグに一意の`id`属性を追加します：

```
<!-- ... somewhere in your html ... -->
<nav id="navigation"></nav>
<!-- ... more html ... -->
```

これにより、`document.getElementById`でHTML要素を検索して`createRoot`に渡すことができ、その内部にあなたのReactコンポーネントをレンダーできるようになります。

```
import { createRoot } from 'react-dom/client';

function NavigationBar() {
  // TODO: Actually implement a navigation bar
  return <h1>Hello from React!</h1>;
}

const domNode = document.getElementById('navigation');
const root = createRoot(domNode);
root.render(<NavigationBar />);
```

`index.html`にあるオリジナルのHTMLコンテンツはそのままに、自分の`NavigationBar`という Reactコンポーネントが、HTMLの`<nav id="navigation">`内に表示されるようになりました。Reactコンポーネントを既存のHTMLページの内部にレンダーする方法の詳細については、`createRoot`使用方法のドキュメントを参照してください。

既存のプロジェクトでReactを使用する場合、まずはボタンのような小さなインタラクティブなコンポーネントから始め、その後、徐々に「上向きに」進んでいき、最終的にはページ全体がReactで構築されるようにすることが一般的です。もしもそのような段階に到達した場合は、Reactの効果が最大限に得られるように、Reactフレームワークに移行することをお勧めします。

## 既存のネイティブモバイルアプリ内で React Native を使用する

React Nativeもまた、既存のネイティブアプリに段階的に統合することができます。Android（Java または Kotlin）用または iOS（Objective-C または Swift）用の既存のネイティブアプリがある場合は、このガイドに従ってReact Native画面を追加できます。
