import torch.distributed.rpc as rpc


def request_inference(prompt):
    # Use RPC to call the generate_text method on the inference_server
    return rpc.rpc_sync(
        "inference_server", InferenceAgent.generate_text, args=(prompt,)
    )


def run_client():
    rpc.init_rpc("client", rank=1, world_size=2)  # Initialize the RPC framework
    prompt = "Once upon a time"
    response = request_inference(prompt)
    print(f"Generated text: {response}")

    rpc.shutdown()


if __name__ == "__main__":
    run_client()
