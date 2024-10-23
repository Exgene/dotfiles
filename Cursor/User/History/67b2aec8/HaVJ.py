import os
import torch
import torch.distributed.rpc as rpc

# from shared_functions import process_tensor
import torch
from models.simple_gpt import ModelConfig, LanguageModel
from data.shakespeare.character import decode, get_batch, estimate_loss, encode


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


def run_master():
    os.environ["MASTER_ADDR"] = "192.168.1.104"
    os.environ["MASTER_PORT"] = "29500"

    rpc.init_rpc("master", rank=0, world_size=2)
    print("Master initialized")

    # Create a tensor
    tensor = torch.tensor([1, 2, 3])
    print("Sending tensor to worker:", tensor)

    # Send the tensor to the worker and get the result
    result = rpc.rpc_sync("worker", generate, args=("To be or not to be",))
    print("Received processed tensor from worker:", result)

    rpc.shutdown()


if __name__ == "__main__":
    run_master()
