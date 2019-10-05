fource-directed-algorithm

## what
グラフネットワークを効率よく可視化するためのアルゴリズム

## how
ノード間に反発力もたせ, エッジ間にバネの力を働かせてシミュレーション.
アニーリングにより, 空気抵抗をステップごとに増加させ, 収束を早める.

## 改善点
現時点で, ノード間のクーロン力を O(n ^ 2) で計算 -> O(n log n) で計算可能なアルゴリズムが存在する.

## require
- processing
- java

## 実行結果
![スクリーンショット 2019-10-05 16 47 14](https://user-images.githubusercontent.com/47474057/66251884-44f93380-e790-11e9-9b32-1f47ef62ccaa.png)
