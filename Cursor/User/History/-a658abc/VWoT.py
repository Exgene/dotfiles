import os
import torch
import torch.distributed.rpc as rpc


def run_client():
    # Initialize the RPC framework
    rpc.init_rpc("client", rank=1, world_size=2)

    # Call the RPC function on the server
    x = torch.tensor([1.0, 2.0])
    y = torch.tensor([3.0, 4.0])
    result = rpc.rpc_sync("server", add_tensors, args=(x, y))
    print("Result from server:", result)

    rpc.shutdown()


if __name__ == "__main__":
    os.environ["MASTER_ADDR"] = "localhost"
    os.environ["MASTER_PORT"] = "29500"
    run_client()
s
