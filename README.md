# Robust-Forms-Processing

An attempt was made to make the entire process that is fully automatic, that is to say, the same code should work well on all the input images without requiring any per-image parameter tuning. Though, it is not completely possible, though it was observed that the same parameters would work good for the images of the same object and of the same type (Scanned or color image etc), apart from the cases of some images would be very far away from the median of the class they are present in. In those cases, manual tuning of parameters would be required. The images processed by this entire algorithm are of the following types:

  1. Scanned
  2. Photos of printed-out forms
  3. Photos of forms in booklets
  
## Alignment

Automatically detect the orientation of the form, and rotate the image to straighten it. In general, the algorithm which was used is given as:

  * First of all, we separate the three RGB layers of the images and obtain their Fourier transforms using fft2.
  * Then these complex ffts are converted into spatial domain and their spectrum is obtained
  * Then from the Spectrum, Canny edge detection is used and the different edges are obtained from it using Hough Transforms
  * Here, we use the parameters that any two edges separated by less than 10 pixels will be merged into one and will thus be considered as one edge.
  * Then, from these edges, the one with the longest length is chosen and it’s inclination is obtained
  * From this, the inclination correction is obtained using some basic coordinate geometry
  * This procedure is carried out for all the three different fft layers
  * Since in the cases of the Booklet images, which are very colorful and thus have a broad independent spectrum of the RGB values as compared to the scanned images, so we use the minimum amount of correction of those three values. Note that, this is highly insignificant for all the other cases except for the Booklet images, since these images are pretty much grey in nature and thus all the three different layers exhibit very similar properties.
  * Then, having obtained this correction, it is used to rotate the original image in the spatial domain
  * Here, we observe that for all the cases, the algorithm works completely automatically and requires no extra manual tuning and it gives very good results for all these cases.
  * From the given photos for the different cases below, it can be seen that the inclination obtained in the final output image is as expected
    
Some failed approaches are given below:

  1. First of all, we tried to rotate each component of the input image by the exact amount of inclination that was found for the different fft components. But the issue with that was having very different angles of inclination of the different image components. This was not an issue with the scanned images and printed images though because of their near to gray scale spectrum, and so all the three components showed the exact same behaviors. So, to combat this issue, we used the same angle for all the three color components by taking a minima of them.
  2. Initially we were rotating the images even towards the vertical direction if the inclination with horizontal would be too much. But, that was making it harder to compare the two images and compare the results in different cases because there were only two such images having such a large inclination. So, we gave the priority to the Horizontal inclination and inclined the images towards that direction only i.e. the longest dimension of the rectangular boxes should be horizontal.
  3. Also, as seen in the output images, in order to preserve the dimensions after rotation, some information is lost and it’s seen as dark patches in the corners. We tried to remove this issue by applying this rotation in the Fourier transform in the complex plane. But we were unable to do this because of the limitations of the inbuilt functions of MATLAB and also rotating each entries of that complex matrix by that amount wouldn’t make sense because even their magnitudes have to be changed for this rotation, else it would give the same answer as the input after scaling to absolute value etc. So, because of this issue, we had to apply the rotation in the spatial domain itself.
  4. Also, we had to fine tune the parameter values given to the inbuilt functions to have a consistency of the parameters for all the images
  
## Form Field Segmentation

The general algorithmic approach to segment out the form fields is given below:

  1. First of all, I read the image and rotate it as per the alignment code given right in above part.
  2. Then there may be many illumination variations across the image which would distort the thresholding. Therefore what I did is to find out the illumination distribution and divide the image by it to get a uniform illumination image
  3. Then I convert that image into gray-scale and then binarize it as per a thresholding value found by applying locally adaptive thresholding (the statistical method found most suitable was ‘mean’)
  4. Then, its 8 connected components are obtained and it’s regionprops are calculated and labelled. This regionprops is stored in a table and from this, all the information of the components like their centroids, areas etc. can be obtained
  5. Then, from the image, a pattern was observed that in the bottom left region, the eccentricities of the non-field regions are very high. So, we remove some highest eccentricity components from the image.
  6. Then, a similar procedure is carried out on the image obtained above, but with a change that we take some highest area components in the output image.
  7. In the final image, the number of 8-connected components left were very less.
   
## Character Detection

Some of the fields would have characters written in them, while others do not. Here the task is to find a way to isolate these characters and label them as distinct connected components. The general algorithmic approach for this is given below

  1. There may be many illumination variations across the image which would distort the thresholding. Therefore what we do is find out the illumination distribution and divide the image by it to get a uniform illumination image.
  2. Then we use Otsu’s method to threshold the image and get a binary image. We then take the complement of the image so that low intensity parts of the image such as the characters become white and others become black.
  3. Then we use regionprops to identify the 8 connected components. Then we display only those bounding boxes which have appropriate size and area. We are not able to segment characters that are connected to the field boxes. That is why we do some dilation and erosion to negate this effect.
  4. Then I use the form field segmentation technique above to keep only those bounding boxes that have at least 3 white pixels in the field segmented image.
  5. Since the zoom of every image is different we had to use different parameters for different images.
  6. For the printed images and scanned images I also had to align them using our alignment function made in part 1 of the assignment and also had to crop the images to suitable size so that we get effective segmentation.

## Seperating special characters from the alpha-numeric ones

The form fields might also include some special characters as well (Like pre-printed slashes for the dates to be entered) and they show up in the character segmentation as well. So, the job of this part is to automatically remove them. The below method is described for the slashes which are the most common special characters in forms. But similar methods can also be developed for other special characters

  1. Firstly I use the same steps of uniformize illumination, thresholding, dilation, erosion and identifying the 8 connected components using regionprops as written in above part
  2. What I noticed was that the slashes were at about a third and two thirds from the edge of a form field box in all the types of images (For the DD/MM/YYY format)
  3. Now I used the form field segmentation algorithm of the the second part to find out the length and the position of the form fields.
  4. Then I removed those connected components that were at about one thirds and two thirds distance from the left edge of the form field box within a threshold of about 3 pixels.
  5. This ensured that we did not get slashes but the downside was that sometimes when some character was too close to the slash, it was also being removed
  
A failed approach in this case was that, Knowing that bounding boxes containing slashes have very small area, it was tried to put a lower bound on the area of the bounding boxes which did work but it also led to the bounding boxes of ‘1’ disappearing and thus some other approach was required
