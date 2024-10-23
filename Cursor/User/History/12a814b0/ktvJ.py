import torch
from models.simple_gpt import ModelConfig, LanguageModel
from data.shakespeare.character import decode, get_batch, estimate_loss, encode


def generate(user_input):

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

    input_tokens = torch.tensor(
        encode(user_input), dtype=torch.long, device=device
    ).unsqueeze(0)

    # Generate text

    generated_text = model.generate(input_tokens, max_new_tokens=500)
    result = decode(generated_text[0].tolist())
    print(result)

    return result
