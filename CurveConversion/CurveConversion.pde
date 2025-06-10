PImage img, imgCurve;//imgは元の画像、imgCurveはガンマ補正後の画像
float btnX, btnY, btnW = 120, btnH = 40;

void setup() {
    size(1400, 900);
    img = loadImage("dbd.png");//今回自分が使用した画像は2560×1600のpngである。ほかのサイズでも大丈夫だが、サイズに違和感を覚えるかもしれない。
    img.resize(width/2, height/2);
    imgCurve = createImage(img.width, img.height, RGB);

    // ボタンを適当な位置に配置
    btnX = 700;
    btnY = 700;

    applyCurveConversion();
}

void draw() {
    background(220);
    image(imgCurve, 50, 50);

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

    
    if (mouseX > btnX && mouseX < btnX + btnW && mouseY > btnY && mouseY < btnY + btnH) {
        imgCurve.save("curveConversion.png");
    }
}

void mouseDragged() {

}

void mouseReleased() {
    
}

void applyCurveConversion() {
    imgCurve.loadPixels();
    for(int i = 0; i < img.pixels.length; i++) {
            color c = img.pixels[i];
            float r = red(c);
            float g = green(c);
            float b = blue(c);
            /*講義資料で使用した式の場合
            r = (-1*(r -128)*(r-128)/64.0+255.0)-1.0;
            g = (-1*(g -128)*(g-128)/64.0+255.0)-1.0;
            b = (-1*(b -128)*(b-128)/64.0+255.0)-1.0;
            */

            //ここで今回は3乗を用いて色の変換を行う。
            r = (-1*(r -128)*(r-128)*(r-128)/16384.0+128.0)-1.0;
            g = (-1*(g -128)*(g-128)*(g-128)/16384.0+128.0)-1.0;
            b = (-1*(b -128)*(b-128)*(b-128)/16384.0+128.0)-1.0;

            imgCurve.pixels[i] = color(r, g, b);
        
    }
}

