# CramShift Scheduler

このアプリは、撮影した紙のシフト表から講師のコマ割りを読み取り、編集後に画像として出力できる iOS アプリのサンプルです。すべての処理は端末内で完結し、外部サービスは利用しません。

## ビルド方法
1. 本リポジトリをクローンし、Xcode 13 以降で `CramShiftSchedulerApp` ディレクトリを開きます。
2. `CramShiftSchedulerApp` ターゲットを選択してビルドします。iOS 15 以上のシミュレータまたは実機で実行してください。

## 使い方
1. アプリ起動後、ホーム画面から **講師管理** を開き、講師名を登録します。
2. ホーム画面に戻り、写真を撮るかライブラリから画像を選択します。OCR 処理が実行され、検出された講師がグリッドに配置されます。
3. 必要に応じて未配置リストからドラッグで移動したり、手動で名前を修正したりして調整します。曜日と備考を入力します。
4. **生成** ボタンをタップすると表形式の画像が生成され、共有シートから保存・共有できます。

## 端末内処理
- OCR には `VNRecognizeTextRequest` を利用しており、インターネット接続は不要です。
- 講師名リストは UserDefaults に保存されます。
