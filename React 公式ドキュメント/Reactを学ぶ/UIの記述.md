# UI の記述

Reactは、ユーザインターフェース（UI）を表示するためのJavaScriptライブラリです。UIはボタンやテキスト、画像といった小さな要素から構成されています。Reactではこれらを、ネストして再利用できるコンポーネントにまとめることができます。ウェブサイトであれ携帯電話アプリであれ、画面上のすべてのものはコンポーネントに分解することができます。この章では、Reactコンポーネントを作成し、カスタマイズし、条件付きで表示する方法について学びます。

### この章で学ぶこと

- 初めてのコンポーネントの書き方
- コンポーネントファイルを複数に分ける理由とその方法
- JSXを使ってJavaScriptにマークアップを追加する方法
- JSX内で波括弧を使ってJavaScriptの機能にアクセスする方法
- コンポーネントをpropsを使ってカスタマイズする方法
- コンポーネントを条件付きでレンダーする方法
- 複数のコンポーネントを同時にレンダーする方法
- コンポーネントを純粋に保つことで混乱を避ける方法
- UIをツリーとして理解することが有用である理由

## 初めてのコンポーネント

Reactアプリケーションはコンポーネントと呼ばれる独立したUIのパーツで構成されています。Reactコンポーネントとは、マークアップを添えることができるJavaScript関数です。コンポーネントは、ボタンのような小さなものであることもあれば、ページ全体といった大きなものであることもあります。以下は3つの`Profile`コンポーネントをレンダーする`Gallery`コンポーネントの例です。

```
function Profile() {
  return (
    <img
      src="https://i.imgur.com/MK3eW3As.jpg"
      alt="Katherine Johnson"
    />
  );
}

export default function Gallery() {
  return (
    <section>
      <h1>Amazing scientists</h1>
      <Profile />
      <Profile />
      <Profile />
    </section>
  );
}
```

## コンポーネントのインポートとエクスポート

1つのファイルに多くのコンポーネントを宣言することもできますが、大きなファイルは取り回しが難しくなります。これを解決するために、コンポーネントを個別のファイルにエクスポートし、別のファイルからそのコンポーネントをインポートすることができます。

```
import Profile from './Profile.js';

export default function Gallery() {
  return (
    <section>
      <h1>Amazing scientists</h1>
      <Profile />
      <Profile />
      <Profile />
    </section>
  );
}
```

## JSXでマークアップを記述する

各 React コンポーネントは、ブラウザにレンダーされるマークアップを含んだJavaScript関数です。Reactコンポーネントは、マークアップを表現するためにJSXという拡張構文を使用します。JSXはHTMLによく似ていますが、少し構文が厳密であり、動的な情報を表示することができます。

既存のHTMLマークアップをReactコンポーネントに貼り付けても、常にうまく機能するわけではありません。

```
export default function TodoList() {
  return (
    // This doesn't quite work!
    <h1>Hedy Lamarr's Todos</h1>
    <img
      src="https://i.imgur.com/yXOvdOSs.jpg"
      alt="Hedy Lamarr"
      class="photo"
    >
    <ul>
      <li>Invent new traffic lights
      <li>Rehearse a movie scene
      <li>Improve spectrum technology
    </ul>
  );
}
```

```
Error
/src/App.js: Adjacent JSX elements must be wrapped in an enclosing tag. Did you want a JSX fragment <>...</>? (5:4)

  3 |     // This doesn't quite work!
  4 |     <h1>Hedy Lamarr's Todos</h1>
> 5 |     <img
    |     ^
  6 |       src="https://i.imgur.com/yXOvdOSs.jpg"
  7 |       alt="Hedy Lamarr"
  8 |       class="photo"
```

このような既存のHTMLがある場合は、コンバータを使って修正することができます。

```
export default function TodoList() {
  return (
    <>
      <h1>Hedy Lamarr's Todos</h1>
      <img
        src="https://i.imgur.com/yXOvdOSs.jpg"
        alt="Hedy Lamarr"
        className="photo"
      />
      <ul>
        <li>Invent new traffic lights</li>
        <li>Rehearse a movie scene</li>
        <li>Improve spectrum technology</li>
      </ul>
    </>
  );
}
```

## JSXに波括弧でJavaScriptを含める

JSXを使うことで、JavaScriptファイル内にHTMLのようなマークアップを記述し、レンダーのロジックとコンテンツを同じ場所に配置することができます。時には、そのマークアップ内でちょっとしたJavaScriptロジックを追加したり、動的なプロパティを参照したりしたいことがあります。このような状況では、JSX内で波括弧を使いJavaScript への「窓を開ける」ことができます。

```
const person = {
  name: 'Gregorio Y. Zara',
  theme: {
    backgroundColor: 'black',
    color: 'pink'
  }
};

export default function TodoList() {
  return (
    <div style={person.theme}>
      <h1>{person.name}'s Todos</h1>
      <img
        className="avatar"
        src="https://i.imgur.com/7vQD0fPs.jpg"
        alt="Gregorio Y. Zara"
      />
      <ul>
        <li>Improve the videophone</li>
        <li>Prepare aeronautics lectures</li>
        <li>Work on the alcohol-fuelled engine</li>
      </ul>
    </div>
  );
}
```

## コンポーネントにpropsを渡す

Reactコンポーネントでは、propsを使ってお互いに情報をやり取りします。親コンポーネントは、子コンポーネントにpropsを与えることで、情報を渡すことができます。HTMLの属性 (attribute) と似ていますが、オブジェクト、配列、関数、そしてJSXまで、どのようなJavaScriptの値でも渡すことができます！

```
import { getImageUrl } from './utils.js'

export default function Profile() {
  return (
    <Card>
      <Avatar
        size={100}
        person={{
          name: 'Katsuko Saruhashi',
          imageId: 'YfeOqp2'
        }}
      />
    </Card>
  );
}

function Avatar({ person, size }) {
  return (
    <img
      className="avatar"
      src={getImageUrl(person)}
      alt={person.name}
      width={size}
      height={size}
    />
  );
}

function Card({ children }) {
  return (
    <div className="card">
      {children}
    </div>
  );
}
```

## 条件付きレンダー

コンポーネントは、さまざまな条件によって表示内容を切り替える必要がよくあります。Reactでは、JavaScript のif文、`&&`や`?``:` 演算子などの構文を使って、条件付きでJSXをレンダーすることができます。

この例では、JavaScriptの`&&`演算子を使い、チェックマークを条件付きでレンダーしています。

```
function Item({ name, isPacked }) {
  return (
    <li className="item">
      {name} {isPacked && '✅'}
    </li>
  );
}

export default function PackingList() {
  return (
    <section>
      <h1>Sally Ride's Packing List</h1>
      <ul>
        <Item
          isPacked={true}
          name="Space suit"
        />
        <Item
          isPacked={true}
          name="Helmet with a golden leaf"
        />
        <Item
          isPacked={false}
          name="Photo of Tam"
        />
      </ul>
    </section>
  );
}
```

### リストのレンダー

データの集まりから複数のよく似たコンポーネントを表示したいことがよくあります。ReactでJavaScriptの`filter()`や`map()`を使って、データの配列をフィルタリングしたり、コンポーネントの配列に変換したりすることができます。

配列内の各要素には、`key`を指定する必要があります。通常、データベースのIDを`key` として使うことになるでしょう。key は、リストが変更されても各アイテムのリスト内の位置を React が追跡できるようにするために必要です。

App.js
data.js
utils.js
Reset

Fork
import { people } from './data.js';
import { getImageUrl } from './utils.js';

export default function List() {
  const listItems = people.map(person =>
    <li key={person.id}>
      <img
        src={getImageUrl(person)}
        alt={person.name}
      />
      <p>
        <b>{person.name}:</b>
        {' ' + person.profession + ' '}
        known for {person.accomplishment}
      </p>
    </li>
  );
  return (
    <article>
      <h1>Scientists</h1>
      <ul>{listItems}</ul>
    </article>
  );
}



Show more
Ready to learn this topic?
リストのレンダーを読んで、コンポーネントのリストをレンダーする方法と、key の選択方法を学びましょう。

Read More
コンポーネントを純粋に保つ
いくつかの JavaScript の関数は純関数です。純関数には以下の特徴があります。

自分の仕事に集中する。呼び出される前に存在していたオブジェクトや変数を変更しない。
同じ入力には同じ出力。同じ入力を与えると、純関数は常に同じ結果を返す。
コンポーネントを常に厳密に純関数として書くことで、コードベースが成長するにつれて起きがちな、あらゆる種類の不可解なバグ、予測不可能な挙動を回避することができます。以下は純粋ではないコンポーネントの例です。


App.js
Download
Reset

Fork
let guest = 0;

function Cup() {
  // Bad: changing a preexisting variable!
  guest = guest + 1;
  return <h2>Tea cup for guest #{guest}</h2>;
}

export default function TeaSet() {
  return (
    <>
      <Cup />
      <Cup />
      <Cup />
    </>
  );
}



Show more
このコンポーネントを純粋にするには、既に存在する変数を書き換えるのではなく、prop を渡すようにすることができます。


App.js
Download
Reset

Fork
function Cup({ guest }) {
  return <h2>Tea cup for guest #{guest}</h2>;
}

export default function TeaSet() {
  return (
    <>
      <Cup guest={1} />
      <Cup guest={2} />
      <Cup guest={3} />
    </>
  );
}


Ready to learn this topic?
コンポーネントを純粋に保つを読んで、予測可能な純関数としてコンポーネントを作成する方法を学びましょう。

Read More
UI をツリーとして理解する
React はコンポーネント間あるいはモジュール間の関係性をモデル化するために、ツリー構造を使用します。

React レンダーツリーとはコンポーネントの親子関係を表現したものです。

5 つのノードからなるツリー。それぞれのノードはコンポーネントを表している。ルートノードはツリーの最上部にあり 'Root Component' と書かれている。そこから 2 本の矢印が下に伸びており 'Component A' および 'Component C' と書かれたノードを指している。それぞれの矢印には 'renders' と書かれている。'Component A' からは 'renders' と書かれた矢印が 'Component B' と書かれたノードに伸びている。'Component C' からは 'renders' と書かれた矢印が 'Component D' と書かれたノードに伸びている。
React のレンダーツリーの例

ツリーの上側、つまりルートに近いコンポーネントはトップレベルコンポーネントです。子を持たないコンポーネントはリーフ（葉）コンポーネントです。このようなコンポーネントの分類は、データの流れやレンダーパフォーマンスを理解する際に有用です。

アプリを理解する上では、JavaScript のモジュール間の関係性をモデルすることも重要です。このようなものをモジュール依存関係ツリーと呼びます。

5 つのノードからなるツリー。それぞれのノードは JavaScript のモジュールを表している。最上部のノードは 'RootModule.js' と書かれている。そこから 'ModuleA.js'、'ModuleB.js'、'ModuleC.js' へと 3 本の矢印が伸びている。各矢印には 'imports' と書かれている。'ModuleC.js' からは 'imports' と書かれた矢印が 'ModuleD.js' と書かれたノードに伸びている。
モジュール依存関係ツリーの例

依存関係ツリーは、関連する JavaScript コードをすべてバンドルしてクライアントがダウンロード・レンダーできるようにするために、ビルドツールでよく使用されます。バンドルサイズが大きいと、React アプリのユーザ体験は悪化します。モジュール依存関係ツリーを理解することは、そのような問題をデバッグするのに役立ちます。

Ready to learn this topic?
UI をツリーとして理解するを読んで、レンダーツリーやモジュール依存関係ツリーの作り方、そしてそのような考え方がユーザ体験やパフォーマンスを改善する際にどのように役立つのかについて学びましょう。

Read More
次のステップ
初めてのコンポーネントに進んで、この章をページごとに読み進めましょう！

もしくは、すでにこれらのトピックに詳しい場合、インタラクティビティの追加について読んでみましょう。

Next
初めてのコンポーネント
Copyright © Meta Platforms, Inc
uwu?
Learn React
Quick Start
Installation
Describing the UI
Adding Interactivity
Managing State
Escape Hatches
API Reference
React APIs
React DOM APIs
Community
Code of Conduct
Meet the Team
Docs Contributors
Acknowledgements
More
Blog
React Native
Privacy
Terms
このページの内容
概要
初めてのコンポーネント
コンポーネントのインポートとエクスポート
JSX でマークアップを記述する
JSX に波括弧で JavaScript を含める
コンポーネントに props を渡す
条件付きレンダー
リストのレンダー
コンポーネントを純粋に保つ
UI をツリーとして理解する
次のステップ
UI の記述 – React
説明