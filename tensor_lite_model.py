import tensorflow as tf
import matplotlib.pyplot as plt
import cv2
import sklearn
from sklearn.metrics import classification_report
from sklearn.metrics import accuracy_score
import numpy as np
from keras.preprocessing.image import ImageDataGenerator, img_to_array, load_img
from keras.models import load_model

IMAGE_SIZE = 224
BATCH_SIZE = 8

train_path = "gender/train/"
val_path = "gender/validation/"

img = load_img(train_path + "Female/fe (1).jpg")
# plt.imshow(img)
# plt.axis("off")
# plt.show()

x = img_to_array(img)
print(x.shape)

train_datagen = tf.keras.preprocessing.image.ImageDataGenerator(
    rescale = 1./255,
    #validation_split = 0.4,
    shear_range = 0.3,   # image i sağa çevirmek
    horizontal_flip=True,  # image yatay yapmak
    zoom_range = 0.3,
    )
val_datagen = tf.keras.preprocessing.image.ImageDataGenerator(
rescale = 1./255
    )
train_generator = train_datagen.flow_from_directory(
    train_path,
    target_size = (IMAGE_SIZE, IMAGE_SIZE),
    batch_size = BATCH_SIZE,
    subset = 'training',
    color_mode= "rgb",
    class_mode= "categorical"
)
val_generator = val_datagen.flow_from_directory(
    val_path,
    target_size = (IMAGE_SIZE, IMAGE_SIZE),
    batch_size = BATCH_SIZE,
    subset = 'validation',
    color_mode= "rgb",
    class_mode= "categorical"
)
print(train_generator.class_indices)
labels = '\n'.join(sorted(
    train_generator.class_indices.keys()))
with open('labels.txt','w') as f:
    f.write(labels)

IMAGE_SHAPE = (IMAGE_SIZE, IMAGE_SIZE,3)
base_model = tf.keras.applications.MobileNetV2(
    input_shape = x.shape, #IMAGE_SHAPE,
    include_top = False,
)

base_model.trainable = False

y = tf.random.normal(x.shape)
model = tf.keras.Sequential([
    base_model,
    tf.keras.layers.Conv2D(64,3,activation = 'relu',input_shape = x.shape),
    tf.keras.layers.Conv2D(32,kernel_size=3,activation = 'relu'),
    tf.keras.layers.GlobalAveragePooling2D(),
    tf.keras.layers.Flatten(),
    tf.keras.layers.Dropout(0.5),
    tf.keras.layers.Dense(3, activation = 'softmax') # 3 class sayısı
])

model.compile(
    optimizer = "rmsprop",
    loss = 'categorical_crossentropy',
    metrics = ['accuracy']
)
print(model.summary())

epochs = 30
history = model.fit(
    train_generator,
    steps_per_epoch = 1600 // BATCH_SIZE,
    epochs = epochs,
    validation_data = val_generator,
)

#%% model evaluation
print(history.history.keys())
plt.plot(history.history["loss"], label = "Train Loss")
plt.plot(history.history["accuracy"], label = "Train Accuracy")
plt.legend()
plt.show()
plt.figure()



#%% 
# Tensorflow 2.2 sonrası için 
# pb dosyası için
# loaded_model = tf.keras.models.load_model('Model/my_model_weights.pb')
# print(loaded_model.summary())
# # h5 dosyası
# model_h5= tf.keras.models.save_model(loaded_model,'weight.h5')
# print(model_h5.summary())

#Tensorflow 2.2 öncesi
# convert tflite için pb dosyası oluşturma

saved_model_dir ='load/'
tf.saved_model.save(model,saved_model_dir)

# convert tflite 
converter = tf.lite.TFLiteConverter.from_saved_model(saved_model_dir)
tflite_model = converter.convert()

with open('mymodel.tflite', 'wb') as f:
    f.write(tflite_model)


model.save('load/my_model_weights.h5')




