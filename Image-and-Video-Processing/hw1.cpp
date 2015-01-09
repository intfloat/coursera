#include <iostream>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

using namespace cv;
using namespace std;

/**
Question 1:
Write a computer program capable of reducing the number of intensity levels in an image from 256 to 2,
in integer powers of 2. The desired number of intensity levels needs to be a variable input to your program.
**/
void scaleIntensity(const Mat& image, const int scale) {
    Mat t_img = image.clone();
    for (int x = 0; x < t_img.rows; ++x) {
        for (int y = 0; y < t_img.cols; ++y) {
            t_img.at<uchar>(y, x) /= scale;
        }
    }
    imshow("Image after scale:", t_img);
    return;
}

/**
Question 2:
Using any programming language you feel comfortable with (it is though recommended to use the provided free Matlab),
load an image and then perform a simple spatial 3x3 average of image pixels.
In other words, replace the value of every pixel by the average of the values in its 3x3 neighborhood.
If the pixel is located at (0,0), this means averaging the values of the pixels
at the positions (-1,1), (0,1), (1,1), (-1,0), (0,0), (1,0), (-1,-1), (0,-1), and (1,-1).
Be careful with pixels at the image boundaries. Repeat the process for a 10x10 neighborhood and again
for a 20x20 neighborhood. Observe what happens to the image.
**/
void spatialAverage(const Mat& image, const int n) {
    Mat t_img = image.clone();
    blur(image, t_img, Size(n, n), Point(-1, -1));
    imshow("Image after blur:", t_img);
    return;
}

/**
Question 3:
Rotate the image by 45 and 90 degrees
**/
void myImageRotation(const Mat& image, const int degree) {
    Mat t_img = image.clone();
    Point center = Point(t_img.rows / 2, t_img.cols / 2);
    Mat rot_matrix = getRotationMatrix2D(center, degree, 1.0);
    warpAffine(image, t_img, rot_matrix, t_img.size());
    imshow("Image after rotation:", t_img);
    return;
}

/**
Question 4:
For every 3×3 block of the image (without overlapping), replace all corresponding 9 pixels by their average.
This operation simulates reducing the image spatial resolution. Repeat this for 5×5 blocks and 7×7 blocks.
**/
void myDownsampling(const Mat& image, const float ratio) {
    Mat t_img = image.clone();
    resize(image, t_img, Size(), ratio, ratio);
    Mat tmp;
    // make sure images before and after downsampling have same size
    resize(t_img, tmp, Size(), 1.0 / ratio, 1.0 / ratio);
    imshow("Image after downsampling:", tmp);
    return;
}

int main( int argc, char** argv ) {

    Mat image;
    image = imread("lena.png", 0); // Read the file

    if(!image.data ) // Check for invalid input
    {
        cout << "Could not open or find the image" << endl;
        return -1;
    }

    // namedWindow( "Display window", WINDOW_AUTOSIZE ); // Create a window for display.
    imshow( "Original Image", image ); // Show our image inside it.

    // waitKey(0); // Wait for a keystroke in the window

    // test intensity scale
    // scaleIntensity(image, 4);

    // test spatial average
    // spatialAverage(image, 8);

    // test myRotationImage
    // myImageRotation(image, 90);

    // test myDownsampling
    myDownsampling(image, 0.5);

    waitKey(0);
    return 0;
}
