A=imread('real_1_changed.jpg'); 
P=imread('dupe_1_changed.jpg'); 

a = rgb2gray(A);
p = rgb2gray(P);


%[I2, rect] = imcrop(a);
a2_tr = imcrop(a,[2218.5 204.5 535 521]);  %transparent gandhi 1
b2_tr = imcrop(p,[2218.5 204.5 535 521]);  %transparent gandhi 2


a2_str = imcrop(a,[1766.5 4.5 63 1096]);   %thin strip 1
p2_str = imcrop(p,[1666.5 4.5 63 1096]);   %thin strip 2



%decompose into hsv

hsvImageReal = rgb2hsv(A);
hsvImageFake = rgb2hsv(P);


figure('Name','real image hsv');
imshow([hsvImageReal(:,:,1) hsvImageReal(:,:,2) hsvImageReal(:,:,3)]);
title('Real');
figure('Name','fake image hsv');
imshow([hsvImageFake(:,:,1) hsvImageFake(:,:,2) hsvImageFake(:,:,3)]);
title('Fake');

%create black and white image

%croppedImageReal = imcrop(hsvImageReal,[1766.5 4.5 63 1096]);
croppedImageReal = imcrop(hsvImageReal,[1778.5 13.5 57 963]);
%croppedImageFake = imcrop(hsvImageFake,[1666.5 4.5 63 1096]);
croppedImageFake = imcrop(hsvImageFake,[1673.5 4.5 96 1096]);

satThresh = 0.3;
valThresh = 0.9;
BWImageReal = (croppedImageReal(:,:,2) > satThresh & croppedImageReal(:,:,3) < valThresh);
figure('Name',' strips');
subplot(1,2,1);
imshow(BWImageReal);
title('Real');
BWImageFake = (croppedImageFake(:,:,2) > satThresh & croppedImageFake(:,:,3) < valThresh);
subplot(1,2,2);
imshow(BWImageFake);
title('Fake');

%closing

se = strel('line', 200, 90);
BWImageCloseReal = imclose(BWImageReal, se);
BWImageCloseFake = imclose(BWImageFake, se);
figure('Name','closed  strips');
subplot(1,2,1);
imshow(BWImageCloseReal);
title('cReal');
subplot(1,2,2);
imshow(BWImageCloseFake);
title('cFake');

%cleanup

figure('Name','cleaned green strips');
areaopenReal = bwareaopen(BWImageCloseReal, 15);
subplot(1,2,1);
imshow(areaopenReal);
title('clReal');
areaopenFake = bwareaopen(BWImageCloseFake, 15);
subplot(1,2,2);
imshow(areaopenFake);
title('clFake');

%count black lines

[~,countReal] = bwlabel(areaopenReal);
[~,countFake] = bwlabel(areaopenFake);
%disp(['The total number of black lines for the real note is: ' num2str(countReal)]);
%disp(['The total number of black lines for the fake note is: ' num2str(countFake)]);

co=corr2 (a2_str, p2_str); 

%display of conclusion

if (co>=0.5 && countReal == 1 && countFake ~= 1 )
    disp ('correlevance of transparent gandhi > 0.5');
    if (countReal == 1 && countFake ~= 1 )
        disp ('currency is legitimate');
    else
        disp ('green strip is fake');
    end;
else
    disp ('correlevance of transparent gandhi < 0.5');
    disp ('currency is fake');
    
end;


