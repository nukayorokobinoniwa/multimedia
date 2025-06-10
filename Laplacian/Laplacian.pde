PImage srcImg, lapImg4, lapImg8;
float[][] kernel4 = {
    { 0,  1, 0 },
    { 1, -4, 1 },
    { 0,  1, 0 }
};

float[][] kernel8 = {
    { 1,  1, 1 },
    { 1, -8, 1 },
    { 1,  1, 1 }
};

int buttonX, buttonY, buttonW, buttonH;
int mode = 0; // 0:元画像, 1:4近傍, 2:8近傍
String[] modeNames = {"Original", "Laplacian 4", "Laplacian 8"};

void setup() {
    size(600, 450);
    srcImg = loadImage("dbd.png");
    srcImg.resize(500, 400);
    lapImg4 = createImage(srcImg.width, srcImg.height, RGB);
    lapImg8 = createImage(srcImg.width, srcImg.height, RGB);
    applyLaplacian(srcImg, lapImg4, kernel4);
    applyLaplacian(srcImg, lapImg8, kernel8);

    buttonW = 160;
    buttonH = 40;
    buttonX = width - buttonW - 20;
    buttonY = height - buttonH - 20;
}

void draw() {
    background(200);
    if (mode == 0) image(srcImg, 0, 0);
    else if (mode == 1) image(lapImg4, 0, 0);
    else if (mode == 2) image(lapImg8, 0, 0);

    // ボタン描画
    fill(50, 150, 255);
    rect(buttonX, buttonY, buttonW, buttonH, 10);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(18);
    text("Switch", buttonX + buttonW/2, buttonY + buttonH/2 - 10);
    text("Save", buttonX + buttonW/2, buttonY + buttonH/2 + 15);

    // 現在のモード表示
    fill(0);
    textSize(16);
    text(modeNames[mode], width/2, height - 20);
}

void mousePressed() {
    // ボタン内クリック判定
    if (mouseX > buttonX && mouseX < buttonX + buttonW &&
        mouseY > buttonY && mouseY < buttonY + buttonH) {
        // 上半分で切り替え、下半分で保存
        if (mouseY < buttonY + buttonH/2) {
            mode = (mode + 1) % 3;
        } else {
            if (mode == 0) srcImg.save("original.png");
            else if (mode == 1) lapImg4.save("laplacian4.png");
            else if (mode == 2) lapImg8.save("laplacian8.png");
        }
    }
}

void applyLaplacian(PImage src, PImage dst, float[][] kernel) {
    src.loadPixels();
    dst.loadPixels();
    for (int y = 1; y < src.height - 1; y++) {
        for (int x = 1; x < src.width - 1; x++) {
            float sum = 0;
            for (int j = -1; j <= 1; j++) {
                for (int i = -1; i <= 1; i++) {
                    color c = src.pixels[(x + i) + (y + j) * src.width];
                    float gray = brightness(c);
                    sum += gray * kernel[j + 1][i + 1];
                }
            }
            int v = constrain(int(sum + 128), 0, 255);
            dst.pixels[x + y * src.width] = color(v);
        }
    }
    dst.updatePixels();
}
