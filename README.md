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


