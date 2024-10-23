import os
import torch
import torch.distributed.rpc as rpc

# from shared_functions import process_tensor
from rpc.generate import generate


def run_master():
    os.environ["MASTER_ADDR"] = "192.168.1.104"
    os.environ["MASTER_PORT"] = "29500"

    rpc.init_rpc("master", rank=0, world_size=2)
    print("Master initialized")

    # Create a tensor
    tensor = torch.tensor([1, 2, 3])
    print("Sending tensor to worker:", tensor)

    # Send the tensor to the worker and get the result
    result = rpc.rpc_sync("worker", generate, args=())
    print("Received processed tensor from worker:", result)

    rpc.shutdown()


if __name__ == "__main__":
    run_master()
