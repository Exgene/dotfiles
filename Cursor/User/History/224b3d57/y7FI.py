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


# Training step
@tf.function
def train_step(real_images):
    noise = tf.random.normal([batch_size, latent_dim])

    with tf.GradientTape() as gen_tape, tf.GradientTape() as disc_tape:
        generated_images = generator(noise, training=True)

        real_output = discriminator(real_images, training=True)
        fake_output = discriminator(generated_images, training=True)

        gen_loss = cross_entropy(tf.ones_like(fake_output), fake_output)
        disc_loss = cross_entropy(
            tf.ones_like(real_output), real_output
        ) + cross_entropy(tf.zeros_like(fake_output), fake_output)

    gradients_of_generator = gen_tape.gradient(gen_loss, generator.trainable_variables)
    gradients_of_discriminator = disc_tape.gradient(
        disc_loss, discriminator.trainable_variables
    )

    generator_optimizer.apply_gradients(
        zip(gradients_of_generator, generator.trainable_variables)
    )
    discriminator_optimizer.apply_gradients(
        zip(gradients_of_discriminator, discriminator.trainable_variables)
    )


# Training loop
for epoch in range(num_epochs):
    for real_images in train_dataset:
        train_step(real_images)

    print(f"Epoch {epoch + 1}/{num_epochs} completed.")


# Generate and save images
def generate_and_save_images(model, num_examples_to_generate):
    noise = tf.random.normal([num_examples_to_generate, latent_dim])
    predictions = model(noise, training=False)
    predictions = (predictions.numpy() + 1) / 2  # Scale back to [0, 1]
    plt.figure(figsize=(10, 10))
    for i in range(predictions.shape[0]):
        plt.subplot(8, 8, i + 1)
        plt.imshow(predictions[i, :, :, 0], cmap="gray")
        plt.axis("off")
    plt.show()


# Generate images after training
generate_and_save_images(generator, 64)
