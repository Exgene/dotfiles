import torch
from models.simple_gpt import ModelConfig, LanguageModel
from data.shakespeare.character import decode, get_batch, estimate_loss, encode

import sys
import os

# Add the parent directory to the Python path
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))


# Generate text
def generate(prompt):
    device = "cuda" if torch.cuda.is_available() else "cpu"

    model_size = "800k"
    model_epoch = "20000"

    # Load the model configuration
    config = ModelConfig.get_config(f"shakespeare-{model_size}")
    assert config

    # Load the pretrained model
    model_path = f"weights/shakespeare-gpt-{model_size}-{model_epoch}.pth"
    model = LanguageModel.from_pretrained(config, model_path)
    model.to(device)

    model.eval()
    context = encode(prompt)
    generated_text = model.generate(context, max_new_tokens=500)
    return decode(generated_text[0].tolist())
