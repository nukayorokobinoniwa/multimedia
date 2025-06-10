PImage img, imgGamma;//imgは元の画像、imgGammaはガンマ補正後の画像
float gammaR = 1.0, gammaG = 1.0, gammaB = 1.0, gammaAll = 1.0;
float[] sliderX = new float[4], sliderY = new float[4], sliderW = new float[4], sliderH = new float[4];
boolean[] dragging = new boolean[4];
color[] sliderColor = {#FF6666, #66FF66, #6699FF, #AAAAAA}; // R, G, B, All

float btnX, btnY, btnW = 120, btnH = 40;

void setup() {
    size(1400, 900);
    img = loadImage("dbd.png");//今回自分が使用した画像は2560×1600のpngである。ほかのサイズでも大丈夫だが、サイズに違和感を覚えるかもしれない。
    img.resize(width/2, height/2);
    imgGamma = createImage(img.width, img.height, RGB);

    for (int i = 0; i < 4; i++) {
        sliderW[i] = img.width * 0.8;
        sliderH[i] = 20;
        sliderX[i] = 50;
        sliderY[i] = 50 + img.height + 40 + i * 50;
    }

    btnX = sliderX[0] + sliderW[0] + 40;
    btnY = sliderY[3];

    applyGamma();
}

void draw() {
    background(220);
    image(imgGamma, 50, 50);

    float[] gammas = {gammaR, gammaG, gammaB, gammaAll};
    String[] labels = {"Gamma R", "Gamma G", "Gamma B", "Gamma ALL"};
    for (int i = 0; i < 4; i++) {
        fill(200);
        rect(sliderX[i], sliderY[i], sliderW[i], sliderH[i], 10);
        float knobX = map(gammas[i], 0.2, 3.0, sliderX[i], sliderX[i] + sliderW[i]);
        fill(sliderColor[i]);
        ellipse(knobX, sliderY[i] + sliderH[i]/2, sliderH[i], sliderH[i]);

        fill(0);
        textSize(16);
        text(labels[i] + ": " + nf(gammas[i], 1, 2), sliderX[i], sliderY[i] - 10);
    }
    // ボタンを押したら実際にγ補正を行った画像が出力されるようにした。
    fill(100, 180, 255);
    rect(btnX, btnY, btnW, btnH, 10);
    fill(0);
    textSize(18);
    textAlign(CENTER, CENTER);
    text("Output", btnX + btnW/2, btnY + btnH/2);
    textAlign(LEFT, BASELINE);
}

void mousePressed() {
    float[] gammas = {gammaR, gammaG, gammaB, gammaAll};
    for (int i = 0; i < 4; i++) {
        float knobX = map(gammas[i], 0.2, 3.0, sliderX[i], sliderX[i] + sliderW[i]);
        if (dist(mouseX, mouseY, knobX, sliderY[i] + sliderH[i]/2) < sliderH[i]) {
            dragging[i] = true;
        }
    }
    
    if (mouseX > btnX && mouseX < btnX + btnW && mouseY > btnY && mouseY < btnY + btnH) {
        imgGamma.save("gamma.png");
    }
}

void mouseDragged() {
    for (int i = 0; i < 4; i++) {
        if (dragging[i]) {
            float mx = constrain(mouseX, sliderX[i], sliderX[i] + sliderW[i]);
            float val = map(mx, sliderX[i], sliderX[i] + sliderW[i], 0.2, 3.0);
            if (i == 0) gammaR = val;
            if (i == 1) gammaG = val;
            if (i == 2) gammaB = val;
            if (i == 3) {
                gammaAll = val;
                gammaR = gammaG = gammaB = gammaAll;
            }
            applyGamma();
        }
    }
}

void mouseReleased() {
    for (int i = 0; i < 4; i++) dragging[i] = false;
}

void applyGamma() {
    imgGamma.loadPixels();
    img.loadPixels();
    for (int i = 0; i < img.pixels.length; i++) {
        color c = img.pixels[i];
        //ここでガンマ補正を行っている。なお講義資料に書いてあったg=255.0 * (f/255.0)^(1/gamma)という式(ただしfは元画像の画素値,gは変換画像の画素値,γはスライダーで変更した補正係数j)をもとに作成した。
        float r = pow(red(c)/255.0, gammaR) * 255;
        float g = pow(green(c)/255.0, gammaG) * 255;
        float b = pow(blue(c)/255.0, gammaB) * 255;
        imgGamma.pixels[i] = color(r, g, b);
    }
    imgGamma.updatePixels();
}
