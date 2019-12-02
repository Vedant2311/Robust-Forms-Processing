clear all
img = imread('booklet_12.jpg');
size(img)


% 10,11,12,13,14,

%figure,imshow(img);

A1 = fft2(img(:,:,1));
A2 = fft2(img(:,:,2));
A3 = fft2(img(:,:,3));


A1 = fftshift(A1);
A2 = fftshift(A2);
A3 = fftshift(A3);

Ab1 = abs(A1);
Ab2 = abs(A2);
Ab3 = abs(A3);

Ab1 = (Ab1 - ((min(min(Ab1)))))./((max(max(Ab1)))).*255;
Ab2 = (Ab2 - ((min(min(Ab2)))))./((max(max(Ab2)))).*255;
Ab3 = (Ab3 - ((min(min(Ab3)))))./((max(max(Ab3)))).*255;

Ab(:,:,1) = Ab1;
Ab(:,:,2) = Ab2;
Ab(:,:,3) = Ab3;

%figure,imshow(Ab), hold on;


BW1 = edge(Ab1,'Canny');
BW2 = edge(Ab2,'Canny');
BW3 = edge(Ab3,'Canny');

Rot1 = [];
Rot2 = [];
Rot3 = [];


[H1,T1,R1] = hough(BW1);

P1  = houghpeaks(H1,5,'threshold',ceil(0.3*max(H1(:))));

lines1 = houghlines(BW1,T1,R1,P1,'FillGap',10,'MinLength',7);

max_len1 = 0;

for k = 1:length(lines1)
    
   xy = [lines1(k).point1; lines1(k).point2];
   len = norm(lines1(k).point1 - lines1(k).point2);
   
   rot1 = rad2deg(atan(-((xy(2,2) - xy(1,2))/(xy(2,1) - xy(1,1)))));
   Rot1 = [Rot1;rot1];
   if ( len > max_len1)
       
      max_len1 = len;
      xy_long1 = xy;
      
   end
end


[H2,T2,R2] = hough(BW2);

P2  = houghpeaks(H2,5,'threshold',ceil(0.3*max(H2(:))));

lines2 = houghlines(BW2,T2,R2,P2,'FillGap',10,'MinLength',7);

max_len2 = 0;

for k = 1:length(lines2)
    
   xy = [lines2(k).point1; lines2(k).point2];
   len = norm(lines2(k).point1 - lines2(k).point2);
      rot2 = rad2deg(atan(-((xy(2,2) - xy(1,2))/(xy(2,1) - xy(1,1)))));
   Rot2 = [Rot2;rot2];

   if ( len > max_len2)
       
      max_len2 = len;
      xy_long2 = xy;
      
   end
end


[H3,T3,R3] = hough(BW3);

P3  = houghpeaks(H3,5,'threshold',ceil(0.3*max(H3(:))));

lines3 = houghlines(BW3,T3,R3,P3,'FillGap',10,'MinLength',7);

max_len3 = 0;

for k = 1:length(lines3)
    
   xy = [lines3(k).point1; lines3(k).point2];
   len = norm(lines3(k).point1 - lines3(k).point2);
      rot3 = rad2deg(atan(-((xy(2,2) - xy(1,2))/(xy(2,1) - xy(1,1)))));
   Rot3 = [Rot3;rot3];

   if (len > max_len3)
       
      max_len3 = len;
      xy_long3 = xy;
      
   end
end

rot1 = rad2deg(atan(-((xy_long1(2,2) - xy_long1(1,2))/(xy_long1(2,1) - xy_long1(1,1)))));
rot2 = rad2deg(atan(-((xy_long2(2,2) - xy_long2(1,2))/(xy_long2(2,1) - xy_long2(1,1)))));
rot3 = rad2deg(atan(-((xy_long3(2,2) - xy_long3(1,2))/(xy_long3(2,1) - xy_long3(1,1)))));


if (rot1>0)
    counterClock = 1;
    
    rot1 = 90 - rot1;
    rot2 = 90 - rot2;
    rot3 = 90 - rot3;
    
else 
    counterClock = -1;
    
    rot1 = 90 + rot1;
    rot2 = 90 + rot2;
    rot3 = 90 + rot3;
    
    
end

rot1 = rot1 * counterClock;
rot2 = rot2 * counterClock;
rot3 = rot3 * counterClock;

if ((rot1>0) && (rot2>0) && (rot3>0))
    rot3 = min([rot1;rot2;rot3]);
    
    if ((abs(abs(rot3) - 90))<45)
        rot3 = max([rot1;rot2;rot3]);
    end

    
else 
    rot3 = max([rot1;rot2;rot3]);
    if ((abs(abs(rot3) - 90))<45)
        rot3 = min([rot1;rot2;rot3]);
    end

    
end
    
if (rot3 >=90) 
    rot3 = rot3 - 90;
elseif (rot3 <= -90)
    rot3 = rot3 + 90;
end

q = imrotate(img(:,:,1),rot3,'bilinear','crop');
r = imrotate(img(:,:,2),rot3,'bilinear','crop');
s = imrotate(img(:,:,3),rot3,'bilinear','crop');

out(:,:,1) = q;
out(:,:,2) = r;
out(:,:,3) = s;

%figure,imshow(uint8(out));

out = uint8(out);

A1 = fft2(out(:,:,1));
A2 = fft2(out(:,:,2));
A3 = fft2(out(:,:,3));

C1 = A1;
C2 = A2;
C3 = A3;


A1 = fftshift(A1);
A2 = fftshift(A2);
A3 = fftshift(A3);

Ab1 = abs(A1);
Ab2 = abs(A2);
Ab3 = abs(A3);

Ab1 = (Ab1 - ((min(min(Ab1)))))./((max(max(Ab1)))).*255;
Ab2 = (Ab2 - ((min(min(Ab2)))))./((max(max(Ab2)))).*255;
Ab3 = (Ab3 - ((min(min(Ab3)))))./((max(max(Ab3)))).*255;

Ab(:,:,1) = Ab1;
Ab(:,:,2) = Ab2;
Ab(:,:,3) = Ab3;
% nothing for booklet_3
% :,500,4160 for booklet_12
img = img(:,500:4160,:);
% 1:1300,1:1300 for booklet_3
% 15:1000,450:1500 for booklet_7
% 1:1200,1:2000 for booklet_12
% img = out;

img2 = img(1:1200,1:2000,:);
%img3 = img2(1:425,1:600,:);
illuminant = illumpca(img);
img1(:,:,1) = img2(:,:,1) /illuminant(1);
img1(:,:,2) = img2(:,:,2) / illuminant(2);
img1(:,:,3) = img2(:,:,3) / illuminant(3);
T = adaptthresh(img1,0.8);
im = imbinarize(img1,T);
im1 = imcomplement(im(:,:,1));
se1 = strel('line', 2,90);
se2 = strel('line', 3,90);
im2 = imdilate(im1,se1);
im2 = imerode(im2,se2);
stats = regionprops(im2,'BoundingBox');
figure, imshow(img)
for k = 1 : length(stats)
  thisBB = stats(k).BoundingBox;
  % 10,100,60,200,1.5,nothing for booklet_3
  % 20,60,20,70,1.4,170 for booklet_12
  if thisBB(3)>=20 && thisBB(3)<=60 && thisBB(4)>=20 && thisBB(4)<=70 && thisBB(3)/thisBB(4)<1.4 && thisBB(3)*thisBB(4)>170 
  rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],...
  'EdgeColor','r','LineWidth',2 )
  end
end
figure,imshow(im2)

%booklet3 best