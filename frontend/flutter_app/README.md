# アーキテクチャ

## レイヤードアーキテクチャ構成

```bash
lib/
│
├── model/                   # データモデル（ビジネスロジック用のデータ）
├── view/                    # UI関連（ウィジェット）
│   └── common/              # 共通ウィジェット
├── viewmodel/               # ビジネスロジック（ViewModel）
├── repository/              # リポジトリ（データ取得や保存のインターフェース）
├── firebase/                # Firebase 関連の設定やサービス
└── main.dart                # エントリーポイント
```

## 各フォルダの詳細

1. model/ フォルダ

- データモデルは、アプリケーションで使用されるオブジェクトや構造体を定義する場所です。例えば、ユーザー情報やメッセージのモデルが含まれます。

2. view/ フォルダ

- UI コンポーネントを格納します。具体的には、ユーザーインターフェースの画面やウィジェットを配置します。

3. viewmodel/ フォルダ

- ビジネスロジックを担当するクラスを格納します。ここでは、ユーザーの操作や状態の管理、API からのデータ取得などを行います。

4. repository/ フォルダ

- データの取得や保存に関連するコードを格納します。Firebase などの外部サービスとやり取りするインターフェースを管理します。

5. firebase/ フォルダ

- Firebase 関連の設定やサービスコードを格納します。Firebase の初期化や API 通信設定を管理します。

6. main.dart

- アプリケーションのエントリーポイントであり、ルーティングやアプリ全体の設定を行います。
