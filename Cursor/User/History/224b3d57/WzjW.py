import tensorflow as tf
from tensorflow.keras import layers, models
import numpy as np
import matplotlib.pyplot as plt

# Hyperparameters
latent_dim = 100
batch_size = 256
num_epochs = 50
buffer_size = 60000
steps_per_epoch = buffer_size // batch_size
seed = np.random.normal(0, 1, (16, latent_dim))


# Simple Generator model
def build_generator():
    model = models.Sequential()
    model.add(layers.Dense(7 * 7 * 256, input_shape=(latent_dim,)))
    model.add(layers.BatchNormalization())
    model.add(layers.LeakyReLU())

    model.add(layers.Reshape((7, 7, 256)))

    model.add(layers.Conv2DTranspose(128, (5, 5), strides=(1, 1), padding="same"))
    model.add(layers.BatchNormalization())
    model.add(layers.LeakyReLU())

    model.add(layers.Conv2DTranspose(64, (5, 5), strides=(2, 2), padding="same"))
    model.add(layers.BatchNormalization())
    model.add(layers.LeakyReLU())

    model.add(
        layers.Conv2DTranspose(
            1, (5, 5), strides=(2, 2), padding="same", activation="tanh"
        )
    )
    return model


# Simple Discriminator model
def build_discriminator():
    model = models.Sequential()

    model.add(layers.Conv2D(64, 5, strides=2, padding="same", input_shape=[28, 28, 1]))
    model.add(layers.LeakyReLU())
    model.add(layers.Dropout(0.3))

    model.add(layers.Conv2D(128, 5, strides=2, padding="same"))
    model.add(layers.LeakyReLU())
    model.add(layers.Dropout(0.3))

    model.add(layers.Flatten())
    model.add(layers.Dense(1))

    return model


def build_gan(generator, discriminator):
    model = models.Sequential()
    model.add(generator)
    discriminator.trainable = False
    model.add(discriminator)
    return model


generator = build_generator(latent_dim)
discriminator = build_discriminator()

gan = build_gan(generator, discriminator)
discriminator.compile(optimizer="adam", loss="binary_crossentropy")
gan.compile(optimizer="adam", loss="binary_crossentropy")

# Load and preprocess the MNIST dataset
(train_images, _), (_, _) = tf.keras.datasets.mnist.load_data()
train_images = (
    train_images.reshape(train_images.shape[0], 28, 28, 1).astype("float32") / 255.0
)
train_images = (train_images - 0.5) * 2  # Normalize to [-1, 1]
train_dataset = (
    tf.data.Dataset.from_tensor_slices(train_images).shuffle(60000).batch(batch_size)
)


# training
def generate_and_save(model, epoch, test_input):
    predictions = model(test_input, training=False)
    fig = plt.figure(figsize=(4, 4))
    for i in range(predictions.shape[0]):
        plt.subplot(4, 4, i + 1)
        plt.imshow((predictions[i] + 1) / 2.0, cmap="gray")
        plt.axis("off")

    plt.savefig(f"image_at_epoch_{epoch}.png")
    plt.show()


for epoch in range(num_epochs):
    for step, real_imgs in enumerate(train_dataset):
        noise = np.random.normal(0, 1, (batch_size, latent_dim))
        generated_imgs = generator.predict(noise)

        combined_imgs = np.concatenate([real_imgs, generated_imgs])
        labels = np.concatenate([np.ones((batch_size, 1)), np.zeros((batch_size, 1))])

        labels += 0.05 * np.random.random(labels.shape)
        dloss = discriminator.train_on_batch(combined_imgs, labels)

        noise = np.random.normal(0, 1, (batch_size, latent_dim))
        misleading_labels = np.zeros((batch_size, 1))
        gloss = gan.train_on_batch(noise, misleading_labels)

    print(f"Epoch: {epoch}, Discriminator Loss: {dloss}, Generator Loss: {gloss}")
    if epoch % 10 == 0:
        generate_and_save_images(generator, epoch + 1, seed)

generator.save("generator.h5")
