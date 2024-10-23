from flask import Flask, request, jsonify
import torch
from models.simple_gpt import ModelConfig, LanguageModel
from data.shakespeare.character import decode, estimate_loss

app = Flask(__name__)

device = "cuda" if torch.cuda.is_available() else "cpu"

model_size = "800k"
model_epoch = "20000"

# Load the model configuration
config = ModelConfig.get_config(f"shakespeare-{model_size}")

# Load the pretrained model
model_path = f"weights/shakespeare-gpt-{model_size}-{model_epoch}.pth"
model = LanguageModel.from_pretrained(config, model_path)
model.to(device)
model.eval()


@app.route("/generate", methods=["POST"])
def generate_text():
    # Generate text
    context = torch.zeros((1, 1), dtype=torch.long, device=device)
    generated_text = model.generate(context, max_new_tokens=500)
    generated_output = decode(generated_text[0].tolist())

    # Evaluate the model's performance
    eval_iters = 100

    assert config
    losses = estimate_loss(model, config.block_size, config.batch_size, eval_iters)

    return jsonify(
        {
            "generated_text": generated_output,
            "train_loss": losses["train"],
            "val_loss": losses["val"],
        }
    )


if __name__ == "__main__":
    app.run()
