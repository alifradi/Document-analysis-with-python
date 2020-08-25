import matplotlib.pyplot as plt
from skimage.transform import rescale
from skimage import io

def show_image(image, cmap_type='gray'):
  plt.clf()
  plt.figure(figsize=(12, 10))
  plt.imshow(image, cmap=cmap_type)
  plt.axis('off')
  plt.show()

 def rescale_it(img,n):
  enlarged_rocket_image = rescale(img, n, anti_aliasing=True, multichannel=True)
  show_image(enlarged_rocket_image)
  
