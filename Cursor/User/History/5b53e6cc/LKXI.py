import os
import torch
import torch.distributed.rpc as rpc


# Define a simple RPC function
def add_tensors(x, y):
    return x + y


def run_server():
    # Initialize the RPC framework
    rpc.init_rpc("server", rank=0, world_size=1)

    # Keep the server running
    print("Server is running...")
    # rpc.shutdown()


if __name__ == "__main__":
    os.environ["MASTER_ADDR"] = "localhost"
    os.environ["MASTER_PORT"] = "29500"
    run_server()
