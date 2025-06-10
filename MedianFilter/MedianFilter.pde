//メディアンフィルタはインタラクティブシステムでも学んだためそこまでコメントを入れていない

import java.util.Collections;

PImage img, noisyImg, filteredImg;
Button saveNoisyBtn, saveFilteredBtn;

void setup() {
    size(1500, 400);
    img = loadImage("dbd.png");
    img.resize(500, 300);
    noisyImg = addNoise(img, 50); // ノイズ強度
    filteredImg = medianFilter(noisyImg, 3); // 3x3メディアンフィルタ

    // ボタンの配置
    saveNoisyBtn = new Button(650, 350, 120, 30, "noise");
    saveFilteredBtn = new Button(1150, 350, 150, 30, "median");
}

void draw() {
    background(255);
    image(img, 0, 100);
    image(noisyImg, 500, 100);
    image(filteredImg, 1000, 100);

    fill(0);
    textSize(24);
    textAlign(CENTER, CENTER);
    text("Original", 250, 80);
    text("Noisy", 750, 80);
    text("Median Filtered", 1250, 80);

    // ボタン描画
    saveNoisyBtn.display();
    saveFilteredBtn.display();
}

void mousePressed() {
    if (saveNoisyBtn.isMouseOver()) {
        noisyImg.save("noisy.png");
    }
    if (saveFilteredBtn.isMouseOver()) {
        filteredImg.save("median.png");
    }
}

// ノイズを加える関数
PImage addNoise(PImage src, float strength) {
    PImage dst = src.copy();
    dst.loadPixels();
    for (int i = 0; i < dst.pixels.length; i++) {
        color c = dst.pixels[i];
        float r = red(c) + random(-strength, strength);
        float g = green(c) + random(-strength, strength);
        float b = blue(c) + random(-strength, strength);
        dst.pixels[i] = color(constrain(r, 0, 255), constrain(g, 0, 255), constrain(b, 0, 255));
    }
    dst.updatePixels();
    return dst;
}

// メディアンフィルタ
PImage medianFilter(PImage src, int kernelSize) {
    PImage dst = createImage(src.width, src.height, RGB);
    int k = kernelSize / 2;
    src.loadPixels();
    dst.loadPixels();
    for (int y = 0; y < src.height; y++) {
        for (int x = 0; x < src.width; x++) {
            ArrayList<Float> rList = new ArrayList<Float>();
            ArrayList<Float> gList = new ArrayList<Float>();
            ArrayList<Float> bList = new ArrayList<Float>();
            for (int dy = -k; dy <= k; dy++) {
                for (int dx = -k; dx <= k; dx++) {
                    int nx = constrain(x + dx, 0, src.width - 1);
                    int ny = constrain(y + dy, 0, src.height - 1);
                    color c = src.pixels[ny * src.width + nx];
                    rList.add(red(c));
                    gList.add(green(c));
                    bList.add(blue(c));
                }
            }
            dst.pixels[y * src.width + x] = color(median(rList), median(gList), median(bList));
        }
    }
    dst.updatePixels();
    return dst;
}

// メディアン値を求める
float median(ArrayList<Float> list) {
    Collections.sort(list);
    int n = list.size();
    if (n % 2 == 1) {
        return list.get(n/2);
    } else {
        return (list.get(n/2-1) + list.get(n/2)) / 2.0;
    }
}

// ボタンクラス
class Button {
    int x, y, w, h;
    String label;
    Button(int x, int y, int w, int h, String label) {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        this.label = label;
    }
    void display() {
        fill(isMouseOver() ? #AAAAFF : #DDDDFF);
        stroke(0);
        rect(x, y, w, h, 8);
        fill(0);
        textSize(16);
        textAlign(CENTER, CENTER);
        text(label, x + w/2, y + h/2);
    }
    boolean isMouseOver() {
        return mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h;
    }
}
