# Reactの流儀

Reactは、あなたが設計を考える方法やアプリを構築する方法を変化させます。Reactでユーザインターフェースを構築する際には、まずUIをコンポーネントと呼ばれる部品に分割します。次に、各コンポーネントのさまざまな視覚的状態を記述します。最後に、複数のコンポーネントを接続し、それらの間をデータが流れるようにします。このチュートリアルでは、Reactを使って検索可能な商品データテーブルを作成する際の思考プロセスについて説明します。

## モックアップから始めよう

すでに、JSON APIが実装済みで、デザイナからもモックアップがもらえているとしましょう。

JSON API は以下のようなデータを返します。

```
[
  { category: "Fruits", price: "$1", stocked: true, name: "Apple" },
  { category: "Fruits", price: "$1", stocked: true, name: "Dragonfruit" },
  { category: "Fruits", price: "$2", stocked: false, name: "Passionfruit" },
  { category: "Vegetables", price: "$2", stocked: true, name: "Spinach" },
  { category: "Vegetables", price: "$4", stocked: false, name: "Pumpkin" },
  { category: "Vegetables", price: "$1", stocked: true, name: "Peas" }
]
```

モックは次のような見た目だったとします。

ReactでUIを実装する際には、通常以下のような5つのステップに従います。

## ステップ1：UIをコンポーネントの階層に分割する

まず最初に行うのは、モックアップのすべてのコンポーネントとサブコンポーネントを四角で囲んで、それぞれに名前を付けていくことです。デザイナと一緒に仕事をしている場合は、彼らがデザインツールでこれらのコンポーネントにすでに名前を付けているかもしれませんので、話をしに行きましょう。

あなたの技術的バックグラウンドによって、デザインをコンポーネントに分割するとはどういうことなのか、いろいろな考え方ができるでしょう。

- **プログラマ** — 新しい関数やオブジェクトを作成するかどうかを決定するときと同じ手法を使いましょう。そのような手法のひとつに単一責任の原則 (single responsibility principle) があります。つまり、1 つのコンポーネントは理想的には 1 つのことだけを行うべきだということです。もし大きくなってしまったら、より小さなサブコンポーネントに分解するべきです。
- **CSSエンジニア** — どの部分に対してクラスセレクタを作成するのか、と考えてみてください（ただし、コンポーネントの方が少し粒度が低めです）。
- **デザイナ** — デザインのレイヤをどのように整理するかを考えてください。

JSON がうまく構造化されている場合、それが UI のコンポーネント構造に自然に対応していることがよくあります。それは、UI とデータモデルが同じ情報アーキテクチャ、つまり同じ形状を持っていることが多いためです。1 つのコンポーネントがデータモデルの 1 つの部分に対応するような形で、UI をコンポーネントに分割していきましょう。

この画面には 5 つのコンポーネントがあることがわかります。

1. `FilterableProductTable`（灰色）はアプリ全体のコンテナ。
2. `SearchBar`（青）はユーザ入力を受け取る。
3. `ProductTable`（紫）はユーザ入力に従ってリストを表示およびフィルタリングする。
4. `ProductCategoryRow`（緑）はカテゴリごとの見出しを表示する。
5. `ProductRow`（黄）は個々の製品に対応する行を表示する。

`ProductTable`（紫）を見ると、（`“Name”`と`“Price”` というラベルがある）テーブルヘッダ部分が、専用のコンポーネントになっていないことに気付くでしょう。これは好みの問題であり、どちらであっても構いません。今回の例ではヘッダは商品テーブル内に表示するものであるため、`ProductTable`の一部としています。ただし、このヘッダが複雑になる場合（例えばソート機能を追加する場合）、専用の`ProductTableHeader`コンポーネントに移動してもよいでしょう。

モックアップ内にあるコンポーネントを特定したら、それらを階層構造に整理します。モックアップで他のコンポーネントの中にあるコンポーネントを、階層構造でも子要素として配置すればいいのです。

- `FilterableProductTable`
  - `SearchBar`
  - `ProductTable`
    - `ProductCategoryRow`
    - `ProductRow`

## ステップ2: Reactで静的なバージョンを作成する

これでコンポーネント階層ができたので、アプリの実装に取り掛かりましょう。最も分かりやすいアプローチは、インタラクティブな要素はまだ加えず、単にデータモデルから UI をレンダーするバージョンを作成することです。静的なバージョンを先に構築し、後からインタラクティブ性を追加する方が、多くの場合は簡単です。静的なバージョンを作成する間はタイプ量が多い代わりに考えることはほどんどなく、インタラクティブな要素を追加しようとするとタイプ量が少ない代わりに考えることが多くなります。

データモデルをレンダーする静的バージョンのアプリを作成するにあたっては、コンポーネントを作成していく際に、他のコンポーネントを再利用しつつprops経由でそれらにデータを渡すようにします。propsとは、親から子へとデータを渡すための手段です。（もしstateの概念に馴染みがある場合でも、この静的なバージョンを作成している間はstateを一切使わないでください。stateはインタラクティビティ、つまり時間とともに変化するデータのためにあるものです。今はアプリの静的なバージョンなのでstateは不要です。）

「トップダウン」で高い階層にあるコンポーネント(`FilterableProductTable`) から構築を始めることも、「ボトムアップ」で低い階層にあるコンポーネント (`ProductRow`) から構築を始めることもできます。通常、単純な例ではトップダウンで作業する方が簡単であり、大規模なプロジェクトではボトムアップで進める方が簡単です。

```
function ProductCategoryRow({ category }) {
  return (
    <tr>
      <th colSpan="2">
        {category}
      </th>
    </tr>
  );
}

function ProductRow({ product }) {
  const name = product.stocked ? product.name :
    <span style={{ color: 'red' }}>
      {product.name}
    </span>;

  return (
    <tr>
      <td>{name}</td>
      <td>{product.price}</td>
    </tr>
  );
}

function ProductTable({ products }) {
  const rows = [];
  let lastCategory = null;

  products.forEach((product) => {
    if (product.category !== lastCategory) {
      rows.push(
        <ProductCategoryRow
          category={product.category}
          key={product.category} />
      );
    }
```

（このコードが難解に思える場合は、まずクイックスタートを参照してください！）

コンポーネントの実装を終えると、データモデルをレンダーするための再利用可能なコンポーネントが一式揃ったということになります。これは静的なアプリですので、コンポーネントは JSX を返す以外のことはしていません。階層の一番上のコンポーネント (`FilterableProductTable`) が、データモデルをpropsとして受け取っています。データがトップレベルのコンポーネントからツリーの下の方にあるコンポーネントに流れていくため、この構造を 単方向データフロー (one-way data flow) と呼びます。

### 落とし穴

この段階では、stateの値をまだ使わないでください。それは次のステップで行います！

## ステップ 3：UIの状態を最小限かつ完全に表現する方法を見つける

UIをインタラクティブにするには、ユーザが背後にあるデータモデルを変更できるようにする必要があります。これにはstateというものを使用します。

stateとは、アプリが記憶する必要のある、変化するデータの最小限のセットのことであると考えましょう。state の構造を考える上で最も重要な原則は、DRY（Don’t Repeat Yourself; 繰り返しを避ける）です。アプリケーションが必要とする状態に関する必要最小限の表現を見つけ出し、他のすべてのものは必要になったらその場で計算します。例えば、ショッピングリストを作成する場合、商品のリストを配列型のstateとして格納できます。リスト内の商品数も表示したいという場合は、その数を別の state値として格納するのではなく、代わりに配列の`length`を読み取ればいいのです。

この例のアプリケーションで使われるデータはどのようなものか考えましょう。

1. 元となる商品のリスト
2. ユーザが入力した検索文字列
3. チェックボックスの値
4. フィルタ済みの商品のリスト

これらのうちどれがstateでしょうか？stateでないものを特定してください。

- 時間が経っても変わらないものですか？ そうであれば、stateではありません。
- 親からprops経由で渡されるものですか？ そうであれば、stateではありません。
- コンポーネント内にある既存のstateやpropsに基づいて計算可能なデータですか？ そうであれば、それは絶対に state ではありません！

残ったものがおそらく state です。

もう一度、それぞれを見ていきましょう。

1. 元の商品リストはpropsとして渡されるので、stateではありません。
2. 検索テキストは state のようです。それは時間が経つと変わりますし、何からも計算することはできません。
3. チェックボックスの値も state のようです。それは時間が経つと変わりますし、何からも計算することはできません。
4. フィルタリングされた商品のリストは、元の商品リストを検索テキストとチェックボックスの値に従ってフィルタリングすることで計算できるため、state ではありません。

つまり、検索テキストとチェックボックスの値だけがstateだということです！ よくできました！

## ステップ4：stateを保持すべき場所を特定する

アプリの最小限のstateデータを特定した後、このstateを変更する責任を持つコンポーネント、つまりstateを所有するコンポーネントを特定する必要があります。ここで思い出しましょう。Reactでは単方向データフロー、つまり親から子コンポーネントへと階層を下る形でのみデータが渡されます。どのコンポーネントがどの状態を所有すべきか、すぐには分からないかもしれません。この概念が初めてであれば難しいかもしれませんが、以下のような手順に従って解決できます！

アプリケーション内の各state について

1. そのstateに基づいて何かをレンダーするすべてのコンポーネントを特定する。
2. 階層内でそれらすべての上に位置する、最も近い共通の親コンポーネントを見つける。
3. state がどこにあるべきかを決定する。
  - 多くの場合、stateをその共通の親に直接置くことができる。
  - stateを、その共通の親のさらに上にあるコンポーネントに置くこともできる。
  - stateを所有するのに適切なコンポーネントが見つからない場合は、stateを保持するためだけの新しいコンポーネントを作成し、共通の親コンポーネントの階層の上のどこかに追加する。

前のステップで、このアプリケーションにstateが2つあることがわかりました。検索テキストとチェックボックスの値です。今回の例では、これらは常に一緒に表示されるので、同じ場所に置くことが理にかなっています。

それではこの戦術をサンプルアプリにも適用してみましょう。

1. **stateを使用するコンポーネントの特定**
ProductTable は、これらのstate（検索テキストとチェックボックスの値）に基づいて製品リストをフィルタリングする必要があります。
SearchBarは、これらのstate（検索テキストとチェックボックスの値）を表示する必要があります。
2. 共通の親を見つける： 両方のコンポーネントに共通の最初の親コンポーネントは `FilterableProductTable`です。
3. stateがどこにあるべきかを決定する： フィルタ文字列とチェック状態の値を `FilterableProductTable`に保持することにします。
したがって、stateの値は`FilterableProductTable`にあることになります。

コンポーネントにstateを追加するには、`useState()`フックを使用します。フックは、Reactに「接続 (“hook into”)」するための特殊な関数です。`FilterableProductTable`の先頭に2つ`state`変数を追加し、それらの初期値を指定します。

```
function FilterableProductTable({ products }) {
  const [filterText, setFilterText] = useState('');
  const [inStockOnly, setInStockOnly] = useState(false);
```

次に、`filterText`と`inStockOnly`を`ProductTable`と`SearchBar`にpropsとして渡します。

```
<div>
  <SearchBar
    filterText={filterText}
    inStockOnly={inStockOnly} />
  <ProductTable
    products={products}
    filterText={filterText}
    inStockOnly={inStockOnly} />
</div>
```

だんだんとアプリケーションの動作が見えてきましたね。試しに以下のサンドボックスコードで `filterText`の初期値を、`useState('')`から`useState('fruit')`へと書き換えてみてください。検索テキストとテーブルの両方が更新されることがわかります。

```
import { useState } from 'react';

function FilterableProductTable({ products }) {
  const [filterText, setFilterText] = useState('');
  const [inStockOnly, setInStockOnly] = useState(false);

  return (
    <div>
      <SearchBar
        filterText={filterText}
        inStockOnly={inStockOnly} />
      <ProductTable
        products={products}
        filterText={filterText}
        inStockOnly={inStockOnly} />
    </div>
  );
}

function ProductCategoryRow({ category }) {
  return (
    <tr>
      <th colSpan="2">
        {category}
      </th>
    </tr>
  );
}

function ProductRow({ product }) {
  const name = product.stocked ? product.name :
    <span style={{ color: 'red' }}>
      {product.name}
    </span>;

  return (
```

```
You provided a `value` prop to a form field without an `onChange` handler. This will render a read-only field. If the field should be mutable use `defaultValue`. Otherwise, set either `onChange` or `readOnly`.
You provided a `checked` prop to a form field without an `onChange` handler. This will render a read-only field. If the field should be mutable use `defaultChecked`. Otherwise, set either `onChange` or `readOnly`.
```

まだフォームの編集ができないことに気付いたでしょう。その理由について、上のサンドボックスのコンソールエラーに説明があります。

```
You provided a `value` prop to a form field without an `onChange` handler. This will render a read-only field.
```

上記のサンドボックスでは、`ProductTable`と`SearchBar`は`filterText`と`inStockOnly`というpropsを読み取り、テーブル、インプット、チェックボックスをレンダーしています。たとえば、`SearchBar`は以下のようにしてインプットの value を指定しています。

```
function SearchBar({ filterText, inStockOnly }) {
  return (
    <form>
      <input
        type="text"
        value={filterText}
        placeholder="Search..."/>
```

ただし、まだユーザからのアクション（タイピングなど）に対応するコードを何も書いていません。これが最後のステップになります。

## ステップ5：逆方向のデータフローを追加する

現在のところこのアプリでは、propsとstateが階層構造の下方向に向かって流れ、適切に表示が行われています。ただし、ユーザの入力に従ってstateを変更するには、逆方向へのデータの流れをサポートする必要があります。つまり、階層の深いところにあるフォームコンポーネントが、`FilterableProductTable`に存在するstateを更新できる必要があるわけです。

双方向データバインディングより多少タイプ量は増えますが、React ではこのデータフローを明示的に記述します。上記の例で何かタイプするか、チェックボックスをオンにしようとしても、React が入力を無視するのがわかるでしょう。これは意図的なものです。`<input value={filterText} />`と記述することで、`input`のpropsであるvalueを、`FilterableProductTable`から渡されたstate である`filterText`と常に等しくせよという意味になります。`filterText`のstateはまだ一切セットされていないため、入力値が変わることもありません。

ユーザがフォームの内容を変更するたびに、state がそれらの変更を反映して更新されるようにしたいと思います。stateは`FilterableProductTable`によって所有されているため、このコンポーネントのみが`setFilterText`と`setInStockOnly`を呼び出すことができます。`SearchBar`が `FilterableProductTable`のstateを更新できるようにするには、これらの関数を`SearchBar`に渡す必要があります。

```
function FilterableProductTable({ products }) {
  const [filterText, setFilterText] = useState('');
  const [inStockOnly, setInStockOnly] = useState(false);

  return (
    <div>
      <SearchBar
        filterText={filterText}
        inStockOnly={inStockOnly}
        onFilterTextChange={setFilterText}
        onInStockOnlyChange={setInStockOnly} />
```

`SearchBar`の中で`onChange`イベントハンドラを追加し、それらから親stateを設定します。

```
function SearchBar({
  filterText,
  inStockOnly,
  onFilterTextChange,
  onInStockOnlyChange
}) {
  return (
    <form>
      <input
        type="text"
        value={filterText}
        placeholder="Search..."
        onChange={(e) => onFilterTextChange(e.target.value)}
      />
      <label>
        <input
          type="checkbox"
          checked={inStockOnly}
          onChange={(e) => onInStockOnlyChange(e.target.checked)}
```

これでアプリは完全に動作するようになりました！

```
import { useState } from 'react';

function FilterableProductTable({ products }) {
  const [filterText, setFilterText] = useState('');
  const [inStockOnly, setInStockOnly] = useState(false);

  return (
    <div>
      <SearchBar
        filterText={filterText}
        inStockOnly={inStockOnly}
        onFilterTextChange={setFilterText}
        onInStockOnlyChange={setInStockOnly} />
      <ProductTable
        products={products}
        filterText={filterText}
        inStockOnly={inStockOnly} />
    </div>
  );
}

function ProductCategoryRow({ category }) {
  return (
    <tr>
      <th colSpan="2">
        {category}
      </th>
    </tr>
  );
}

function ProductRow({ product }) {
  const name = product.stocked ? product.name :
    <span style={{ color: 'red' }}>
      {product.name}
    </span>;

```

イベントの処理やstateの更新に関しては、インタラクティビティの追加のセクションで学ぶことができます。

## 次に向かう場所

ここまでが、Reactを使ってコンポーネントやアプリケーションを構築する際の考え方についての、非常に簡単な紹介でした。今すぐReactのプロジェクトを始めるか、あるいは本チュートリアルで使用されたすべての構文について詳しく学ぶことができます。
