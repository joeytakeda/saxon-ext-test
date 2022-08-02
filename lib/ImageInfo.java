import javax.swing.ImageIcon;
public class ImageInfo {

String filename;
ImageIcon img;

public ImageInfo(String filename) {
    this.filename = filename;
    img = new ImageIcon(filename);
}

public int getWidth() {
    return img.getIconWidth();
}

public int getHeight() {
    return img.getIconHeight();
}
}