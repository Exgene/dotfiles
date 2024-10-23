import torch
import torch.distributed.rpc as rpc
from transformers import AutoTokenizer, AutoModelForCausalLM


class InferenceAgent:
    def __init__(self, model_name="gpt2"):
        # Load the model and tokenizer for inference
        self.tokenizer = AutoTokenizer.from_pretrained(model_name)
        self.model = AutoModelForCausalLM.from_pretrained(model_name)
        self.device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
        self.model.to(self.device)
        self.model.eval()

    def generate_text(self, prompt: str, max_length: int = 50):
        inputs = self.tokenizer(prompt, return_tensors="pt").to(self.device)
        with torch.no_grad():
            outputs = self.model.generate(
                inputs.input_ids, max_length=max_length, do_sample=True, temperature=0.7
            )
        return self.tokenizer.decode(outputs[0], skip_special_tokens=True)


def run_server():
    rpc.init_rpc(
        "inference_server", rank=0, world_size=2
    )  # Initialize the RPC framework
    agent = InferenceAgent()  # Initialize the inference agent

    # Keep the server running
    rpc.shutdown()


if __name__ == "__main__":
    run_server()
