//これもただの行列計算を行うだけでラプラシアンフィルタの実装と大差ないため、コメントをあまり入れていない。
PImage srcImg, horiImg, verImg, URImg, ULImg;
float[][] hori = {
    { -1,  -1, -1 },
    { 1, 1, 1 },
    { -1,  -1, -1 }
};

float[][] ver = {
    { -1,  1, -1 },
    { -1,  1, -1 },
    { -1,  1, -1 }
};

float[][] UR ={
    {-1,-1,1},
    {-1,1,-1},
    {1,-1,-1}
};

float[][] UL ={
    {1,-1,-1},
    {-1,1,-1},
    {-1,-1,1}
};

int buttonX, buttonY, buttonW, buttonH;
int mode = 0;
String[] modeNames = {"Original", "Hori", "Ver", "UR", "UL"};

void setup() {
    size(600, 450);
    srcImg = loadImage("dbd.png");
    srcImg.resize(500, 400);
    horiImg = createImage(srcImg.width, srcImg.height, RGB);
    verImg = createImage(srcImg.width, srcImg.height, RGB);
    URImg = createImage(srcImg.width, srcImg.height, RGB);
    ULImg = createImage(srcImg.width, srcImg.height, RGB);
    applyPattern(srcImg, horiImg, hori);
    applyPattern(srcImg, verImg, ver);
    applyPattern(srcImg, URImg, UR);
    applyPattern(srcImg, ULImg, UL);

    buttonW = 160;
    buttonH = 40;
    buttonX = width - buttonW - 20;
    buttonY = height - buttonH - 20;
}

void draw() {
    background(200);
    if (mode == 0) image(srcImg, 0, 0);
    else if (mode == 1) image(horiImg, 0, 0);
    else if (mode == 2) image(verImg, 0, 0);
    else if (mode == 3) image(URImg, 0, 0);
    else if (mode == 4) image(ULImg, 0, 0);

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
            mode = (mode + 1) % 5;
        } else {
            if (mode == 0) srcImg.save("original.png");
            else if (mode == 1) horiImg.save("hori.png");
            else if (mode == 2) verImg.save("ver.png");
            else if (mode == 3) URImg.save("UR.png");
            else if (mode == 4) ULImg.save("UL.png");
        }
    }
}

void applyPattern(PImage src, PImage dst, float[][] kernel) {
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
