import torch
from models.simple_gpt import ModelConfig, LanguageModel
from data.shakespeare.character import (
    decode,
    get_batch,
    estimate_loss,
    encode,
    vocab_size,
)


# Generate texts
def generate():

    device = "cuda" if torch.cuda.is_available() else "cpu"

    model_size = "200k"
    model_epoch = "5000"

    # Load the model configuration
    config = ModelConfig.get_config(f"shakespeare-{model_size}")
    assert config
    config.vocab_size = vocab_size

    # Load the pretrained model
    model_path = f"weights/shakespeare-gpt-word-{model_size}-{model_epoch}.pth"
    model = LanguageModel.from_pretrained(config, model_path)
    model.to(device)
    model.eval()

    # Generate text
    context = torch.zeros((1, 1), dtype=torch.long, device=device)
    generated_tokens = model.generate(context, max_new_tokens=100)
    generated_text = decode(generated_tokens[0].tolist())
    print("Generated text:")
    print(generated_text)
    return generated_text
