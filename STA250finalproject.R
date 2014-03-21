library("biOps");library("jpeg");library("abind"); library("EBImage")
setwd("/Users/Qian/Documents/STA_250Duncan/Project250")

####################################
###          PART 1
###      SVD compress picture
####################################

image = readJpeg("lenac.jpeg")
r=svd(image[,,1])
g=svd(image[,,2])
b=svd(image[,,3])

recover = function (UDV, k) {
  D = mat.or.vec(k,k); diag(D) = UDV$d[1:k] 
  U = UDV$u[,1:k]; V = UDV$v[,1:k]
  result = U %*% D %*% t(V)
  return(result)
}

output = function (k) {
  r_rec = recover(r,k); g_rec = recover(g,k); b_rec = recover(b,k)
  img = imagedata(abind(r_rec,g_rec,b_rec,along=3))
  img[which(img < 0)]=0; img[which(img >255)]=255
  #plot(img)
  writeJpeg(sprintf("svd_pic2_%d.jpg", k), img)
}

k_list = c (2,5,10,20,50,100,200)
for (i in k_list) {
  output(i)
}


####################################
###          PART 2 
###         blurring
####################################

blur = function (image, k) {
  kernel = mat.or.vec(k,k) + 1/(k^2)
  res = imgConvolve(image,kernel)
}
k_list = c (3,5,7,11,13,15)
for (i in k_list) {
  writeJpeg(sprintf("lenac_blur_%d.jpg", i), blur(image,i))
}
# Blurring is performed by convolution, using a uniform kernel of k*k. 


####################################
###          PART 3 
###         sharpenning
####################################

sharpen = function (image, k) {
  kernel = mat.or.vec(k,k)-1
  kernel[floor(k/2+1),floor(k/2+1)]=k*k
  res = imgConvolve(image,kernel)
}
k_list = c (3,5,7,11,13,15)
for (i in k_list) {
  writeJpeg(sprintf("lenac_sharpen_%d.jpg", i), sharpen(image,i))
}
# Sharpenning is performed by convolution, using a kernel of k*k. 

####################################
###          PART 4 
###         relief effect
####################################



relief = function (image, k) {
  kernel = mat.or.vec(k,k)
  kernel[1,1] = 1
  kernel[k,k] = -1
  res = imgConvolve(image,kernel)+100
  res[res>255]=255
  res
}
k_list = c (2,3,4,5)
for (i in k_list) {
  writeJpeg(sprintf("lenac_relief_%d.jpg", i), relief(image,i))
}
# Sharpenning is performed by convolution, using a kernel of k*k. 

####################################
###          PART 5 
###         Edge Detection
####################################

writeJpeg("lenac_edge.jpg", imgDifferenceEdgeDetection(image))
writeJpeg("lenac_edge2.jpg", 255-imgDifferenceEdgeDetection(image))

####################################
###          PART 6 
###         0ld picture
####################################

R = image[,,1]; G = image[,,2]; B = image[,,3]
old_effect = imagedata(abind(0.6*R + 0.8*G + 0.2*B,
                             0.3*R + 0.8*G + 0.2*B,
                             0.3*R + 0.2*G + 0.1*B, along=3))
old_effect[old_effect>255]=255
writeJpeg("lenac_old_picture.jpg",old_effect)


####################################
###          PART 7 
###         0ld picture
####################################
ghost = function (image, k) {
  kernel = mat.or.vec(k,k)
  kernel[1,1]=0.5; kernel[k,k]=0.5
  res = imgConvolve(image,kernel)
}
k_list = c (5,10,20)
for (i in k_list) {
  writeJpeg(sprintf("lenac_ghosting_%d.jpg", i), ghost(image,i))
}
# Ghosting is performed by convolution, using a kernel of k*k. 

####################################
###          PART 8 
###         Recover picture
####################################

# Try to recover from ghosting pic 

Deconvolve = function(Ghost_img,kernel, w) {
  Deconvolve_ch = function (Ghost_ch) {
    # It is known that, if Y = X convolve Kernel, 
    # then: Fourier(Y) = Fourier(X) * Fourier(Kernel), 
    # here the mulitiple is point multiple, element by element
    Ghost_F = fft(Ghost_ch) # Fourier Transforming 
    Kernel_F = fft(Kernel)
    #Recover_F = Ghost_F / (Kernel_F + w) # This is the old method, 
    # The method below is better: 
    Recover_F = Ghost_F * Conj(Kernel_F) / (abs(Kernel_F)^2 + w)
    # w is the parameter, avoiding 0 in abs(Kernel_F)
    Recover = abs (fft(Recover_F, inverse=T))
    Recover = Recover - min(Recover)
    Recover / max(Recover) * 255
    # control for display 
    # let pixel vaule between 0 and 255
    # the picture will not be too bright or Dark
  }  
  k1 = dim(kernel)[1]; k2 = dim(kernel)[2]
  Kernel = Ghost_img[,,1] * 0
  Kernel[1:k1, 1:k2] = kernel
  Kernel = rbind(Kernel[-(1:(k1/2)),], Kernel[1:(k1/2),])
  Kernel = cbind(Kernel[,-(1:(k2/2))], Kernel[,1:(k2/2)])
  
  imagedata(abind(Deconvolve_ch(Ghost_img[,,1]),
                  Deconvolve_ch(Ghost_img[,,2]),
                  Deconvolve_ch(Ghost_img[,,3]),along=3))
}

k=20
kernel = mat.or.vec(k,k)
kernel[1,1]=0.5; kernel[k,k]=0.5
Ghost_img = ghost(image,k)
writeJpeg("lenac_ghosting_to_recovery.jpg", Ghost_img)

w_list = c (0.0002,0.0005,0.001,0.002,0.005,0.01,0.02,0.05,0.1,0.2)
for (w in w_list) {
  writeJpeg(sprintf("lenac_ghosting_recovery_w=%1.4f.jpg", w),
            Deconvolve(Ghost_img,kernel,w))
}

Ghost_img_cut = Ghost_img[(k+1):(dim(Ghost_img)[1]-k),
                          (k+1):(dim(Ghost_img)[2]-k), ]
w = 0.01
#writeJpeg(sprintf("lenac_ghosting_recovery_w=%1.2f_EdgeCut.jpg", w),
#          Deconvolve(Ghost_img_cut,kernel,w))
Expand = function(img) {
  dim1= dim(img)[1]; dim2 = dim(img)[2]
  img_expand_row = abind( img[,dim2:1,], img, img[,dim2:1,], along=2)
  imagedata(abind( img_expand_row [dim1:1,,],
                   img_expand_row,
                   img_expand_row [dim1:1,,], along=1))
}
dim1= dim(Ghost_img_cut)[1]; dim2 = dim(Ghost_img_cut)[2]
Ghost_img_cut_expand = Expand(Ghost_img_cut)
writeJpeg("lenac_ghosting_to_recovery_expand.jpg", Ghost_img_cut_expand)
w = 0.01
Recovery_expand = Deconvolve(Ghost_img_cut_expand,kernel,w)
Recovery = imagedata(Recovery_expand[(dim1+1):(dim1*2),(dim2+1):(dim2*2),])
writeJpeg(sprintf("lenac_ghosting_recovery_w=%1.2f_EdgeCut_expand1.jpg", w),
          Recovery_expand)
writeJpeg(sprintf("lenac_ghosting_recovery_w=%1.2f_EdgeCut_expand2.jpg", w),
          Recovery)

Color_adjust = function(img1, img2, rate) {
  img3 = img2
  for (i in 1:3) {
    while (sum(img3[,,i]) < sum(img1[,,i])*rate) {
      #img3[,,i]=img3[,,i]-min(img3[,,i])+min(img1[,,i])
      #img3[img3>255]=255
      img3[,,i] = img3[,,i]/sum(img3[,,i])*sum(img1[,,i])
      img3[img3>255]=255
    }
  }
  imagedata(img3)
}
Recovery_color_adjust = Color_adjust(Ghost_img_cut,Recovery,0.99)
writeJpeg(sprintf("lenac_ghosting_recovery_w=%1.2f_EdgeCut_expand3.jpg", w),
           Recovery_color_adjust)

# Expanding without cutting 
dim1= dim(Ghost_img)[1]; dim2 = dim(Ghost_img)[2]
Ghost_img_expand = Expand (Ghost_img)
writeJpeg("lenac_ghosting_to_recovery_expand_without_cut.jpg", Ghost_img_expand)
w = 0.01
Recovery_expand = Deconvolve(Ghost_img_expand,kernel,w)
Recovery = imagedata(Recovery_expand[(dim1+1):(dim1*2),(dim2+1):(dim2*2),])
writeJpeg(sprintf("lenac_ghosting_recovery_w=%1.2f_expand1.jpg", w),
          Recovery_expand)
writeJpeg(sprintf("lenac_ghosting_recovery_w=%1.2f_expand2.jpg", w),
          Recovery)
Recovery_color_adjust = Color_adjust(Ghost_img,Recovery,0.99)
writeJpeg(sprintf("lenac_ghosting_recovery_w=%1.2f_expand3.jpg", w),
          Recovery_color_adjust)

# Deblurring, without expanding 
k=5; kernel = mat.or.vec(k,k) + 1/(k^2)
Blur_img = imgConvolve(image,kernel)
writeJpeg("lenac_deblur_before.jpg",Blur_img)
w_list = c (1e-6,1e-5,0.0001,0.001,0.01,0.1,1)
for (w in w_list) {
  writeJpeg(sprintf("lenac_deblur_w=%g.jpg", w),
            Color_adjust(Blur_img,Deconvolve(Blur_img,kernel,w),0.95))
}
#Deblurring, with expanding
dim1= dim(Blur_img)[1]; dim2 = dim(Blur_img)[2]
Blur_img_expand = Expand (Blur_img)
w_list = c (1e-6,1e-5,0.0001,0.001,0.01,0.1,1)
for (w in w_list) {
  Deblur_expand = Deconvolve(Blur_img_expand,kernel,w)
  Deblur = imagedata(Deblur_expand[(dim1+1):(dim1*2),(dim2+1):(dim2*2),])
  writeJpeg(sprintf("lenac_deblur_expand_w=%g.jpg", w),
            Color_adjust(Blur_img,Deblur,0.95))
}


####################################
###          PART 8 
###         Other tricks
####################################

# Rotate an image using the given interpolation 
# like "nearestneighbor | bilinear | cubic | spline

imgR = imgRotate(image,45,"cubic")
writeJpeg("lenac_Rotate45.jpg", imgR)

# Crops an image

imgC = imgCrop(image,150,180,200,110)
writeJpeg("lenac_Crop.jpg", imgC)

# Produce Grayscale
imageType(image) # rge
imgGrey = imgRGB2Grey(image);
writeJpeg("lenac_Grey.jpg", imgGrey)

imgNoise = imgGaussianNoise(image,0,200)
writeJpeg("lenac_Noise.jpg", imgNoise)


#imgDecreaseContrast, imgDecreaseIntensity
#plot(imgRedBand(x));
#plot(imgBlueBand(x));
#plot(imgGreenBand(x));