final int N = 77;  // ネットワークのノード数
final int M = 254; // ねっとわーくのリンク数

float[] x = new float[N];    // 頂点の座標
float[] y = new float[N];    // 頂点の座標
float[] vx = new float[N];   // 頂点の速さ
float[] vy = new float[N];   // 頂点の速さ
int[] degree = new int[N]; // 頂点の次数

final float r = 20;              // ノードの半径的なパラメータ
final float minDistance = 10;    // 距離の閾値
float alpha = 1;                 // sa に使うハイパーパラメータ
final float decay = 0.999;       // これが小さければ小さいほど, 収束は早くなる (が, 可視化の完成度は落ちる)


/**  以下, レ・ミゼラブルの情報  **/
String name[];     
String source[];
String target[];
String group[];
String weight[];

void setup() {
  size(1200, 1200);
  readFile();
  initGraph();
}

void draw() {
  drawGraph();
  updatePosition();
  updateVelocity();
}


// txt ファイルから レ・ミゼラブルの情報を取得
void readFile() {
  name = loadStrings("name.txt");
  source = loadStrings("source.txt");
  target = loadStrings("target.txt");
  group = loadStrings("group.txt");
  weight = loadStrings("weight.txt");
}

// グラフの初期化
void initGraph() {

  // 次数を計算
  for(int i = 0; i < M; i++) {
    int u = int(source[i]);
    int v = int(target[i]);
    degree[u]++;
    degree[v]++;
  }

  // 頂点の初期位置を設定
  for (int i = 0; i < N; i++) {
    x[i] = random(width);
    y[i] = random(height);
  }
}

// Graph の描画
void drawGraph() {
  colorMode(RGB, 255, 255, 255);
  background(255);
  for (int i = 0; i < source.length; i++) {  // 辺の描画
    int u = int(source[i]);
    int v = int(target[i]);
    strokeWeight(int(weight[i]) / 5.0);    // 重みに応じて辺の太さを変更
    line(x[u], y[u], x[v], y[v]);
  }
  for (int i = 0; i < N; i++) {  // 頂点の描画
    colorMode(HSB, 360, 100, 100);
    fill(int(group[i]) * 36, 100, 100,128);
    ellipse(x[i], y[i], degree[i] + r, degree[i] + r);  // 次数に応じて頂点の大きさを変更
    colorMode(RGB, 255, 255, 255);
    fill(0);
    textSize(10);
    textAlign(CENTER, CENTER);
    text(name[i], x[i], y[i]);   // 人の名前を表示
  }
}

// 頂点の座標を更新
void updatePosition() {
  for (int i = 0; i < N; i++) {
    x[i] += vx[i];
    y[i] += vy[i];
  }
}

// 頂点の速度を更新
void updateVelocity() {
  applySpringForce(0.001, 10);
  applyRepulsiveForce(10);
  applyResistanceForce(1 - alpha);
  applyCentering();
  alpha *= decay;
}

// バネによる力を適用
// L := バネの自然長, k := バネ定数
void applySpringForce(float k, float L) {
  for (int i = 0; i < source.length; i++) {
    int u = int(source[i]);
    int v = int(target[i]);
    float d = distance(u, v);
    float theta = atan2(y[u] - y[v], x[u] - x[v]);
    float w = k * (int(weight[i]) - d);      // フックの法則より
    vx[u] += w * cos(theta);
    vy[u] += w * sin(theta);
    vx[v] -= w * cos(theta);
    vy[v] -= w * sin(theta);
  }
}

// 空気抵抗
// アニーリングにより, 徐々に空気抵抗を増やしていく
void applyResistanceForce(float k) {
  for (int i = 0; i < N; i++) {
    vx[i] += -k * vx[i];
    vy[i] += -k * vy[i];
  }
}

// クーロン力を適用
// q := クーロン
void applyRepulsiveForce(float q) {
  for (int i = 0; i < N; i++) {
    for (int j = 0; j < N; j++) {
      if (i == j) {
        continue;
      }
      float d = distance(i, j);
      float w = -q / (d * d);  // クーロンの法則より
      vx[i] += (x[j] - x[i]) * w;
      vy[i] += (y[j] - y[i]) * w;
    }
  }
}

// 中心に引き寄せる
void applyCentering() {
  float cx = 0;
  float cy = 0;
  for (int i = 0; i < N; i++) {
    cx += x[i];
    cy += y[i];
  }
  cx /= N;
  cy /= N;
  for (int i = 0; i < N; i++) {
    x[i] += -cx + width / 2;
    y[i] += -cy + height / 2;
  }
}

float distance(int i, int j) {
  float d = dist(x[i], y[i], x[j], y[j]);
  if (d < minDistance) {
    d = minDistance;
  }
  return d * 2.5;
}
