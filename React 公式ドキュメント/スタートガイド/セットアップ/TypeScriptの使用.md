# TypeScript の使用

TypeScriptはJavaScriptコードベースに型定義を追加するための人気の方法です。TypeScriptは標準でJSXをサポートしており、プロジェクトに`@types/react`と`@types/react-dom`を追加することで、React Webに対する完全なサポートを得ることができます。

### このページで学ぶこと

- TypeScriptでReactコンポーネントを書く方法
- フックの型付けの例
- @types/react にある一般的な型
- さらに学習するためのリソース

## インストール

すべての本番環境向け React フレームワークは TypeScript の使用をサポートしています。フレームワーク個別のガイドに従ってインストールを行ってください。


## 既存のReactプロジェクトにTypeScriptを追加する

Reactの型定義の最新バージョンをインストールするには以下のようにします。

```
npm install @types/react @types/react-dom
```

`tsconfig.json`で以下のコンパイラオプションを設定する必要があります。

1. `lib`にdomが含まれていなければなりません（注：`lib`オプションが指定されない場合、`dom`はデフォルトで含まれます）。
2. `jsx`を有効なオプションのいずれかに設定する必要があります。ほとんどのアプリケーションでは`preserve`で上手くいきます。ライブラリを公開する場合は、選択すべき値について`jsx`のドキュメンテーションを参照してください。

## TypeScriptでReactコンポーネントを書く方法

### 補足

JSXを含むファイルはすべて`.tsx`というファイル拡張子を使用しなければなりません。これはTypeScript固有の拡張子であり、ファイルにJSXが含まれていることを TypeScriptに伝えるためのものです。

TypeScriptでReactを書くことは、JavaScriptでReactを書くことに非常に似ています。コンポーネントを扱う際の主な違いは、コンポーネントのpropsに対して型が指定できることです。これらの型は、正確性チェックと、エディタ内でのインラインドキュメンテーションの表示に使用できます。

クイックスタートガイドの MyButton コンポーネントを例にすると、ボタンの title に型を追加する方法は以下のようになります。

```
function MyButton({ title }: { title: string }) {
  return (
    <button>{title}</button>
  );
}

export default function MyApp() {
  return (
    <div>
      <h1>Welcome to my app</h1>
      <MyButton title="I'm a button" />
    </div>
  );
}
```

### 補足

上記のサンドボックスは TypeScript のコードを扱うことができますが、型チェッカは実行されません。つまりこの TypeScriptサンドボックスを書き換えて学習することはできますが、型エラーや警告は得られないということです。型チェックが必要な場合は、TypeScript Playgroundを使用するか、より完全な機能を備えたオンラインサンドボックスを使用してください。

このインライン形式の構文は、コンポーネントに対して型を指定する最も簡単な方法ですが、記述するフィールドが複数あるときには扱いにくくなることがあります。代わりに、コンポーネントのpropsを記述するために`interface`または`type`を使用することができます。

```
interface MyButtonProps {
  /** The text to display inside the button */
  title: string;
  /** Whether the button can be interacted with */
  disabled: boolean;
}

function MyButton({ title, disabled }: MyButtonProps) {
  return (
    <button disabled={disabled}>{title}</button>
  );
}

export default function MyApp() {
  return (
    <div>
      <h1>Welcome to my app</h1>
      <MyButton title="I'm a disabled button" disabled={true}/>
    </div>
  );
}
```

コンポーネントのpropsを記述する型は、必要に応じて単純なものでも複雑なものでも構いませんが、`type`または `interface`で記述されたオブジェクト型であるべきです。TypeScriptでのオブジェクトの記述方法についてはオブジェクト型で学ぶことができます。いくつかの異なる型のうちの1つの型になるpropsを記述するためのユニオン型や、より高度な使用例であるCreating Types from Typesガイドも参照してください。

## 例：フック

`@types/react`にある型定義には、組み込みのフックに対する型が含まれており、追加のセットアップなしにあなたのコンポーネント内で使用することができます。これらはあなたがコンポーネントに書くコードを考慮できるように作られており、多くの場合は型の推論が働くため、理想的にはこまごまと型の指定を行う必要がないようになっています。

とはいえ、フックの型をどのように指定するかについて、ここでいくつかの例を見ておきましょう。

## useState

useState フックは、初期stateとして渡された値を利用して、その値の型が何であるべきかを決定します。例えば、

```
// Infer the type as "boolean"
const [enabled, setEnabled] = useState(false);
```

これで`enabled`に`boolean`型が割り当てられ、また`setEnabled`は引数として`boolean`値または`boolean`を返す関数を受け取る関数になります。state の型を明示的に指定したい場合は、useState の呼び出しに型引数を渡すことで行えます。

```
// Explicitly set the type to "boolean"
const [enabled, setEnabled] = useState<boolean>(false);
```

上記の例ではあまりこうする意義はありませんが、明示的に型を指定したい一般的なケースとして、ユニオン型を持たせたい場合があります。例えば、以下では status はいくつかの異なる文字列のいずれかになります。

```
type Status = "idle" | "loading" | "success" | "error";

const [status, setStatus] = useState<Status>("idle");
```

または、stateの構造化の原則で推奨されているように、関連する state をオブジェクトとしてグループ化し、オブジェクト型を介して可能性のある状態を記述することができます。

```
type RequestState =
  | { status: 'idle' }
  | { status: 'loading' }
  | { status: 'success', data: any }
  | { status: 'error', error: Error };

const [requestState, setRequestState] = useState<RequestState>({ status: 'idle' });
```

## `useReducer`

`useReducer`フック は、リデューサ関数と初期stateを受け取る、より複雑なフックです。リデューサ関数の型は初期stateから推論されます。`useReducer`の呼び出しに型引数を含めることでstateの型を指定することもできますが、通常は代わりに初期state自体に型を指定する方が良いでしょう。

```
import {useReducer} from 'react';

interface State {
   count: number
};

type CounterAction =
  | { type: "reset" }
  | { type: "setCount"; value: State["count"] }

const initialState: State = { count: 0 };

function stateReducer(state: State, action: CounterAction): State {
  switch (action.type) {
    case "reset":
      return initialState;
    case "setCount":
      return { ...state, count: action.value };
    default:
      throw new Error("Unknown action");
  }
}

export default function App() {
  const [state, dispatch] = useReducer(stateReducer, initialState);

  const addFive = () => dispatch({ type: "setCount", value: state.count + 5 });
  const reset = () => dispatch({ type: "reset" });

  return (
    <div>
      <h1>Welcome to my counter</h1>

      <p>Count: {state.count}</p>
      <button onClick={addFive}>Add 5</button>
      <button onClick={reset}>Reset</button>
    </div>
  );
}
```

ここではいくつかの重要な場所でTypeScriptが使用されています。

- `interface State`でリデューサのstateの型を指定する。
- `type CounterAction`でリデューサにディスパッチできる各種のアクションを記述する。
- `const initialState`: `State`で初期stateの型、およびデフォルトで`useReducer`によって使用される型を指定する。
- `stateReducer(state: State, action: CounterAction): State`でリデューサ関数の引数と返り値の型を指定する。

`initialState`に型を指定するよりも明示的な代替手段として、`useReducer`に型引数を渡すこともできます。

```
import { stateReducer, State } from './your-reducer-implementation';

const initialState = { count: 0 };

export default function App() {
  const [state, dispatch] = useReducer<State>(stateReducer, initialState);
}
```

## `useContext`

`useContext`フックは、propsを使って多数のコンポーネントを経由させることなく、コンポーネントツリーを通じてデータを下に渡すための技術です。使用するにはプロバイダコンポーネントを作成し、多くの場合は子コンポーネントで値を受け取るためのフックを用います。

コンテクストが提供する値の型は、`createContext`の呼び出しに渡す値から推論されます。

```
import { createContext, useContext, useState } from 'react';

type Theme = "light" | "dark" | "system";
const ThemeContext = createContext<Theme>("system");

const useGetTheme = () => useContext(ThemeContext);

export default function MyApp() {
  const [theme, setTheme] = useState<Theme>('light');

  return (
    <ThemeContext value={theme}>
      <MyComponent />
    </ThemeContext>
  )
}

function MyComponent() {
  const theme = useGetTheme();

  return (
    <div>
      <p>Current theme: {theme}</p>
    </div>
  )
}
```

意味のあるデフォルト値が存在する場合にはこれでうまくいきます。しかし時にはそうではない場合もあり、デフォルト値として`null`が適切に感じられることもあるでしょう。型システムにあなたのコードを理解させるため、`createContext`呼び出しで`ContextShape | null` と明示的に指定する必要があります。

これにより、コンテクストを利用する側で`| null`の可能性を排除する必要が生じます。お勧めの方法は、値が存在することをフックで実行時にチェックし、存在しない場合にエラーをスローするようにすることです。

```
import { createContext, useContext, useState, useMemo } from 'react';

// This is a simpler example, but you can imagine a more complex object here
type ComplexObject = {
  kind: string
};

// The context is created with `| null` in the type, to accurately reflect the default value.
const Context = createContext<ComplexObject | null>(null);

// The `| null` will be removed via the check in the Hook.
const useGetComplexObject = () => {
  const object = useContext(Context);
  if (!object) { throw new Error("useGetComplexObject must be used within a Provider") }
  return object;
}

export default function MyApp() {
  const object = useMemo(() => ({ kind: "complex" }), []);

  return (
    <Context value={object}>
      <MyComponent />
    </Context>
  )
}

function MyComponent() {
  const object = useGetComplexObject();

  return (
    <div>
      <p>Current object: {object.kind}</p>
    </div>
  )
}
```

## `useMemo`

### 補足

React Compilerは値や関数の自動的なメモ化を行うことで、手作業による`useMemo`呼び出しの必要性を軽減します。自動でメモ化を行うためにコンパイラを使用可能です。

`useMemo`フックは、関数呼び出しからの値の作成/再アクセスを行い、2番目の引数として渡された依存配列が変更されたときにのみ関数を再実行します。フックの呼び出し結果の型は、1番目の引数として指定した関数の返り値の型から推論されます。フックに型引数を指定することで明示的にすることができます。

```
// The type of visibleTodos is inferred from the return value of filterTodos
const visibleTodos = useMemo(() => filterTodos(todos, tab), [todos, tab]);
```

## `useCallback`

### 補足

React Compilerは値や関数の自動的なメモ化を行うことで、手作業による`useCallback`呼び出しの必要性を軽減します。自動でメモ化を行うためにコンパイラを使用可能です。

useCallbackは、第2引数に渡される依存配列が同じである限り、関数への安定した参照を提供するものです。`useMemo`と同様に、関数の型は1番目の引数として指定した関数から推論され、フックに型引数を指定することでより明示的にすることができます。

```
const handleClick = useCallback(() => {
  // ...
}, [todos]);
```

TypeScriptのstrictモードで作業している場合、useCallbackではコールバックの引数に型を追加する必要があります。これは、コールバックの型が関数から推論されるため、引数がないと型を完全に決定できないからです。

好みのコードスタイルによっては、Reactが提供する`*EventHandler`関数型を使用して、コールバックを定義しながらイベントハンドラの型を提供することができます。

```
import { useState, useCallback } from 'react';

export default function Form() {
  const [value, setValue] = useState("Change me");

  const handleChange = useCallback<React.ChangeEventHandler<HTMLInputElement>>((event) => {
    setValue(event.currentTarget.value);
  }, [setValue])

  return (
    <>
      <input value={value} onChange={handleChange} />
      <p>Value: {value}</p>
    </>
  );
}
```

## 便利な型

`@types/react`パッケージには非常に様々な型が存在しており、React と TypeScript の扱いに慣れたら目を通す価値があります。これらは DefinitelyTyped 内の React のフォルダで見ることができます。ここでは一般的な型をいくつか紹介します。

## DOMイベント
ReactでDOMイベントを扱うとき、イベントの型はイベントハンドラから推論できることもあります。しかし、イベントハンドラに渡すための関数を抽出して別に定義したい場合は、イベントの型を明示的に設定する必要があります。

```
import { useState } from 'react';

export default function Form() {
  const [value, setValue] = useState("Change me");

  function handleChange(event: React.ChangeEvent<HTMLInputElement>) {
    setValue(event.currentTarget.value);
  }

  return (
    <>
      <input value={value} onChange={handleChange} />
      <p>Value: {value}</p>
    </>
  );
}
```

React型定義には多くの種類のイベントが提供されています。完全なリストはこちらにあり、DOMで最も使われるイベントに基づいています。

必要なイベント型を見つけたい場合は、まず使用しているイベントハンドラのホバー情報を見てみると、イベントの型が表示されます。

このリストに含まれていないイベントを使用する必要がある場合は、すべてのイベントの基本型である`React.SyntheticEvent`型を使用することができます。

## 子要素

コンポーネントの子要素を型として記述する一般的な方法は2つあります。1つ目は React.ReactNode 型を使用する方法であり、これは JSX で子要素として渡すことが可能なすべての型のユニオン型です。

```
interface ModalRendererProps {
  title: string;
  children: React.ReactNode;
}
```

これは子要素の非常に包括的な定義です。2つ目は`React.ReactElement`型を使用する方法です。こちらは JSX要素のみを指し、文字列や数値のようなJavaScriptのプリミティブは含まれません。

```
interface ModalRendererProps {
  title: string;
  children: React.ReactElement;
}
```

子要素が特定の JSX 要素の型であることをTypeScriptで記述することはできないことに注意してください。子要素として `<li>`のみを受け入れるコンポーネントを型システムで記述することはできません。

こちらのTypeScriptプレイグラウンドで、`React.ReactNode`と`React.ReactElement`の両方の例を型チェッカ付きで確認することができます。

## スタイルprops

Reactでインラインスタイルを使用する際には、styleプロパティに渡されるオブジェクト型を記述するために`React.CSSProperties`を使用することができます。この型は可能なCSSプロパティすべてのユニオンであり、有効なCSSプロパティを propsとして`style`に渡していることを保証し、エディタで自動補完を得るための良い方法です。

```
interface MyComponentProps {
  style: React.CSSProperties;
}
```

## さらに学ぶ

このガイドではReactでTypeScriptを使用するための基本的な方法を紹介しましたが、まだ学ぶべきことはたくさんあります。
ドキュメントの個々のAPIページには、TypeScriptとともに使用する方法についてのより詳細な説明がある場合があります。

以下のリソースがお勧めです。

- The TypeScript handbookはTypeScript の公式ドキュメントであり、ほとんどの主要な言語機能をカバーしています。

- TypeScript のリリースノートでは新機能が詳細に解説されています。

- React TypeScript Cheatsheetはコミュニティによってメンテナンスされている、ReactでTypeScriptを使用するためのチートシートです。多くの有用なエッジケースをカバーしており、このドキュメントよりも広範な解説が得られます。

- TypeScriptコミュニティDiscordは、TypeScriptとReactの問題について質問したり、助けを得たりするための素晴らしい場所です。
